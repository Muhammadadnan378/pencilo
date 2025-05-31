import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/controller/events_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/create_event_model.dart';
import 'application_form_view.dart';

class PopularGamesView extends StatelessWidget {
  PopularGamesView({super.key});
  final EventsController controller = Get.put(EventsController());


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
            height: SizeConfig.screenHeight * 0.09,
            width: SizeConfig.screenWidth,
            child: Center(
              child: ListView.builder(
                itemCount: controller.icon.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(() {
                    controller.selectedIndex.value;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (controller.selectedIndex.value != index) {
                              controller.selectedIndex.value = index;
                              controller.selectedEventType.value = controller.sportsNames[index];
                            } else {
                              controller.selectedIndex.value = 40;
                              controller.selectedEventType.value = "";
                            }
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: controller.selectedIndex.value == index
                                ? Color(0xff496e3d)
                                : blackColor,
                            child: Icon(controller.icon[index],
                                color: controller.selectedIndex.value == index
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
            controller.selectedEventType.value;
            return StreamBuilder<QuerySnapshot>(
              stream: controller.selectedEventType.value == "" ? FirebaseFirestore.instance
                  .collection('events')
                  .snapshots() : FirebaseFirestore.instance
                  .collection('events')
                  .where(
                  'selectedEventType', isEqualTo: controller.selectedEventType.value)
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
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: events.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var eventData = EventModel.fromMap(events[index].data() as Map<String, dynamic>);
                    // Format the selectedDateTime into "Fri 15th"
                    DateTime eventDate = DateFormat('dd/MM/yyyy').parse(eventData.selectedDateTime);
                    String formattedDate = DateFormat('EEE dd\'th\',').format(eventDate); // Format: "Fri 15th"
                    bool isLastIndex = index == events.length - 1;
                    // Combine with time to display "Fri 15th, 8pm"
                    String dateTime = "$formattedDate ${eventData.time}";

                    return Padding(
                      padding: EdgeInsets.only(bottom: isLastIndex ? 0 : 10),
                      child: CustomCard(
                        onTap: () => buildShowModalBottomSheet(context, eventData,controller.eventImages[eventData.selectedEventType] ?? basketBallImage),
                        padding: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 10),
                        width: SizeConfig.screenWidth,
                        color: Color(0xffF2F2F2),
                        borderRadius: 6,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    controller.eventImages[eventData.selectedEventType] ?? basketBallImage,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  ),
                                ),

                                // Use the correct image path
                                SizedBox(width: 5),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0, top: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                            value: "${eventData.selectedCity}, ${eventData.selectedState}"),
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
                );
              },
            );
          })


        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, EventModel eventModel,String eventImage) async {
    // Format the selectedDateTime into "Fri 15th"
    DateTime eventDate = DateFormat('dd/MM/yyyy').parse(eventModel.selectedDateTime);
    String formattedDate = DateFormat('EEE dd\'th\',').format(eventDate); // Format: "Fri 15th"

    // Combine with time to display "Fri 15th, 8pm"

    return showBottomSheet(
      backgroundColor: Colors.white,
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
                      eventImage,  // You can replace this with dynamic data if needed.
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
              }),
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
                    color: Colors.grey.withValues(alpha: 0.5),
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
                onTap: () {
                  shareOnWhatsApp(eventModel);
                },
                alignment: Alignment.center,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
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

  Future<void> shareOnWhatsApp(EventModel eventModel) async {
    final message = '''
    📢 *${eventModel.selectedEventType}* Event
    
    📍 Location: ${eventModel.selectedCity}, ${eventModel.selectedState}
    📅 Date: ${eventModel.selectedDateTime}
    🕒 Time: ${eventModel.time}
    
    📌 Rules:
    ${eventModel.rules}
    
    Join us for an exciting experience!
    ''';

    final url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Handle error
      debugPrint("Could not launch WhatsApp");
    }
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
