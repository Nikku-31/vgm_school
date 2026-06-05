class SaveFeeRequest {
  final int studentId;
  final String feeType;
  final int paymentMode;
  final double feePaid;
  final double balance;
  final double feePayable;
  final List<FeeDetailItem> feeDetails;
  final List<SelectedMonthItem> selectedMonths;

  SaveFeeRequest({
    required this.studentId,
    this.feeType = "1",
    this.paymentMode = 3,
    required this.feePaid,
    required this.balance,
    required this.feePayable,
    required this.feeDetails,
    required this.selectedMonths,
  });

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "feeType": feeType,
    "paymentMode": paymentMode,
    "feePaid": feePaid,
    "balance": balance,
    "feePayable": feePayable,
    "feeDetails": feeDetails.map((e) => e.toJson()).toList(),
    "selectedMonths": selectedMonths.map((e) => e.toJson()).toList(),
    "bankName": "", "branch": "", "chequeNo": "", "chequeAmt": 0,
    "chequeDate": DateTime.now().toIso8601String(),
    "created_by": 0, "discount": 0,
  };
}

class FeeDetailItem {
  final int feeHeadId;
  final double originalFee;
  final double actualFee;

  FeeDetailItem({required this.feeHeadId, required this.originalFee, required this.actualFee});

  Map<String, dynamic> toJson() => {
    "feeHeadId": feeHeadId,
    "originalFee": originalFee,
    "actualFee": actualFee,
    "discount": 0
  };
}
class SelectedMonthItem {
  final int feeMonth;
  final int feeYear;

  SelectedMonthItem({required this.feeMonth, required this.feeYear});

  Map<String, dynamic> toJson() => {"feeMonth": feeMonth, "feeYear": feeYear};
}