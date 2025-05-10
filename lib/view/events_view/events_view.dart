import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/view/events_view/upload_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/consts/const_import.dart';
import '../../data/custom_widget/show_youtube_video.dart';

class FriendsView extends StatelessWidget {
  FriendsView({super.key});


 final List<String> videoUrls = [
   "https://www.youtube.com/shorts/ED0QpzC4Cyw?feature=share",
   "https://www.youtube.com/shorts/h4mE_C6a3Bo?feature=share",
 ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.05,
                      ),
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
                  SizedBox(height: 15,),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: videoUrls.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final videoUrl = videoUrls[index];

                      return CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            CustomCard(
                              onTap: (){
                                  Get.to(ShowYoutubeVideo(
                                    videoUrl: videoUrl, // Navigate to ShowYoutubeVideo
                                  ));
                              },
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight * 0.3,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    child: Image.network(
                                      "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(videoUrl)}/0.jpg", // YouTube thumbnail
                                      height: SizeConfig.screenHeight * 0.3,
                                      width: SizeConfig.screenWidth,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    top: 0,
                                    left: 0,
                                    child: Icon(
                                      Icons.play_circle,
                                      size: 40,
                                      color: whiteColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage(startBoyImage),
                                  ),
                                  SizedBox(height: 8),
                                  // Title
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Build it in Figma: Create a Design System — Foundations",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: interFontFamily,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        // Description
                                        Text(
                                          "Figma . 44K views . 4 months ago",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Icon(Icons.more_vert_outlined,size: 25,color: blackColor,)
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Divider(height: 3,thickness: 1.2,color: blackColor,),
                            SizedBox(height: 15,)
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: InkWell(
              onTap: () {
                Get.to(UploadVideo());
              },
              child: CircleAvatar(
                radius: 27,
                backgroundColor: blackColor,
                child: Icon(CupertinoIcons.plus,color: whiteColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
