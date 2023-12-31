import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/favourites_page.dart';
import 'package:nati_project/home/categories_page.dart';

import 'home_page.dart';
import 'menu_page.dart';

final pageIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class MainNav extends ConsumerWidget {
  const MainNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: IndexedStack(
        index: pageIndex,
        children: const [
          HomePage(),
          CategoriesPage(),
          MenuPage(),
          FavouritesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          ref.read(pageIndexProvider.notifier).update((_) => index);
        },
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
        ],
      ),
    );
  }
}
