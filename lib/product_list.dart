import 'package:cart/Api/api_model.dart';
import 'package:cart/Api/model.dart';
import 'package:cart/cart_screen.dart';
import 'package:cart/db_helper.dart'; // Apna DBHelper import karo
import 'package:cart/shared_prefernce/shared.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart'; // Provider ka package

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ApiModel apiModel = ApiModel();
  late Future<List<Product>> futureList;

  @override
  void initState() {
    super.initState();
    futureList = apiModel.getuserApi();
  }

  @override
  Widget build(BuildContext context) {
    // DBHelper ka instance yahan le lo
    final dbHelper = DBHelper();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<CartProvider>(
                // <--- MAGIC START: Ye counter ko live rakhta hai
                builder: (context, value, child) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    child: badges.Badge(
                      badgeContent: Text(
                        value.counter
                            .toString(), // Ab ye Provider se real number uthayega
                        style: const TextStyle(color: Colors.white),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('API Error! Check internet.'),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length > 10
                        ? 10
                        : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            product.images[0],
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.title),
                          subtitle: Text("\$${product.price}"),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              // <--- ACTION: Button dabne par kya hoga? ---
                              final cart = Provider.of<CartProvider>(
                                context,
                                listen: false,
                              );

                              // 1. Database mein dalo
                              dbHelper
                                  .insert(product.toMap())
                                  .then((value) {
                                    // 2. Provider update karo
                                    cart.addCounter();
                                    cart.addTotalPrice(product.price);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Item Added to Cart'),
                                      ),
                                    );
                                  })
                                  .onError((error, stackTrace) {
                                    print("Error adding to DB: $error");
                                  });
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
