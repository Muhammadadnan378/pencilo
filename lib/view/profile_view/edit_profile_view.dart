import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import '../../controller/profile_controller.dart';
import '../../data/current_user_data/current_user_Data.dart';
import '../login_view/login_view.dart'; // For Firebase integration

final _formKey = GlobalKey<FormState>();

class EditProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("${CurrentUserData.schoolList}");
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Academic Details Section
              Text('Academic Details Section:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildTextField('Full Name', isName: true, controller.fullNameController),
              if (CurrentUserData.isTeacher)
                _buildTextField('Subject', controller.subjectController),
              if (!CurrentUserData.isTeacher)
              Row(
                children: [
                  Expanded(
                    child: Obx((){
                      controller.selectedStandard.value;
                      return _buildDropdown(
                        subjects: controller.standards,
                        selectedValue: controller.selectedStandard,
                        dropdownTitle: "Select Standard",
                      );
                    }),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Obx((){
                      controller.selectedDivision.value;
                      return _buildDropdown(
                        subjects: controller.divisions,
                        selectedValue: controller.selectedDivision,
                        dropdownTitle: "Select Division",
                      );
                    }),
                  ),
                ],
              ),
              if (!CurrentUserData.isTeacher)
                _buildTextField('Roll Number', controller.rollNumberController, keyboardType: TextInputType.number),
              if (!CurrentUserData.isTeacher)
                _buildTextField('Admission Number', controller.admissionNumberController, keyboardType: TextInputType.number),
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
                    return ListTile(
                      title: CustomText(text: suggestion, size: 16, color: blackColor),
                    );
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
                    textEditingController.text = controller.schoolNameController.text;

                    return CustomTextFormField(
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
              SizedBox(height: 10,),

                // _buildTextField('School Name', controller.schoolNameController, keyboardType: TextInputType.text),

              _buildDatePickerField('Date of Birth (DD/MM/YYYY)', controller.dobController, context),
              Obx((){
                controller.selectedBloodGroup.value;
                return _buildDropdown(
                  subjects: controller.bloodGroups,
                  selectedValue: controller.selectedBloodGroup,
                  dropdownTitle: "Select Blood Group",
                );
              }),
              _buildTextField(
                  'Aadhar Number',
                  isAadharNumber: true,
                  controller.aadharNumberController,
                  keyboardType: TextInputType.number,
                  errorMessage: "Aadhar number should be 12 digits"
              ),

              // Contact Information Section
              SizedBox(height: 20),
              Text('Contact Information Section:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildTextField(
                  'Email Address',
                  controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  isEmail: true,
                  errorMessage: "Email should contain '@gmail.com'"
              ),
              _buildTextField('Phone Number', isPhoneNumber: true, controller.phoneNumberController, keyboardType: TextInputType.phone), // Numeric keyboard for Phone Number
              _buildTextField('Residential Address', controller.residentialAddressController, keyboardType: TextInputType.streetAddress),

              if (!CurrentUserData.isTeacher)
                _buildTextField('Parent/Guardian Name', controller.parentNameController, keyboardType: TextInputType.streetAddress),
              if (!CurrentUserData.isTeacher)
                _buildTextField('Parent/Guardian Phone Number',isGurdianPhone: true, controller.parentPhoneController, keyboardType: TextInputType.phone), // Numeric keyboard for Parent/Guardian Phone

              // Done Button
              SizedBox(height: 20),
              Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : CustomCard(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.isLoading(true);
                    controller.updateProfile().then((value) {
                      controller.isLoading(false);
                    });
                  }
                },
                alignment: Alignment.center,
                borderRadius: 11,
                width: double.infinity,
                height: 57,
                color: blackColor,
                child: CustomText(text: 'Update Profile'),
              )),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController textFieldControl, {
        TextInputType keyboardType = TextInputType.text,
        bool isName = false,
        bool isAadharNumber = false,
        bool isEmail = false,
        bool isPhoneNumber = false,
        bool isGurdianPhone = false,
        String? errorMessage,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: textFieldControl,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction, // Automatically validates when the user interacts
        validator: (value) {
          return controller.validation(
            isGurdianPhone: isGurdianPhone,
            isPhoneNumber: isPhoneNumber,
            isEmail: isEmail,
            isAadharNumber: isAadharNumber,
            isName: isName,
            value: value!,
          );
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: grayColor),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> subjects,
    required RxString selectedValue,
    required String dropdownTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CustomCard(
        borderRadius: 5,
        height: 57,
        border: Border.all(color: blackColor),
        child: PopupMenuButton<String>(
          color: whiteColor,
          onSelected: (String value) {
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
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController textController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          controller.pickDateOfBirth(context);
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: textController,
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
