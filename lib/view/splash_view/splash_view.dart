import 'dart:async';

import 'package:pencilo/admin_views/admin_home_view.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/view/home.dart';
import 'package:pencilo/view/splash_view/lets_start_view.dart';
import '../../data/consts/const_import.dart';
import '../../data/current_user_data/current_user_Data.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    debugPrint("${CurrentUserData.isAdmin}");
    // Load user data from Hive
    CurrentUserData.loadUserDataFromHive().then((_) {
      if (CurrentUserData.isAdmin) {
        Get.offAll(AdminHomeView());
      } else if (CurrentUserData.isTeacher || CurrentUserData.isStudent) {
        Get.offAll(Home());
      } else {
        Get.offAll(LetsStartView());
      }
      CurrentUserData.getSchoolName();
    });


    // Navigate after 2 seconds
    Timer(Duration(seconds: 2), () {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(text: 'Aniket Ganesh', color: blackColor, fontFamily: interFontFamily, size: 14),
            SizedBox(height: 5),
            CustomCard(
              alignment: Alignment.center,
              borderRadius: 100,
              color: Color(0xff57A8B8),
              width: 146,
              height: 146,
              child: CustomText(text: "AG", size: 45, color: blackColor, fontFamily: nixinOneFontFamily),
            ),
          ],
        ),
      ),
    );
  }
}

