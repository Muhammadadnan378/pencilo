import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../data/consts/images.dart';
import 'answer_view.dart';

class SubjectPartsView extends StatelessWidget {
  final String? subject;
  const SubjectPartsView({super.key, this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15),
          child: ListView(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04,),
              Row(
                children: [
                  Column(
                    children: [
                      CustomText(text: 'Aniket Ganesh',
                        color: blackColor,
                        fontFamily: interFontFamily,
                        size: 8,),
                      SizedBox(height: 5,),
                      CustomCard(
                        alignment: Alignment.center,
                        borderRadius: 100,
                        color: Color(0xff57A8B8),
                        width: 41,
                        height: 41,
                        child: CustomText(text: "AG",
                          size: 20,
                          color: blackColor,
                          fontFamily: nixinOneFontFamily,),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: () {}, icon: Icon(Icons.notifications_rounded,size:27,))
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  CustomText(text: '$subject Answer',
                    color: blackColor,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  CustomCard(
                    width: 124,
                    height: 36,
                    borderRadius: 20,
                    color: Color(0xffD9D9D9),
                    child: Row(
                      children: [
                        SizedBox(width: 14,),
                        Icon(CupertinoIcons.search,size: 18,color: Color(0xff666666)),
                        SizedBox(width: 10,),
                        CustomText(
                          text: 'Search',
                          color: Color(0xff666666),
                          fontFamily: poppinsFontFamily,
                          size: 12,
                          fontWeight: FontWeight.w600,)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 15,),
              // Part 1
              Row(
                children: [
                  CustomText(text: 'Part 1',
                    color: blackColor,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Row(
                    children: [
                      CustomText(text: 'See All',
                        color: Color(0xff57A8B8),
                        fontFamily: interFontFamily,
                        size: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      Icon(Icons.navigate_next,color: Color(0xff57A8B8),size: 18,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10,bottom: 10), // spacing between cards
                      child: CustomCard(
                        onTap: () {
                          Get.to(AnswerView(subject: subject));
                        },
                        width: 126,
                        height: 200,
                        color: Colors.grey[200],
                        borderRadius: 12,
                        boxShadow: [
                          BoxShadow(color: grayColor,blurRadius: 5,offset: Offset(0, 3))
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                mathImage,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Title
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CustomText(
                                text: 'Part 1',
                                fontWeight: FontWeight.w600,
                                size: 12,
                                color: blackColor,
                              ),
                            ),
                            // Subtitle
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CustomText(
                                text: 'Addition of two number',
                                fontWeight: FontWeight.w300,
                                size: 8,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: Divider(
                  color: Color(0xffe6e2e2),
                ),
              ),
              SizedBox(height: 15,),
              //Part 2
              Row(
                children: [
                  CustomText(text: 'Part 2',
                    color: blackColor,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Row(
                    children: [
                      CustomText(text: 'See All',
                        color: Color(0xff57A8B8),
                        fontFamily: interFontFamily,
                        size: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      Icon(Icons.navigate_next,color: Color(0xff57A8B8),size: 18,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10,bottom: 10), // spacing between cards
                      child: CustomCard(
                        width: 126,
                        height: 200,
                        color: Colors.grey[200],
                        borderRadius: 12,
                        boxShadow: [
                          BoxShadow(color: grayColor,blurRadius: 5,offset: Offset(0, 3))
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                mathImage,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Title
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CustomText(
                                text: 'Part 1',
                                fontWeight: FontWeight.w600,
                                size: 12,
                                color: blackColor,
                              ),
                            ),
                            // Subtitle
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CustomText(
                                text: 'Addition of two number',
                                fontWeight: FontWeight.w300,
                                size: 8,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: Divider(
                  color: Color(0xffe6e2e2),
                ),
              ),
              SizedBox(height: 15,),
              //Part 3
              Row(
                children: [
                  CustomText(text: 'Part 3',
                    color: blackColor,
                    fontFamily: interFontFamily,
                    size: 18,),
                  Spacer(),
                  Row(
                    children: [
                      CustomText(text: 'See All',
                        color: Color(0xff57A8B8),
                        fontFamily: interFontFamily,
                        size: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      Icon(Icons.navigate_next,color: Color(0xff57A8B8),size: 18,)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10,bottom: 10), // spacing between cards
                      child: CustomCard(
                        width: 126,
                        height: 200,
                        color: Colors.grey[200],
                        borderRadius: 12,
                        boxShadow: [
                          BoxShadow(color: grayColor,blurRadius: 5,offset: Offset(0, 3))
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                mathImage,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Title
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CustomText(
                                text: 'Part 1',
                                fontWeight: FontWeight.w600,
                                size: 12,
                                color: blackColor,
                              ),
                            ),
                            // Subtitle
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CustomText(
                                text: 'Addition of two number',
                                fontWeight: FontWeight.w300,
                                size: 8,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: Divider(
                  color: Color(0xffe6e2e2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
