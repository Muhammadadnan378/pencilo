import 'package:firebase_auth/firebase_auth.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/view/home.dart';

import 'data/custom_widget/custom_media_query.dart';

class PhoneOtpView extends StatefulWidget {
  final String otp;
  const PhoneOtpView({super.key, required this.otp});

  @override
  State<PhoneOtpView> createState() => _PhoneOtpViewState();
}

class _PhoneOtpViewState extends State<PhoneOtpView> {
  var otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Auth"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              CustomCard(

                onTap: ()async{
                  String OTP = otpController.text;

                  if(OTP.isEmpty){
                    Get.snackbar("Error", "Please enter your phone number");
                    return;
                  }else{
                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(smsCode: OTP, verificationId: widget.otp,);

                      await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                        Get.off(Home());
                      },);
                    } on FirebaseAuthException catch (e) {
                      Get.snackbar("Error", e.code.toString());
                      return;
                    }
                  }

                  Get.to(Home());
                },
                alignment: Alignment.center,
                borderRadius: 7,
                width: SizeConfig.screenWidth * 0.8,
                height: 42,
                color: const Color(0xff9AC3FF),
              )
            ]
        ),
      ),
    );
  }
}
