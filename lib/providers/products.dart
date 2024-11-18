import 'dart:convert';
import '../services/http_exception.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _list = [
    // Product(
    //   id: "p1",
    //   title: "MacBook Pro",
    //   description:
    //   "Ajoyib MacBook.  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    //   imageUrl:
    //   "https://images.unsplash.com/photo-1646718609370-490a5810e37d?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzl8fE1hY2Jvb2slMjBwcm8lMjBpbWFnZXN8ZW58MHx8MHx8fDA%3D",
    //   price: 920.0,
    // ),
    // Product(
    //   id: "p2",
    //   title: "iPhone 15 Pro",
    //   description: "Ajoyib iPhone 15 Pro ",
    //   imageUrl:
    //   "https://images.unsplash.com/photo-1702289613007-8b830e2520b0?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8aXBob25lJTIwMTUlMjBwcm98ZW58MHx8MHx8fDA%3D",
    //   price: 500.0,
    // ),
    // Product(
    //   id: "p3",
    //   title: "Smart Watch",
    //   description: "Ajoyib Smart Watch. Sizlar uchun juda qulay narxda!",
    //   imageUrl:
    //   "https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8U21hcnQlMjBXYXRjaHxlbnwwfHwwfHx8MA%3D%3D",
    //   price: 10.0,
    // ),
  ];

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> getProductFromFirebase() async {
    final url = Uri.parse(
        'https://fir-app07-4947e-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);

      final List<Product> loadedProduct = [];
      if (jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        data.forEach(
          (productId, productsData) {
            loadedProduct.insert(
              0,
              Product(
                  id: productId,
                  title: productsData["title"],
                  description: productsData['description'],
                  imageUrl: productsData['imageUrl'],
                  price: productsData['price'],
                  isFavorite: productsData["isFavorite"]),
            );
          },
        );
        _list = loadedProduct;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://fir-app07-4947e-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
        id: name,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _list.add(newProduct);
      notifyListeners();
    } catch (error) {
      // ignore: use_rethrow_when_possible
      throw error;
    }

    void updateProduct(Product updatedProduct) {
      final productIndex = _list.indexWhere(
        (product) => product.id == updatedProduct.id,
      );
      if (productIndex >= 0) {
        _list[productIndex] = updatedProduct;
        notifyListeners();
      }
    }

    Future<void> deleteProduct(String id) async {
      final url = Uri.parse(
          "https://fir-app07-4947e-default-rtdb.firebaseio.com/products/$id.json");

      try {
        var deletingProduct = _list.firstWhere((product) => product.id == id);
        final productIndex = _list.indexWhere((product) => product.id == id);
        _list.removeWhere((product) => product.id == id);
        notifyListeners();

        final response = await http.delete(url);
        print(response.statusCode);

        if (response.statusCode >= 400) {
          _list.insert(productIndex, deletingProduct);
          notifyListeners();
          throw HttpException("Kechirasiz, o'chirishda xatolik!");
        }
      } catch (e) {
        print("salom");
        rethrow;
      }
    }

    Product findById(String productId) {
      return _list.firstWhere(
        (product) => product.id == productId,
      );
    }
  }

  findById(String productId) {}

  void deleteProduct(String id) {}

  void updateProduct(Product product) {}
}
