import 'package:pencilo/data/consts/images.dart';
import '../../../data/consts/const_import.dart';
import '../../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
              Obx((){
                controller.selectedSchoolName.value;
                return _selectSubjectsDropdown(
                  subjects: controller.schoolNameList,
                  selectedValue: controller.selectedSchoolName,
                  dropdownTitle: "Select School",
                );
              }),
              // LoginClassTextField(
              //   hintText: "School Name",
              //   onChanged: (value) => controller.schoolName.value = value,
              // ),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30.0,left: 25,right: 25),
        child: Obx(() =>
        controller.isLoginUser.value ? SizedBox(width: 50,height: 50,child: Center(child: CircularProgressIndicator()))
            : CustomCard(
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
          },

          alignment: Alignment.center,
          borderRadius: 11,
          width: double.infinity,
          height: 57,
          color: blackColor,
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
            fontFamily: poppinsFontFamily,
          ),
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
          FocusManager.instance.primaryFocus?.unfocus();
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

  const LoginClassTextField({
    super.key, required this.hintText, this.suffixIcon, this.onChanged, this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
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

