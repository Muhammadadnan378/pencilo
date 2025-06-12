import 'package:pencilo/admin_views/admin_login.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../controller/login_controller.dart';
import '../../data/consts/images.dart';
import '../../db_helper/model_name.dart';
import '../../model/admin_model.dart';
import '../../model/student_model.dart';
import '../../model/teacher_model.dart';
import '../login_view/login_view.dart';

class LetsStartView extends StatelessWidget {
  LetsStartView({super.key});

  final LoginController controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onLongPress: () {
                controller.isStudent = false;
                controller.isTeacher = false;
                Get.to(AdminLogin());
              },
              child: CustomText(
                text: "Let's Start",
                fontWeight: FontWeight.w500,
                color: blackColor,
                fontFamily: poppinsFontFamily,
                size: 30,
              ),
            ),
          ),
          CustomText(
            text: "Get Every Answer You Need, Anytime!",
            color: blackColor,
            fontFamily: poppinsFontFamily,
            size: 18,
          ),
          CustomCard(
            height: SizeConfig.screenHeight * 0.67,
            child: Stack(
              children: [
                Positioned(
                  bottom: 50,
                  top: 50,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      startRedBall,
                      width: 130,
                      height: 130,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 40,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      startupLabBoy,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 10,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      startupHindiBook,
                      width: 140,
                      height: 140,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
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
          ),
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
              Get.to(LoginView(
                isTeacher: false,
                isStudent: true,
              ));
            },
            child: CustomText(
              text: "Start",
              fontWeight: FontWeight.w500,
              size: 15,
              fontFamily: poppinsFontFamily,
            ),
          ),
          SizedBox(height: 15,),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Get.to(LoginView(
                  isTeacher: true,
                  isStudent: false,
                ));
              },
              child: CustomText(
                text: "I am a Teacher/Professor",
                color: blackColor,
                fontFamily: poppinsFontFamily,
                size: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
