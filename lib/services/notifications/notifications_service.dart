import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

// add repeated notifs, add notifs to events, figure out notif title
// figure out id for all events and reminders

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class NotifyHelper {
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> initializeNotification() async {
    _configureLocalTimezone();

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("icons8_app_50");


    const InitializationSettings initializationSettings =
        InitializationSettings(
       iOS: initializationSettingsIOS,
       android:initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground
        // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
        );
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }



  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('Notification payload: $payload');
    }
    // You can handle the notification response here
    // For example, you can navigate to a specific screen based on the payload
    // You can use the `navigatorKey` from your MaterialApp or use a different approach
  }

  // Future<void> onDidReceiveNotificationResponse(String? payload) async {
  // if (payload != null) {
  //   debugPrint('Notification payload: $payload');
  // }
  // You can handle the notification response here
  // For example, you can navigate to a specific screen based on the payload
  // You can use the `navigatorKey` from your MaterialApp or use a different approach
  // For demonstration purposes, we'll navigate to a dummy screen
  // Navigator.of(navigatorKey.currentContext!).push(CupertinoPageRoute<void>(
  //   builder: (BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Notification Response'),
  //       ),
  //       body: Center(
  //         child: Text('Notification Payload: $payload'),
  //       ),
  //     );
  //   },
  // ));
// }

//   void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     // await Navigator.push(
//     //   context,
//     //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
//     // );
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async { 
//       print("..................onMessage..................");
//       print("onMessage: ${message.notification?.title}/${message.notification?.body}");

//       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//         message.notification!.body.toString(), 
//         htmlFormatBigText: true,
//         contentTitle: message.notification!.title.toString(),
//         htmlFormatContentTitle: true
//       );

//       AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'SPA', 
//         'SPA',
//         importance: Importance.high,
//         styleInformation: bigTextStyleInformation,
//         priority: Priority.high,
//         playSound: true
//       );

//       NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: const DarwinNotificationDetails()
//       );

//       await flutterLocalNotificationsPlugin.show(
//         0, 
//         message.notification?.title, 
//         message.notification?.body, 
//         platformChannelSpecifics,
//         payload: message.data['body'] //if navigating to a diff page
//       );
//     });

// }

  Future<void> sendLocalNotification({required String title, required String body}) async {

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'SPA', //'channel_id'
      'SPA', //'channel_name'
      // channelDescription: 'your channel description',
      importance: Importance.max, 
      priority: Priority.high,
      playSound: true
      //customise notifs here
    );

    const iOSPlatformChannelSpecifics =  DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, 
      iOS: iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  Future<void> scheduledReminderNotification(DateTime scheduledTime, int id, String title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "Reminder:",
      title,
      TZDateTime.from(scheduledTime, tz.local),
    
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'SPA',
          'SPA', 
          // channelDescription: 'your channel description'
        )
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // payload: reminder.title    
    );
   }

  Future<void> scheduledDailyReminderNotification(DateTime scheduledTime, int id, String title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "Reminder:",
      title,
      TZDateTime.from(scheduledTime, tz.local),
    
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'SPA',
          'SPA', 
          // channelDescription: 'your channel description'
        )
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      // payload: reminder.title    
    );
   }

   Future<void> scheduledWeeklyReminderNotification(DateTime scheduledTime, int id, String title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "Reminder:",
      title,
      TZDateTime.from(scheduledTime, tz.local),
    
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'SPA',
          'SPA', 
          // channelDescription: 'your channel description'
        )
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      // payload: reminder.title    
    );
   }

   Future<void> scheduledMonthlyReminderNotification(DateTime scheduledTime, int id, String title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "Reminder:",
      title,
      TZDateTime.from(scheduledTime, tz.local),
    
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'SPA',
          'SPA', 
          // channelDescription: 'your channel description'
        )
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      // payload: reminder.title    
    );
   }

   Future<void> scheduledEventNotification(DateTime scheduledTime, int id, String title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "Upcoming event:",
      title,
      TZDateTime.from(scheduledTime, tz.local),
    
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'SPA',
          'SPA', 
          // channelDescription: 'your channel description'
        )
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // payload: reminder.title    
    );
   }

  Future<void> cancelScheduledNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id); //notification ID you want to cancel
  }

  Future<void> cancelAllScheduledNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }


  
  // Future onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   //context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  //   Get.dialog(const Text("Welcome to Flutter"));
  // }

  // tz.TZDateTime _convertTime(int hour, int minutes, bool isMorning) {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

  //   // If notifications should be sent at night, check if the scheduled time is in the morning
  // // and subtract 12 hours to it to schedule it at night of the same day
  // if (!isMorning && scheduleDate.hour < 12) {
  //   scheduleDate = scheduleDate.add(const Duration(hours: 12));
  // }

  //   if (scheduleDate.isBefore(now)) {
  //     scheduleDate = scheduleDate.add(const Duration(days: 1));
  //   }

  // //   If notifications should be sent in the morning, check if the scheduled time is in the night
  // // and add 12 hours to it to schedule it in the morning of the next day
  // // if (isMorning && scheduleDate.hour < 12) {
  // //   scheduleDate = scheduleDate.subtract(const Duration(hours: 12));
  // //   print('changed');
  // //   print(scheduleDate);
  // // }

  // print('date');
  //   print(scheduleDate);
  //   return scheduleDate;
  // }

}