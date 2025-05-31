import 'package:pencilo/controller/sell_book_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import '../../../controller/home_controller.dart';
import '../../../data/current_user_data/current_user_Data.dart';
import '../../../model/sell_book_model.dart';


class SellBookView extends StatelessWidget {
  final SellBookModel? sellBook;
  SellBookView({super.key, this.sellBook});
  final SellBookController controller = Get.put(SellBookController());


  @override
  Widget build(BuildContext context) {
    if (sellBook != null) {
      controller.titleController.text = sellBook!.bookName;
      controller.amountController.text = sellBook!.amount.toString();
      controller.currentLocationController.text = sellBook!.currentLocation;
      controller.contactNumberController.text = sellBook!.contactNumber;

      // Convert List<String> to List<File> and assign it to the controller
      controller.updateImageList.value = sellBook!.images;
    }
    controller.getFullAddress();
    controller.contactNumberController.text = CurrentUserData.phoneNumber;
    debugPrint("Location ${CurrentUserData.currentLocation}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          controller.clearDataAfterUpload();
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          controller.clearDataAfterUpload();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: ListView(
            children: [
              CustomText(text: 'Sell Your Book', color: blackColor, fontFamily: poppinsFontFamily, size: 16, fontWeight: FontWeight.w700),
              SizedBox(height: 10),
              CustomCard(
                alignment: Alignment.center,
                borderRadius: 12,
                width: SizeConfig.screenWidth * 0.9,
                height: 120,
                color: Color(0xffD9D9D9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt, size: 45, color: bgColor),
                      onPressed: () {
                        controller.pickImageFromCamera();
                      },
                    ),
                    SizedBox(width: 10,),
                    IconButton(
                      icon: Icon(Icons.photo, size: 45, color: bgColor),
                      onPressed: () {
                        controller.selectImage();  // Select image from gallery
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Obx(() {
              int imagesLength = controller.updateImageList.length + controller.images.length;
              return imagesLength > 0
                  ? SizedBox(
                height: 140,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagesLength,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                    mainAxisExtent: 72,
                  ),
                  itemBuilder: (context, index) {
                    // Check which list to access
                    bool isFromUpdateList = index < controller.updateImageList.length;
                    return Stack(
                      children: [
                        // Display image from updateImageList or images based on the index
                        if (isFromUpdateList)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              controller.updateImageList[index],
                              height: 143,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              controller.images[index - controller.updateImageList.length], // Adjust index for the images list
                              fit: BoxFit.cover,
                              height: 143,
                              width: 70,
                            ),
                          ),
                        // Positioned delete icon
                        Positioned(
                          right: 3,
                          top: 3,
                          child: GestureDetector(
                            onTap: () async{
                              // Deleting the image from Firebase Storage and Firestore
                              if (isFromUpdateList) {
                                controller.firestoreImageUrls.add(controller.updateImageList[index]);
                                controller.firestoreStorageImagePath.add(sellBook!.storageImagePath![index]);
                                controller.updateImageList.removeAt(index);
                              } else {
                                controller.images.removeAt(index - controller.updateImageList.length);
                              }
                            },
                            child: Icon(Icons.cancel, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
                  : SizedBox();
            }),
              SizedBox(height: 10),
              SellBookClassTextField(
                hintText: "Enter Book Title",
                title: 'Title',
                controller: controller.titleController, // Pass controller
              ),
              SizedBox(height: 10),
              CustomText(text: "Book condition ",color: blackColor,fontWeight: FontWeight.w500,size: 14),
              // Book condition (New or Old) Radio Buttons
              Obx(() {
                controller.selectedOption.value;
                return Row(
                  children: [
                    Radio<String>(
                      value: 'New',
                      groupValue: controller.selectedOption.value,
                      onChanged: (value) {
                        controller.selectedOption.value = value!;
                      },
                    ),
                    Text('New'),
                    Radio<String>(
                      value: 'Old',
                      groupValue: controller.selectedOption.value,
                      onChanged: (value) {
                        controller.selectedOption.value = value!;
                      },
                    ),
                    Text('Old'),
                  ],
                );
              },),
              SellBookClassTextField(
                hintText: "Enter Amount",
                title: 'Amount',
                keyboardType: TextInputType.number,
                controller: controller.amountController, // Pass controller
              ),
              SellBookClassTextField(
                hintText: "Enter Current location",
                title: 'Current location',
                controller: controller.currentLocationController,
                isMultiline: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 6.0,top: 5),
                  child: SizedBox(width: 30,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () async{
                              await startLocationStream().then((value) {
                                controller.getFullAddress();
                              },);
                            },
                              child: Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              )
                          )
                      )
                  ),
                ),
              ),
              SellBookClassTextField(
                keyboardType: TextInputType.phone,
                hintText: "Enter Contact Number",
                title: 'Contact number',
                controller: controller.contactNumberController, // Pass controller
              ),
              SizedBox(height: 15),
              Obx(() => controller.uploading.value
                  ? Center(child: CircularProgressIndicator())
                  : Align(
                child: GestureDetector(
                  onTap: () {
                    // Call saveBook method to validate and store data
                    if(sellBook != null){
                      controller.uploading(true);
                      controller.updateBook(context,sellBook!);
                    }else{
                      controller.saveBook(context);
                    }
                  },
                  child: CustomCard(
                    alignment: Alignment.center,
                    borderRadius: 11,
                    width: double.infinity,
                    height: 57,
                    color: blackColor,
                    child: CustomText(text: sellBook != null ? "Update" : "Ok", fontWeight: FontWeight.w700, size: 16),
                  ),
                ),
              ),),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


class SellBookClassTextField extends StatelessWidget {
  final String hintText;
  final String title;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool isMultiline;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const SellBookClassTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    required this.title,
    this.isMultiline = false,
    this.contentPadding,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title,color: blackColor,fontWeight: FontWeight.w500,size: 14),
          SizedBox(height: 7),
          SizedBox(
            height: isMultiline ? 100 : 45,
            width: SizeConfig.screenWidth * 0.87,
            child: CustomTextFormField(
              controller: controller,
              maxLines: isMultiline ? null : 1,
              keyboardType: keyboardType,
              hintText: hintText,
              contentPadding: EdgeInsets.only(left: 14),
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
