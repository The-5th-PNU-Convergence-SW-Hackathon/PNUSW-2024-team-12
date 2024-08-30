class mypage_info {
  final String user_name;
  final String user_id;

  mypage_info({required this.user_name, required this.user_id});

  factory mypage_info.fromJson(Map<String, dynamic> json) {
    return mypage_info(
      user_name: json['user_name'] ?? '',
      user_id: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': user_name,
      'user_id': user_id,
    };
  }
}
