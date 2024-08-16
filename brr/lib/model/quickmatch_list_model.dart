class QuickMatch {
  final String depart;
  final String dest;
  final int maxMember;
  final int currentMember;

  QuickMatch({
    required this.depart,
    required this.dest,
    required this.maxMember,
    required this.currentMember,
  });

  factory QuickMatch.fromJson(Map<String, dynamic> json) {
    return QuickMatch(
        depart: json['depart'] as String? ?? '출발지 정보 없음', // 기본값 설정
        dest: json['dest'] as String? ?? '도착지 정보 없음', // 기본값 설정
        maxMember: json['max_member'] ?? 0, // 기본값 설정
        currentMember: json['current_member'] ?? 0 // 기본값 설정
        );
  }
}
