import 'package:firebase_auth/firebase_auth.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/phone_otp_view.dart';
import 'package:pencilo/view/home.dart';

import 'data/custom_widget/custom_media_query.dart';

class PhoneAuthView extends StatelessWidget {
  PhoneAuthView({super.key});

  final TextEditingController phoneController = TextEditingController();

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
              controller: phoneController,
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
                String number = phoneController.text;

                if(number.isEmpty){
                  Get.snackbar("Error", "Please enter your phone number");
                  return;
                }else{
                  try{
                    await FirebaseAuth.instance.verifyPhoneNumber(
                        verificationCompleted: (credential){},
                        verificationFailed: (error){},
                        codeSent: (otp,token){
                          Get.to(PhoneOtpView(otp: otp));
                        },
                        codeAutoRetrievalTimeout: (otp){},phoneNumber: "+92$number"
                    );
                  }on FirebaseAuthException catch(e){
                    Get.snackbar("Error", e.code.toString());
                    return;
                  }
                }

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
