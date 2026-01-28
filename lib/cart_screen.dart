import 'package:cart/shared_prefernce/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cart/db_helper.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final dbHelper = DBHelper();

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: cart.getData(), // Database se items nikaalo
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Your Cart is Empty'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(item.images[0], width: 50),
                        title: Text(item.title),
                        subtitle: Text("\$${item.price}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // 1. Database se delete karo
                            dbHelper.delete(item.id);
                            // 2. Provider se counter aur price kam karo
                            cart.removeCounter();
                            cart.removeTotalPrice(item.price);
                            // 3. Screen refresh karne ke liye dobara data mangwao
                            cart.getData();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // --- TOTAL PRICE SECTION ---
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${value.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
