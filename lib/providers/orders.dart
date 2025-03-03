import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> getOrdersFromFirebase() async {
    final url = Uri.parse(
        "https://fir-app07-4947e-default-rtdb.firebaseio.com/orders.json");

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) == null) {
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      List<Order> loadedOrder = [];
      data.forEach(
        (orderId, order) {
          loadedOrder.insert(
            0,
            Order(
              id: orderId,
              totalPrice: order['totalPrice'],
              date: DateTime.parse(order['date']),
              products: (order['products'] as List<dynamic>)
                  .map(
                    (product) => CartItem(
                      id: product['id'],
                      title: product['title'],
                      image: product['image'],
                      price: product['price'],
                      quantity: product['quantity'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _items = loadedOrder;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToOrders(List<CartItem> products, double totalPrice) async {
    final url = Uri.parse(
        'https://fir-app07-4947e-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "totalPrice": totalPrice,
            "date": DateTime.now().toIso8601String(),
            "products": products
                .map(
                  (product) => {
                    "id": product.id,
                    "title": product.title,
                    "quantity": product.quantity,
                    "price": product.price,
                    "image": product.image,
                  },
                )
                .toList(),
          },
        ),
      );

      _items.insert(
        0,
        Order(
            id: jsonDecode(response.body)["name"],
            totalPrice: totalPrice,
            date: DateTime.now(),
            products: products),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
