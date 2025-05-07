import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tractalk_flutter/constants.dart';
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

  // get the user data from firestore
  Future<void> getUserDataFromFireStore() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(Constants.usersCollection).doc(_uid).get();
    _userModel = UserModel.fromMap(
      documentSnapshot.data() as Map<String, dynamic>,
    );
  }

  // save user data to shared preferences
  Future<void> saveUserDataToSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      Constants.userModel,
      jsonEncode(_userModel!.toMap()),
    );
  }

  // get user data from shared preferences
  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userModelString = sharedPreferences.getString(Constants.userModel);
    _userModel = UserModel.fromMap(
      jsonDecode(userModelString!),
    );
    _uid = _userModel!.uid;
    notifyListeners();
  }

  // check if user exists in Firestore
  Future<bool> checkIfUserExists() async {
    try {
      DocumentSnapshot doc =
          await _firestore
              .collection(Constants.usersCollection)
              .doc(_uid)
              .get();
      if (doc.exists) {
        return true; // User exists
      } else {
        return false; // User does not exist
      }
    } catch (e) {
      print("Error checking user existence: $e");
      return false; // Error occurred, assume user does not exist
    }
  }

  Future<void> verifyOTPCode({
    required String verificationId,
    required String smsCode,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential).then((value) async {
        if (value.user != null) {
          // User is signed in
          _uid = value.user!.uid;
          _phoneNumber = value.user!.phoneNumber;
          _isSuccessful = true;
          _isLoading = false;
          notifyListeners();
          onSuccess();
        } else {
          // no such user
          _isLoading = false;
          _isSuccessful = false;
          notifyListeners();
        }
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, e.toString());
    }
  }

  // sign in with phone number
  Future<void> signInWithPhoneNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      // check if the phone number is valid
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        // if verification is successful, we will get credential info
        verificationCompleted: (PhoneAuthCredential credential) async {
          // then we will use this credential to sign in the user
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
          Navigator.of(context).pushNamed(
            Constants.otpScreen,
            arguments: {
              Constants.verificationId: verificationId,
              Constants.phoneNumber: phoneNumber,
            },
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
