import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../data/consts/images.dart';
import '../login_view/login_view.dart';

class LetsStartView extends StatelessWidget {
  const LetsStartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomText(
                    text: "Let's Start",
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                    fontFamily: poppinsFontFamily,
                    size: 30,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomText(
                    text: "Get Every Answer You Need, Anytime!",
                    color: blackColor,
                    fontFamily: poppinsFontFamily,
                    size: 18,
                  ),
                ),
                Spacer(),
                CustomCard(
                  alignment: Alignment.center,
                  borderRadius: 7,
                  width: SizeConfig.screenWidth * 0.8,
                  height: 42,
                  color: Color(0xff9AC3FF),
                  child: CustomText(
                    text: "Start",
                    fontWeight: FontWeight.w500,
                    size: 15,
                    color: blackColor,
                    fontFamily: poppinsFontFamily,
                  ),
                  boxShadow: [
                    BoxShadow(color: grayColor,blurRadius: 5,offset: Offset(0, 3))
                  ],
                  onTap: () {
                    Get.to(LoginView(isTeacher: false,));
                  },
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () => Get.to(LoginView(isTeacher: true,)),
                  child: CustomText(
                    text: "I am a Teacher/Professor",
                    color: blackColor,
                    fontFamily: poppinsFontFamily,
                    size: 10,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            top: 50,
            right: 10,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                startRedBall,
                width: 150,
                height: 150,
              ),
            ),
          ),
          Positioned(
            top: 170,
            right: 40,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                startupLabBoy,
                width: 150,
                height: 150,
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            top: 10,
            left: 10,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                startupHindiBook,
                width: 150,
                height: 150,
              ),
            ),
          ),
          Positioned(
            bottom: 115,
            right: 50,
            left: 50,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                startBoyImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
