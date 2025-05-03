import 'package:flutter/material.dart';

import '../../data/consts/colors.dart';
import '../../data/consts/images.dart';
import '../../data/custom_widget/custom_text_field.dart';
import '../../data/custom_widget/custom_text_widget.dart';

class ApplicationFormView extends StatelessWidget {

  ApplicationFormView({super.key,});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8),
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
              fontFamily: poppinsFontFamily,),
            SizedBox(height: 15,),
            buildCustomIconTextFields(
              icon: Icons.person,
              labelText: 'Your Name',
              textFieldControl: nameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            buildCustomIconTextFields(
              icon: Icons.school,
              labelText: 'School Name',
              textFieldControl: schoolNameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            buildCustomIconTextFields(
              icon: Icons.call,
              labelText: 'Contact Number',
              textFieldControl: contactNumberController,
              keyboardType: TextInputType.text,
            )
          ],
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
            textFieldControl: textFieldControl,
            keyboardType: keyboardType,
            validator: validate,
            contentPadding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            hintText: hintText ?? '',
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
