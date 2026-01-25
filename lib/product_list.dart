import 'package:cart/Api/api_model.dart';
import 'package:cart/Api/model.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Product List'),
        centerTitle: true,

        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: badges.Badge(
                badgeContent: Text('0', style: TextStyle(color: Colors.white)),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length > 10
                        ? 10
                        : snapshot.data!.length,
                    itemBuilder: (contex, index) {
                      final product = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            product.images[0],
                            width: MediaQuery.of(context).size.width * 0.3,

                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                          title: Text(product.title),
                          subtitle: Text("\$${product.price}"),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {},
                            child: Text("Add"),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
