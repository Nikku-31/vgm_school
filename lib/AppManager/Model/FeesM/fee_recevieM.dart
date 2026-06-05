class FeeModel {
  final String name;
  final String className;
  final String section;
  final int rollNo;
  final int admNo;
  final String mobileNo;
  final String feeMonth;
  final int totalFee;
  final int paidAmount;
  final int discount;
  final int balance;
  final DateTime collectionDate;

  FeeModel({
    required this.name,
    required this.className,
    required this.section,
    required this.rollNo,
    required this.admNo,
    required this.mobileNo,
    required this.feeMonth,
    required this.totalFee,
    required this.paidAmount,
    required this.discount,
    required this.balance,
    required this.collectionDate,
  });

  static int _parseAmount(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      name: json["Name"] ?? "",
      className: json["Class"] ?? "",
      section: json["Section"] ?? "",
      rollNo: _parseAmount(json["Roll No"]),
      admNo: _parseAmount(json["Adm. No"]),
      mobileNo: json["Mobile No"] ?? "",
      feeMonth: json["Fee Month"] ?? "",
      totalFee: _parseAmount(json["Total Fee"]),
      paidAmount: _parseAmount(json["Paid Amount"]),
      discount: _parseAmount(json["Discount"]),
      balance: _parseAmount(json["Balance"]),
      collectionDate:
      DateTime.tryParse(json["Collection Date"] ?? "") ??
          DateTime.now(),
    );
  }
}