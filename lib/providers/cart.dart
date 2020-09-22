import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/product.dart';
class CartItem {
  final Product product;
  int quantity;
  final double total;

  CartItem({
    @required this.product,
    @required this.quantity,
    @required this.total,
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
      total += cartItem.total * cartItem.quantity;
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
          total: existingItem.total * (existingItem.quantity + 1),
        );
      });
    } else {
      _items.putIfAbsent(
        product.id,
            () => CartItem(
          product: product,
              total: product.price,
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

  void removeSingleItem(Product product) {
    if(!_items.containsKey(product.id)) {
      return;
    } else {
      if(_items[product.id].quantity > 1) {
        _items[product.id].quantity = _items[product.id].quantity - 1;
      } else {
        removeItem(product.id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
