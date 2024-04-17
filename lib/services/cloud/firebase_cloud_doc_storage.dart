import 'package:orbital_spa/services/cloud/tasks/cloud_task.dart';

abstract class FirebaseCloudDocumentStorage {
  const FirebaseCloudDocumentStorage();

  Future<CloudTask> createNewTask({required String ownerUserId});
}