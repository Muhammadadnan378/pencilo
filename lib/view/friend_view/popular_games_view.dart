import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/consts/images.dart';

import 'application_form_view.dart';

class PopularGamesView extends StatelessWidget {
  PopularGamesView({super.key});

  final List<IconData> icon = [
    Icons.nordic_walking,
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.sports_football,
    Icons.sports_cricket,
    Icons.sports_baseball,
    Icons.sports_volleyball,
  ];

  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
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
                itemCount: 7,
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
                            selectedIndex.value = index;
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
          CustomCard(
            height: SizeConfig.screenHeight * 0.68,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 2,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomCard(
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: CustomCard(
                                      onTap: () => buildShowModalBottomSheet(context),
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
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) async {
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
                borderRadiusOnly: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                height: SizeConfig.screenHeight * 0.2,
                width: SizeConfig.screenWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                    child: Image.asset(
                      basketBallImage,
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Text(
                "Basketball Game",
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
                                text: "15 July",
                                size: 13,
                                fontWeight: FontWeight.bold,
                                color: blackColor
                            ),
                            CustomText(
                              text: "Friday",
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
                            text: "8 pm",
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
                      text: "Thane , Mumbai",
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
                    fontWeight:
                    FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text("1: Rule 1"),
              Text("2: Rule 2"),
              Text("3: Rule 3"),
              SizedBox(height: 20),
              CustomCard(
                onTap: () {
                  Get.to(ApplicationFormView());
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
                child: CustomText(text: "Join", color: blackColor, size: 22,fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: 10,),
              CustomCard(
                onTap: () {
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
                color: Color(0xff58FF2A),
                width: SizeConfig.screenWidth,
                height: 40,
                child: CustomText(text: "Share", color: blackColor, size: 22,fontWeight: FontWeight.bold,),
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
