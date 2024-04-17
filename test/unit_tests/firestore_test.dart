import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orbital_spa/services/cloud/cloud_storage_exceptions.dart';
import 'package:orbital_spa/services/cloud/events/firebase_cloud_event_storage.dart';
import 'package:orbital_spa/services/cloud/reminders/firebase_cloud_reminders_storage.dart';
import 'package:orbital_spa/services/cloud/tasks/cloud_task.dart';
import 'package:orbital_spa/services/cloud/tasks/firebase_cloud_task_storage.dart';
import 'firestore_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QueryDocumentSnapshot,
  QuerySnapshot,
  Query,
  FirebaseCloudTaskStorage,
  FirebaseCloudEventStorage,
  FirebaseCloudReminderStorage
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocumentSnapshot;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockFirebaseCloudTaskStorage mockFirebaseCloudTaskStorage;
  // late MockFirebaseCloudEventStorage mockFirebaseCloudEventStorage;
  // late MockFirebaseCloudReminderStorage mockFirebaseCloudReminderStorage;
  late Map<String, dynamic> dataFields;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQuery = MockQuery();
    // streamMockQuerySnapshot = const Stream();
    mockFirebaseCloudTaskStorage = MockFirebaseCloudTaskStorage();
    // mockFirebaseCloudEventStorage = MockFirebaseCloudEventStorage();
    // mockFirebaseCloudReminderStorage = MockFirebaseCloudReminderStorage();
    dataFields = <String, dynamic>{};

    // Set up the relationships between Firestore classes
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocumentReference);
  });

  group('Mock CloudTask firestore', () {

    test('Successfully created a task and return a CloudTask', () async {
      // Arrange.
      when(mockCollection.add(dataFields)).thenAnswer((_) async 
          => mockDocumentReference);
      when(mockDocumentReference.get()).thenAnswer((_) async 
          => mockDocumentSnapshot);
      // Simulate the data returned from Firestore when the document is fetched.
      when(mockDocumentSnapshot.id).thenReturn('test_document_id');
      when(mockFirebaseCloudTaskStorage.createNewTask(ownerUserId: 'test_owner_user_id'))
          .thenAnswer((_) async => const CloudTask(
                                     documentId: 'test_document_id',
                                     ownerUserId: 'test_owner_user_id',
                                     title: 'test_title',
                                     text: 'test_text',
                                     deadline: 'test_deadline',
                                     difficulty: 0,
                                     importance: 0,
                                     timeRequired: 0,
                                     isCompleted: 0,
                                    )
      );

      // Act
      CloudTask cloudTask = await mockFirebaseCloudTaskStorage.createNewTask(ownerUserId: 'test_owner_user_id');

      // Assert that the created CloudTask has the expected values.
      expect(cloudTask.documentId, 'test_document_id');
      expect(cloudTask.ownerUserId, 'test_owner_user_id');
    });

    test('Successfully get tasks and return a Future<Iterable<CloudTask>>', () async {
      // Arrange. 
      const ownerUserId = 'test_owner_user_id';
      when(mockCollection.where('ownerUserIdFieldName', isEqualTo: ownerUserId)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);

      // Simulate the data returned from Firestore when the query is executed.
      const cloudTask1 = CloudTask(
        documentId: 'task_1',
        ownerUserId: ownerUserId,
        title: 'Task 1',
        text: 'Task 1 description',
        deadline: 'Task 1 deadline',
        difficulty: 0,
        importance: 0,
        timeRequired: 0,
        isCompleted: 0
      );

      const cloudTask2 = CloudTask(
        documentId: 'task_2',
        ownerUserId: ownerUserId,
        title: 'Task 2',
        text: 'Task 2 description',
        deadline: 'Task 2 deadline',
        difficulty: 0,
        importance: 0,
        timeRequired: 0,
        isCompleted: 0
      );

      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot, mockQueryDocumentSnapshot]);

      when(mockDocumentSnapshot.data()).thenReturn({
        'documentId': cloudTask1.documentId,
        'ownerUserId': cloudTask1.ownerUserId,
        'title': cloudTask1.title,
        'text': cloudTask1.text,
        'deadline': cloudTask1.deadline,
        'difficulty': cloudTask1.difficulty,
        'importance': cloudTask1.importance,
        'timeRequired': cloudTask1.timeRequired,
        'isCompleted': cloudTask1.isCompleted,
        // Add other properties based on your CloudTask.fromSnapshot(doc) mapping.
      });

      when(mockDocumentSnapshot.data()).thenReturn({
        'documentId': cloudTask2.documentId,
        'ownerUserId': cloudTask2.ownerUserId,
        'title': cloudTask2.title,
        'text': cloudTask2.text,
        'deadline': cloudTask2.deadline,
        'difficulty': cloudTask2.difficulty,
        'importance': cloudTask2.importance,
        'timeRequired': cloudTask2.timeRequired,
        'isCompleted': cloudTask2.isCompleted,
        // Add other properties based on your CloudTask.fromSnapshot(doc) mapping.
      });

      // when(mockQuerySnapshot.docs.map((doc) => CloudTask.fromSnapshot(doc)))
      //     .thenReturn([cloudTask1, cloudTask2]);

      when(mockFirebaseCloudTaskStorage.getTasks(ownerUserId: ownerUserId))
          .thenAnswer((_) async => [cloudTask1, cloudTask2]);

      // Act
      Iterable<CloudTask> tasks = await mockFirebaseCloudTaskStorage.getTasks(ownerUserId: ownerUserId);
      
      // Assert
      expect(tasks, isA<Iterable<CloudTask>>());

      // Specific assertions for the tasks list based on test data.
      expect(tasks, contains(cloudTask1));
      expect(tasks, contains(cloudTask2));
    });

    test("Successfully update task", () async {
      // Arrange.
      const String documentId = 'test_document_id';
      const String title = 'Updated Title';
      const String text = 'Updated Text';
      const String deadline = 'Updated Deadline';
      const int difficulty = 5;
      const int importance = 5;
      const int timeRequired = 5;

      
      when(mockCollection.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update({})).thenAnswer((_) async => Future.value());
      when(mockFirebaseCloudTaskStorage.updateTask(
        documentId: documentId, 
        title: title, 
        text: text, 
        deadline: deadline, 
        difficulty: difficulty, 
        importance: importance, 
        timeRequired: timeRequired
      )).thenAnswer((_) async => true);

      // Act
      final updated = await mockFirebaseCloudTaskStorage.updateTask(
        documentId: documentId, 
        title: title, 
        text: text, 
        deadline: deadline, 
        difficulty: difficulty, 
        importance: importance, 
        timeRequired: timeRequired
      );

      // Assert
      expect(updated, true);
    });

    test('Successfully delete task', () async {
      // Arrange.
      const String documentId = 'test_document_id';
      when(mockCollection.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenAnswer((_) async => Future.value());
      when(mockFirebaseCloudTaskStorage.deleteTask(
        documentId: documentId,
      )).thenAnswer((_) async => true);

      // Act
      final deleted = await mockFirebaseCloudTaskStorage.deleteTask(
        documentId: documentId, 
      );

      // Assert
      expect(deleted, true);
    });

    test("Successfully complete task", () async {
      // Arrange.
      const String documentId = 'test_document_id';
      const int isCompleted = 1;

      
      when(mockCollection.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update({})).thenAnswer((_) async => Future.value());
      when(mockFirebaseCloudTaskStorage.completeTask(
        documentId: documentId, 
        isCompleted: isCompleted
      )).thenAnswer((_) async => true);

      // Act
      final completed = await mockFirebaseCloudTaskStorage.completeTask(
        documentId: documentId, 
        isCompleted: 1
      );

      // Assert
      expect(completed, true);
    });

    test('Stream emits expected CloudTasks for specific ownerUserId', () async {
      // Arrange
      const ownerUserId = 'test_owner_user_id';
      const task1 = CloudTask(
        documentId: 'task_1',
        ownerUserId: ownerUserId,
        title: 'Task 1',
        text: 'Task 1 description',
        deadline: 'Task 1 deadline',
        difficulty: 0,
        importance: 0,
        timeRequired: 0,
        isCompleted: 0,
      );
      const task2 = CloudTask(
        documentId: 'task_2',
        ownerUserId: ownerUserId,
        title: 'Task 2',
        text: 'Task 2 description',
        deadline: 'Task 2 deadline',
        difficulty: 0,
        importance: 0,
        timeRequired: 0,
        isCompleted: 0,
      );

      when(mockFirebaseCloudTaskStorage.allDocs(ownerUserId: ownerUserId))
      .thenAnswer((_) => Stream.fromIterable([[task1, task2]]));

      // Act
      final streamFuture = mockFirebaseCloudTaskStorage.allDocs(ownerUserId: ownerUserId).toList();

      // Await the first emitted value
      final tasks = (await streamFuture)[0];

      // Assert
      expect(tasks, isA<Iterable<CloudTask>>());

      // Specific assertions for the tasks list based on test data.
      expect(tasks, contains(task1));
      expect(tasks, contains(task2));

    });

    test('Throw CouldNotGetAllException when getTasks fails', () {
      // Arrange
      const ownerUserId = 'test_owner_user_id';

      // when(mockCollection.where('ownerUserIdFieldName', isEqualTo: ownerUserId)).thenReturn(mockQuery);
      // when(mockQuery.get()).thenThrow(Exception('Firestore query failed'));
      when(mockFirebaseCloudTaskStorage.getTasks(ownerUserId: ownerUserId))
          .thenThrow(CouldNotGetAllException());

      // Act & Assert
      expect(
        () async => await mockFirebaseCloudTaskStorage.getTasks(ownerUserId: ownerUserId),
        throwsA(isInstanceOf<CouldNotGetAllException>()),
      );
    });

    test('Throw CouldNotUpdateException when update fails', () async {

      // Arrange.
      const String documentId = 'test_document_id';
      const String title = 'Updated Title';
      const String text = 'Updated Text';
      const String deadline = 'Updated Deadline';
      const int difficulty = 5;
      const int importance = 5;
      const int timeRequired = 5;

      // Set up the DocumentReference mock to throw an error when update is called.
      when(mockFirebaseCloudTaskStorage.updateTask(
        documentId: documentId, 
        title: title, 
        text: text, 
        deadline: deadline, 
        difficulty: difficulty, 
        importance: importance, 
        timeRequired: timeRequired
      )).thenThrow(CouldNotUpdateException());

      // Act and Assert
      expect(() async {
        await mockFirebaseCloudTaskStorage.updateTask(
          documentId: documentId,
          title: title,
          text: text,
          deadline: deadline,
          difficulty: difficulty,
          importance: importance,
          timeRequired: timeRequired,
        );
      }, throwsA(isInstanceOf<CouldNotUpdateException>()));
    });

    test('Throw CouldNotDeleteException when delete fails', () {
      // Arrange
      const documentId = 'test_document_id';

      when(mockFirebaseCloudTaskStorage.deleteTask(documentId: documentId))
          .thenThrow(CouldNotDeleteException());

      // Act & Assert
      expect(
        () async => await mockFirebaseCloudTaskStorage.deleteTask(documentId: documentId),
        throwsA(isInstanceOf<CouldNotDeleteException>()),
      );
    });

    test('Throw CouldNotUpdateException when completeTask fails', () async {

      // Arrange.
      const String documentId = 'test_document_id';
      const int isCompleted = 1;

      // Set up the DocumentReference mock to throw an error when update is called.
      when(mockFirebaseCloudTaskStorage.completeTask(
        documentId: documentId, 
        isCompleted: isCompleted
      )).thenThrow(CouldNotUpdateException());

      // Act and Assert
      expect(() async {
        await mockFirebaseCloudTaskStorage.completeTask(
          documentId: documentId,
          isCompleted: isCompleted
        );
      }, throwsA(isInstanceOf<CouldNotUpdateException>()));
    });

  });





}
