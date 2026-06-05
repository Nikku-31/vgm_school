import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PendingShimmer extends StatelessWidget {
  const PendingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Dropdown Placeholder
                _buildInputLoading(height: 50),
                const SizedBox(height: 12),

                // 2. Admission & Date Row
                Row(
                  children: [
                    Expanded(child: _buildInputLoading(height: 45)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInputLoading(height: 45)),
                  ],
                ),
                const SizedBox(height: 20),

                // 3. Labels & Inputs
                _buildLabelText(width: 100),
                const SizedBox(height: 8),
                _buildInputLoading(height: 45),
                const SizedBox(height: 14),

                _buildLabelText(width: 120),
                const SizedBox(height: 8),
                _buildInputLoading(height: 45),
                const SizedBox(height: 14),

                // 4. Class & Section Grid
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelText(width: 60),
                          const SizedBox(height: 8),
                          _buildInputLoading(height: 45),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelText(width: 60),
                          const SizedBox(height: 8),
                          _buildInputLoading(height: 45),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 5. Fee Details Section
                _buildLabelText(width: 90, height: 16),
                const SizedBox(height: 12),
                Container(height: 35, width: double.infinity, color: Colors.white), // Header block
                const SizedBox(height: 10),

                // Fee Rows
                Column(
                  children: List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _buildLabelText(width: double.infinity)),
                        const SizedBox(width: 20),
                        Expanded(flex: 2, child: _buildLabelText(width: double.infinity)),
                        const SizedBox(width: 20),
                        Expanded(flex: 2, child: _buildLabelText(width: double.infinity)),
                      ],
                    ),
                  )),
                ),
                const SizedBox(height: 30),

                // 6. Bottom Payment Area
                _buildInputLoading(height: 50, width: 160),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 42,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Mimics a TextField input area
  Widget _buildInputLoading({required double height, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, // This is the 'baseColor' inside the shimmer
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Container(
        height: 10,
        width: width == double.infinity ? 100 : width * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Slightly darker to show as "text inside"
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Mimics a simple Text Label
  Widget _buildLabelText({required double width, double height = 12}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}