import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_service.dart';
import '../../models/fellowship.dart';

abstract class FellowshipRepositoryModel {
  Future<Fellowship?> get(String fellowshipId);

  Stream<Fellowship?> stream(String fellowshipId);
  Future<String> create(String fellowshipName);
  Future<void> update(String fellowshipId, Fellowship fellowship);
}

class FellowshipRepository extends BaseService
    implements FellowshipRepositoryModel {
  FellowshipRepository(this._db);
  final FirebaseFirestore _db;

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
      final DocumentReference<Map<String, dynamic>> docRef =
          await _fellowshipCollectionReference.add(<String, dynamic>{
        'name': fellowshipName,
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
