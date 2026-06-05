import 'package:flutter/material.dart';
import '../../Model/FeesM/get_student_fee_model.dart';
import '../../Service/FeesS/get_student_fee_service.dart';

class StudentFeeViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<FeeData> feeList = [];
  double totalPayable = 0.0;
  int baseFeeYear = 0;
  bool isAlreadyPaid = false; // New flag for UI
  double previousBalance = 0.0;

  Future<void> getFees(int admissionNo, int month) async {
    isLoading = true;
    isAlreadyPaid = false;
    feeList = [];
    totalPayable = 0.0;
    previousBalance = 0.0;
    notifyListeners();
    try {
      final response = await StudentFeeService.fetchFees(admissionNo, month);
      baseFeeYear = response.feeYear as int;

      if (response.data.isNotEmpty && response.data[0].status == "ALREADY_PAID") {
        isAlreadyPaid = true;
      } else {
        feeList = response.data;
        if(feeList.isNotEmpty){
          previousBalance = feeList.first.previousBalance;
        }
        totalPayable = feeList.fold(0, (sum, item) => sum + (item.feeAmount ?? 0.0));
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}