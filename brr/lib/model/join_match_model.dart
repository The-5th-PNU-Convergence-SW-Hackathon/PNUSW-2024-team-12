class JoinMatchModel {
  int id;
  String depart;
  String dest;
  int minMember;
  int currentMember;
  DateTime boardingTime;
  String createdBy;

  JoinMatchModel({
    required this.id,
    required this.depart,
    required this.dest,
    required this.minMember,
    required this.currentMember,
    required this.boardingTime,
    required this.createdBy,
  });

  factory JoinMatchModel.fromJson(Map<String, dynamic> json) {
    return JoinMatchModel(
      id: json['id'],
      depart: json['depart'],
      dest: json['dest'],
      minMember: json['min_member'],
      currentMember: json['current_member'],
      boardingTime: DateTime.parse(json['boarding_time']),
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'depart': depart,
      'dest': dest,
      'min_member': minMember,
      'current_member': currentMember,
      'boarding_time': boardingTime.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
