import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/colors.dart';
import '../controller/home_controller.dart';
import '../data/current_user_data/current_user_Data.dart';

class FcmService {
  static Future<String?> getPushToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}

class Home extends StatelessWidget {
  Home({super.key});
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    debugPrint("is teacher ${CurrentUserData.isTeacher}");
    debugPrint(" is student ${CurrentUserData.isStudent}");
    return Obx(() {
      return Scaffold(
        body: controller.screens[controller.selectedIndex.value],
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
          items: controller.icons.map((icon) => BottomNavigationBarItem(
            icon: Icon(icon),
            label: '', // No label
          ))
              .toList(),
        ),
      );
    });
  }
}
