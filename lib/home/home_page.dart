import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nati_project/cart/controllers/cart_provider.dart';
import 'package:nati_project/categories_mngmt/category.dart';
import 'package:nati_project/categories_mngmt/controllers/category_provider.dart';
// import 'package:nati_project/home/controllers/products_provider.dart';

import '../cart/cart_page.dart';
import '../categories_mngmt/models/category_model.dart';
import '../product_mngt/screens/add_product_page.dart';
import '../product_mngt/screens/display_products_page.dart';
import '../search/product_search_delegate.dart';
import 'constants/colors.dart';
import 'model/product.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //final productsAsyc = ref.watch(productsProvider);
    final categoryAsync = ref.watch(categoriesProvider);
    //final totalPrices=ref.watch(priceProvider);

    return Scaffold(
      //backgroundColor: tdBGColor,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Categories",style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold),),
        //backgroundColor: tdBGColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryManagement(),
                  ));
            },
            icon: const Icon(Icons.access_alarm),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ProductSearch());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CartPage(),
              ));
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddProductPage(),
              ));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.white,//Color(0xFFFEF9EB),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categoryAsync.when(data: (categories) {
                      return Column(
                        children: categories
                            .map((category) => CategoryTile(
                                  category: category,
                                ))
                            .toList(),
                      );
                    }, error: (e, s) {
                      return Text("$e");
                    }, loading: () {
                      return const CircularProgressIndicator();
                    })
                  ],
                ),
                // child: Column(
                //   children: [
                //     searchBox(),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Center(
                //       child: productsAsyc.when(
                //         data: (products) {
                //           return Column(
                //             children: products
                //                 .map(
                //                   (e) => ProductTile(
                //                     product: e,
                //                   ),
                //                 )
                //                 .toList(),
                //           );
                //         },
                //         error: (error, stackTrace) => Text(error.toString()),
                //         loading: () => const CircularProgressIndicator(),
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
              width: 400,
              height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(product.image)),
            ),
            // child: Padding(
            //     padding: const EdgeInsets.all(0),
            //     child: Image.asset(
            //       product.image,
            //     )),
          ),
          Text(
            product.name,
            style: const TextStyle(fontSize: 16),
          ),
          ListTile(
            leading: Text(
                "${product.price}",
              style: const TextStyle(fontSize: 16),
            ),
            trailing:  IconButton(
              onPressed: () {
                ref.read(cartProvider.notifier).state.add(product);
                //final priceT=ref.read(priceProvider);
                ref.read(priceProvider.notifier).state += product.price;
                //print(ref.read(priceProvider.notifier).state);
              },
              icon: const Icon(Icons.add_shopping_cart_outlined,),
            ),

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
