import 'package:pencilo/controller/sell_book_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import '../../../controller/home_controller.dart';
import '../../../model/sell_book_model.dart';


class BuyBookView extends StatelessWidget {
  final SellBookModel book;
  BuyBookView({super.key, required this.book});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    startLocationStream();
    controller.getFullAddress();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            SellBookClassTextField(
              hintText: "Enter Your amount",
              title: 'Your amount',
              keyboardType: TextInputType.number,
              controller: controller.amountController, // Pass controller
            ),
            SellBookClassTextField(
              hintText: "Enter Your Address",
              title: 'Address',
              keyboardType: TextInputType.streetAddress,
              controller: controller.currentLocationController,
              isMultiline: true,
            ),
            SellBookClassTextField(
              keyboardType: TextInputType.phone,
              hintText: "Enter Contact Number",
              title: 'Contact number',
              controller: controller.contactNumberController, // Pass controller
            ),
            SizedBox(height: 15),
            Obx(() {
              controller.isSelectCashDelivery.value;
              return Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      onTap: (){
                        controller.isSelectCashDelivery.value = true;
                      },
                      border: Border.all(color: grayColor),
                      alignment: Alignment.center,
                      height: 70,
                      borderRadius: 6,
                      color: controller.isSelectCashDelivery.value ? blackColor : whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomCard(
                                  borderRadius: 100,
                                  color: whiteColor,
                                  border: Border.all(color: controller.isSelectCashDelivery.value ? blackColor : grayColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      backgroundColor: controller.isSelectCashDelivery.value ? blackColor : whiteColor,
                                      radius: 4,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                CustomText(
                                    text: "Cash on Delivery",
                                    fontWeight: FontWeight.w700,
                                    size: 12,
                                    color: controller.isSelectCashDelivery.value ? whiteColor : blackColor,
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            CustomText(
                                text: "₹ 80",
                                fontWeight: FontWeight.w700,
                                size: 15,
                                color: controller.isSelectCashDelivery.value ?  whiteColor : blackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: CustomCard(
                      onTap: (){
                        controller.isSelectCashDelivery.value = false;
                      },
                      alignment: Alignment.center,
                      height: 70,
                      borderRadius: 6,
                      border: Border.all(color: grayColor),
                      color: !controller.isSelectCashDelivery.value ? blackColor : whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomCard(
                                  borderRadius: 100,
                                  color: whiteColor,
                                  border: Border.all(color: !controller.isSelectCashDelivery.value ? blackColor : grayColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      backgroundColor: !controller.isSelectCashDelivery.value ? blackColor : whiteColor,
                                      radius: 4,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                CustomText(
                                  text: "Pay through Online",
                                  fontWeight: FontWeight.w700,
                                  size: 12,
                                  color: !controller.isSelectCashDelivery.value ? whiteColor : blackColor,
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              text: "₹ 80",
                              fontWeight: FontWeight.w700,
                              size: 15,
                              color: !controller.isSelectCashDelivery.value ?  whiteColor : blackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: SizeConfig.screenHeight * 0.2),
            Obx(() =>
            controller.uploading.value ? Center(
                child: CircularProgressIndicator()) : Align(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: GestureDetector(
                  onTap: () {
                    // Call saveBook method to validate and store data
                    // controller.saveBook(context);
                  },
                  child: CustomCard(
                    onTap: (){
                      controller.uploading(true);
                      controller.buyMethod(book).then((value) => controller.uploading(false),);
                    },
                    alignment: Alignment.center,
                    borderRadius: 11,
                    width: double.infinity,
                    height: 57,
                    color: blackColor,
                    child: CustomText(text: "Done", fontWeight: FontWeight.w700, size: 14),
                  ),
                ),
              ),
            ),),
            SizedBox(height: 30),
          ],
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
      padding: const EdgeInsets.only(top: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title,
              color: blackColor,
              fontWeight: FontWeight.w500,
              size: 14),
          SizedBox(height: 7),
          SizedBox(
            height: isMultiline ? 100 : 45,
            width: double.infinity,
            child: TextField(
              controller: controller,
              maxLines: isMultiline ? null : 1,
              minLines: isMultiline ? 4 : 1,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: hintText,
                hintStyle: TextStyle(fontFamily: poppinsFontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
                contentPadding: contentPadding ??
                    EdgeInsets.only(left: 13, bottom: 2),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff4C4C4C), width: 0.1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff4C4C4C), width: 0.1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff4C4C4C), width: 0.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
