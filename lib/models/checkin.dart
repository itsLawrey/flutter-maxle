class CheckIn {
  final DateTime date;

  CheckIn({required this.date});

  Map<String, dynamic> toJson() => {'date': date.toIso8601String()};

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(date: DateTime.parse(json['date']));
  }
}
