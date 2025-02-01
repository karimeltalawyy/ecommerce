import 'package:e_commerce/features/home/presentation/widgets/category_list_shimmer.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_grid_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/widgets/shimmer_wrapper.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar Shimmer
                ShimmerWrapper(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Banner Shimmer
                ShimmerWrapper(
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Categories Shimmer
        const SliverToBoxAdapter(
          child: CategoryListShimmer(),
        ),
        // Products Grid Shimmer
        const SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: ProductGridShimmer(),
        ),
      ],
    );
  }
}
