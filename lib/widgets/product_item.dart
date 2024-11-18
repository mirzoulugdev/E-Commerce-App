import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screens/product_details.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetails.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, pro, child) {
              return IconButton(
                onPressed: () {
                  product.toggleFavorite();
                },
                icon: Icon(
                    pro.isFavorite ? Icons.favorite : Icons.favorite_outline),
                iconSize: 25,
                color: Colors.teal,
              );
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCart(
                product.id,
                product.title,
                product.imageUrl,
                product.price,
              );
              // MaterialBanner -> Yuqoridan xabar berish uchun qo'llaniladi.

              // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              // ScaffoldMessenger.of(context).showMaterialBanner(
              //   MaterialBanner(
              //     backgroundColor: Colors.grey.shade800,
              //     content: Text(
              //       "Savatchaga qo'shildi!",
              //       style: TextStyle(
              //         color: Colors.white,
              //       ),
              //     ),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           ScaffoldMessenger.of(context)
              //               .hideCurrentMaterialBanner();
              //           cart.removeSingleItem(
              //             product.id,
              //             isCartButton: true,
              //           );
              //         },
              //         child: Text(
              //           "BEKOR QILISH",
              //         ),
              //       ),
              //     ],
              //   ),
              // );
              // Future.delayed(
              //   Duration(
              //     seconds: 2,
              //   ),
              // ).then(
              //   (value) =>
              //       ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              // );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: "BEKOR QILISH",
                    onPressed: () {
                      cart.removeSingleItem(product.id, isCartButton: true);
                    },
                  ),
                  content: const Text(
                    "Savatchaga qo'shildi! ",
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
