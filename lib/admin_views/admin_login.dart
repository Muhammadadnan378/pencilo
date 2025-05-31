import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';

import '../controller/login_controller.dart';
import '../data/consts/images.dart';
import '../data/custom_widget/custom_media_query.dart';

class AdminLogin extends StatelessWidget {
  AdminLogin({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Admin Login",color: blackColor,),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: CustomTextFormField(
                labelText: "Enter Phone Number",
                onChanged: (value) {
                  controller.phoneNumber.value = value;
                },
                validator: (value) {
                  final myPhoneNumber = RegExp(r'^[789]\d{9}$');
                  if (value == null || value.isEmpty || !myPhoneNumber.hasMatch(value)) {
                    return 'Please enter a valid Indian phone number.';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0,left: 25,right: 25),
              child: Obx(() =>
              controller.isLoginUser.value ? SizedBox(width: 50,height: 50,child: Center(child: CircularProgressIndicator()))
                  : CustomCard(
                onTap: () async {
                  controller.isLoginUser(true);
                  await controller.fetchUserDataAndStoreInHive().then((value) {
                    controller.isLoginUser(false);
                  },);
                },

                alignment: Alignment.center,
                borderRadius: 7,
                width: SizeConfig.screenWidth * 0.8,
                height: 42,
                color: const Color(0xff9AC3FF),
                boxShadow: [
                  BoxShadow(
                      color: grayColor,
                      blurRadius: 5,
                      offset: const Offset(0, 3))
                ],
                child: CustomText(
                  text: "Start",
                  fontWeight: FontWeight.w500,
                  size: 15,
                  color: blackColor,
                  fontFamily: poppinsFontFamily,
                ),
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
