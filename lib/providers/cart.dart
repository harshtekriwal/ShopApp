import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get getItems {
    return {..._items};
  }

  int getItemCount() {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId].quantity>1){
      _items.update(productId, (existingCartItem) => CartItem(id:existingCartItem.id,title: existingCartItem.title,price: existingCartItem.price,
      quantity: existingCartItem.quantity-1));
    }
    else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }
  void clear(){
    _items={};
    notifyListeners();
  }
}
