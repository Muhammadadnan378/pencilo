import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/consts/colors.dart';
import '../../../data/current_user_data/current_user_Data.dart';
import '../../../data/custom_widget/custom_card.dart';
import '../../../data/custom_widget/custom_media_query.dart';
import '../../../data/custom_widget/custom_text_widget.dart';
import 'like_videos_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
        child: Column(
          children: [
            CustomCard(
                onTap: () => CurrentUserData.logout(),
                width: SizeConfig.screenWidth,
                height: 50,
                borderRadius: 4,
                border: Border.all(color: grayColor, width: 0.5),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    CustomText(text: "Logout", color: blackColor,size: 16,),
                    Spacer(),
                    Icon(Icons.logout),
                    SizedBox(width: 15,),
                  ],
                )

            ),
            SizedBox(height: 10,),
            CustomCard(
                onTap: () => Get.to(LikeVideosView()),
                width: SizeConfig.screenWidth,
                height: 50,
                borderRadius: 4,
                border: Border.all(color: grayColor, width: 0.5),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    CustomText(text: "like videos", color: blackColor,size: 16,),
                    Spacer(),
                    Icon(Icons.thumb_up_alt_outlined),
                    SizedBox(width: 15,),
                  ],
                )

            ),
          ],
        ),
      )
    );
  }
}
