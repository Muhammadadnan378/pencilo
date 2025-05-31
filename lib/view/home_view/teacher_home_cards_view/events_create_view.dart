import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/model/create_event_model.dart';
import '../../../controller/teacher_home_view_controller.dart';
import '../../../data/current_user_data/current_user_Data.dart';
import '../../../data/custom_widget/custom_dropdown.dart';
import '../../../data/custom_widget/custom_text_field.dart';

class CreateEventView extends StatelessWidget {
  CreateEventView({super.key});

  final TeacherHomeViewController controller = Get.put(TeacherHomeViewController());

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
                                      controller.eventsModel = null;
                                      controller.clearValues();
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
    // Pre-fill the form fields if eventModel is provided
    if (controller.eventsModel != null) {
      controller.nameController.text = controller.eventsModel!.name;
      controller.schoolNameController.text = controller.eventsModel!.schoolName;
      controller.entryFeeController.text = controller.eventsModel!.entryFee;
      controller.time.value = controller.eventsModel!.time;
      controller.winnerAmountController.text =
          controller.eventsModel!.winnerAmount;
      controller.contactNumberController.text =
          controller.eventsModel!.contactNumber;
      controller.rulesController.text = controller.eventsModel!.rules;
      controller.selectedDateTime.value =
          controller.eventsModel!.selectedDateTime;
      controller.selectedEventType.value =
          controller.eventsModel!.selectedEventType;
      controller.selectedCity.value = controller.eventsModel!.selectedCity;
      controller.selectedState.value = controller.eventsModel!.selectedState;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        CustomText(
          text: 'Create School Events',
          color: bgColor,
          fontWeight: FontWeight.w400,
          size: 25,
          fontFamily: poppinsFontFamily,
        ),
        SizedBox(height: 15),
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
          child: Obx(() {
            controller.isSelectEventEmpty.value;
            return CustomDropdown(
              isValidate: controller.isSelectEventEmpty.value,
              subjects: controller.eventTypes,
              selectedValue: controller.selectedEventType,
              dropdownTitle: "Select Event Type",
            );
          }),
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
        Obx(() {
          controller.isSelectCityEmpty.value;
          return Row(
            children: [
              SizedBox(width: 34),
              Expanded(
                child: CustomDropdown(
                  isValidate: controller.isSelectCityEmpty.value,
                  dropdownTitle: "Select City",
                  subjects: controller.cities,
                  selectedValue: controller.selectedCity,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomDropdown(
                  isValidate: controller.isSelectStateEmpty.value,
                  subjects: controller.states,
                  selectedValue: controller.selectedState,
                  dropdownTitle: "Select State",
                ),
              ),
            ],
          );
        }),
        Obx(() {
          controller.selectedDateTime.value;
          return buildCustomIconTextFields(
            icon: Icons.calendar_month,
            labelText: controller.selectedDateTime.isEmpty
                ? "Select Date"
                : controller.selectedDateTime.value,
            labelStyle: TextStyle(
              color: controller.selectedDateTime.isEmpty
                  ? grayColor
                  : blackColor,
            ),
            keyboardType: TextInputType.text,
            isEditable: false,
            onTap: () => controller.pickDateOfBirth(context),
            // Keyboard type for text
            validate: (value) {
              // Validation logic: Ensure time is selected
              if (controller.selectedDateTime.isEmpty) {
                return 'Time is required'; // Error message if no time is selected
              }
              return null; // Return null if validation passes
            },
          );
        }),
        SizedBox(height: 10),
        // Time Picker
        Obx(() {
          controller.selectedMinutes.value;
          return buildCustomIconTextFields(
            icon: Icons.watch_later_outlined,
            labelText: controller.selectedMinutes.value == 0 &&
                controller.selectedHours.value == 0
                && controller.time.value.isEmpty ? "Select Time"
                : controller.selectedMinutes.value == 0 &&
                controller.selectedHours.value == 0
                ? controller.time.value
                : "${controller.selectedHours}:${controller.selectedMinutes
                .toString().padLeft(2, '0')} ${controller.selectAmPm}",
            labelStyle: TextStyle(
              color: controller.selectedMinutes.value == 0 &&
                  controller.selectedHours.value == 0 &&
                  controller.time.value.isEmpty
                  ? grayColor
                  : blackColor,
            ),
            keyboardType: TextInputType.text,
            isEditable: false,
            onTap: () => showTimeSelectDialog(context),
            // Keyboard type for text
            validate: (value) {
              // Validation logic: Ensure time is selected
              if (controller.selectedMinutes.value == 0 &&
                  controller.selectedHours.value == 0 &&
                  controller.time.value.isEmpty) {
                return 'Time is required'; // Error message if no time is selected
              }
              return null; // Return null if validation passes
            },
          );
        }),
        SizedBox(
            height: 10),

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
        SizedBox(
            height: 10),

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
        SizedBox(
            height: 10),

        // Contact Number with CustomTextField and Icon
        buildCustomIconTextFields(
          icon: Icons.phone,
          labelText: 'Contact Number',
          textFieldControl: controller.contactNumberController,
          keyboardType: TextInputType.phone,
          validate: (value) {
            final myPhoneNumber = RegExp(r'^[789]\d{9}$');
            if (value == null || value.isEmpty ||
                !myPhoneNumber.hasMatch(value)) {
              return 'Please enter a valid Indian phone number.';
            }
            return null;
          },
        ),
        SizedBox(
            height: 10),

        // Rules TextArea with CustomTextField
        buildCustomIconTextFields(
          icon: Icons.notes,
          isRuls: true,
          hintText: 'Any Rules',
          maxLines: 4,
          textFieldControl: controller.rulesController,
          keyboardType: TextInputType.text,
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
                controller.clearValues();
                controller.eventsModel = null;
                Get.back(); // Back to previous screen
              },
              child: CustomText(text: 'Back'),
            ),
            SizedBox(width: 10),
            Obx(() =>
            !controller.isLoading.value
                ? CustomCard(
              width: 100,
              height: 50,
              borderRadius: 7,
              color: Color(0xff57A8B8),
              alignment: Alignment.center,
              onTap: () {
                controller.isLoading(true);

                // Validate form before proceeding
                if (!controller.validate()) {
                  debugPrint("Validation failed.");
                  controller.isLoading(false); // Stop loading if validation fails
                  controller.checkValidatFields(context); // You can handle custom validation messages here
                  controller.formKey.currentState!.validate(); // Validate form manually if you need extra validation on fields
                } else {
                  debugPrint("Validation passed.");
                  if (controller.eventsModel == null) {
                    controller.createEvent(context).then((value) {
                      controller.isLoading(false);
                    });
                  } else {
                    controller.updateEvent(context).then((value) {
                      controller.isLoading(false);
                    });
                  }
                }
              },
              child: CustomText(
                  text: controller.eventsModel == null ? 'Don' : "Update"),
            )
                : Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: CircularProgressIndicator(),
            )),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  showTimeSelectDialog(BuildContext context) async {
    controller.selectedHours.value = 1;
    // Show the modal bottom sheet
    return showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
                          controller.selectedHours.value = value + 1; // Update selected hours
                        },
                        children: List.generate(12, (index) {
                          int startIndex = index + 1;
                          return Center(
                            child: Text(
                              "$startIndex",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
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
                          controller.selectedMinutes.value = value; // Update selected minutes
                        },
                        children: List.generate(60, (index) {
                          int startIndex = index + 1;
                          return Center(
                            child: Text(
                              "${startIndex > 10 ? "" : "0"}$index min",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
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
                          value == 0
                              ? controller.selectAmPm.value = "AM"
                              : controller.selectAmPm.value =
                          "PM"; // Update AM/PM
                        },
                        children: List.generate(2, (index) {
                          int startIndex = index + 1;
                          return Center(
                            child: Text(
                              startIndex == 1 ? "AM" : "PM",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                              context, null); // Cancel without selection
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(
                            color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Return the selected time as a Duration object
                          int totalMinutes = controller.selectedHours.value *
                              60 + controller.selectedMinutes.value;
                          if (controller.selectAmPm.value == "PM") {
                            totalMinutes += 12 * 60; // Add 12 hours for PM
                          }
                          Duration selectedDuration = Duration(
                              minutes: totalMinutes);

                          // Return the selected time duration
                          Navigator.pop(context, selectedDuration);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Set', style: TextStyle(
                            color: Colors.white)),
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

  // Helper for Custom Text Fields
  Widget buildCustomIconTextFields({
    required IconData icon,
    String? labelText,
    String? hintText,
    int? maxLines,
    bool? isRuls = false,
    TextEditingController? textFieldControl,
    required TextInputType keyboardType,
    String? Function(String?)? validate,
    bool isEditable = true,
    VoidCallback? onTap,
    TextStyle? labelStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: isRuls!
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
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
            isEditable: isEditable,
            onTap: onTap,
            lableStyle: labelStyle,
          ),
        ),
      ],
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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where("userId", isEqualTo: CurrentUserData.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No events available.'));
            }

            // Get the list of events
            var events = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var eventData = EventModel.fromMap(
                    events[index].data() as Map<String, dynamic>);
                // Format the selectedDateTime into "Fri 15th"
                DateTime eventDate = DateFormat('dd/MM/yyyy').parse(eventData.selectedDateTime);
                String formattedDate = DateFormat('EEE dd\'th\',').format(eventDate); // Format: "Fri 15th"

                // Combine with time to display "Fri 15th, 8pm"
                String dateTime = "$formattedDate ${eventData.time}";

                return Column(
                  children: [
                    CustomCard(
                      padding:
                      EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 10),
                      width: SizeConfig.screenWidth,
                      color: Color(0xffF2F2F2),
                      borderRadius: 6,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Image.asset(basketBallImage)),
                              // Use the correct image path
                              SizedBox(width: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      CustomText(
                                        text: eventData.selectedEventType,
                                        // Event Type
                                        color: blackColor,
                                        size: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 5),
                                      CustomText(
                                        text: dateTime, // Formatted Date & Time
                                        color: blackColor,
                                        size: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      SizedBox(height: 5),
                                      buildTitleValue(
                                          title: "Location",
                                          value: "${eventData
                                              .selectedCity}, ${eventData
                                              .selectedState}"),
                                      SizedBox(height: 5),
                                      buildTitleValue(title: "Entry fee",
                                          value: eventData.entryFee),
                                      SizedBox(height: 5),
                                      buildTitleValue(
                                          title: "Winning Price",
                                          value: eventData.winnerAmount),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomCard(
                                              onTap: () {
                                                // Handle event deletion
                                                controller.deleteEvent(
                                                    context, eventData.eventId);
                                              },
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
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: CustomCard(
                                              onTap: () {
                                                controller.isSelectEvent(true);
                                                controller.eventsModel =
                                                    eventData;
                                              },
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
                              ),
                            ],
                          ),
                          eventData.participants.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              CustomText(
                                text: "${eventData.selectedEventType} Application",
                                color: blackColor,
                                size: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 10),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'School',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Contact',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Generate rows for each participant dynamically
                                  ...eventData.participants.map((participant) {
                                    return TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                participant['studentName'] ??
                                                    'N/A'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                participant['studentClass'] ??
                                                    'N/A'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                participant['studentPhone'] ??
                                                    'N/A'),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ],
                          )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    if(index < events.length - 1)
                      Divider(),
                  ],
                );
              },
            );
          },
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
          maxLines: 1,
        ),
        Expanded(
          child: CustomText(
            text: ": $value",
            color: blackColor,
            size: 12,
            fontWeight: FontWeight.w400,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

