class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;

  UserModel(
      {required this.name,
      required this.phoneNumber,
      required this.groupId,
      required this.uid,
      required this.profilePic,
      required this.isOnline});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        groupId: List<String>.from(map['groupId']),
        uid: map['uid'] ?? '',
        profilePic: map['profilePic'] ?? '',
        isOnline: map['isOnline'] ?? '');
  }
}
