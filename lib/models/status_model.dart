import 'dart:convert';

class Status {
  final String uid;
  final String userName;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;
  Status({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'userName': userName});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'photoUrl': photoUrl});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'profilePic': profilePic});
    result.addAll({'statusId': statusId});
    result.addAll({'whoCanSee': whoCanSee});

    return result;
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
