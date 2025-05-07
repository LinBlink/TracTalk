import 'package:tractalk_flutter/constants.dart';

class UserModel {
  String uid;
  String name;
  String phoneNumber;
  String image;
  String token;
  String aboutMe;
  String lastSeen;
  String createdAt;
  bool isOnline;
  List<String> friendsUIDs;
  List<String> friendRequestsUIDs;
  List<String> blockedUIDs;
  List<String> sentFriendRequestsUIDs;

  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.token,
    required this.aboutMe,
    required this.lastSeen,
    required this.createdAt,
    required this.isOnline,
    required this.friendsUIDs,
    required this.friendRequestsUIDs,
    required this.blockedUIDs,
    required this.sentFriendRequestsUIDs,
  });

  // user model toMap
  Map<String, dynamic> toMap() {
    return {
      "uid":uid,
      "name":name,
      "phoneNumber":phoneNumber,
      "image":image,
      "token":token,
      "aboutMe":aboutMe,
      "lastSeen":lastSeen,
      "createdAt":createdAt,
      "isOnline":isOnline,
      "friendsUIDs":friendsUIDs,
      "friendRequestsUIDs":friendRequestsUIDs,
      "blockedUIDs":blockedUIDs,
      "sentFriendRequestsUIDs":sentFriendRequestsUIDs,
      
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
    : uid = map[Constants.uid] ?? '',
      name = map[Constants.name] ?? '',
      phoneNumber = map[Constants.phoneNumber] ?? '',
      image = map[Constants.image] ?? '',
      token = map[Constants.token] ?? '',
      aboutMe = map[Constants.aboutMe] ?? '',
      lastSeen = map[Constants.lastSeen] ?? '',
      createdAt = map[Constants.createdAt] ?? '',
      isOnline = map[Constants.isOnline] ?? false,
      friendsUIDs = List<String>.from(map[Constants.friendsUIDs] ?? []),
      friendRequestsUIDs = List<String>.from(map[Constants.friendRequestsUIDs] ?? []),
      blockedUIDs = List<String>.from(map[Constants.blockedUIDs] ?? []),
      sentFriendRequestsUIDs = List<String>.from(map[Constants.sentFriendRequestsUIDs] ?? []);
     
}
