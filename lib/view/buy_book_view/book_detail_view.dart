import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/view/show_images_view.dart';

import '../../data/consts/images.dart';
import '../../data/custom_widget/custom_media_query.dart';

class BookDetail extends StatelessWidget {
  final SellBookModel book;

  const BookDetail({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Detail")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Book Detail',
              color: blackColor,
              fontFamily: poppinsFontFamily,
              size: 18,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 14),

            // Book Info Card
            CustomCard(
              width: SizeConfig.screenWidth,
              borderRadius: 6,
              padding: EdgeInsets.all(13),
              border: Border.all(color: bgColor, width: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: book.title,
                    color: blackColor,
                    fontFamily: poppinsFontFamily,
                    size: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 7),

                  CustomText(
                    text: book.oldOrNewBook,  // Display "New" or "Old"
                    color: Color(0xff666666),
                    fontFamily: poppinsFontFamily,
                    size: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 7),

                  // Display Images in GridView
                  // Book Image GridView
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: GridView.builder(
                      itemCount: book.images.length,  // Dynamically use the length of images list
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 140,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String image = book.images[index];

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the ShowImagesView when tapped
                            Get.to(ShowImagesView(imagePaths: book.images, initialIndex: index));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: image.startsWith('http') || image.startsWith('https')
                                ? Image.network(
                              image,
                              fit: BoxFit.cover,
                            )
                                : File(image).existsSync()
                                ? Image.file(
                              File(image),
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              'assets/images/fallback.png', // Fallback if image path is invalid
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            // Buy Now Button (same as before)
            CustomCard(
              width: SizeConfig.screenWidth,
              borderRadius: 6,
              padding: EdgeInsets.all(13),
              border: Border.all(color: bgColor, width: 0.1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: book.title,
                        color: blackColor,
                        fontFamily: poppinsFontFamily,
                        size: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 7),
                      CustomText(
                        text: book.oldOrNewBook,
                        color: Color(0xff666666),
                        fontFamily: poppinsFontFamily,
                        size: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Spacer(),
                  CustomCard(
                    onTap: () {
                      // Your onTap action (e.g., navigate to AmountView)
                    },
                    alignment: Alignment.center,
                    borderRadius: 4,
                    width: 63,
                    height: 28,
                    color: blackColor,
                    child: CustomText(
                      text: "Buy now",
                      size: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

