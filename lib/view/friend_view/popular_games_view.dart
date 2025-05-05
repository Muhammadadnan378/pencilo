import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/consts/images.dart';

import '../../data/current_user_data/current_user_Data.dart';
import '../../model/create_event_model.dart';
import 'application_form_view.dart';

class PopularGamesView extends StatelessWidget {
  PopularGamesView({super.key});

  final List<IconData> icon = [
    Icons.directions_run,             // For Run
    Icons.sports_basketball,          // For Basketball
    Icons.sports_tennis,              // For Tennis (Could be used for Badminton too)
    Icons.sports_football,            // For Football
    Icons.sports_cricket,             // For Cricket
    Icons.sports_baseball,            // For Baseball
    Icons.sports_volleyball,          // For Volleyball
    Icons.sports_handball,            // For Handball (Added for example)
    Icons.sports_kabaddi,             // For Kabaddi (Added for example)
    Icons.sports_rugby,               // For Rugby (Added for example)
    Icons.videogame_asset,            // For PUBG (Added for example)
    Icons.videogame_asset_outlined,   // For BGMI (Added for example)
    Icons.sports_hockey,              // For Hockey (Added for example)
    Icons.sports_tennis,              // Placeholder for Badminton
    Icons.sports_basketball,          // Placeholder for Table Tennis
  ];


  final List<String> sportsNames = [
    "Run",             // Updated names for sports
    "Basketball",
    "Tennis",
    "Football",
    "Cricket",
    "Baseball",
    "Volleyball",
    "Handball",        // Added
    "Kabaddi",         // Added
    "Rugby",           // Added
    "PUBG",            // Added
    "BGMI",            // Added
    "Hockey",          // Added
    "Badminton",       // Added
    "Table Tennis",    // Added
  ];


  RxInt selectedIndex = 40.obs;
  RxString selectedEventType = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.08,
          ),
          CustomText(
            text: "Popular Games",
            color: blackColor,
            size: 34,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: SizeConfig.screenWidth * 0.2,
            width: SizeConfig.screenWidth,
            child: Center(
              child: ListView.builder(
                itemCount: icon.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(() {
                    selectedIndex.value;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (selectedIndex.value != index) {
                              selectedIndex.value = index;
                              selectedEventType.value = sportsNames[index];
                            } else {
                              selectedIndex.value = 40;
                              selectedEventType.value = "";
                            }
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: selectedIndex.value == index
                                ? Color(0xff496e3d)
                                : blackColor,
                            child: Icon(icon[index],
                                color: selectedIndex.value == index
                                    ? blackColor
                                    : grayColor),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    );
                  });
                },
              ),
            ),
          ),
          Obx(() {
            selectedEventType.value;
            return StreamBuilder<QuerySnapshot>(
              stream: selectedEventType.value == "" ? FirebaseFirestore.instance
                  .collection('events')
                  .snapshots() : FirebaseFirestore.instance
                  .collection('events')
                  .where(
                  'selectedEventType', isEqualTo: selectedEventType.value)
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


                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: events.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var eventData = EventModel.fromMap(
                          events[index].data() as Map<String, dynamic>);
                      // Format the selectedDateTime into "Fri 15th"
                      DateTime eventDate = DateFormat('dd/MM/yyyy').parse(
                          eventData.selectedDateTime);
                      String formattedDate = DateFormat('EEE dd\'th\',').format(
                          eventDate); // Format: "Fri 15th"

                      // Combine with time to display "Fri 15th, 8pm"
                      String dateTime = "$formattedDate ${eventData.time}";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CustomCard(
                          padding:
                          EdgeInsets.only(
                              left: 3, right: 3, top: 3, bottom: 10),
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
                                            text: dateTime,
                                            // Formatted Date & Time
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
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: CustomCard(
                                                onTap: () =>
                                                    buildShowModalBottomSheet(
                                                        context, eventData),
                                                alignment: Alignment.center,
                                                borderRadius: 18,
                                                color: Color(0xff85B6FF),
                                                width: 75,
                                                height: 35,
                                                child: CustomText(
                                                  text: "Join",
                                                  fontWeight: FontWeight.bold,
                                                  color: blackColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          })


        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, EventModel eventModel) async {
    // Format the selectedDateTime into "Fri 15th"
    DateTime eventDate = DateFormat('dd/MM/yyyy').parse(eventModel.selectedDateTime);
    String formattedDate = DateFormat('EEE dd\'th\',').format(eventDate); // Format: "Fri 15th"

    // Combine with time to display "Fri 15th, 8pm"
    String dateTime = "$formattedDate ${eventModel.time}";

    return showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCard(
                  borderRadiusOnly: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  height: SizeConfig.screenHeight * 0.2,
                  width: SizeConfig.screenWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Image.asset(
                      basketBallImage,  // You can replace this with dynamic data if needed.
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Text(
                eventModel.selectedEventType,  // Dynamic event type
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: blackColor
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: 5),
                        Column(
                          children: [
                            CustomText(
                                text: formattedDate.split(' ')[1],  // Day of the month
                                size: 13,
                                fontWeight: FontWeight.bold,
                                color: blackColor
                            ),
                            CustomText(
                                text: formattedDate.split(' ')[0],  // Day of the week
                                size: 13,
                                fontWeight: FontWeight.w400,
                                color: blackColor
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        SizedBox(width: 5),
                        CustomText(
                            text: eventModel.time,  // Dynamic time
                            size: 13,
                            fontWeight: FontWeight.bold,
                            color: blackColor
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 5),
                  CustomText(
                    text: "${eventModel.selectedCity}, ${eventModel.selectedState}",  // Dynamic location
                    size: 13,
                    fontWeight: FontWeight.w400,
                    color: blackColor,
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                "Rules: ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              // Display rules dynamically
              ...eventModel.rules.split('\n').map((rule) {
                return Text(rule);  // Assuming rules are separated by newline '\n'
              }).toList(),
              SizedBox(height: 20),
              CustomCard(
                onTap: () {
                  Get.back();
                  Timer(Duration(milliseconds: 100), () {
                    Get.to(ApplicationFormView(eventModel: eventModel));
                  });
                },
                alignment: Alignment.center,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 2), // changes position of shadow
                  )
                ],
                borderRadius: 10,
                color: Color(0xff85B6FF),
                width: SizeConfig.screenWidth,
                height: 40,
                child: CustomText(
                  text: "Join",
                  color: blackColor,
                  size: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              CustomCard(
                onTap: () {},
                alignment: Alignment.center,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 2), // changes position of shadow
                  )
                ],
                borderRadius: 10,
                color: Color(0xff58FF2A),
                width: SizeConfig.screenWidth,
                height: 40,
                child: CustomText(
                  text: "Share",
                  color: blackColor,
                  size: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
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
        Expanded(
          child: CustomText(
            text: ": $value",
            color: blackColor,
            size: 12,
            maxLines: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
