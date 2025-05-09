import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencilo/data/consts/const_import.dart'; // Update this path according to your imports
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import '../../../controller/sell_book_controller.dart';
import '../../../db_helper/model_name.dart';
import '../../../db_helper/send_notification_service.dart';
import '../../../model/sell_book_model.dart'; // Adjust if necessary

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: CustomCard(
          borderRadius: 5,
          padding: EdgeInsets.all(5),
          color: Colors.grey.shade300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Product Requests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(sellBookTableName).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available.'));
                  }


                  List<SellBookModel> sellBooks = snapshot.data!.docs.map((doc) => SellBookModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

                  // Flatten buyBookUsersList from all SellBookModels
                  List<Map<String, dynamic>> allBuyBookUsers = [];
                  for (var book in sellBooks) {
                    if (book.buyBookUsersList != null) {
                      allBuyBookUsers.addAll(book.buyBookUsersList!);
                    }
                  }

                  if (allBuyBookUsers.isEmpty) {
                    return Center(child: Text('No product requests available.'));
                  }

                  var data = snapshot.data!.docs;
                  var bookName = data[0]["title"];

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: allBuyBookUsers.length,
                    itemBuilder: (context, index) {
                      var sellBook = allBuyBookUsers[index];
                      final buyBookUsersList = data[0]['buyBookUsersList'];

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.blue,
                                      child: CustomText(
                                        text: sellBook['userName']?[0] ?? 'N/A',
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
                                            width: SizeConfig.screenWidth * 0.4,
                                            child: CustomText(
                                              text: sellBook['userName'] ??
                                                  'No Name',
                                              size: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 17,
                                                  color: Colors.white),
                                              SizedBox(width: 5),
                                              SizedBox(
                                                width: SizeConfig.screenWidth *
                                                    0.4,
                                                child: CustomText(
                                                  text: sellBook['userAddress'] ??
                                                      'No Address',
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.phone, size: 17,
                                                  color: Colors.white),
                                              SizedBox(width: 5),
                                              CustomText(
                                                text: data[0]['uid'] ??
                                                    'No Contact',
                                                color: Colors.white.withOpacity(
                                                    0.9),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        CustomText(
                                            text: sellBook["paymentMethod"] ==
                                                "Cash on Delivery"
                                                ? "COD"
                                                : "Online"),
                                        CustomText(
                                          text: '₹ ${sellBook['userAmount'] ??
                                              '0'}',
                                          size: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff2CD13A),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: "Do you want to sell to ${sellBook['userName']}?",
                                        color: Colors.white.withOpacity(0.9),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        sellBook['sellingRequest'] == false
                                            ? Obx(() {
                                          controller.sellingRequest.value;
                                          return Center(
                                              child: controller.sellingRequest.value != false
                                                  ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color: whiteColor,
                                                ),
                                              ) : CustomCard(
                                                width: 30,
                                                height: 30,
                                                color: Color(0xff658E5C),
                                                onTap: () async
                                                {
                                                  controller.sellingRequest(true);
                                                  try {
                                                    // Create a copy of the buyBookUsersList
                                                      final docId = data[0].id; // assuming you're using data[0] always (change if needed)
                                                      final DocumentReference docRef = FirebaseFirestore.instance.collection(sellBookTableName).doc(docId);

                                                      DocumentSnapshot docSnap = await docRef.get();
                                                      List<dynamic> updatedList = List.from(docSnap['buyBookUsersList']);

                                                      // Find the matching user by some unique identifier
                                                      int targetIndex = updatedList.indexWhere((element) =>
                                                      element['userContact'] == sellBook['userContact']); // or another unique field

                                                      if (targetIndex != -1) {
                                                        updatedList[targetIndex]['sellingRequest'] = true;

                                                        await docRef.update({
                                                          'buyBookUsersList': updatedList,
                                                        });

                                                        controller.sellingRequest.value = false;
                                                        Get.snackbar("Success", "Selling request updated");
                                                      } else {
                                                        controller.sellingRequest.value = false;
                                                        Get.snackbar("Error", "User not found in buyBookUsersList");
                                                      }
                                                      String pushToken = "";

                                                      try {
                                                        // Query the Firestore collection based on the uid
                                                        QuerySnapshot snapshot = await FirebaseFirestore.instance
                                                            .collection(studentTableName)
                                                            .where("uid", isEqualTo: data[0]['uid'])
                                                            .get();

                                                        // Check if the document exists
                                                        if (snapshot.docs.isNotEmpty) {
                                                          // Retrieve the first document (assuming uid is unique and only one document matches)
                                                          DocumentSnapshot userDoc = snapshot.docs.first;

                                                          // Get the push token (FCM token) from the document
                                                          pushToken = userDoc['pushToken'];

                                                          // Do something with the push token
                                                          print("Push Token: $pushToken");

                                                          // You can now use this push token to send notifications via FCM
                                                        } else {
                                                          print("User not found");
                                                        }
                                                      } catch (e) {
                                                        print("Error retrieving push token: $e");
                                                      }

                                                      // Send the push notification using the push token
                                                      if (pushToken.isNotEmpty) {
                                                        await SendNotificationService.sendNotificationUsingApi(
                                                          token: pushToken,
                                                          title: "Your book ${data[0]['title']} buying request accepted",
                                                          body: "Tap to view the notification",
                                                          data: {
                                                            "screen": "NotificationView", // This is for navigation when tapped
                                                          },
                                                        );
                                                      }
                                                      // // Listen for notification tap and navigate to the screen
                                                      // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
                                                      //   if (message.data['screen'] == 'NotificationView') {
                                                      //     Get.to(() => NotificationView()); // Navigate to NotificationView screen
                                                      //   }
                                                      // });
                                                      controller.sellingRequest(false);
                                                      Get.snackbar("Success", "Request sent successfully!");
                                                  } catch (e) {
                                                    controller.sellingRequest(false);
                                                    Get.snackbar("Error", "$e");
                                                  }
                                                },
                                                child: Icon(Icons.check,
                                                    color: whiteColor),
                                              ));
                                        }) : SizedBox(),
                                        SizedBox(width: 10),
                                        CustomCard(
                                          onTap: () async {
                                            if(sellBook['sellingRequest'] == true){
                                              try {
                                                final docId = data[0].id; // assuming you're using data[0] always (change if needed)
                                                final DocumentReference docRef = FirebaseFirestore.instance.collection(sellBookTableName).doc(docId);

                                                DocumentSnapshot docSnap = await docRef.get();
                                                List<dynamic> updatedList = List.from(docSnap['buyBookUsersList']);

                                                // Find the matching user by some unique identifier
                                                int targetIndex = updatedList.indexWhere((element) =>
                                                element['userContact'] == sellBook['userContact']); // or another unique field

                                                if (targetIndex != -1) {
                                                  updatedList[targetIndex]['sellingRequest'] = false;

                                                  await docRef.update({
                                                    'buyBookUsersList': updatedList,
                                                  });

                                                  Get.snackbar("Success", "Selling request updated");
                                                } else {
                                                  Get.snackbar("Error", "User not found in buyBookUsersList");
                                                }
                                              } catch (e) {
                                                Get.snackbar("Error", e.toString());
                                              }
                                            }
                                          },
                                          width: 30,
                                          height: 30,
                                          color: Color(0xff8E5C5C),
                                          child: Icon(
                                              Icons.clear, color: blackColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Center(
                child: CustomCard(
                  onTap: () {},
                  child: CustomText(
                    text: 'Sell All',
                    size: 18,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
