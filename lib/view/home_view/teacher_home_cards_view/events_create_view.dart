import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import '../../../controller/teacher_home_view_controller.dart';
import '../../../data/custom_widget/custom_dropdown.dart';
import '../../../data/custom_widget/custom_text_field.dart';
import '../../friend_view/popular_games_view.dart';

class CreateEventView extends StatelessWidget {
  CreateEventView({super.key});

  final TeacherHomeViewController controller = Get.put(
      TeacherHomeViewController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey, // Assigning the form key to validate
          child: Obx(() {
            controller.isSelectEvent.value;
            return ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        CustomText(
                          text: 'Aniket Ganesh',
                          color: blackColor,
                          fontFamily: interFontFamily,
                          size: 8,
                        ),
                        SizedBox(height: 5),
                        CustomCard(
                          alignment: Alignment.center,
                          borderRadius: 100,
                          color: Color(0xff57A8B8),
                          width: 41,
                          height: 41,
                          child: CustomText(
                            text: "AG",
                            size: 20,
                            color: blackColor,
                            fontFamily: nixinOneFontFamily,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Obx(() {
                      controller.isSelectEvent.value;
                      return CustomCard(
                        borderRadius: 10,
                        color: Color(0xffe0e3e1),
                        width: SizeConfig.screenWidth * 0.6,
                        height: 44,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CustomCard(
                                  alignment: Alignment.center,
                                  borderRadius: 10,
                                  height: double.infinity,
                                  color: controller.isSelectEvent.value ? Color(
                                      0xffF6F6F6) : Colors.transparent,
                                  child: CustomText(
                                    text: "Create Events",
                                    color: blackColor,
                                    size: 13,
                                    fontWeight: FontWeight.bold,),
                                  onTap: () {
                                    controller.isSelectEvent.value = true;
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CustomCard(
                                    alignment: Alignment.center,
                                    borderRadius: 10,
                                    height: double.infinity,
                                    color: !controller.isSelectEvent.value
                                        ? Color(
                                        0xffF6F6F6)
                                        : Colors.transparent,
                                    child: CustomText(
                                      text: "Applications",
                                      color: blackColor,
                                      size: 13,
                                      fontWeight: FontWeight.bold,),
                                    onTap: () {
                                      controller.isSelectEvent.value = false;
                                    },
                                  ),
                                )
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
                if(controller.isSelectEvent.value)
                  EventTab(controller: controller),
                if(!controller.isSelectEvent.value)
                  ApplicationTab(controller: controller),
              ],
            );
          }),
        ),
      ),
    );
  }
}


class EventTab extends StatelessWidget {
  final TeacherHomeViewController controller;

  const EventTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15,),
        CustomText(text: 'Create School Events',
          color: bgColor,
          fontWeight: FontWeight.w400,
          size: 25,
          fontFamily: poppinsFontFamily,),
        SizedBox(height: 15,),
        // Your Name with CustomTextField and Icon
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

        // Event Type Dropdown
        Padding(
          padding: const EdgeInsets.only(left: 34.0),
          child: SizedBox(
            height: 58,
            child: CustomDropdown(
              subjects: controller.eventTypes,
              selectedValue: controller.selectedEventType,
              dropdownTitle: "Select Event Type",
            ),
          ),
        ),

        // School Name with CustomTextField and Icon
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

        // Event Location (City, State)
        Row(
          children: [
            SizedBox(width: 34,),
            Expanded(
              child: SizedBox(
                height: 58,
                child: CustomDropdown(
                  dropdownTitle: "Select City",
                  subjects: controller.cities,
                  selectedValue: controller.selectedCity,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 58,
                child: CustomDropdown(
                  subjects: controller.states,
                  selectedValue: controller.selectedState,
                  dropdownTitle: "Select State",
                ),
              ),
            ),
          ],
        ),

        // Time Picker with Icon
        Row(
          children: [
            Icon(Icons.calendar_month),
            SizedBox(width: 10),
            Expanded(
              child: _buildDatePickerField('Date', controller.selectedDateTimeController, context),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Time Picker with Icon
        Row(
          children: [
            Icon(Icons.access_time),
            SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                controller.selectedHours.value;
                controller.selectedHours.value;
                return CustomCard(
                  height: 47,
                  borderRadius: 5,
                  alignment: AlignmentDirectional.centerStart,
                  border: Border.all(color: blackColor),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: CustomText(
                        text: controller.selectedMinutes.value == 1 && controller.selectedHours.value == 1 ? "Select Time" : "${controller.selectedHours.value}:${controller.selectedMinutes.value} ${controller.selectAmPm.value}",
                        color: grayColor,
                        size: 16,
                      ),
                    ),
                  onTap: () => showTimeSelectDialog(context),
                );
              }),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Entry Fee with CustomTextField and Icon
        buildCustomIconTextFields(
          icon: Icons.monetization_on,
          labelText: 'Entry Fee',
          textFieldControl: controller.entryFeeController,
          keyboardType: TextInputType.number,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter entry fee';
            }
            return null;
          },
        ),
        SizedBox(height: 10),

        // Winner Amount with CustomTextField and Icon
        buildCustomIconTextFields(
          icon: Icons.star,
          labelText: 'Winner Amount',
          textFieldControl: controller.winnerAmountController,
          keyboardType: TextInputType.number,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter winner amount';
            }
            return null;
          },
        ),
        SizedBox(height: 10),

        // Contact Number with CustomTextField and Icon
        buildCustomIconTextFields(
          icon: Icons.phone,
          labelText: 'Contact Number',
          textFieldControl: controller.contactNumberController,
          keyboardType: TextInputType.phone,
          validate: (value) {
            if (value == null || value.isEmpty || value.length != 10) {
              return 'Please enter a valid contact number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        // Contact Number with CustomTextField and Icon
        buildCustomIconTextFields(
          icon: Icons.notes,
          isRuls: true,
          hintText: 'Any Rules',
          maxLines: 4,
          textFieldControl: controller.rulesController,
          keyboardType: TextInputType.text,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter any rules';
            }
            return null;
          },
        ),
        SizedBox(height: 30),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              width: 100,
              height: 50,
              borderRadius: 7,
              color: blackColor,
              alignment: Alignment.center,
              onTap: () {
                // Implement 'Back' action
                Get.back();
              },
              child: CustomText(text: 'Back'),
            ),
            SizedBox(width: 10,),
            CustomCard(
              width: 100,
              height: 50,
              borderRadius: 7,
              color: Color(0xff57A8B8),
              alignment: Alignment.center,
              onTap: () {
                // Validate form before proceeding
                // if (controller.formKey.currentState!.validate()) {
                //   // Implement 'Done' action
                // }
                Get.off(PopularGamesView());
              },
              child: CustomText(text: 'Done'),
            ),
          ],
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  Future<Duration?> showTimeSelectDialog(BuildContext context) async {
    controller.selectedHours.value = 1;
    controller.selectedMinutes.value = 1;
    controller.selectAmPm.value = "AM";
    return showModalBottomSheet<Duration>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Set Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int value) {
                          controller.selectedHours.value = value + 1;  // Update selected hours
                        },
                        children: List.generate(12, (index) {
                          int startIndex = index + 1;
                          return Center(
                            child: Text(
                              "$startIndex hour",
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int value) {
                          controller.selectedMinutes.value = value + 1;  // Update selected minutes
                        },
                        children: List.generate(60, (index) {
                          int startIndex = index + 1;
                          return Center(
                            child: Text(
                              "$startIndex minute",
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(width: 8),
                    Flexible(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int value) {

                          value == 0 ? controller.selectAmPm.value = "AM" : controller.selectAmPm.value = "PM";  // Update selected minutes
                        },
                        children: List.generate(2, (index) {
                          int startIndex = index + 1;
                          return Center(
                            child: Text(
                              startIndex == 1 ? "AM" : "PM",
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, null); // Cancel without selection
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Create a Duration from selected hours and minutes
                          Duration selectedDuration = Duration(
                            hours: controller.selectedHours.value,
                            minutes: controller.selectedMinutes.value,
                          );

                          // Check if the context is still mounted before popping
                          if (context.mounted) {
                            Navigator.pop(context, selectedDuration);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Set', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // Create custom row build widget with Icon for TextFields
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

  Widget _buildDatePickerField(String label, TextEditingController Textcontroller, BuildContext context) {
    return SizedBox(
      height: 47,
      child: GestureDetector(
        onTap: () {
          controller.pickDateOfBirth(context);
        },
        child: AbsorbPointer(

          child: TextFormField(
            controller: Textcontroller,
            decoration: InputDecoration(
              labelText: label,
              contentPadding: EdgeInsets.only(left: 10,bottom: 5),
              labelStyle: TextStyle(color: grayColor),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

class ApplicationTab extends StatelessWidget {
  final TeacherHomeViewController controller;

  const ApplicationTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02,),
        CustomCard(
          padding:
          EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 10),
          width: SizeConfig.screenWidth,
          color: Color(0xffF2F2F2),
          borderRadius: 6,
          child: Row(
            children: [
              Expanded(child: Image.asset(basketBallImage)),
              SizedBox(width: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Basketball Game",
                        color: blackColor,
                        size: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        text: "Fri 15th, 8pm",
                        color: blackColor,
                        size: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 5),
                      buildTitleValue(
                          title: "Location", value: "Thane , Mumbai"),
                      SizedBox(height: 5),
                      buildTitleValue(title: "Entry fee", value: "Free"),
                      SizedBox(height: 5),
                      buildTitleValue(
                          title: "Winning Price", value: "₹ 1,000"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomCard(
                              onTap: (){},
                              alignment: Alignment.center,
                              borderRadius: 10,
                              color: Color(0xffFF8585),
                              height: 33,
                              child: CustomText(
                                text: "Delete",
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                                size: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: CustomCard(
                              onTap: (){},
                              alignment: Alignment.center,
                              borderRadius: 10,
                              color: Color(0xff85B6FF),
                              height: 33,
                              child: CustomText(
                                text: "Edit",
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 15,),
        CustomText(
          text: "Basketball Application",
          color: blackColor,
          size: 25,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 10,),
        Table(
          border: TableBorder.all(
            color: blackColor,
            width: 1.0,
          ),
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'School',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Contact',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Ganesh sahu'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Dayanand school'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('7506885458'),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Ajay yaday'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Palghar school'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('8689985069'),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Sunny Gows..'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Mulund vidyal..'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('2233665544'),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Muhammad ..'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('DVV'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('7506889656'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTitleValue({required String title, required String value}) {
    return Row(
      children: [
        CustomText(
          text: "$title ",
          color: Color(0xff818181),
          size: 12,
          fontWeight: FontWeight.w400,
        ),
        CustomText(
          text: ": $value",
          color: blackColor,
          size: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

