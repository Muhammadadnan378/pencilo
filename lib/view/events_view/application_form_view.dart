import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/controller/friend_view_controller.dart';
import '../../data/consts/colors.dart';
import '../../data/consts/images.dart';
import '../../data/custom_widget/custom_card.dart';
import '../../data/custom_widget/custom_text_field.dart';
import '../../data/custom_widget/custom_text_widget.dart';
import '../../model/create_event_model.dart';

class ApplicationFormView extends StatelessWidget {
  final EventModel eventModel;
  ApplicationFormView({super.key, required this.eventModel,});
  final FriendViewController controller = Get.put(FriendViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Application form',
                color: bgColor,
                fontWeight: FontWeight.bold,
                size: 30,
                fontFamily: poppinsFontFamily,
              ),
              SizedBox(height: 10,),
              CustomText(
                text: 'Basketball Game',
                color: bgColor,
                fontWeight: FontWeight.w500,
                size: 20,
                fontFamily: poppinsFontFamily,
              ),
              SizedBox(height: 15,),
              buildCustomIconTextFields(
                icon: Icons.person,
                labelText: 'Your Name',
                textFieldControl: controller.nameController,
                keyboardType: TextInputType.text,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              buildCustomIconTextFields(
                icon: Icons.school,
                labelText: 'School Name',
                textFieldControl: controller.schoolNameController,
                keyboardType: TextInputType.text,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter school name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              buildCustomIconTextFields(
                icon: Icons.call,
                labelText: 'Contact Number',
                textFieldControl: controller.contactNumberController,
                keyboardType: TextInputType.text,
                validate: (value) {
                  final myPhoneNumber = RegExp(r'^[789]\d{9}$');
                  if (value == null || value.isEmpty || !myPhoneNumber.hasMatch(value)) {
                    return 'Please enter a valid Indian phone number.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 50),
              Obx(() => !controller.isLoading.value ? Center(
                child: CustomCard(
                  alignment: Alignment.center,
                  borderRadius: 11,
                  width: double.infinity,
                  height: 57,
                  color: blackColor,
                  onTap: () {
                    controller.isLoading(true);
                    // Validate form before proceeding
                    FocusScope.of(context).unfocus();
                    if (controller.formKey.currentState!.validate()) {
                      controller.joinEvent(context,eventModel).then((value) => controller.isLoading(false),);
                    }else{
                      controller.isLoading(false);
                    }
                  },
                  child: CustomText(text: 'Join Event',size: 18,fontWeight: FontWeight.bold,),
                ),
              ) : Center(child: CircularProgressIndicator())
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildCustomIconTextFields({
    required IconData icon,
    String? labelText,
    String? hintText,
    int? maxLines,
    bool? isRuls = false,
    FocusNode? focusNode,
    required TextEditingController textFieldControl,
    required TextInputType keyboardType,
    String? Function(String?)? validate}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: isRuls! ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Icon(icon, color: blackColor),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomTextFormField(
            labelText: labelText,
            controller: textFieldControl,
            keyboardType: keyboardType,
            validator: validate,
            contentPadding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            hintText: hintText ?? '',
            maxLines: maxLines,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
