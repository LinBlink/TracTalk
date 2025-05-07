import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tractalk_flutter/constants.dart';
import 'package:tractalk_flutter/providers/authentication_provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  String? _optCode;


  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final verificationId = args[Constants.verificationId] as String;
    final phoneNumber = args[Constants.phoneNumber] as String;
    final authProvider = context.watch<AuthenticationProvider>();

    void verifyOTPCode({
      required String verificationId,
      required String smsCode,
    }) async {
      final authProvider = context.read<AuthenticationProvider>();
      authProvider.verifyOTPCode(
        verificationId: verificationId,
        smsCode: smsCode,
        context: context,
        onSuccess: () async {
          // 1. Check if the user exists in Firestore
          bool userExists = await authProvider.checkIfUserExists();

          // 2. If the user exists, navigate to the home screen
          //  - get user data from Firestore
          //  - save user info to provider / shared_prefereneces
          if (userExists) {
            await authProvider.getUserDataFromFireStore();
            await authProvider.saveUserDataToSharedPreferences();
            navigate(userExists: true);
          } else {
            navigate(userExists: false);
          }

          // 3. If the user does not exist, navigate to the user information screen

          Navigator.of(context).pushReplacementNamed('/home');
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Icon(
                  Icons.sms_outlined,
                  size: 70,
                  color: Colors.deepPurple,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'We have sent a code to your phone number',
                    // textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    phoneNumber,
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 68,
                child: Pinput(
                  length: 6,
                  controller: _otpController,
                  onCompleted: (value) {
                    setState(() {
                      _optCode = value;
                      print("Completed OTP Code: $_optCode");
                      verifyOTPCode(
                        verificationId: verificationId,
                        smsCode: "$_optCode",
                      );
                    });
                  },

                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                  ),

                  focusedPinTheme: PinTheme(
                    width: 61,
                    height: 61,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                  ),

                  submittedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),

              authProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),

              authProvider.isSuccessful
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 20),
              Text(
                'Didn\'t receive the code?',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO Handle resend OTP
                },
                child: Text(
                  'Resend Code',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Handle OTP verification
              //   },
              //   child: const Text('Verify Code'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void navigate({required bool userExists}) {
    if (userExists) {
      Navigator.pushReplacementNamed(context, Constants.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, Constants.userInformationScreen);
    }
  }
}
