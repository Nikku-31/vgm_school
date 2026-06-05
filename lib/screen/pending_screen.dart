import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/FeesVM/fee_pending_vm.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../core/constants/app_colors.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  //pdf save logic
  Future<void> generatePdf(PendingVM vm) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Pending Fees Report",
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ["Sr No", "Month", "Fees"],
            data: [
              ...List.generate(vm.pendingList.length, (i) {
                final p = vm.pendingList[i];
                return [
                  "${i + 1}",
                  p.monthName,
                  "Rs ${p.monthlyFee}"
                ];
              }),
              [
                "",
                "Total",
                "Rs ${vm.totalMonthlyFee}"
              ]
            ],
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/pending_fees.pdf");

    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);

    print("PDF Saved At: ${file.path}");
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PendingVM()..getPending(461),

      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F8),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Pending Fees",
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                color: AppColors.primary
            ),
          ),
        ),
        body: SafeArea(
          child: Consumer<PendingVM>(
            builder: (context, vm, child) {

              if (vm.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!vm.loading && vm.pendingList.isEmpty) {
                return const Center(
                  child: Text("No Pending Fees"),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    // Pending List
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.pendingList.length,
                        itemBuilder: (context, index) {
                          final p = vm.pendingList[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [

                                // Icon
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: AppColors.primary,
                                  ),
                                ),

                                const SizedBox(width: 15),

                                // Month Name
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.monthName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "Pending Fee",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Amount
                                Text(
                                  "₹ ${p.monthlyFee}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    //Total Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Pending",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "₹ ${vm.totalMonthlyFee}",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // PDF Button
                    ElevatedButton.icon(
                      onPressed: () => generatePdf(vm),
                      icon: const Icon(Icons.picture_as_pdf,
                      color: AppColors.background,),
                      label: const Text("Download PDF",
                      style: TextStyle(color:AppColors.background),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.9),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
}