import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../controller/profile_controller.dart';
import '../../data/current_user_data/current_user_Data.dart'; // For Firebase integration

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../controller/profile_controller.dart';
import '../../data/current_user_data/current_user_Data.dart'; // For Firebase integration

class EditProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Academic Details Section
            Text('Academic Details Section:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // Inside the body of the EditProfilePage
            _buildTextField('Full Name', controller.fullNameController),

            if (CurrentUserData.isTeacher)
              _buildTextField('Subject', controller.subjectController),

            if (!CurrentUserData.isTeacher)
              Row(
                children: [
                  Expanded(
                    child: _buildClassDropdown(),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildSectionDropdown(),
                  ),
                ],
              ),
            if (!CurrentUserData.isTeacher)
              _buildTextField('Roll Number', controller.rollNumberController, keyboardType: TextInputType.number),
            if (!CurrentUserData.isTeacher)
              _buildTextField('Admission Number', controller.admissionNumberController, keyboardType: TextInputType.number),

            _buildDatePickerField('Date of Birth (DD/MM/YYYY)', controller.dobController, context),
            _buildBloodGroupDropdown(),
            _buildTextField('Aadhar Number', controller.aadharNumberController, keyboardType: TextInputType.number), // Numeric keyboard for Aadhar number

            // Contact Information Section
            SizedBox(height: 20),
            Text('Contact Information Section:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildTextField('Email Address', controller.emailController, keyboardType: TextInputType.emailAddress, isEmail: true),
            _buildTextField('Phone Number', controller.phoneNumberController, keyboardType: TextInputType.phone), // Numeric keyboard for Phone Number
            _buildTextField('Residential Address', controller.residentialAddressController, keyboardType: TextInputType.streetAddress),

            if (!CurrentUserData.isTeacher)
              _buildTextField('Parent/Guardian Name', controller.parentNameController, keyboardType: TextInputType.streetAddress),
            if (!CurrentUserData.isTeacher)
              _buildTextField('Parent/Guardian Phone Number', controller.parentPhoneController, keyboardType: TextInputType.phone), // Numeric keyboard for Parent/Guardian Phone

            // Done Button
            SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: () {
                controller.isLoading(false);
                controller.saveProfileData(context).then((value) {
                  controller.isLoading(false);
                },);
              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            )),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Class Dropdown
// Custom Dropdown with dividers between items
  Widget _buildClassDropdown() {
    final List<String> classes = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        return CustomCard(
          borderRadius: 5,
          height: 57,
          border: Border.all(color: blackColor),
          child: PopupMenuButton<String>(
            color: whiteColor,
            onSelected: (String value) {
              controller.selectedClass.value = value;
            },
            itemBuilder: (BuildContext context) {
              return classes.map((classItem) {
                return PopupMenuItem<String>(
                  value: classItem,
                  child: Column(
                    children: [
                      Text(classItem),  // Display the class
                      Divider(), // Divider added after each item
                    ],
                  ),
                );
              }).toList();
            },
            child: Row(
              children: [
                SizedBox(width: 9,),
                CustomText(
                  text:controller.selectedClass.value.isEmpty
                      ? "Select Standard"
                      : controller.selectedClass.value,
                  color: blackColor,
                  size: 16,
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                Icon(Icons.arrow_drop_down),
                SizedBox(width: 5,)
              ],
            ),
          ),
        );
      }),
    );
  }
  // Section Dropdown
  Widget _buildSectionDropdown() {
    final List<String> sections = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        return CustomCard(
          borderRadius: 5,
          height: 57,
          border: Border.all(color: blackColor),
          child: PopupMenuButton<String>(
            color: whiteColor,
            onSelected: (String value) {
              controller.selectedSection.value = value;
            },
            itemBuilder: (BuildContext context) {
              return sections.map((section) {
                return PopupMenuItem<String>(
                  value: section,
                  child: Column(
                    children: [
                      Text(section),  // Display the section
                      Divider(), // Divider added after each item
                    ],
                  ),
                );
              }).toList();
            },
            child: Row(
              children: [
                SizedBox(width: 9),
                CustomText(
                  text: controller.selectedSection.value.isEmpty
                      ? "Select Division"
                      : controller.selectedSection.value,
                  color: blackColor,
                  size: 16,
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                Icon(Icons.arrow_drop_down),
                SizedBox(width: 5),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      {
        TextInputType keyboardType = TextInputType.text,
        bool isEmail = false
      }
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: blackColor,
          ),
          suffixIcon: isEmail ? SizedBox(
            width: SizeConfig.screenWidth * 0.4,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: "@gmail.com",
                  size: 16,
                  color: grayColor,
                ),
              ),
            ),
          )
              : SizedBox(),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

// Blood Group Dropdown
  Widget _buildBloodGroupDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        return CustomCard(
          borderRadius: 5,
          height: 57,
          border: Border.all(color: blackColor),
          child: PopupMenuButton<String>(
            color: whiteColor,
            onSelected: (String value) {
              controller.selectedBloodGroup.value = value;
            },
            itemBuilder: (BuildContext context) {
              return controller.bloodGroups.map((bloodGroup) {
                return PopupMenuItem<String>(
                  value: bloodGroup,
                  child: Column(
                    children: [
                      Text(bloodGroup), // Display the blood group
                      Divider(), // Divider added after each item
                    ],
                  ),
                );
              }).toList();
            },
            child: Row(
              children: [
                SizedBox(width: 9),
                CustomText(
                  text: controller.selectedBloodGroup.value.isEmpty
                      ? "Select Blood Group"
                      : controller.selectedBloodGroup.value,
                  color: blackColor,
                  size: 16,
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),
                Icon(Icons.arrow_drop_down),
                SizedBox(width: 5),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController Textcontroller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          controller.pickDateOfBirth(context);
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: Textcontroller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

