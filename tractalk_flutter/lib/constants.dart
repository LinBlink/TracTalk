class Constants {
  // Constatns for Screen Routes
  static const String loginScreen = '/loginScreen';
  static const String otpScreen = '/otpScreen';
  static const String userInformationScreen = '/userInformationScreen';
  static const String homeScreen = '/homeScreen';
  static const String chatScreen = '/chatScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String profileScreen = '/profileScreen';
  static const String searchScreen = '/searchScreen';
  static const String friendsScreen = '/friendsScreen';

  // Constants for Firebase Authentication
  static const String verificationId = 'verificationId';

  // Constants for Firestore Collections
  static const String usersCollection = 'users';

  static const String userModel = 'userModel';

  // Constants for UserModel fields
  static const String uid = '';
  static const String name = '';
  static const String phoneNumber = '';
  static const String image = '';
  static const String token = '';
  static const String aboutMe = '';
  static const String lastSeen = '';
  static const String createdAt = '';
  static const bool isOnline = false;
  static const List<String> friendsUIDs = [];
  static const List<String> friendRequestsUIDs = [];
  static const List<String> blockedUIDs = [];
  static const List<String> sentFriendRequestsUIDs = [];
}
