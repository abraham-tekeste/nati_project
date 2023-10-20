import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/categories_mngmt/models/category_model.dart';

import '../../categories_mngmt/controllers/category_provider.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoriesProvider);

    return categoryAsync.when(
      data: (categories) {
        if (categories.indexWhere((c) => c.id == 'All') == -1) {
          categories.insert(0, Category(name: 'All', id: 'All'));
        }

        return SizedBox(
          height: 96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
                child: Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final category = categories[index];

                        final isSelected =
                            ref.watch(selectedCategoryProvider).id ==
                                category.id;

                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: FilterChip(
                            selected: isSelected,
                            onSelected: (value) {
                              ref
                                  .read(selectedCategoryProvider.notifier)
                                  .update((_) => category);
                            },
                            label: Text(category.name),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Text("$error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
