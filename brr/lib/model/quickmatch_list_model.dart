class QuickMatch {
  final int type;
  final String boardingTime;
  final String depart;
  final String dest;
  final int maxMember;

  QuickMatch({
    required this.type,
    required this.boardingTime,
    required this.depart,
    required this.dest,
    required this.maxMember,
  });

  factory QuickMatch.fromJson(Map<String, dynamic> json) {
    return QuickMatch(
      type: json['type'],
      boardingTime: json['boarding_time'],
      depart: json['depart'],
      dest: json['dest'],
      maxMember: json['max_member'],
    );
  }
}
