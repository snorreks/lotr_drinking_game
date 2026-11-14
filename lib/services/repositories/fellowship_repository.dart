import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_service.dart';
import '../../constants/characters.dart';
import '../../constants/game_rule.dart';
import '../../models/fellowship.dart';
import '../../models/fellowship_member.dart';

enum IncrementType {
  drinks,
  saves,
}

extension IncrementTypeExtension on IncrementType {
  String get value {
    switch (this) {
      case IncrementType.drinks:
        return 'drinks';
      case IncrementType.saves:
        return 'saves';
    }
  }
}

abstract class FellowshipRepositoryModel {
  ///PIN and ID based get, streams and such. This way we can operate of PINs, making life easier for users.
  ///
  Future<Fellowship?> get(String fellowshipId);
  Future<Fellowship?> getByPin(String fellowshipPin);

  Stream<Fellowship?> stream(String fellowshipId);

  Future<String> create(String fellowshipName);

  /// Adds a member to the fellowship and returns the key it was stored
  /// under (the member's id).
  ///
  /// The plain character value is used as the key while the character is
  /// still free, which keeps documents readable by older app versions. Once
  /// a character is taken, new members get a unique key prefixed with the
  /// character value, so multiple players can share a character without
  /// overwriting each other.
  Future<String> addMember(String fellowshipId, FellowshipMember member);
  Future<void> updateDifficulty({
    required String fellowshipId,
    required String memberId,
    required RuleDifficulty difficulty,
  });
  Future<void> changeAdmin(String fellowshipId, FellowshipMember newAdmin,
      FellowshipMember oldAdmin);
  Future<void> nextMovie(String fellowshipId, String currentMovie);
  Future<void> updateLastSummaryShown(String fellowshipId, String nextMovie);

  Future<void> increment({
    required String fellowshipId,
    required String memberId,
    required IncrementType type,
    int? amount,
  });

  Future<void> createCallout({
    required String fellowshipId,
    required String memberId,
    required String rule,
    required String caller,
  });
  Future<void> resolveCallout({
    required String fellowshipId,
    required String memberId,
    required int drinks,
  });
}

class FellowshipRepository extends BaseService
    implements FellowshipRepositoryModel {
  FellowshipRepository(this._db);
  final FirebaseFirestore _db;

  //DEPRECATED!
  @override
  Future<Fellowship?> get(String fellowshipId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _getFellowshipDocumentReference(fellowshipId).get();

      if (!doc.exists) {
        return null;
      }

      return Fellowship.fromJson(<String, dynamic>{
        ...doc.data()!,
        'id': doc.id,
      });
    } catch (e) {
      logError('get', e);
      return null;
    }
  }

  //DEPRECATED!
  @override
  Stream<Fellowship?> stream(String fellowshipId) {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      return docRef
          .snapshots()
          .where((DocumentSnapshot<Map<String, dynamic>> doc) => doc.exists)
          .map(
            (DocumentSnapshot<Map<String, dynamic>> doc) =>
                Fellowship.fromJson(<String, dynamic>{
              ...doc.data()!,
              'id': doc.id,
            }),
          );
    } catch (e) {
      logError('fellowshipStream', e);
      return const Stream<Fellowship?>.empty();
    }
  }

  @override
  Future<String> create(String fellowshipName) async {
    try {
      String randomPin = '';
      final Random rnd = Random();
      for (int i = 0; i < 6; i++) {
        randomPin = randomPin + rnd.nextInt(9).toString();
      } //block for random 6 digit String, couldn't bother doing it before.

      final DocumentReference<Map<String, dynamic>> docRef =
          await _fellowshipCollectionReference.add(<String, dynamic>{
        'name': fellowshipName,
        'pin': randomPin,
        'createdAt': FieldValue.serverTimestamp(),
        'currentMovie': 'Fellowship of the Ring',
        'lastSummaryShown': 'Fellowship of the Ring',
        'members': <String, dynamic>{}
      });

      return docRef.id;
    } catch (e) {
      logError('createFellowship', e);
      rethrow;
    }
  }

  @override
  Future<String> addMember(String fellowshipId, FellowshipMember member) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      // Pick the member key inside a transaction, so two players picking a
      // character at the same time can never overwrite each other.
      final String memberId = await _db.runTransaction<String>(
        (Transaction transaction) async {
          final DocumentSnapshot<Map<String, dynamic>> snapshot =
              await transaction.get(docRef);
          final Map<String, dynamic> data =
              snapshot.data() ?? <String, dynamic>{};
          final Map<String, dynamic> members =
              (data['members'] as Map<String, dynamic>?) ?? <String, dynamic>{};

          // Reuse the key this membership is already stored under. Without
          // this, retrying a write (or recovering twice) appends a new key
          // each time and quietly grows the members map forever.
          final String characterKey = member.character.value;
          final String compositeKey = '${characterKey}_${member.id}';
          final String key;
          if (members.containsKey(member.id)) {
            key = member.id;
          } else if (!members.containsKey(characterKey)) {
            // Free characters keep their plain value as key, which keeps the
            // document compatible with older app versions. Only duplicates
            // get a unique, character-prefixed key.
            key = characterKey;
          } else {
            key = compositeKey;
          }

          transaction.update(docRef, <String, dynamic>{
            'members.$key': <String, dynamic>{
              'name': member.name,
              'character': member.character.value,
              'isAdmin': member.isAdmin,
              'difficulty': member.difficulty.value,
              'drinks': member.drinks
                  .map((DateTime dateTime) => Timestamp.fromDate(dateTime))
                  .toList(),
              'saves': member.saves
                  .map((DateTime dateTime) => Timestamp.fromDate(dateTime))
                  .toList(),
            }
          });
          return key;
        },
      );

      return memberId;
    } catch (e) {
      logError('addMember', e);
      rethrow;
    }
  }

  @override
  Future<void> updateDifficulty({
    required String fellowshipId,
    required String memberId,
    required RuleDifficulty difficulty,
  }) async {
    try {
      await _updateDocument(fellowshipId, <String, dynamic>{
        'members.$memberId.difficulty': difficulty.value,
      });
    } catch (e) {
      logError('updateDifficulty', e);
      rethrow;
    }
  }

  @override
  Future<void> changeAdmin(String fellowshipId, FellowshipMember newAdmin,
      FellowshipMember oldAdmin) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      await _db.runTransaction((Transaction transaction) async {
        transaction.update(docRef, <String, dynamic>{
          'members.${newAdmin.id}.isAdmin': true,
          'members.${oldAdmin.id}.isAdmin': false
        });
      });
    } catch (e) {
      logError('changeAdmin', e);
      rethrow;
    }
  }

  @override
  Future<void> nextMovie(String fellowshipId, String currentMovie) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      String nextMovie = '';

      //hardcoded logic... i hate it but I am too sleepy to think of other solutions
      switch (currentMovie) {
        case ('Fellowship of the Ring'):
          {
            nextMovie = 'The Two Towers';
          }
        case ('The Two Towers'):
          {
            nextMovie = 'Return of the King';
          }
        case ('Return of the King'):
          {
            //commence ending sequence
            nextMovie = 'Fellowship of the Ring';
          }
      }

      await _db.runTransaction((Transaction transaction) async {
        transaction.update(docRef, <String, dynamic>{
          'currentMovie': nextMovie,
        });
      });
    } catch (e) {
      logError('changeAdmin', e);
      rethrow;
    }
  }

  @override
  Future<void> updateLastSummaryShown(
      String fellowshipId, String nextMovie) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      await docRef.update(<String, dynamic>{
        'lastSummaryShown': nextMovie,
        'currentMovieStart': Timestamp.now()
      });
    } catch (e) {
      logError('updateLastSummaryShown', e);
      rethrow;
    }
  }

  @override
  Future<void> increment({
    required String fellowshipId,
    required String memberId,
    required IncrementType type,
    int? amount,
  }) async {
    try {
      await _updateDocument(fellowshipId, <String, dynamic>{
        'members.$memberId.${type.value}': FieldValue.arrayUnion(
          List<Timestamp>.generate(
            amount ?? 1,
            (int index) => Timestamp.now(),
          ),
        ),
      });
    } catch (e) {
      logError('increment', e);
      rethrow;
    }
  }

  @override
  Future<void> createCallout({
    required String fellowshipId,
    required String memberId,
    required String rule,
    required String caller,
  }) async {
    try {
      await _updateDocument(fellowshipId, <String, dynamic>{
        'members.$memberId.callout': <String, dynamic>{
          'rule': rule,
          'caller': caller,
        },
      });
    } catch (e) {
      logError('createCallout', e);
      rethrow;
    }
  }

  @override
  Future<void> resolveCallout({
    required String fellowshipId,
    required String memberId,
    required int drinks,
  }) async {
    try {
      if (drinks > 0) {
        await _updateDocument(fellowshipId, <String, dynamic>{
          'members.$memberId.callout': FieldValue.delete(),
          'members.$memberId.drinks': FieldValue.arrayUnion(
            List<Timestamp>.generate(
              drinks,
              (int index) => Timestamp.now(),
            ),
          ),
        });
      } else {
        await _updateDocument(fellowshipId, <String, dynamic>{
          'members.$memberId.callout': FieldValue.delete(),
        });
      }
    } catch (e) {
      logError('resolveCallout', e);
      rethrow;
    }
  }

  //SET OF PIN-BASED GETTERS AND SUCH. So you can join games and work off solely a pin-based system.
  @override
  Future<Fellowship?> getByPin(String fellowshipPin) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query =
          await _fellowshipCollectionReference
              .where('pin', isEqualTo: fellowshipPin)
              .orderBy('createdAt', descending: true)
              .get();

      if (query.docs.isEmpty) {
        logError('Query returned empty.', e);
        return null;
      }

      final DocumentSnapshot<Map<String, dynamic>> doc = query.docs.first;

      return Fellowship.fromJson(<String, dynamic>{
        ...doc.data()!,
        'id': doc.id,
      });
    } catch (e) {
      logError('Exception in getByPin', e);
      return null;
    }
  }

  Future<void> _updateDocument(
    String fellowshipId,
    Map<String, dynamic> data,
  ) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      await docRef.update(data);

      // await docRef.set(data, SetOptions(merge: true));
    } catch (error) {
      logError('_updateDocument', error);
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>>
      get _fellowshipCollectionReference => _db.collection('fellowship');

  DocumentReference<Map<String, dynamic>> _getFellowshipDocumentReference(
          String fellowshipId) =>
      _fellowshipCollectionReference.doc(fellowshipId);
}

final Provider<FellowshipRepositoryModel> fellowshipRepository =
    Provider<FellowshipRepositoryModel>(
  (Ref ref) => FellowshipRepository(
    FirebaseFirestore.instance,
  ),
);
