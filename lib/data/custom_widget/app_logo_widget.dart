import '../consts/const_import.dart';
import '../consts/images.dart';

class AppLogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? fit;
  const AppLogoWidget({super.key, this.height, this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      appLogo,
      height: height ?? 100,
      width: width ?? 100,
      fit: fit ?? BoxFit.contain,
    );
  }
}
