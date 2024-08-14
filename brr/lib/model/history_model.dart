class History {
  int id;
  String car_num;
  DateTime date;
  String boarding_time;
  String quit_time;
  String depart;
  String dest;
  int amount;

  History({
    required this.id,
    required this.car_num,
    required this.date,
    required this.boarding_time,
    required this.quit_time,
    required this.depart,
    required this.dest,
    required this.amount,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      car_num: json['car_num'],
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      boarding_time: json['boarding_time'],
      quit_time: json['quit_time'],
      depart: json['depart'],
      dest: json['dest'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_num': car_num,
      'date': date.toIso8601String(),
      'boarding_time': boarding_time,
      'quit_time': quit_time,
      'depart': depart,
      'dest': dest,
      'amount': amount,
    };
  }
}