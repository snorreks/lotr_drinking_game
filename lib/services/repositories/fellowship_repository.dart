import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_service.dart';
import '../../constants/characters.dart';
import '../../models/fellowship.dart';

abstract class FellowshipRepositoryModel {
  Future<Fellowship?> get(String fellowshipId); //Semi-deprecated!!
  Future<Fellowship?> getByPin(String fellowshipPin);

  Stream<Fellowship?> streamByPin(String fellowshipPin);
  Stream<Fellowship?> stream(String fellowshipId); //FULLY DEPRECATED

  Future<String> create(String fellowshipName);
  Future<void> update(String fellowshipId, Fellowship fellowship);

  Future<void> increment(String fellowshipId, Character character);
  Future<void> incrementByPin(String fellowshipPin, Character character);
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
  Future<void> update(String fellowshipId, Fellowship fellowship) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      await docRef.update(fellowship.toJson());
    } catch (e) {
      logError('updateFellowship', e);
      rethrow;
    }
  }

  //DEPRECATED!!
  @override
  Future<void> increment(String fellowshipId, Character character) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _getFellowshipDocumentReference(fellowshipId);

      await docRef.update({
        'members.${character.value}.drinks': FieldValue.increment(1),
      });
    } catch (e) {
      logError('increment', e);
      rethrow;
    }
  }

  @override
  Future<Fellowship?> getByPin(String pin) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query =
          await _fellowshipCollectionReference
              .where('pin', isEqualTo: pin)
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

  @override
  Stream<Fellowship?> streamByPin(String pin) {
    try {
      return _fellowshipCollectionReference
          .where('pin', isEqualTo: pin)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .where((QuerySnapshot<Map<String, dynamic>> query) =>
              query.docs.isNotEmpty)
          .map(
        (QuerySnapshot<Map<String, dynamic>> query) {
          final DocumentSnapshot<Map<String, dynamic>> doc = query.docs.first;
          return Fellowship.fromJson(<String, dynamic>{
            ...doc.data()!,
            'id': doc.id,
          });
        },
      );
    } catch (e) {
      logError('streamByPin', e);
      return const Stream<Fellowship?>.empty();
    }
  }

  @override
  Future<void> incrementByPin(String pin, Character character) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query =
          await _fellowshipCollectionReference
              .where('pin', isEqualTo: pin)
              .orderBy('createdAt', descending: true)
              .get();

      if (query.docs.isEmpty) {
        throw Exception('No fellowship with the provided PIN');
      }

      final DocumentReference<Map<String, dynamic>> docRef =
          query.docs.first.reference;

      await docRef.update({
        'members.${character.value}.drinks': FieldValue.increment(1),
      });
    } catch (e) {
      logError('incrementByPin', e);
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
