import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/controllers/cart_provider.dart';
import 'package:nati_project/categories_mngmt/controllers/category_provider.dart';
import 'package:nati_project/home/controllers/products_provider.dart';

// import 'package:nati_project/home/controllers/products_provider.dart';

import '../cart/cart_page.dart';
import '../categories_mngmt/models/category_model.dart';
import '../product_mngt/screens/display_products_page.dart';
import '../search/product_search_delegate.dart';
import 'constants/colors.dart';
import 'model/product.dart';

final categoryDisplayProvider =
    StateProvider<Category>((ref) => Category(name: "All"));

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //final productsAsyc = ref.watch(productsProvider);
    final indexProvider = ref.watch(categoryDisplayProvider);

    log("$indexProvider");

    return Scaffold(
        //backgroundColor: Theme.of(context).primaryColor,
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "HOME",
            style: TextStyle(
                fontSize: 28.0, fontWeight: FontWeight.bold, color: tdBlack),
          ),
          //backgroundColor: tdBGColor,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ProductSearch());
              },
              icon: const Icon(
                Icons.search,
                color: tdBlack,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ));
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: tdBlack,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                //margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const CategoriesWidget(),
              ListProdInCategory(indexProvider),

              //ListProdInCategory(),
              //const CategoryList(category);
            ],
          ),
        ));
  }
}

final indexProvider = StateProvider((ref) => 0);

class CategoriesWidget extends ConsumerWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final categoryAsync = ref.watch(categoriesProvider);
    final selectedIndex = ref.watch(indexProvider);
    return categoryAsync.when(
      data: (categories) => SizedBox(
          height: 40,
          child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      //ref.watch(categoryDisplayProvider);
                      ref.read(categoryDisplayProvider.notifier).state =
                          categories[index];
                      ref.read(indexProvider.notifier).state = index;

                      //log("$index");
                      //log("it is working");
                      //CategoryList(categories[index]);
                      //print("$ref.read(categoryDisplayProvider.notifier).state");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => DisplayProductsPage(
                      //           categories[index].id, categories[index].name),
                      //     ));
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 10),

                      //color: Colors.grey,
                      decoration: BoxDecoration(
                        color: index == ref.read(indexProvider.notifier).state
                            ? Colors.black
                            : tdBGColor,
                        borderRadius: BorderRadius.circular(24),
                      ),

                      child: Center(
                        child: Text(
                          categories[index].name,
                          style: TextStyle(
                            fontSize: 20.0,
                            color:
                                index == ref.read(indexProvider.notifier).state
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ))),
      error: (error, stackTrace) => Text("$error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

// class CategoryList extends ConsumerWidget {
//   const CategoryList(this.index, {super.key});

//   final int index;

//   @override
//   Widget build(BuildContext context, ref) {
//     return Container(
//       color: Colors.blue,
//       height: 500,
//       child: Text($index),
//     );
//   }
// }

class ListProdInCategory extends ConsumerWidget {
  const ListProdInCategory(this.category, {super.key});

  final Category category;

  @override
  Widget build(BuildContext context, ref) {
    final productAsync = ref.watch(categoryProductsProvider(category.id));
    final productAll = ref.watch(productsProvider);
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.name == "All")
          productAll.when(
            data: (products) => SizedBox(
              height: 700,
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProductTile(product: products[index]);
                },

                // children: ListView.builder(
                //   scrollDirection: Axis.horizontal,
                //   itemCount: products.length,
                //   itemBuilder: (context, index) =>
                //       ProductTile(product: products[index]),
                // ),
              ),
            ),
            error: (error, stackTrace) => Text("$error"),
            loading: () => const CircularProgressIndicator(),
          ),
        //Text(category.name),
        productAsync.when(
          data: (products) => SizedBox(
            height: 700,
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return ProductTile(product: products[index]);
              },
            ),
          ),
          error: (error, stackTrace) => Text("$error"),
          loading: () => const CircularProgressIndicator(),
        )
      ],
    );
  }
}

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, ref) {
    final isFavorite = ref.watch(isSelectedAsFavouriteProvider(product.id));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: tdBGColor,
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          // const ListTile(
          //   trailing: IconButton(onPressed: null, icon: Icon(Icons.favorite)),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  // if product is in favorite list, remove it
                  // if product is not in favorite list, add it

                  // depending on the status of the list, determine wheither a product is part of the favorites or not

                  ref.read(favoritesProvider.notifier).handleFavSelect(product);
                },
                icon: isFavorite
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.red,
                      ),
              )
            ],
          ),
          Container(
            width: 200,
            height: 61,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(product.image)),
            ),
            // child: Padding(
            //     padding: const EdgeInsets.all(0),
            //     child: Image.asset(
            //       product.image,
            //     )),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "${product.price}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).state.add(product);
                  //final priceT=ref.read(priceProvider);
                  ref.read(priceProvider.notifier).state += product.price;
                  //print(ref.read(priceProvider.notifier).state);
                },
                icon: const Icon(
                  Icons.add_shopping_cart_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    //Padding(
    //   padding: const EdgeInsets.only(bottom: 4.0),
    //   child: ListTile(
    //     leading: Image.asset(product.image),
    //     title: Text(product.name),
    //     subtitle: Text(product.price.toString()),
    //     trailing: IconButton(
    //       onPressed: () {
    //         ref.read(cartProvider.notifier).state.add(product);
    //         //final priceT=ref.read(priceProvider);
    //         ref.read(priceProvider.notifier).state += product.price;
    //         //print(ref.read(priceProvider.notifier).state);
    //       },
    //       icon: const Icon(Icons.add),
    //     ),
    //     //tileColor: Theme.of(context).colorScheme.surfaceVariant,
    //   ),
    // );
  }
}

Widget searchBox() {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white70, borderRadius: BorderRadius.circular(20.0)),
    child: const TextField(
      onChanged: null,
      decoration: InputDecoration(
          hintText: "search",
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          border: InputBorder.none),
    ),
  );
}

class CategoryTile extends ConsumerWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/areki.jpeg")),
        title: Text(category.name),
        subtitle: const Text("This many ads available"),
        trailing: const Icon(Icons.navigate_next),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayProductsPage(category.id, category.name),
              ));
        },
        //IconButton(
        //   onPressed: () {//print(ref.read(priceProvider.notifier).state);
        //   },
      ),
      //tileColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}
