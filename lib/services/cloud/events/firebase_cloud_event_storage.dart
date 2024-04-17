import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud_constants.dart';
import 'cloud_event.dart';
import '../cloud_storage_exceptions.dart';

class FirebaseCloudEventStorage {
  // Creates a singleton.
  factory FirebaseCloudEventStorage() => _shared;

  static final FirebaseCloudEventStorage _shared = 
      FirebaseCloudEventStorage._sharedInstance();

  FirebaseCloudEventStorage._sharedInstance();

  final events = FirebaseFirestore.instance.collection('event');

  Future<CloudEvent> createNewEvent({required String ownerUserId}) async {
    DateTime time = DateTime(2000);
    String defaultTime = time.toString();

    final document = await events.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      descriptionFieldName: '',
      fromFieldName: defaultTime,
      toFieldName: defaultTime,
      isAllDayFieldName: 1,
      doRemindFieldName: 0,
      remindAtFieldName: defaultTime,
      uniqueIdFieldName: 0
    });

    final fetchedEvent = await document.get();
    return CloudEvent(
      documentId: fetchedEvent.id, 
      ownerUserId: ownerUserId, 
      title: '',
      description: '',
      from: defaultTime,
      to: defaultTime,
      isAllDay: 1,
      doRemind: 0,
      remindAt: defaultTime,
      uniqueId: 0
    );
  }

  Future<Iterable<CloudEvent>> getEvents({required String ownerUserId}) async {
    try {
      return await events.where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId      
      ).get()
      .then(
        (value) => value.docs.map(
          (doc) => CloudEvent.fromSnapshot(doc),
        )
      );

    } catch(e) {
      throw CouldNotGetAllException();
    }
  }

  Future<void> updateEvent({
    required String documentId,
    required String title,
    required String description,
    required String from,
    required String to,
    required int isAllDay,
    required int doRemind,
    required String remindAt,
    required int uniqueId
  }) async {
    try {
      events.doc(documentId).update({
        titleFieldName: title,
        descriptionFieldName: description,
        fromFieldName: from,
        toFieldName: to,
        isAllDayFieldName: isAllDay,
        doRemindFieldName: doRemind,
        remindAtFieldName: remindAt,
        uniqueIdFieldName: uniqueId
      });
    } catch (e) {
      print(e);
      throw CouldNotUpdateException();
    }
  }

  Future<void> deleteEvent({required String documentId}) async {
    try {
      await events.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  Stream<Iterable<CloudEvent>> allEvents({required String ownerUserId}) =>
    events.snapshots().map((e) => e.docs
    .map((doc) => CloudEvent.fromSnapshot(doc))
    .where((event) => event.ownerUserId == ownerUserId));


  
  Future<List<CloudEvent>> eventList() async {
    var snapshotsValue = await events.get();

    return snapshotsValue.docs
        .map((event) => CloudEvent.fromSnapshot(event))
        .toList();
  }
}