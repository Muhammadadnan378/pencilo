import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/view/login_view/otp_view.dart';
import '../../../data/consts/const_import.dart';
import '../../controller/login_controller.dart';
import '../../data/custom_widget/custom_media_query.dart';

class LoginView extends StatelessWidget {
  final bool isTeacher;
  const LoginView({super.key, required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    controller.setIsTeacher(isTeacher); // Set whether it's teacher or student login

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 17.0, right: 17),
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  loginTeacher,
                ),
              ),
              SizedBox(height: 30),
              LoginClassTextField(
                hintText: "Name",
                onChanged: (value) => controller.name.value = value,
              ),
              SizedBox(height: 12),
              LoginClassTextField(
                hintText: "School Name",
                onChanged: (value) => controller.schoolName.value = value,
              ),
              SizedBox(height: 12),
              if (isTeacher)
                Row(
                  children: [
                    CustomText(
                      text: "I Teach",
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      size: 11,
                      fontFamily: poppinsFontFamily,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: LoginClassTextField(
                        hintText: "Hindi , English , Marathi",
                        onChanged: (value) => controller.subject.value = value,
                      ),
                    ),
                  ],
                ),
              if (!isTeacher)
                Obx(() => SizedBox(
                  height: 42,
                  child: DropdownButtonFormField<String>(
                    decoration: _dropdownDecoration("Standard"),
                    value: controller.selectedStandard.value.isEmpty
                        ? null
                        : controller.selectedStandard.value,
                    items: controller.standards
                        .map((std) => DropdownMenuItem(
                      value: std,
                      child: Text(std),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.selectStandard(val);
                    },
                  ),
                )),
              if (!isTeacher) SizedBox(height: 12),
              if (!isTeacher)
                Obx(() => SizedBox(
                  height: 42,
                  child: DropdownButtonFormField<String>(
                    decoration: _dropdownDecoration("Div"),
                    value: controller.selectedDivision.value.isEmpty
                        ? null
                        : controller.selectedDivision.value,
                    items: controller.divisions
                        .map((div) => DropdownMenuItem(
                      value: div,
                      child: Text(div),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.selectDivision(val);
                    },
                  ),
                )),
              SizedBox(height: 12),
              LoginClassTextField(
                hintText: "Current location",
                onChanged: (value) => controller.currentLocation.value = value,
              ),
              SizedBox(height: 12),
              LoginClassTextField(
                hintText: "Phone number",
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.phoneNumber.value = value,
              ),
              if(!isTeacher)SizedBox(height: SizeConfig.screenHeight * 0.05),
              if(isTeacher)SizedBox(height: SizeConfig.screenHeight * 0.1),
              Obx(() =>
              controller.isLoginUser.value ? Center(
                child: CircularProgressIndicator(),)
                  : CustomCard(
                onTap: () async {
                  controller.isLoginUser(true);
                  if (controller.isFormValid) {
                    // Trigger Firebase phone verification
                    await controller.storeUserData().then((value) {
                      controller.isLoginUser(false);
                    },); // Call the method to start phone verification
                  } else {
                    // Show a message if form is invalid
                    Get.snackbar(
                        'Error', 'Please fill all the required fields.');
                    controller.isLoginUser(false);
                  }
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
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(
        fontFamily: poppinsFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.only(left: 13, bottom: 2),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff4C4C4C), width: 0.1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff4C4C4C), width: 0.1),
      ),
    );
  }
}

class LoginClassTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const LoginClassTextField({
    super.key, required this.hintText, this.suffixIcon, this.onChanged, this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: TextStyle(fontFamily: poppinsFontFamily,
                fontWeight: FontWeight.w500,
                fontSize: 14),
            contentPadding: EdgeInsets.only(left: 13, bottom: 2),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4C4C4C),width: 0.1)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4C4C4C),width: 0.1)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4C4C4C),width: 0.1)
            )
        ),
      ),
    );
  }
}
