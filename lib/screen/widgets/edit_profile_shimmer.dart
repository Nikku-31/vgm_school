import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image Circle Shimmer
            Container(
              height: 90,
              width: 90,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 30),

            // Mocking the TextFields
            _buildInputSkeleton(),
            _buildInputSkeleton(),
            _buildInputSkeleton(),
            _buildInputSkeleton(),

            // Row for Pickup/Drop
            Row(
              children: [
                Expanded(child: _buildInputSkeleton()),
                const SizedBox(width: 10),
                Expanded(child: _buildInputSkeleton()),
              ],
            ),

            _buildInputSkeleton(),
            _buildInputSkeleton(height: 80), // Address box

            const SizedBox(height: 20),
            const Divider(height: 40),

            // Parent Details Header
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 15,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInputSkeleton(),
            _buildInputSkeleton(),
            _buildInputSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSkeleton({double height = 55}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
        ),
        // Internal shimmering line to look like a label/text
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          height: 10,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}