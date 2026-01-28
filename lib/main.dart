import 'package:cart/product_list.dart';
import 'package:cart/shared_prefernce/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// main.dart mein ye change karo
void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => CartProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const ProductListScreen(),
    );
  }
}
