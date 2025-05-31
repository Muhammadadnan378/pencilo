import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';
import '../data/custom_widget/play_short_video.dart';
import '../db_helper/model_name.dart';
import '../model/student_model.dart';
import '../model/teacher_model.dart';
import '../view/buy_book_view/student_buy_book_view/buy_sell_book_view.dart';
import '../view/events_view/events_view.dart';
import '../view/events_view/popular_games_view.dart';
import '../view/home_view/student_home_view/student_home_view.dart';
import '../view/home_view/teacher_home_cards_view/teacher_home_view.dart';
import '../view/profile_view/profile_view.dart';


class HomeController extends GetxController {

  @override
  void onInit() async{
    startLocationStream().then((value) {
      requestNotificationPermission();
    },);
    await MobileAds.instance.initialize();
    super.onInit();
  }

  RxInt selectedIndex = 2.obs; // Default is HomeView at center


  final List<Widget> screens = [
    PlayShortVideo(),
    BuySellBookView(),
    CurrentUserData.isTeacher == true ? TeacherHomeView() : StudentHomeView(),
    CurrentUserData.isTeacher == true ? FriendsView() : PopularGamesView(),
    ProfileView(),
  ];

  final List<IconData> icons = const [
    Icons.ondemand_video,
    Icons.menu_book,
    Icons.home,
    Icons.people,
    Icons.person,
  ];

}
Future<void> startLocationStream() async {
  // Step 1: Permission check
  var status = await Permission.location.status;

  if (status.isGranted) {
    debugPrint("Location permission already granted");
  } else {
    var result = await Permission.location.request();

    if (result.isGranted) {
      debugPrint("Permission granted after request");
    } else if (result.isPermanentlyDenied) {
      debugPrint("Permission permanently denied, opening settings");
      await openAppSettings();
      return;
    } else {
      debugPrint("Permission denied, but not permanently. You can ask again later.");
      return;
    }
  }

  // Step 2: Ensure location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    debugPrint("Location services are disabled.");
    return;
  }

  debugPrint("Permission Status: ${await Permission.location.isGranted}");

  // Step 3: Fetch and store initial location
  Position initialPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  String location = '${initialPosition.latitude}, ${initialPosition.longitude}';
  debugPrint("Initial Location: $location");

  // ✅ Store initial location
  if (CurrentUserData.isTeacher == true) {
    await FirebaseFirestore.instance
        .collection(teacherTableName)
        .doc(CurrentUserData.uid)
        .update({'currentLocation': location});

    final teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
    final newTeacher = TeacherModel(
      uid: CurrentUserData.uid,
      fullName: CurrentUserData.name,
      schoolName: CurrentUserData.schoolName,
      phoneNumber: CurrentUserData.phoneNumber,
      currentLocation: location,
      subject: CurrentUserData.subject,
    );
    await teacherBox.add(newTeacher);

    CurrentUserData.currentLocation = location;

  } else if (CurrentUserData.isStudent == true) {
    await FirebaseFirestore.instance
        .collection(studentTableName)
        .doc(CurrentUserData.uid)
        .update({'currentLocation': location});

    final studentBox = await Hive.openBox<StudentModel>(studentTableName);
    final newStudent = StudentModel(
      uid: CurrentUserData.uid,
      fullName: CurrentUserData.name,
      schoolName: CurrentUserData.schoolName,
      standard: CurrentUserData.standard,
      division: CurrentUserData.division,
      phoneNumber: CurrentUserData.phoneNumber,
      currentLocation: location,
    );
    await studentBox.add(newStudent);

    CurrentUserData.currentLocation = location;
  }

  // Step 4: Setup location stream
  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position position) async {
      String updatedLocation = '${position.latitude}, ${position.longitude}';
      debugPrint("Updated Location: $updatedLocation");

      if (CurrentUserData.isTeacher == true) {
        await FirebaseFirestore.instance
            .collection(teacherTableName)
            .doc(CurrentUserData.uid)
            .update({'currentLocation': updatedLocation});

        final teacherBox = await Hive.openBox<TeacherModel>(teacherTableName);
        final newTeacher = TeacherModel(
          uid: CurrentUserData.uid,
          fullName: CurrentUserData.name,
          schoolName: CurrentUserData.schoolName,
          phoneNumber: CurrentUserData.phoneNumber,
          currentLocation: updatedLocation,
          subject: CurrentUserData.subject,
        );
        await teacherBox.add(newTeacher);

        CurrentUserData.currentLocation = updatedLocation;

      } else if (CurrentUserData.isStudent == true) {
        await FirebaseFirestore.instance
            .collection(studentTableName)
            .doc(CurrentUserData.uid)
            .update({'currentLocation': updatedLocation});

        final studentBox = await Hive.openBox<StudentModel>(studentTableName);
        final newStudent = StudentModel(
          uid: CurrentUserData.uid,
          fullName: CurrentUserData.name,
          schoolName: CurrentUserData.schoolName,
          standard: CurrentUserData.standard,
          division: CurrentUserData.division,
          phoneNumber: CurrentUserData.phoneNumber,
          currentLocation: updatedLocation,
        );
        await studentBox.add(newStudent);

        CurrentUserData.currentLocation = updatedLocation;
      }
    },
  );
}

Future<void> requestNotificationPermission() async {
  // Check the notification permission status
  PermissionStatus status = await Permission.notification.status;

  if (!status.isGranted) {
    // Request permission if not granted
    PermissionStatus newStatus = await Permission.notification.request();

    if (newStatus.isGranted) {
      debugPrint('Notification permission granted');
    } else if (newStatus.isDenied) {
      debugPrint('Notification permission denied');
    } else if (newStatus.isPermanentlyDenied) {
      debugPrint('Notification permission permanently denied');
      openAppSettings(); // Optionally, you can prompt the user to open settings to manually enable permission.
    }
  } else {
    debugPrint('Notification permission already granted');
  }
}
