import '../consts/const_import.dart';
import '../consts/images.dart';

class AppCustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color bgColor;

  const AppCustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.bgColor = blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,

      alignment: Alignment.center,
      borderRadius: 11,
      width: double.infinity,
      height: 57,
      color: bgColor,
      boxShadow: [
        BoxShadow(
            color: grayColor,
            blurRadius: 5,
            offset: const Offset(0, 3))
      ],
      child: CustomText(
        text: text,
        fontWeight: FontWeight.w500,
        size: 15,
        fontFamily: poppinsFontFamily,
      ),
    );
  }
}
