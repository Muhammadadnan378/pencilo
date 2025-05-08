import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pencilo/controller/sell_book_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/view/buy_book_view/book_detail_view.dart';
import 'package:pencilo/view/buy_book_view/sell_book_view.dart';
import '../../data/consts/images.dart';

class BuySellBookView extends StatelessWidget {

  BuySellBookView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCard(
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Obx(() {
                controller.isBookViewSearching.value;
                controller.isSelectBooksView.value;
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      Column(
                        children: [
                          Padding(
                            padding: controller.isBookViewSearching.value == true
                                ? EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 20)
                                : EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                controller.isBookViewSearching.value != true
                                    ? Column(
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
                                )
                                    : SizedBox(),
                                Spacer(),
                                controller.isBookViewSearching.value == true
                                    ? SizedBox(
                                  height: 40,
                                  width: SizeConfig.screenWidth * 0.8,
                                  child: TextField(
                                    controller: controller.searchController,
                                    focusNode: controller.searchFocusNode,
                                    onChanged: (query) {
                                      controller.searchQuery.value = query
                                          .toLowerCase(); // Convert to lower case for case insensitive search
                                      controller.update();
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            controller.isBookViewSearching(false);
                                          },
                                          child: Icon(Icons.cancel_outlined)),
                                      contentPadding: EdgeInsets.only(
                                          left: 15, right: 10),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                  ),
                                )
                                    : CustomCard(
                                  onTap: () {
                                    controller.isBookViewSearching(true);
                                    controller.searchFocusNode.requestFocus();
                                  },
                                  width: 124,
                                  height: 36,
                                  borderRadius: 20,
                                  color: Color(0xffD9D9D9),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 14),
                                      Icon(CupertinoIcons.search, size: 18,
                                          color: Color(0xff666666)),
                                      SizedBox(width: 10),
                                      CustomText(
                                        text: 'Search',
                                        color: Color(0xff666666),
                                        fontFamily: poppinsFontFamily,
                                        size: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          CustomCard(
                            borderRadius: 10,
                            color: Color(0xffe0e3e1),
                            width: SizeConfig.screenWidth * 0.8,
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
                                      color: controller.isSelectBooksView.value
                                          ? Color(
                                          0xffF6F6F6)
                                          : Colors.transparent,
                                      child: CustomText(
                                        text: "Books",
                                        color: blackColor,
                                        size: 13,
                                        fontWeight: FontWeight.bold,),
                                      onTap: () {
                                        controller.isSelectBooksView.value = true;
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
                                        color: !controller.isSelectBooksView.value
                                            ? Color(
                                            0xffF6F6F6)
                                            : Colors.transparent,
                                        child: CustomText(
                                          text: "My Order",
                                          color: blackColor,
                                          size: 13,
                                          fontWeight: FontWeight.bold,),
                                        onTap: () {
                                          controller.isSelectBooksView.value =
                                          false;
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      if(controller.isSelectBooksView.value)
                        StudentBooksView(),
                      if(!controller.isSelectBooksView.value)
                        StudentMyBookOrderView(),

                    ],
                  ),
                );
              }),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: CustomCard(
                onTap: () {
                  Get.to(SellBookView());
                },
                padding: EdgeInsets.only(right: 12, top: 13, bottom: 13),
                color: Color(0xff57A8B8),
                borderRadius: 20,
                child: Row(
                  children: [
                    SizedBox(width: 14),
                    Icon(
                      CupertinoIcons.add,
                      weight: 0.7,
                      size: 18,
                      color: whiteColor,
                    ),
                    SizedBox(width: 3),
                    CustomText(
                      text: 'Sell book',
                      color: whiteColor,
                      fontFamily: poppinsFontFamily,
                      size: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentBooksView extends StatelessWidget {
  StudentBooksView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: 'Buy or sell new and used books',
            color: blackColor,
            fontFamily: interFontFamily,
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // GridView for displaying books from Hive
            ValueListenableBuilder(
              valueListenable: Hive.box<SellBookModel>(
                  sellBookTableName).listenable(),
              // Listening to the changes in the Hive box
              builder: (BuildContext context,
                  Box<SellBookModel> value, Widget? child) {
                // Fetching the list of books from Hive
                final books = value.values.toList();

                if (books.isEmpty) {
                  return SizedBox();
                }

                // Sort books by addedDate in descending order (latest first)
                books.sort((a, b) {
                  var dateA = DateTime.parse(a.addedDate);
                  var dateB = DateTime.parse(b.addedDate);
                  return dateB.compareTo(
                      dateA); // Sort descending (latest first)
                });

                return GridView.builder(
                  itemCount: books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.66,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return CustomCard(
                      width: double.infinity,
                      color: Colors.grey[200],
                      borderRadius: 12,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  Get.to(BookDetail(
                                      book: book)); // Navigate to Book Details
                                },
                                child: book.images.isNotEmpty
                                    ? (book.images[0].startsWith(
                                    'http') ||
                                    book.images[0].startsWith('https')
                                    ? Image.network(
                                  book.images[0],
                                  height: 143,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                    : Image.file(
                                  File(book.images[0]),
                                  height: 143,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ))
                                    : Image.asset(
                                  'assets/default_image.png',
                                  height: 143,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: book.title,
                                fontWeight: FontWeight.w600,
                                size: 14,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Wrap the column inside Expanded to prevent overflow
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets
                                              .only(left: 4.0),
                                          child: CustomText(
                                            text: '₹ ${book.amount}',
                                            fontWeight: FontWeight.bold,
                                            size: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .only(left: 4.0),
                                          child: CustomText(
                                            text: book.currentLocation,
                                            fontWeight: FontWeight.w300,
                                            size: 11,
                                            maxLines: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  CustomText(
                                    text: book.oldOrNewBook,
                                    fontWeight: FontWeight.w400,
                                    size: 12,
                                    maxLines: 1,
                                    color: Colors.black,
                                  )
                                ],
                              ),

                              SizedBox(height: 4),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            bottom: 2,
                            child: book.uploading == true
                                ? SizedBox(
                                width: 15,
                                height: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    //true the uploading value in hive
                                    book.uploading = false;
                                    value.put(
                                        book.bookUid, book);
                                  },
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,),
                                )
                            )
                                : GestureDetector(
                                onTap: () {
                                  //true the uploading value in hive
                                  book.uploading = true;
                                  value.put(book.bookUid, book);
                                  controller.storeInFirestore(
                                      book);
                                },
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 6,),
            Obx(() {
              controller.searchQuery.value;
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(
                    sellBookTableName).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(child: CustomText(
                        text: "No Sell books available",
                        color: blackColor));
                  }

                  // Map Firestore data to SellBookModel
                  var books = snapshot.data!.docs.map((doc) {
                    return SellBookModel.fromFirestore(
                        doc.data() as Map<String, dynamic>);
                  }).toList();

                  // Filter books based on search query
                  if (controller.searchQuery.isNotEmpty) {
                    books = books.where((book) {
                      return book.title.toLowerCase().contains(
                          controller
                              .searchQuery); // Case insensitive search
                    }).toList();
                  }

                  // Sort books by addedDate in descending order (latest first)
                  books.sort((a, b) {
                    var dateA = DateTime.parse(a.addedDate);
                    var dateB = DateTime.parse(b.addedDate);
                    return dateB.compareTo(
                        dateA); // Sort descending (latest first)
                  });

                  return GridView.builder(
                    itemCount: books.length,
                    padding: EdgeInsets.only(top: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.66,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final book = books[index];

                      return Column(
                        children: [
                          CustomCard(
                            width: double.infinity,
                            color: Colors.grey[200],
                            borderRadius: 12,
                            boxShadow: [
                              BoxShadow(color: grayColor,
                                  blurRadius: 5,
                                  offset: Offset(0, 3)),
                            ],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(BookDetail(book: book));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: book.images.isNotEmpty
                                        ? (book.images[0].startsWith('http') ||
                                        book.images[0].startsWith('https')
                                        ? Image.network(
                                      book.images[0],
                                      height: 143,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.file(
                                      File(book.images[0]),
                                      height: 143,
                                      width: 114,
                                      fit: BoxFit.cover,
                                    ))
                                        : Image.asset(
                                      mathImage,
                                      height: 153,
                                      width: 114,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0),
                                  child: CustomText(
                                    text: book.title,
                                    fontWeight: FontWeight.w600,
                                    size: 14,
                                    color: blackColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.screenWidth *
                                            0.22,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            CustomText(
                                              text: '₹ ${book.amount}',
                                              fontWeight: FontWeight
                                                  .bold,
                                              size: 13,
                                              color: blackColor,
                                            ),
                                            CustomText(
                                              text: book.currentLocation,
                                              fontWeight: FontWeight.w300,
                                              size: 11,
                                              maxLines: 1,
                                              color: blackColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      CustomText(text: "${book.oldOrNewBook}",
                                        size: 12,
                                        color: blackColor,),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4,)
                              ],
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      );
                    },
                  );
                },
              );
            })
          ],
        ),
      ],
    );
  }
}

class StudentMyBookOrderView extends StatelessWidget {
  StudentMyBookOrderView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
        Obx(() {
          controller.isSelectBuying.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Column(
                  children: [
                    CustomText(
                      text: "I am Buying",
                      color: controller.isSelectBuying.value == true
                          ? blackColor
                          : grayColor,
                      size: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 3,),
                    controller.isSelectBuying.value == true ? CustomCard(
                      width: 30,
                      height: 2,
                      color: blackColor,
                    ) : SizedBox(),
                  ],
                ),
                onTap: () {
                  controller.isSelectBuying.value = true;
                },
              ),
              SizedBox(width: 10,),
              CustomCard(
                width: 1,
                height: 26,
                color: blackColor,
              ),
              SizedBox(width: 10,),
              GestureDetector(
                child: Column(
                  children: [
                    CustomText(
                      text: "I am Selling",
                      color: controller.isSelectBuying.value == false
                          ? blackColor
                          : grayColor,
                      size: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    controller.isSelectBuying.value == false ? CustomCard(
                      width: 30,
                      height: 2,
                      color: blackColor,
                    ) : SizedBox(),
                  ],
                ),
                onTap: () {
                  controller.isSelectBuying.value = false;
                },
              ),
            ],
          );
        }),
        SizedBox(height: 15,),
        Obx(() => controller.isSelectBuying.value ? ImBuyingView() : ImSellingView())
      ],
    );
  }
}

class ImBuyingView extends StatelessWidget {
  const ImBuyingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          padding: EdgeInsets.only(left: 20,right: 20),
          width: double.infinity,
          color: Colors.grey[200],
          borderRadius: 12,
          boxShadow: [
            BoxShadow(color: grayColor,
                blurRadius: 5,
                offset: Offset(0, 3)),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start,
            children: [
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // Get.to(BookDetail(book: book));
                },
                child: Center(
                  child: Image.asset(
                    mathImage,
                    height: 153,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0),
                child: CustomText(
                  text: "Google",
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: blackColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start,
                        children: [
                          CustomText(
                            text: '₹ 80',
                            fontWeight: FontWeight
                                .bold,
                            size: 13,
                            color: blackColor,
                          ),
                          CustomText(
                            text: "Ghowri town phase 4",
                            fontWeight: FontWeight.w300,
                            size: 11,
                            maxLines: 1,
                            color: blackColor,
                          ),
                          CustomText(
                            text: "Payment mode : Cash on Delivery",
                            fontWeight: FontWeight.w500,
                            size: 11,
                            maxLines: 1,
                            color: blackColor,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    CustomText(text: "Old",
                      size: 12,
                      color: blackColor,),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 4,),
            ],
          ),
        ),
      ],
    );
  }
}

class ImSellingView extends StatelessWidget {
  const ImSellingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          padding: EdgeInsets.only(left: 15,right: 15),
          width: double.infinity,
          color: Colors.grey[200],
          borderRadius: 12,
          boxShadow: [
            BoxShadow(color: grayColor,
                blurRadius: 5,
                offset: Offset(0, 3)),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start,
            children: [
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // Get.to(BookDetail(book: book));
                },
                child: Center(
                  child: Image.asset(
                    mathImage,
                    height: 153,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0),
                child: CustomText(
                  text: "Google",
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: blackColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start,
                        children: [
                          CustomText(
                            text: '₹ 80',
                            fontWeight: FontWeight
                                .bold,
                            size: 13,
                            color: blackColor,
                          ),
                          CustomText(
                            text: "Ghowri town phase 4",
                            fontWeight: FontWeight.w300,
                            size: 11,
                            maxLines: 1,
                            color: blackColor,
                          ),
                          CustomText(
                            text: "Payment mode : Cash on Delivery",
                            fontWeight: FontWeight.w500,
                            size: 11,
                            maxLines: 1,
                            color: blackColor,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        CustomCard(
                          width: 73,
                          height: 33,
                          color: Color(0xffFF8585),
                          borderRadius: 10,
                          alignment: Alignment.center,
                          child: CustomText(text: "Delete",size: 12,color: bgColor,),
                        ),
                        SizedBox(width: 5,),
                        CustomCard(
                          width: 73,
                          height: 33,
                          color: Color(0xff85B6FF),
                          borderRadius: 10,
                          alignment: Alignment.center,
                          child: CustomText(text: "Edit",size: 12,color: bgColor,),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(text: "Book Contact",
            size: 22,
            color: blackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 5,),
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
                          fontSize: 13
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
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
                          fontSize: 13
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Muhammad"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("80"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("2345678",),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Google"),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Muhammad"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("80"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("2345678"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Google"),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Muhammad"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("80"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("2345678"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Google"),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Muhammad"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("80"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("2345678"),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Google"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}



