import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloud_constants.dart';

class CloudReminder {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String by;
  final int doRemind; //0, false; 1, true
  final String remindAt; 
  final int doRepeat;
  final String repeat;
  final int isCompleted; // 0, false; 1, true
  final int uniqueId;

  const CloudReminder({
    required this.documentId, 
    required this.ownerUserId, 
    required this.title,
    required this.by,
    required this.doRemind,
    required this.remindAt,
    required this.doRepeat,
    required this.repeat,
    required this.isCompleted,
    required this.uniqueId
  });

  factory CloudReminder.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CloudReminder(
      documentId: snapshot.id, 
      ownerUserId: snapshot.data()[ownerUserIdFieldName], 
      title: snapshot.data()[titleFieldName], 
      by: snapshot.data()[byFieldName], 
      doRemind: snapshot.data()[doRemindFieldName],
      remindAt: snapshot.data()[remindAtFieldName], 
      doRepeat: snapshot.data()[doRepeatFieldName],
      repeat: snapshot.data()[repeatFieldName],
      isCompleted: snapshot.data()[isCompletedFieldName], 
      uniqueId: snapshot.data()[uniqueIdFieldName]
    );
  }
}