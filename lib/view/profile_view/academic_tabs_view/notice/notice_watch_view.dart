import 'package:flutter/material.dart';
import 'package:pencilo/model/notice_&_homework_model.dart';

import '../../../../data/consts/colors.dart';
import '../../../../data/custom_widget/custom_media_query.dart';
import '../../../../data/custom_widget/custom_text_widget.dart';

class NoticeWatchView extends StatelessWidget {
  final NoticeHomeWorkModel notice;
  const NoticeWatchView({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(text: notice.teacherName,color: blackColor,size: 26,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Title",
              color: blackColor,
              fontWeight: FontWeight.w800,
              size: 19,
            ),
            SizedBox(height: 5),
            CustomText(
              text: notice.title,
              fontWeight: FontWeight.w400,
              size: 13,
              color: blackColor,
            ),
            SizedBox(height: 5),
            CustomText(
              text: "Description",
              color: blackColor,
              fontWeight: FontWeight.w800,
              size: 19,
            ),
            SizedBox(height: 5),
            CustomText(
              text: notice.note,
              fontWeight: FontWeight.w400,
              size: 13,
              color: blackColor,
            ),
            SizedBox(height: 20,),
            if (notice.imageUrl != null &&
                notice.imageUrl!.isNotEmpty)
              Center(child: Image.network(notice.imageUrl!,height: SizeConfig.screenHeight * 0.3)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
