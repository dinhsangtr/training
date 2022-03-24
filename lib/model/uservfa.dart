class UserVfa {
  String userId;
  String vfaTitle;
  bool vfaStatus;
  String vfaEmail;
  String vfaJoinedDate;

  UserVfa.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        vfaTitle = json['vfaTitle'],
        vfaStatus = json['vfaStatus'],
        vfaEmail = json['vfaEmail'],
        vfaJoinedDate = json['vfaJoinedDate'];

  Map<String, dynamic> toJson() => {
        'id': userId,
        'vfaTitle': vfaTitle,
        'vfaStatus': vfaStatus,
        'vfaEmail': vfaEmail,
        'vfaJoinedDate': vfaJoinedDate
      };
}
