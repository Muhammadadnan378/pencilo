import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import '../../../data/consts/const_import.dart';
import '../../controller/login_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../data/custom_widget/app_custom_button.dart';

class LoginView extends StatelessWidget {
  final bool isTeacher;
  final bool isStudent;
  LoginView({super.key,required this.isTeacher, required this.isStudent,});
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    controller.isTeacher = isTeacher;
    controller.isStudent = isStudent;
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
            Obx(() {
              controller.selectedSchoolName.value;
              return TypeAheadField<String>(
                autoFlipDirection: true,
                suggestionsCallback: (pattern) {
                  return CurrentUserData.schoolList
                      .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(title: CustomText(text: suggestion,size: 16, color: blackColor));
                },
                decorationBuilder: (context, child) {
                  return Material(
                    color: Colors.white, // 💡 White background for suggestions
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  );
                },
                onSelected: (String suggestion) {
                  controller.schoolNameController.text = suggestion;
                  controller.selectedSchoolName.value = suggestion;
                },
                builder: (context, textEditingController, focusNode) {
                  // Keep controller in sync (especially needed for rebuilds)
                  textEditingController.text = controller.schoolNameController.text;

                  return LoginClassTextField(
                    hintText: "School Name",
                    controller: controller.schoolNameController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      controller.selectedSchoolName.value = value;
                      controller.schoolNameController.text = value;
                    },
                  );
                },
              );
            }),


        SizedBox(height: 12),
              if (controller.isTeacher)
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
              if (controller.isTeacher) SizedBox(height: 12),
              Obx((){
                controller.selectedGender.value;
                return _selectSubjectsDropdown(
                  subjects: controller.genderList,
                  selectedValue: controller.selectedGender,
                  dropdownTitle: "Select Gender",
                );
              }),
              SizedBox(height: 10),
              if (!controller.isTeacher)
                Obx((){
                  controller.selectedStandard.value;
                  return _selectSubjectsDropdown(
                    subjects: controller.standardsList,
                    selectedValue: controller.selectedStandard,
                    dropdownTitle: "Select Standard",
                  );
                }),
              if (!controller.isTeacher) SizedBox(height: 12),
              if (!controller.isTeacher)
                Obx((){
                  controller.selectedDivision.value;
                  return _selectSubjectsDropdown(
                    subjects: controller.divisionsList,
                    selectedValue: controller.selectedDivision,
                    dropdownTitle: "Select Division",
                  );
                }),
              if (!controller.isTeacher) SizedBox(height: 12),
              LoginClassTextField(
                hintText: "Phone number",
                keyboardType: TextInputType.phone,
                onChanged: (value) => controller.phoneNumber.value = value,
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0,left: 25,right: 25),
                child: Obx(() =>
                controller.isLoginUser.value ? SizedBox(width: 50,height: 50,child: Center(child: CircularProgressIndicator()))
                    : AppCustomButton(
                  text: "Start",
                  onTap: () async {
                    controller.isLoginUser(true);
                    bool isFormValid = await controller.validateForm(context);

                    if (isFormValid) {
                      // Trigger Firebase phone verification
                      await controller.storeUserData().then((value) {
                        controller.isLoginUser(false);
                      });
                    } else {
                      // Show a message if form is invalid
                      controller.isLoginUser(false);
                    }
                  },),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectSubjectsDropdown({
    required List<String> subjects,
    required RxString selectedValue,
    required String dropdownTitle,
  }) {
    return CustomCard(
      borderRadius: 5,
      height: 47,
      border: Border.all(color: grayColor,width: 0.3),
      child: PopupMenuButton<String>(
        color: whiteColor,
        onSelected: (String value) {
          FocusScope.of(Get.context!).unfocus();
          selectedValue.value = value;
        },
        itemBuilder: (BuildContext context) {
          return subjects.map((item) {
            return PopupMenuItem<String>(
              value: item,
              child: Column(
                children: [
                  Text(item),
                  Divider(),
                ],
              ),
            );
          }).toList();
        },
        child: Obx(() => Row(
          children: [
            const SizedBox(width: 9),
            CustomText(
              text: selectedValue.value.isEmpty
                  ? dropdownTitle
                  : selectedValue.value,
              color: selectedValue.value.isNotEmpty ? blackColor : grayColor,
              size: 16,
              fontWeight: FontWeight.w400,
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
            const SizedBox(width: 5),
          ],
        )),
      ),
    );
  }
}

class LoginClassTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const LoginClassTextField({
    super.key, required this.hintText, this.suffixIcon, this.onChanged, this.keyboardType, this.focusNode, this.controller
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,

            hintStyle: TextStyle(
                fontFamily: poppinsFontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: grayColor
            ),
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

