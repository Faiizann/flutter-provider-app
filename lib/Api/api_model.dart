import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cart/Api/model.dart';

class ApiModel {
  Future<List<Product>> getuserApi() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products?categoryId='),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      
      return throw Exception('not valid');
    }
  }
}
