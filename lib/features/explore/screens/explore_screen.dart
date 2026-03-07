import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/rental_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../widgets/category_chips.dart';
import '../widgets/rental_item_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? _selectedCategory;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = _selectedCategory != null
        ? ref.watch(rentalsByCategoryProvider(_selectedCategory!))
        : null;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items, concerts, artists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceLight,
              ),
            ),
          ),
          CategoryChips(
            selected: _selectedCategory,
            onSelected: (category) {
              setState(() => _selectedCategory = category);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedCategory == null
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, size: 64, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text(
                          'Select a category or search\nto find rentals',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : itemsAsync!.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            'No items found in this category',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return RentalItemCard(
                            item: item,
                            onTap: () => context.pushNamed(
                              'itemDetail',
                              pathParameters: {'id': item.id},
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const LoadingIndicator(),
                    error: (e, _) => Center(
                      child: Text('Error: $e',
                          style:
                              const TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
