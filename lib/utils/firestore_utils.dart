/// This file contains the methods to deserialize and serialize the Firestore. Used for models
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Deserialize Firebase DocumentReference data type from Firestore
DocumentReference<Map<String, dynamic>>? firestoreDocRefFromJson(
    dynamic value) {
  if (value is DocumentReference) {
    return FirebaseFirestore.instance.doc(value.path);
  } else if (value is String) {
    return FirebaseFirestore.instance.doc(value);
  }
  return null;
}

/// This method only stores the "relation" data type back in Firestore
dynamic firestoreDocRefToJson(dynamic value) => value;

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp? firestoreTimestampFromJson(dynamic value) {
  return value != null
      ? Timestamp.fromMicrosecondsSinceEpoch(value as int)
      : null;
}

/// This method only stores the "timestamp" data type back in Firestore
dynamic firestoreTimestampToJson(dynamic value) => value;
