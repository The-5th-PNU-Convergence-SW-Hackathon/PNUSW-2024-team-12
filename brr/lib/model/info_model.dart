class mypage_info {
  final String driver_name;
  final String car_num;
  final String car_model;
  final String id;

  mypage_info({required this.driver_name, required this.car_num, required this.car_model, required this.id});

  factory mypage_info.fromJson(Map<String, dynamic> json) {
    return mypage_info(
      driver_name: json['driver_name'] ?? '',
      car_num: json['car_num'] ?? '',
      car_model: json['car_model'] ?? '',
      id: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_name': driver_name,
      'car_num': car_num,
      'car_model': car_model,
      'id': id
    };
  }
}


class user_info{
  final String user_name;
  final String id;

  user_info({required this.user_name, required this.id});

  factory user_info.fromJson(Map<String, dynamic> json) {
    return user_info(
      user_name: json['user_name'] ?? '',
      id: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': user_name,
      'id': id
    };
  }
}