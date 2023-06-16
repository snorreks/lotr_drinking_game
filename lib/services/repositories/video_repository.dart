import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_service.dart';
import '../../models/score.dart';

abstract class CategoryRepositoryModel {
  Stream<Iterable<Score>> categoriesStream();
}

class CategoryRepository extends BaseService
    implements CategoryRepositoryModel {
  CategoryRepository(this._db);
  final FirebaseFirestore _db;

  @override
  Stream<Iterable<Score>> categoriesStream() {
    try {
      final Query<Map<String, dynamic>> querySnap =
          _categoriesCollectionRef.orderBy('priority');

      return querySnap.snapshots().map(
            (QuerySnapshot<Map<String, dynamic>> snap) => snap.docs
                .where(
                    (DocumentSnapshot<Map<String, dynamic>> doc) => doc.exists)
                .map(
                  (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                      Score.fromJson(
                    doc.id,
                    doc.data(),
                  ),
                ),
          );
    } catch (e) {
      logError('categoriesStream', e);
      return const Stream<Iterable<Score>>.empty();
    }
  }

  CollectionReference<Map<String, dynamic>> get _categoriesCollectionRef =>
      _db.collection('categories');
}

final Provider<CategoryRepositoryModel> categoryRepository =
    Provider<CategoryRepositoryModel>(
  (ProviderRef<CategoryRepositoryModel> ref) => CategoryRepository(
    FirebaseFirestore.instance,
  ),
);
