import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/FeesVM/fee_recevie_vm.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class DepositeScreen extends StatelessWidget {
  const DepositeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeeVM()..getFees(461),
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            AppStrings.get(context, 'deposit_fee'),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: SafeArea(
          child: Consumer<FeeVM>(
            builder: (context, vm, child) {

              if (vm.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (vm.fees.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.get(context, 'no_data'),
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }
              int totalFeeSum =
              vm.fees.fold(0, (sum, e) => sum + e.totalFee);

              int paidSum =
              vm.fees.fold(0, (sum, e) => sum + e.paidAmount);

              int balanceSum =
              vm.fees.fold(0, (sum, e) => sum + e.balance);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    /// ================= LIST =================
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.fees.length,
                        itemBuilder: (context, index) {

                          final f = vm.fees[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Row(
                              children: [

                                /// STATUS STRIP
                                Container(
                                  width: 6,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: f.balance == 0
                                        ? Colors.green
                                        : f.paidAmount == 0
                                        ? Colors.red
                                        : Colors.orange,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                ),

                                /// CONTENT
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        /// Month + Date
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              f.feeMonth,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              DateFormat("dd-MMM-yyyy")
                                                  .format(f.collectionDate),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        /// STATUS
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: f.balance == 0
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            f.balance == 0
                                                ? AppStrings.get(context, 'paid')
                                                : AppStrings.get(context, 'pending'),
                                            style: TextStyle(
                                              color: f.balance == 0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 14),

                                        /// AMOUNT ROW
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            _amountBox(
                                              context,
                                              AppStrings.get(context, 'total'),
                                              f.totalFee,
                                              Colors.black,
                                            ),
                                            _amountBox(
                                              context,
                                              AppStrings.get(context, 'paid'),
                                              f.paidAmount,
                                              Colors.green,
                                            ),
                                            _amountBox(
                                              context,
                                              AppStrings.get(context, 'balance'),
                                              f.balance,
                                              Colors.red,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    /// ================= SUMMARY =================
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _summaryRow(
                            context,
                            AppStrings.get(context, 'total_fee'),
                            totalFeeSum,
                          ),
                          const SizedBox(height: 6),
                          _summaryRow(
                            context,
                            AppStrings.get(context, 'total_paid'),
                            paidSum,
                          ),
                          const SizedBox(height: 6),
                          _summaryRow(
                            context,
                            AppStrings.get(context, 'total_balance'),
                            balanceSum,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ===== Amount Box =====
  Widget _amountBox(
      BuildContext context,
      String title,
      int amount,
      Color color,
      ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          "₹ $amount",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// ===== Summary Row =====
  Widget _summaryRow(
      BuildContext context,
      String title,
      int value,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        Text(
          "₹ $value",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}