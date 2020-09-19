import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final double price;

  CartItem({
    @required this.product,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total =0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    /*
     * When a product is already in the cart, we should only add +1 to que quantity.
     */
    if (_items.containsKey(product.id)) {
      /*
       * Map<>.update returns the existing entry of the item you are updating (existingItem)
       */
      _items.update(product.id, (existingItem) {
        return CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        );
      });
    } else {
      _items.putIfAbsent(
        product.id,
            () => CartItem(
          product: product,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
