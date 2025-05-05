import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts/colors.dart';
import 'custom_card.dart';
import 'custom_text_widget.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> subjects;
  final RxString selectedValue;
  final String dropdownTitle;
  final bool? isValidate;

  const CustomDropdown({super.key, required this.subjects, required this.selectedValue, required this.dropdownTitle, this.isValidate,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CustomCard(
        borderRadius: 5,
        height: 47,
        border: Border.all(color: isValidate == true ? Colors.red : blackColor),
        child: PopupMenuButton<String>(
          color: whiteColor,
          onSelected: (String value) {
            selectedValue.value = value;
          },
          itemBuilder: (BuildContext context) {
            return subjects.map((item) {
              return PopupMenuItem<String>(
                value: item,
                child: Column(
                  children: [
                    Text(item),
                    Divider(),
                  ],
                ),
              );
            }).toList();
          },
          child: Obx(() => Row(
            children: [
              const SizedBox(width: 9),
              Expanded(
                flex: 1,
                child: CustomText(
                  text: selectedValue.value.isEmpty
                      ? dropdownTitle
                      : selectedValue.value,
                  color: selectedValue.value.isNotEmpty ? blackColor : grayColor,
                  size: 16,
                  maxLines: 1,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
              const SizedBox(width: 5),
            ],
          )),
        ),
      ),
    );
  }
}
