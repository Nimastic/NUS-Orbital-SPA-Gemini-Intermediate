import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital_spa/services/cloud/cloud_constants.dart';

class CloudTask{
  final String documentId;
  final String ownerUserId;
  final String title;
  final String text;
  final String deadline;
  final int difficulty;
  final int importance;
  final int timeRequired;
  final int isCompleted; // isCompleted ? 1 : 0

  const CloudTask({
    required this.documentId, 
    required this.ownerUserId, 
    required this.title, 
    required this.text,
    required this.deadline,
    required this.difficulty,
    required this.importance,
    required this.timeRequired,
    required this.isCompleted,
    // required this.remind,
    // required this.repeat,
  });

  // Factory method.
  factory CloudTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CloudTask(
      documentId: snapshot.id, 
      ownerUserId: snapshot.data()[ownerUserIdFieldName], 
      title: snapshot.data()[titleFieldName], 
      text: snapshot.data()[textFieldName], 
      deadline: snapshot.data()[deadlineFieldName], 
      difficulty: snapshot.data()[difficultyFieldName], 
      importance: snapshot.data()[importanceFieldName], 
      timeRequired: snapshot.data()[timeRequriedFieldName],
      isCompleted: snapshot.data()[isCompletedFieldName], 
    );
  }
}