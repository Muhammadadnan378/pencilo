import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/view/buy_book_view/book_detail.dart';
import 'package:pencilo/view/buy_book_view/sell_book_view.dart';

import '../../data/consts/images.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/view/buy_book_view/book_detail.dart';

class BuyBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Row(
                children: [
                  Column(
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
                  ),
                  Spacer(),
                  CustomCard(
                    width: 124,
                    height: 36,
                    borderRadius: 20,
                    color: Color(0xffD9D9D9),
                    child: Row(
                      children: [
                        SizedBox(width: 14),
                        Icon(CupertinoIcons.search, size: 18, color: Color(0xff666666)),
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
                  ),
                ],
              ),
              SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: 'Buy or sell new and used books',
                  color: blackColor,
                  fontFamily: interFontFamily,
                  size: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              // GridView for displaying books from Hive
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(sellBookModelName)  // Listen to the collection in Firestore
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: CustomText(text: "No Sell books available", color: blackColor));
                    }

                    // Map Firestore data to SellBookModel
                    var books = snapshot.data!.docs.map((doc) {
                      return SellBookModel.fromFirestore(doc.data() as Map<String, dynamic>);
                    }).toList();

                    return GridView.builder(
                      itemCount: books.length,  // Use the length of the Firestore data
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.66, // Adjust for height/width ratio
                      ),
                      shrinkWrap: true, // Important when used inside a column
                      physics: NeverScrollableScrollPhysics(), // Avoid scroll conflict
                      itemBuilder: (context, index) {
                        final book = books[index];

                        return CustomCard(
                          width: double.infinity,
                          height: 250,
                          color: Colors.grey[200],
                          borderRadius: 12,
                          boxShadow: [
                            BoxShadow(color: grayColor, blurRadius: 5, offset: Offset(0, 3))
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: CustomText(
                                          text: '${book.title}',
                                          fontWeight: FontWeight.w600,
                                          size: 12,
                                          color: blackColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: CustomText(
                                          text: '${book.amount}',
                                          fontWeight: FontWeight.w300,
                                          size: 9,
                                          color: blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 5),
                              // Top Image
                              GestureDetector(
                                onTap: () {
                                  Get.to(BookDetail(book: book));
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(1)),
                                    child: book.images.isNotEmpty
                                        ? (book.images[0].startsWith('http') ||
                                        book.images[0].startsWith('https') // Check if image is a URL
                                        ? Image.network(
                                      book.images[0], // Use Image.network for URL-based images
                                      height: 153,
                                      width: 114,
                                      fit: BoxFit.fill,
                                    )
                                        : Image.file(
                                      File(book.images[0]), // Use Image.file for local files
                                      height: 153,
                                      width: 114,
                                      fit: BoxFit.cover,
                                    ))
                                        : Image.asset(
                                      mathImage,
                                      // Fallback image if no image is found
                                      height: 153,
                                      width: 114,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4.0),
                                          child: CustomText(
                                            text: '₹ ${book.amount}',
                                            fontWeight: FontWeight.w600,
                                            size: 12,
                                            color: blackColor,
                                          ),
                                        ),
                                        // Subtitle
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4.0),
                                          child: CustomText(
                                            text: '${book.address}',
                                            fontWeight: FontWeight.w300,
                                            size: 9,
                                            maxLines: 1,
                                            color: blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4,),
                                  CustomCard(
                                    onTap: () {
                                      // Handle Buy Now action here
                                    },
                                    alignment: Alignment.center,
                                    borderRadius: 4,
                                    width: 43,
                                    height: 23,
                                    color: blackColor,
                                    child: CustomText(text: "Buy now", size: 8),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: CustomCard(
            onTap: () {
              Get.to(SellBookView());
            },
            width: 106,
            height: 47,
            color: Color(0xff57A8B8),
            borderRadius: 20,
            child: Row(
              children: [
                SizedBox(width: 14),
                Icon(CupertinoIcons.add, weight: 10, size: 18, color: whiteColor),
                SizedBox(width: 3),
                CustomText(
                  text: 'Sell book',
                  color: whiteColor,
                  fontFamily: poppinsFontFamily,
                  size: 12,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

