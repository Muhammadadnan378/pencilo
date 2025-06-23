import 'dart:async';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/admin_views/admin_home_view.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/view/home.dart';
import 'package:pencilo/view/splash_view/lets_start_view.dart';
import '../../data/current_user_data/current_user_Data.dart';
import '../../web_views/web_home_views.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      debugPrint("${CurrentUserData.isAdmin}");

      // Load user data from Hive
      await CurrentUserData.loadUserDataFromHive();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kIsWeb) {
          // If Web, navigate to web view
          Get.offAll(() => WebHomeViews()); // You must create this
        } else {
          // Mobile/Desktop platforms
          if (CurrentUserData.isAdmin) {
            CurrentUserData.getSchoolName();
            Get.offAll(() => AdminHomeView());
          } else if (CurrentUserData.isTeacher || CurrentUserData.isStudent) {
            CurrentUserData.getSchoolName();
            Get.offAll(() => Home());
          } else {
            Get.offAll(() => LetsStartView());
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(appLogo),
      ),
    );
  }
}
