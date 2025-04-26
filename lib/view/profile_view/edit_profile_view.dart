import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart'; // For Firebase integration


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
            _buildTextField('Full Name', controller.fullNameController),
            _buildTextField('Class and Section', controller.classSectionController),
            _buildTextField('Roll Number', controller.rollNumberController),
            _buildTextField('Admission Number', controller.admissionNumberController),
            _buildDatePickerField('Date of Birth (DD/MM/YYYY)', controller.dobController, context),
            _buildTextField('Blood Group', controller.bloodGroupController),
            _buildTextField('Aadhar Number', controller.aadharNumberController),

            // Contact Information Section
            SizedBox(height: 20),
            Text('Contact Information Section:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildTextField('Email Address', controller.emailController),
            _buildTextField('Student Phone Number', controller.phoneNumberController),
            _buildTextField('Residential Address', controller.residentialAddressController),
            _buildTextField('Parent/Guardian Name', controller.parentNameController),
            _buildTextField('Parent/Guardian Phone Number', controller.parentPhoneController),

            // Done Button
            SizedBox(height: 20),
            Obx(() => controller.isLoading.value ? Center(child: CircularProgressIndicator()) : ElevatedButton(
              onPressed:(){
                controller.isLoading(true);
                controller.saveProfileData().then((value) {
                  controller.isLoading(false);
                  Get.back();
                },);
              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label,TextEditingController Textcontroller, BuildContext context) {
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