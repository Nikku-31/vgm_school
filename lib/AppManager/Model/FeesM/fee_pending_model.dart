class PendingModel {
  final String monthName;
  final int monthlyFee;

  PendingModel({
    required this.monthName,
    required this.monthlyFee,
  });

  factory PendingModel.fromJson(Map<String, dynamic> json) {

    int parseAmount(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return PendingModel(
      monthName: json["MonthName"]?.toString() ?? "",
      monthlyFee: parseAmount(json["MonthlyFee"]),
    );
  }
}