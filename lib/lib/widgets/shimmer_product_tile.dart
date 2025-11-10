import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductTile extends StatelessWidget {
  const ShimmerProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(width: 86, height: 86, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(height: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(height: 14, color: Colors.white),
                    ),
                    const Spacer(),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(height: 14, width: 120, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
