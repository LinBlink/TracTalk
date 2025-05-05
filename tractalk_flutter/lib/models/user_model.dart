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

  UserModel.fromMap(Map<String, dynamic> map)
    : uid = map['uid'],
      name = map['name'],
      phoneNumber = map['phoneNumber'],
      image = map['image'],
      token = map['token'],
      aboutMe = map['aboutMe'],
      lastSeen = map['lastSeen'],
      createdAt = map['createdAt'],
      isOnline = map['isOnline'],
      friendsUIDs = List<String>.from(map['friendsUIDs']),
      friendRequestsUIDs = List<String>.from(map['friendRequestsUIDs']),
      blockedUIDs = List<String>.from(map['blockedUIDs']),
      sentFriendRequestsUIDs = List<String>.from(map['sentFriendRequestsUIDs']);
}
