import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/constants/characters.dart';
import 'package:lotr_drinking_game/constants/game_rule.dart';
import 'package:lotr_drinking_game/models/fellowship.dart';
import 'package:lotr_drinking_game/models/fellowship_member.dart';
import 'package:lotr_drinking_game/services/api/fellowship_service.dart';
import 'package:lotr_drinking_game/services/app/dialog_service.dart';
import 'package:lotr_drinking_game/services/app/preferences_service.dart';
import 'package:lotr_drinking_game/services/repositories/fellowship_repository.dart';

Fellowship fellowshipWith(Map<String, FellowshipMember> members) => Fellowship(
      id: 'fellowship-1',
      pin: '453603',
      name: 'Test fellowship',
      currentMovie: 'Fellowship of the Ring',
      lastSummaryShown: 'Fellowship of the Ring',
      members: members,
    );

class _FakePreferences implements PreferencesServiceModel {
  @override
  String? fellowshipId;

  @override
  String? fellowshipPin;

  @override
  String? memberId;

  @override
  Character? character;

  @override
  RuleDifficulty difficulty = RuleDifficulty.easy;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used');
}

class _FakeDialogService implements DialogServiceModel {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used');
}

class _FakeFellowshipRepository implements FellowshipRepositoryModel {
  final StreamController<Fellowship?> _controller =
      StreamController<Fellowship?>.broadcast();

  Fellowship? current;
  int addMemberCalls = 0;

  @override
  Stream<Fellowship?> stream(String fellowshipId) => _controller.stream;

  @override
  Future<Fellowship?> get(String fellowshipId) async => current;

  @override
  Future<String> addMember(String fellowshipId, FellowshipMember member) async {
    addMemberCalls++;
    final Fellowship fellowship = current!;
    final Map<String, FellowshipMember> members =
        Map<String, FellowshipMember>.of(fellowship.members);

    final String characterKey = member.character.value;
    final String key;
    if (members.containsKey(member.id)) {
      key = member.id;
    } else if (!members.containsKey(characterKey)) {
      key = characterKey;
    } else {
      key = '${characterKey}_${member.id}';
    }

    members[key] = FellowshipMember(
      id: key,
      name: member.name,
      character: member.character,
      difficulty: member.difficulty,
      isAdmin: member.isAdmin,
      drinks: member.drinks,
      saves: member.saves,
    );
    current = fellowshipWith(members);
    return key;
  }

  void emit() => _controller.add(current);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used');
}

/// Lets the async BehaviorSubjects and streams in the service deliver their
/// pending events.
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 5));

void main() {
  test('onboarding does not recover its own not-yet-visible member', () async {
    final _FakePreferences preferences = _FakePreferences()
      ..fellowshipId = 'fellowship-1';
    final _FakeFellowshipRepository repository = _FakeFellowshipRepository()
      ..current = fellowshipWith(<String, FellowshipMember>{});

    final ProviderContainer container = ProviderContainer(
      // The Override type is not exported by riverpod 3.x, so the list
      // literal cannot carry a type annotation.
      // ignore: always_specify_types
      overrides: [
        preferencesService.overrideWithValue(preferences),
        fellowshipRepository.overrideWithValue(repository),
        dialogService.overrideWithValue(_FakeDialogService()),
      ],
    );
    addTearDown(container.dispose);

    final FellowshipServiceModel service = container.read(fellowshipService);
    final StreamSubscription<Fellowship?> subscription =
        service.fellowshipStream.listen((Fellowship? _) {});
    addTearDown(subscription.cancel);

    // The fellowship is loaded and currently has no members.
    repository.emit();
    await settle();

    // Joining writes the member, but Firestore has not echoed the new
    // snapshot back yet. The old, member-less snapshot is still in memory.
    final bool success = await service.selectCharacter(
      username: 'Alice',
      character: Character.frodo,
      difficulty: RuleDifficulty.easy,
    );
    expect(success, isTrue);
    expect(repository.addMemberCalls, 1);

    // Give every pending stream event plenty of chances to run while the
    // stale snapshot is still the latest one the service has seen. This used
    // to make recovery add another member (and then another, and another).
    for (int i = 0; i < 20; i++) {
      await settle();
    }

    expect(
      repository.addMemberCalls,
      1,
      reason: 'a pending write must not be treated as a clobbered membership',
    );
    expect(repository.current!.members, hasLength(1));
    expect(repository.current!.members.values.single.name, 'Alice');

    // Now deliver the snapshot that contains the freshly written member.
    repository.emit();
    await settle();

    expect(service.member?.name, 'Alice');
    expect(repository.addMemberCalls, 1);
  });
}
