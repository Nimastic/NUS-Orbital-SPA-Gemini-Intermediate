import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital_spa/services/cloud/reminders/cloud_reminder.dart';

import '../cloud_constants.dart';
import '../cloud_storage_exceptions.dart';

class FirebaseCloudReminderStorage {
  // Creates a singleton.
  factory FirebaseCloudReminderStorage() => _shared;

  static final FirebaseCloudReminderStorage _shared = 
      FirebaseCloudReminderStorage._sharedInstance();

  FirebaseCloudReminderStorage._sharedInstance();

  final reminders = FirebaseFirestore.instance.collection('reminder');

  Future<CloudReminder> createNewReminder({required String ownerUserId}) async {
    DateTime time = DateTime(2000);
    String defaultTime = time.toString();

    final document = await reminders.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      byFieldName: defaultTime,
      doRemindFieldName: 0,
      remindAtFieldName: defaultTime,
      doRepeatFieldName: 0,
      repeatFieldName: "Daily",
      isCompletedFieldName: 0,
      uniqueIdFieldName: 0
    });

    final fetchedReminder = await document.get();
    return CloudReminder(
      documentId: fetchedReminder.id, 
      ownerUserId: ownerUserId, 
      title: '',
      by: defaultTime,
      doRemind: 0,
      remindAt: defaultTime,
      doRepeat: 0,
      repeat: "Daily",
      isCompleted: 1,
      uniqueId: 0
    );
  }

  Future<Iterable<CloudReminder>> getReminders({required String ownerUserId}) async {
    try {
      var all = await reminders.where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId      
      ).get()
      .then(
        (value) => value.docs.map(
          (doc) => CloudReminder.fromSnapshot(doc),
        )
      );
      return all;

    } catch(e) {
      throw CouldNotGetAllException();
    }
  }

  Future<void> updateReminder({
    required String documentId,
    required String title,
    required String by,
    required int doRemind,
    required String remindAt,
    required int doRepeat,
    required String repeat,
    required int isCompleted,
    required int uniqueId
  }) async {
    try {
      reminders.doc(documentId).update({
        titleFieldName: title,
        byFieldName: by,
        doRemindFieldName: doRemind,
        remindAtFieldName: remindAt,
        doRepeatFieldName: doRepeat,
        repeatFieldName: repeat,
        isCompletedFieldName: isCompleted,
        uniqueIdFieldName: uniqueId
      });
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  Future<void> deleteReminder({required String documentId}) async {
    try {
      await reminders.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  Future<void> completeReminder({
    required String documentId,
    required int isCompleted
  }) async {
    try {
      reminders.doc(documentId).update({
        isCompletedFieldName: isCompleted
      });
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  Stream<Iterable<CloudReminder>> allReminders({required String ownerUserId}) =>
    reminders.snapshots().map((e) => e.docs
    .map((doc) => CloudReminder.fromSnapshot(doc))
    .where((event) => event.ownerUserId == ownerUserId));


  Stream<Iterable<DateTime>> allDates({required String ownerUserId}) =>
    reminders.snapshots().map((e) => e.docs
    .map((doc) => CloudReminder.fromSnapshot(doc))
    .where((event) => event.ownerUserId == ownerUserId)
    .map((e) => DateTime.parse(e.by)));

  Stream<Iterable<CloudReminder>> dayReminder({required String ownerUserId, required DateTime date}) =>
    reminders.snapshots().map((e) => e.docs
    .map((doc) => CloudReminder.fromSnapshot(doc))
    .where((event) => event.ownerUserId == ownerUserId)
    .where((event) => DateTime.parse(event.by.split(' ')[0]).isAtSameMomentAs(date)));
}