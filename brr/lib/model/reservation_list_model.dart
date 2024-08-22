class ReservationMatch {
  final String depart;
  final String dest;
  final int maxMember;
  final int currentMember;
  final DateTime boardingTime;

  ReservationMatch({
    required this.depart,
    required this.dest,
    required this.maxMember,
    required this.currentMember,
    required this.boardingTime,
  });

  factory ReservationMatch.fromJson(Map<String, dynamic> json) {
    return ReservationMatch(
      depart: json['depart'] as String? ?? '출발지 정보 없음',
      dest: json['dest'] as String? ?? '도착지 정보 없음',
      maxMember: json['max_member'] ?? 0,
      currentMember: json['current_member'] ?? 0,
      boardingTime: DateTime.parse(json['boarding_time']),
    );
  }
}
