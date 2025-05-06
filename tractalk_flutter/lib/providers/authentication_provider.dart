import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:tractalk_flutter/models/user_model.dart';
import 'package:tractalk_flutter/utils/global_methods.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  String? _uid;
  String? _phoneNumber;
  UserModel? _userModel;

  bool get isLoading => _isLoading;
  bool get isSuccessful => _isSuccessful;
  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;
  UserModel? get userModel => _userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // sign in with phone number
  Future<void> signInWithPhoneNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              // User is signed in
              _uid = value.user!.uid;
              _phoneNumber = phoneNumber;
              _isSuccessful = true;
              _isLoading = false;
              notifyListeners();
            } else {
              // no such user
              _isLoading = false;
              _isSuccessful = false;
              notifyListeners();
            }
          });
          _isLoading = false;
          notifyListeners();
        },

        verificationFailed: (FirebaseAuthException e) {
          _isLoading = false;
          notifyListeners();

          showSnackBar(context, e.message!);
        },

        codeSent: (String verificationId, int? resendToken) async {
          _isLoading = false;
          notifyListeners();
          // navigate to the OTP screen
          print("code sent, navigating to OTP screen");

        },

        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
