import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/data/custom_widget/show_images_view.dart';

import '../../data/consts/images.dart';
import '../../data/current_user_data/current_user_Data.dart';
import '../../data/custom_widget/custom_media_query.dart';
import 'buy_book_view.dart';
import 'buy_sell_book_view.dart';

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
            SizedBox(
              height: 250, // Adjust height as needed
              child: PageView.builder(
                itemCount: book.images.length,
                controller: PageController(viewportFraction: 0.9),
                itemBuilder: (context, index) {
                  final image = book.images[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(ShowImagesView(imagePaths: book.images, initialIndex: index));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: image.startsWith('http') || image.startsWith('https')
                          ? Image.network(
                        image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : File(image).existsSync()
                          ? Image.file(
                        File(image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/fallback.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 15),
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

            CustomText(
              text: book.currentLocation,  // Display "New" or "Old"
              color: Color(0xff666666),
              fontFamily: poppinsFontFamily,
              size: 12,
              fontWeight: FontWeight.w600,
            ),
            Spacer(),
            // if(book.uid != CurrentUserData.uid)
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 10),
              child: CustomCard(
                onTap: () {
                  // Your onTap action (e.g., navigate to AmountView)
                  Get.off(BuyBookView(book: book,));
                },
                alignment: Alignment.center,
                borderRadius: 11,
                width: double.infinity,
                height: 57,
                color: blackColor,
                child: CustomText(
                  text: "Buy now",
                  size: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: poppinsFontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

