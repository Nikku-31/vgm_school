import 'package:flutter/material.dart';
import '../../Model/FeesM/save_fee_model.dart';
import '../../Service/FeesS/save_fee_service.dart';

class SaveFeeViewModel extends ChangeNotifier {
  bool isSaving = false;

  Future<String?> postFee(SaveFeeRequest request) async {
    isSaving = true;
    notifyListeners();

    // Call service and get the URL
    String? redirectUrl = await SaveFeeService.saveFee(request);

    isSaving = false;
    notifyListeners();
    return redirectUrl;
  }
}