import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_service.dart';
import '../../constants/characters.dart';
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
  Future<void> addMember(String fellowshipId, FellowshipMember member);
  Future<void> changeAdmin(String fellowshipId, FellowshipMember newAdmin,
      FellowshipMember oldAdmin);

  Future<void> increment({
    required String fellowshipId,
    required Character character,
    required IncrementType type,
    int? amount,
  });

  Future<void> createCallout({
    required String fellowshipId,
    required Character character,
    required String rule,
  });
  Future<void> resolveCallout({
    required String fellowshipId,
    required Character character,
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
        'members': <String, dynamic>{}
      });

      return docRef.id;
    } catch (e) {
      logError('createFellowship', e);
      rethrow;
    }
  }

  @override
  Future<void> addMember(String fellowshipId, FellowshipMember member) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      await docRef.update(<String, dynamic>{
        'members.${member.character.value}': <String, dynamic>{
          'name': member.name,
          'isAdmin': member.isAdmin,
        }
      });
    } catch (e) {
      logError('updateFellowship', e);
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
        transaction.update(docRef, {
          'members.${newAdmin.character.value}.isAdmin': true,
          'members.${oldAdmin.character.value}.isAdmin': false
        });
      });
    } catch (e) {
      logError('changeAdmin', e);
      rethrow;
    }
  }

  @override
  Future<void> increment({
    required String fellowshipId,
    required Character character,
    required IncrementType type,
    int? amount,
  }) async {
    try {
      await _updateDocument(fellowshipId, <String, dynamic>{
        'members.${character.value}.${type.value}': FieldValue.arrayUnion(
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
    required Character character,
    required String rule,
  }) async {
    try {
      await _updateDocument(fellowshipId, <String, dynamic>{
        'members.${character.value}.callout': rule,
      });
    } catch (e) {
      logError('createCallout', e);
      rethrow;
    }
  }

  @override
  Future<void> resolveCallout({
    required String fellowshipId,
    required Character character,
    required int drinks,
  }) async {
    try {
      if (drinks > 0) {
        await _updateDocument(fellowshipId, <String, dynamic>{
          'members.${character.value}.callout': FieldValue.delete(),
          'members.${character.value}.drinks': FieldValue.arrayUnion(
            List<Timestamp>.generate(
              drinks,
              (int index) => Timestamp.now(),
            ),
          ),
        });
      } else {
        await _updateDocument(fellowshipId, <String, dynamic>{
          'members.${character.value}.callout': FieldValue.delete(),
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
  (ProviderRef<FellowshipRepositoryModel> ref) => FellowshipRepository(
    FirebaseFirestore.instance,
  ),
);
