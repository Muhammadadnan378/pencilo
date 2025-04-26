import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/colors.dart';
import 'package:pencilo/data/consts/const_import.dart';

class ShowImagesView extends StatelessWidget {
  final List<String> imagePaths;  // List of image paths (URLs or local files)
  final int initialIndex;         // Initial index of the image to display

  // Constructor to accept image paths and display configurations
  const ShowImagesView({
    Key? key,
    required this.imagePaths,
    required this.initialIndex,  // Required initial index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: CustomText(text: "Image Viewer",),
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: whiteColor,)),
      ),
      body: Center(
        child: PageView.builder(
          itemCount: imagePaths.length,
          controller: PageController(initialPage: initialIndex),  // Set the initial index
          itemBuilder: (context, index) {
            String image = imagePaths[index];

            // Check if image is a URL or local file and display accordingly
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.startsWith('http') || image.startsWith('https')
              // If it's a URL, use Image.network
                  ? Image.network(
                image,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              )
                  : File(image).existsSync()
              // If it's a local file, use Image.file
                  ? Image.file(
                File(image),
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              )
                  : Image.asset(
                'assets/images/fallback.png', // Fallback image
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
      ),
    );
  }
}
