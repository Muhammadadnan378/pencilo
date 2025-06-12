import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/firebase_options.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/model/student_model.dart';
import 'package:pencilo/model/teacher_model.dart';
import 'package:pencilo/view/home_view/student_home_view/notification_view.dart';
import 'package:pencilo/view/splash_view/splash_view.dart';
import 'data/custom_widget/custom_media_query.dart';
import 'local_notification_practice/notifiaction_practice_view.dart';
import 'model/admin_model.dart';
// @pragma("vm:entry-point")
// Future<void> onActionReceivedMethod(ReceivedAction action) async {
//   final payload = action.payload ?? {};
//   final screen = payload['screen'];
//
//   if (screen == 'NotificationView') {
//     // Ensure the app is fully launched
//     Get.to(() => NotificationView());
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 🔔 Foreground notification display
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint("🔔 Foreground message received: ${message.notification?.title}");

  });
  // 🔗 Handle tap from system notification (Firebase default notification tap)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final screen = message.data['screen'];
    if (screen == 'NotificationView') {
      Get.to(() => NotificationView());
    }
  });

  // Hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(TeacherModelAdapter());
  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(SellBookModelAdapter());
  Hive.registerAdapter(AdminModelAdapter());

  await Hive.openBox<TeacherModel>(teacherTableName);
  await Hive.openBox<StudentModel>(studentTableName);
  await Hive.openBox<SellBookModel>(sellBookTableName);
  await Hive.openBox<AdminModel>(adminTableName);

  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // 👈 call this once
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
      // ShowAwesomeForegroundNotification(),
      // ShowAddBanner(),
      SplashView(),
    );
  }
}




// class Practice extends StatelessWidget {
//   Practice({super.key});
//
//   final RxList<RxBool> isPresentList = <RxBool>[].obs;
//   final RxList<String> datas = <String>[].obs;
//   bool initialized = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//           children: [
//             Padding(
//                 padding: const EdgeInsets.all(70.0),
//                 child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection(attendanceRecordsTableName)
//                         .doc("2025-5-18")
//                         .collection("students")
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) return CircularProgressIndicator();
//
//                       var attendanceDocs = snapshot.data!.docs;
//
//                       return StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection(attendanceTableName)
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) return CircularProgressIndicator();
//
//                             var usersDocs = snapshot.data!.docs;
//
//                             /// ✅ Initialize once when attendanceDocs is not empty
//                             if (!initialized && usersDocs.isNotEmpty) {
//                               isPresentList.clear();
//                               for (int i = 0; i < usersDocs.length; i++) {
//                                 if (attendanceDocs.any((doc) =>
//                                 doc.id == usersDocs[i].id)) {
//                                   final matchedDoc = attendanceDocs
//                                       .firstWhere((doc) => doc.id == usersDocs[i].id);
//                                   isPresentList.add(
//                                       (matchedDoc['isPresent'] as bool).obs);
//                                 } else {
//                                   isPresentList.add(false.obs); // default
//                                 }
//                               }
//                               initialized = true;
//                             }
//                             return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: usersDocs.length,
//                               itemBuilder: (context, index) {
//
//                                 if(attendanceDocs.isNotEmpty){
//                                   datas.add(attendanceDocs[index]['createdDateTime']);
//                                 }
//
//                                 return Column(
//                                   children: [
//                                     Obx(() {
//                                       isPresentList[index].value;
//                                       final present = attendanceDocs.isEmpty ? isPresentList[index].value : attendanceDocs[index]['isPresent'];
//                                       final activeColor = present ? Colors.green : Color(0xffAC4444);
//                                       return Padding(
//                                         padding: const EdgeInsets.only(bottom: 10.0),
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             isPresentList[index].value = !present;
//                                           },
//                                           child: AnimatedContainer(
//                                             duration: Duration(milliseconds: 300),
//                                             curve: Curves.easeInOut,
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 4, vertical: 4),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               border: Border.all(color: activeColor, width: 2),
//                                               borderRadius: BorderRadius.circular(15),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 if (!present)
//                                                   AnimatedContainer(
//                                                     duration: Duration(milliseconds: 300),
//                                                     width: 20,
//                                                     height: 20,
//                                                     decoration: BoxDecoration(
//                                                       color: activeColor,
//                                                       shape: BoxShape.circle,
//                                                     ),
//                                                   ),
//                                                 if (!present)
//                                                   SizedBox(width: 10),
//                                                 AnimatedSwitcher(
//                                                   duration: Duration(milliseconds: 300),
//                                                   child: Text(
//                                                     !present ? "Present" : "Absent",
//                                                     key: ValueKey(present),
//                                                     style: TextStyle(
//                                                       color: activeColor,
//                                                       fontSize: 12,
//                                                       fontWeight: FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 if (present)
//                                                   SizedBox(width: 10),
//                                                 if (present)
//                                                   AnimatedContainer(
//                                                     duration: Duration(
//                                                         milliseconds: 300),
//                                                     width: 20,
//                                                     height: 20,
//                                                     decoration: BoxDecoration(
//                                                       color: activeColor,
//                                                       shape: BoxShape.circle,
//                                                     ),
//                                                   ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                                   ],
//                                 );
//                               },);
//                           }
//                       );
//                     }
//                 )
//             ),
//             CustomCard(
//               onTap: () async {
//                 final userSnapshot = await FirebaseFirestore.instance
//                     .collection(attendanceTableName)
//                     .get();
//                 final userDocs = userSnapshot.docs;
//
//                 for (int i = 0; i < userDocs.length; i++) {
//                   final userId = userDocs[i].id;
//                   final isPresent = isPresentList[i].value;
//
//                   final attendanceRef = FirebaseFirestore.instance
//                       .collection(attendanceRecordsTableName)
//                       .doc("2025-5-18")
//                       .collection("students")
//                       .doc(userId);
//
//                   final docSnapshot = await attendanceRef.get();
//
//                   if (!docSnapshot.exists) {
//                     await attendanceRef.set({
//                       'isPresent': isPresent,
//                       'createdDateTime': DateTime.now().toIso8601String(),
//                       'userId': userId,
//                     });
//                   } else {
//                     // Optional: update existing record
//                     await attendanceRef.update({
//                       'isPresent': isPresent,
//                     });
//                   }
//                 }
//
//                 Get.snackbar("Updated", "Attendance marked successfully");
//               },
//               width: 150,
//               height: 36,
//               color: blackColor,
//               alignment: Alignment.center,
//               borderRadius: 10,
//               child: CustomText(text: "Update"),
//             ),
//           ],
//         )
//     );
//   }
// }



// class ShowAwesomeForegroundNotification extends StatelessWidget {
//   const ShowAwesomeForegroundNotification({super.key});
//
//   void _sendNotification() {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 10, // Unique ID for the notification
//         channelKey: 'basic_channel',
//         title: 'Hello Awesome Notifications!',
//         body: 'This is a foreground notification example.',
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize Awesome Notifications
//     AwesomeNotifications().initialize(
//       null, // Use null to load default app icon
//       [
//         NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//           defaultColor: Color(0xFF9D50DD),
//           ledColor: Colors.white,
//         )
//       ],
//     );
//
//     // Request notification permissions
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Foreground Notification Example'),
//       ),
//       body: Center(
//         child: Text('Press the button to send a notification.'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendNotification,
//         child: Icon(Icons.notifications),
//       ),
//     );
//   }
// }











