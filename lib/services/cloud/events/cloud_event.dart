import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud_constants.dart';

class CloudEvent {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String description;
  final String from;
  final String to;
  final int isAllDay; // 0, false; 1, true
  final int doRemind; // 0, false; 1, true
  final String remindAt;
  final int uniqueId;

  const CloudEvent({
    required this.documentId, 
    required this.ownerUserId, 
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.doRemind,
    required this.remindAt,
    required this.isAllDay,
    required this.uniqueId
  });

  CloudEvent.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
  documentId = snapshot.id,
  ownerUserId = snapshot.data()[ownerUserIdFieldName],
  title = snapshot.data()[titleFieldName],
  description = snapshot.data()[descriptionFieldName],
  from = snapshot.data()[fromFieldName],
  to = snapshot.data()[toFieldName] as String,
  isAllDay = snapshot.data()[isAllDayFieldName] as int,
  doRemind = snapshot.data()[doRemindFieldName] as int,
  remindAt = snapshot.data()[remindAtFieldName] as String,
  uniqueId = snapshot.data()[uniqueIdFieldName] as int;
}