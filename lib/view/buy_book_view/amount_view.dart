import 'package:flutter/material.dart';

import '../../data/consts/const_import.dart';
import '../../data/consts/images.dart';
import '../../data/custom_widget/custom_media_query.dart';

class AmountView extends StatelessWidget {
  const AmountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
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
            AmountViewClassTextField(hintText: "", title: 'Your amount',),
            AmountViewClassTextField(hintText: "", title: 'Address',isMultiline: true,contentPadding: EdgeInsets.only(left: 15,top: 15),),
            AmountViewClassTextField(hintText: "", title: 'Contact number',),
            SizedBox(height: 20,),
            Align(
              child: CustomCard(
                alignment: Alignment.center,
                width: 81,
                height: 36,
                borderRadius: 6,
                color: blackColor,
                child: CustomText(text: "Ok",fontWeight: FontWeight.w700,size: 12,),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}


class AmountViewClassTextField extends StatelessWidget {
  final String hintText;
  final String title;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool isMultiline; // new parameter

  const AmountViewClassTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    required this.title,
    this.isMultiline = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title,color: blackColor,fontWeight: FontWeight.w500,size: 14,),
          SizedBox(height: 7,),
          SizedBox(
            height: isMultiline ? 100 : 42, // taller if multiline
            width: SizeConfig.screenHeight * 0.32,
            child: TextField(
              maxLines: isMultiline ? null : 1,
              minLines: isMultiline ? 4 : 1,
              decoration: InputDecoration(
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: TextStyle(fontFamily: poppinsFontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  contentPadding: contentPadding ?? EdgeInsets.only(left: 13, bottom: 2),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff4C4C4C),width: 0.1)
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff4C4C4C),width: 0.1)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff4C4C4C),width: 0.1)
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
