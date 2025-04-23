import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pencilo/data/consts/colors.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/view/play_short_video.dart';
import 'package:pencilo/view/profile_view.dart';
import 'package:pencilo/view/buy_book_view/buy_book_view.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controller/home_controller.dart';
import '../model/student_model.dart';
import '../model/teacher_model.dart';
import 'friend_view.dart';
import 'home_view/home_startup_view.dart';
import 'home_view/home_view.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<Widget> _screens = [
    PlayShortVideo(),
    BuyBookView(),
    HomeView(),
    FriendsView(),
    StudentProfilePage(),
  ];

  final List<IconData> _icons = const [
    Icons.ondemand_video,
    Icons.menu_book,
    Icons.home,
    Icons.people,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    // Start location stream to continuously update the location
    _startLocationStream();

    return Obx(() {
      return Scaffold(
        body: _screens[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: blackColor,
          selectedItemColor: Color(0xff57A8B8),
          unselectedItemColor: whiteColor,
          iconSize: 26,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: _icons.map((icon) => BottomNavigationBarItem(
            icon: Icon(icon),
            label: '', // No label
          ))
              .toList(),
        ),
      );
    });
  }

  void _startLocationStream()async {
    if(!(await Permission.location.isGranted)){
      await Geolocator.requestPermission();
    }

    if(CurrentUserData.currentLocation == ''){

      // Create LocationSettings with desired accuracy and distance filter
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high, // Set desired accuracy (best)
        distanceFilter: 10, // Minimum distance in meters before update
      );

      // Start listening for location updates
      Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) async {
          String location = '${position.latitude}, ${position.longitude}';
          print("Updated Location: $location");
          print("Is Teacher:: ${CurrentUserData.isTeacher}");
          print("Is Student: ${CurrentUserData.isStudent}");

          // Store the updated location to Firestore for student or teacher
          if (CurrentUserData.isTeacher == true) {
            await FirebaseFirestore.instance.collection(teacherModelName).doc(CurrentUserData.uid).update({
              'currentLocation': location, // Update the current location
            });
            // Here implement to update the teacher current location in hive
            final teacherBox = await Hive.openBox<TeacherModel>(teacherModelName);
            final newTeacher = TeacherModel(
              uid: CurrentUserData.uid,
              name: CurrentUserData.name,
              schoolName: CurrentUserData.schoolName,
              phoneNumber: CurrentUserData.phoneNumber,
              currentLocation: location,
              subject: CurrentUserData.subject,
            );
            await teacherBox.add(newTeacher);

            CurrentUserData.currentLocation = location;

          } else if(CurrentUserData.isStudent == true) {
            await FirebaseFirestore.instance.collection(studentModelName).doc(CurrentUserData.uid).update({
              'currentLocation': location, // Update the current location
            });
            // Here implement to update the student current location in hive

            final studentBox = await Hive.openBox<StudentModel>(studentModelName);
            final newStudent = StudentModel(
              uid: CurrentUserData.uid,
              name: CurrentUserData.name,
              schoolName: CurrentUserData.schoolName,
              standard: CurrentUserData.standard,
              division: CurrentUserData.division,
              phoneNumber: CurrentUserData.phoneNumber,
              currentLocation: location,
            );
            await studentBox.add(newStudent);
            CurrentUserData.currentLocation = location;

          }
        },
      );
    }
  }
}
