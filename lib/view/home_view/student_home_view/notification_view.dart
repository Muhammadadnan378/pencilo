import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/data/consts/const_import.dart'; // Update this path according to your imports
import 'package:pencilo/model/buying_selling_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../../controller/sell_book_controller.dart';
import '../../../data/current_user_data/current_user_Data.dart';
import '../../../data/custom_widget/custom_media_query.dart';
import '../../../db_helper/model_name.dart';
import '../../../model/notice_&_homework_model.dart';
import '../../profile_view/academic_tabs_view/notice/notice_watch_view.dart';

class NotificationView extends StatelessWidget {
  final int initialTabIndex;
  final SellBookController controller = Get.put(SellBookController());

  NotificationView({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    controller.updateRequestCount();
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: whiteColor),
        ),
        foregroundColor: whiteColor,
        backgroundColor: blackColor,
        title: const CustomText(
          text: "Notification",
          fontWeight: FontWeight.bold,
          size: 25,
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(buyingRequestTableName)
                .where("sellerUid", isEqualTo: CurrentUserData.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SizedBox();
              }

              var data = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: CustomCard(
                    borderRadius: 5,
                    padding: EdgeInsets.all(5),
                    color: Color(0xff2D2D2D),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Product Requests',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          controller.isBuyingLength.value;
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.isBuyingLength.value == true
                                    ? 3
                                    : data.length,
                                itemBuilder: (context, index) {
                                  var buyBooks = BuyingSellingModel.fromMap(
                                      data[index].data() as Map<String, dynamic>);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: CustomCard(
                                      color: Color(0xff5C5C5C),
                                      borderRadius: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.blue,
                                                  child: CustomText(
                                                    text: buyBooks.buyerUserName[0],
                                                    // Displaying initial of userName
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      SizedBox(
                                                        width: SizeConfig
                                                            .screenWidth * 0.4,
                                                        child: CustomText(
                                                          text: buyBooks
                                                              .buyerUserName,
                                                          size: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    CustomText(
                                                        text: buyBooks
                                                            .paymentMethod ==
                                                            "Cash on Delivery"
                                                            ? "COD"
                                                            : "Online"),
                                                    CustomText(
                                                      text: '₹ ${buyBooks
                                                          .buyerUserAmount}',
                                                      size: 17,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff2CD13A),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              child: CustomText(
                                                text: "Do you want to sell ${buyBooks
                                                    .bookName} to ${buyBooks
                                                    .buyerUserName}?",
                                                color: Colors.white.withValues(alpha: 0.5),
                                                maxLines: 1,
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            if (!buyBooks.sellingRequest)
                                              Obx(() {
                                                final isLoading = controller.isLoadingMap[buyBooks.buyId] ?? false;

                                                return isLoading
                                                    ? SizedBox(width: 30,height: 30,child: CircularProgressIndicator(color: whiteColor,))
                                                    : CustomCard(
                                                  height: 30,
                                                  borderRadius: 5,
                                                  width: SizeConfig.screenWidth * 0.4,
                                                  color: Color(0xff373737),
                                                  onTap: () async {
                                                    await controller.acceptSellingRequest(data, buyBooks);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.check, color: whiteColor),
                                                      SizedBox(width: 10),
                                                      CustomText(text: "YES"),
                                                    ],
                                                  ),
                                                );
                                              }),

                                            SizedBox(width: 10),

                                            if (buyBooks.sellingRequest)
                                              Obx(() {
                                                final isLoading = controller.isLoadingMap[buyBooks.buyId] ?? false;

                                                return isLoading
                                                    ? SizedBox(width: 30,height: 30,child: CircularProgressIndicator(color: whiteColor,))
                                                    : CustomCard(
                                                  height: 30,
                                                  borderRadius: 5,
                                                  width: SizeConfig.screenWidth * 0.4,
                                                  color: Color(0xff373737),
                                                  onTap: () async {
                                                    await controller.rejectSellingRequest(data, buyBooks);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.clear, color: whiteColor),
                                                      SizedBox(width: 10),
                                                      CustomText(text: "NO"),
                                                    ],
                                                  ),
                                                );
                                              })

                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if(data.length > 3)
                                Center(
                                  child: CustomCard(
                                    onTap: () {
                                      if (controller.isBuyingLength.value == false) {
                                        controller.isBuyingLength(true);
                                      } else {
                                        controller.isBuyingLength(false);
                                      }
                                    },
                                    child: CustomText(
                                      text: 'Sell All',
                                      size: 18,
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          StreamBuilder<List<QuerySnapshot>>(
            stream: CombineLatestStream.list([
              FirebaseFirestore.instance
                  .collection(noticeTableName)
                  .where("division", isEqualTo: CurrentUserData.division)
                  .where("standard", isEqualTo: CurrentUserData.standard)
                  .snapshots(),
              FirebaseFirestore.instance
                  .collection(homeWorkTableName)
                  .where("division", isEqualTo: CurrentUserData.division)
                  .where("standard", isEqualTo: CurrentUserData.standard)
                  .snapshots(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.hasError) {
                return CustomText(text: "Something went wrong or no data", color: blackColor);
              }

              final noticeDocs = snapshot.data![0].docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['source'] = 'notice'; // Add source info
                return data;
              }).toList();

              final homeworkDocs = snapshot.data![1].docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['source'] = 'homework'; // Add source info
                return data;
              }).toList();

              final allDocs = [...noticeDocs, ...homeworkDocs];

              // Sort by createdAt
              allDocs.sort((a, b) {
                return (b['createdAt']).compareTo(a['createdAt']);
              });

              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: allDocs.length,
                itemBuilder: (context, index) {
                  final data = allDocs[index];
                  final notice = NoticeHomeWorkModel.fromMap(data);

                  // ✅ Show message depending on source
                  final sharedText = data['source'] == 'homework'
                      ? "${notice.teacherName} has shared Homework"
                      : "${notice.teacherName} has shared Notice";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCard(
                        onTap: () => Get.to(NoticeWatchView(notice: notice)),
                        color: Color(0xff5C5C5C),
                        borderRadius: 7,
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.6,
                                  child: CustomText(
                                    text: sharedText,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w600,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  text: "Title: ${notice.title}",
                                  fontWeight: FontWeight.w600,
                                  size: 15,
                                ),
                                CustomText(
                                  text: DateFormat.yMMMd().add_jm().format(notice.createdAt),
                                  color: grayColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}



class SellingRequestView extends StatelessWidget {
  final SellBookController controller;

  const SellingRequestView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(sellingRequestTableName)
          .where("sellerUid", isEqualTo: CurrentUserData.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: CustomText(text: 'No book requests available.'));
        }


        var data = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: CustomCard(
              borderRadius: 5,
              padding: EdgeInsets.all(5),
              color: Color(0xff2D2D2D),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Product Requests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    controller.isSellingLength.value;
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.isSellingLength.value == true
                              ? 3
                              : data.length,
                          itemBuilder: (context, index) {
                            var buyBooks = BuyingSellingModel.fromMap(
                                data[index].data() as Map<String, dynamic>);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: CustomCard(
                                color: Color(0xff5C5C5C),
                                borderRadius: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.blue,
                                            child: CustomText(
                                              text: buyBooks.buyerUserName[0],
                                              // Displaying initial of userName
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                SizedBox(
                                                  width: SizeConfig
                                                      .screenWidth * 0.4,
                                                  child: CustomText(
                                                    text: buyBooks
                                                        .buyerUserName,
                                                    size: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              CustomText(
                                                  text: buyBooks
                                                      .paymentMethod ==
                                                      "Cash on Delivery"
                                                      ? "COD"
                                                      : "Online"),
                                              CustomText(
                                                text: '₹ ${buyBooks
                                                    .buyerUserAmount}',
                                                size: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff2CD13A),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Align(
                                      //   alignment: AlignmentDirectional.centerStart,
                                      //   child: CustomText(
                                      //     text: "Do you want to buy ${buyBooks.bookTitle} from ${buyBooks.userName}?",
                                      //     color: Colors.white.withOpacity(
                                      //         0.9),
                                      //     maxLines: 1,
                                      //   ),
                                      // ),
                                      // SizedBox(height: 5,),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if(data.length > 3)
                          Center(
                            child: CustomCard(
                              onTap: () {
                                if (controller.isSellingLength.value == false) {
                                  controller.isSellingLength(true);
                                } else {
                                  controller.isSellingLength(false);
                                }
                              },
                              child: CustomText(
                                text: 'Sell All',
                                size: 18,
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
