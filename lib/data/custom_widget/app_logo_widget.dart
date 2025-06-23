import '../consts/const_import.dart';
import '../consts/images.dart';

class AppLogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? imagePath;
  const AppLogoWidget({super.key, this.height, this.width, this.fit, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath ?? appLogo,
      height: height ?? 100,
      width: width ?? 100,
      fit: fit ?? BoxFit.contain,
    );
  }
}
