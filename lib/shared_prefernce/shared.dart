import 'package:cart/Api/model.dart';
import 'package:cart/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Apna DBHelper import karna mat bhoolna!
// Apna Model bhi

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();

  late Future<List<Product>> _cart;
  Future<List<Product>> get cart => _cart;

  Future<List<Product>> getData() async {
    _cart = db.getCartList(); // DBHelper bhi Product return karega
    return _cart;
  }

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getprefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  // --- Counter Logic ---
  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    if (_counter > 0) {
      // Zero se neeche nahi jana chahiye!
      _counter--;
      _setPrefItems();
      notifyListeners();
    }
  }

  int getCounter() {
    _getprefItems();
    return _counter;
  }

  // --- NEW: Total Price Logic ---
  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    if (_totalPrice >= productPrice) {
      _totalPrice = _totalPrice - productPrice;
      _setPrefItems();
      notifyListeners();
    }
  }

  double getTotalPrice() {
    _getprefItems();
    return _totalPrice;
  }
}
