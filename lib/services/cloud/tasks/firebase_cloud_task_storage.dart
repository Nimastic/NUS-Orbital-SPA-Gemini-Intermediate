import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloud_constants.dart';
import '../cloud_storage_exceptions.dart';
import 'cloud_task.dart';

class FirebaseCloudTaskStorage {

  // Creates a singleton.
  factory FirebaseCloudTaskStorage() => _shared;

  static final FirebaseCloudTaskStorage _shared = 
      FirebaseCloudTaskStorage._sharedInstance();

  FirebaseCloudTaskStorage._sharedInstance();

  final tasks = FirebaseFirestore.instance.collection('task');

  Future<CloudTask> createNewTask({required String ownerUserId}) async {

    DateTime time = DateTime(2000);
    String defaultTime = time.toString();

    final document = await tasks.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      textFieldName: '',
      deadlineFieldName: defaultTime,
      difficultyFieldName: 5,
      importanceFieldName: 5,
      timeRequriedFieldName: 0,
      isCompletedFieldName: 0,
      // remindFieldName: 0,
      // repeatFieldName: 0,
    });

    final fetchedTask = await document.get();
    return CloudTask(
      documentId: fetchedTask.id, 
      ownerUserId: ownerUserId, 
      title: '',
      text: '',
      deadline: defaultTime,
      difficulty: 5,
      importance: 5,
      timeRequired: 0,
      isCompleted: 0,
    );
  }

  Future<Iterable<CloudTask>> getTasks({required String ownerUserId}) async {
    try {
      return await tasks.where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId      
      ).get()
      .then(
        (value) => value.docs.map(
          (doc) => CloudTask.fromSnapshot(doc),
        )
      );
    } catch(e) {
      throw CouldNotGetAllException();
    }
  }

  Future<bool> updateTask({
    required String documentId,
    required String title,
    required String text,
    required String deadline,
    required int difficulty,
    required int importance,
    required int timeRequired,
  }) async {
    try {
      tasks.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
        deadlineFieldName: deadline,
        difficultyFieldName: difficulty,
        importanceFieldName: importance,
        timeRequriedFieldName: timeRequired,
      });
      return true;
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  Future<bool> deleteTask({required String documentId}) async {
    try {
      await tasks.doc(documentId).delete();
      return true;
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  Future<bool> completeTask({
    required String documentId,
    required int isCompleted
  }) async {
    try {
      tasks.doc(documentId).update({
        isCompletedFieldName: isCompleted
      });
      return true;
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  Stream<Iterable<CloudTask>> allDocs({required String ownerUserId}) =>
    tasks.snapshots().map((event) => event.docs
    .map((doc) => CloudTask.fromSnapshot(doc))
    .where((task) => task.ownerUserId == ownerUserId));
}