import 'package:pencilo/admin_views/admin_login.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../controller/login_controller.dart';
import '../../data/consts/images.dart';
import '../login_view/login_view.dart';

class LetsStartView extends StatelessWidget {
  LetsStartView({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 20,
            top: 40,
            child: GestureDetector(
              onTap: () {
                controller.isStudent = false;
                controller.isTeacher = false;
                Get.to(AdminLogin());
              },
              child: Icon(
                Icons.admin_panel_settings,
                size: 30,
                color: blackColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.07,
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
                  borderRadius: 11,
                  width: double.infinity,
                  height: 57,
                  color: blackColor,
                  boxShadow: [
                    BoxShadow(color: grayColor,blurRadius: 5,offset: Offset(0, 3))
                  ],
                  onTap: () {
                    controller.isStudent = true;
                    Get.to(LoginView());
                  },
                  child: CustomText(
                    text: "Start",
                    fontWeight: FontWeight.w500,
                    size: 15,
                    fontFamily: poppinsFontFamily,
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    controller.isTeacher = true;
                    Get.to(LoginView());
                  },
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
