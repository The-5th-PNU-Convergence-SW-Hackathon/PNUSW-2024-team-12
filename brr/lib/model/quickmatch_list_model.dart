class QuickMatch {
  final String depart;
  final String dest;
  final int maxMember;
  final int currentMember;

  QuickMatch({
    required this.depart,
    required this.dest,
    required this.maxMember,
    required this.currentMember
  });

  factory QuickMatch.fromJson(Map<String, dynamic> json) {
    return QuickMatch(
      depart: json['depart'],
      dest: json['dest'],
      maxMember: json['max_member'],
      currentMember:  json['current_member']
    );
  }
}
