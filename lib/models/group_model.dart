class GroupModel {
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final String senderId;
  final List<String> membersUid;
  final DateTime timeSent;

  GroupModel({
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.senderId,
    required this.membersUid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'senderId': senderId,
      'membersUid': membersUid,
      'timeSent': timeSent
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      senderId: map['senderId'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
