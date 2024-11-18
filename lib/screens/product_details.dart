import 'package:flutter/material.dart';
import 'package:my_store/providers/cart.dart';
import 'package:my_store/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final productId = ModalRoute.of(context)!.settings.arguments;
    final product = Provider.of<Products>(context, listen: false)
        .findById(productId as String);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Narxi: ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                ),
                Text(
                  "\$${product.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (ctx, cart, child) {
                final isProductAdded = cart.items.containsKey(productId);
                if (isProductAdded) {
                  return ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed(
                      CartScreen.routeName,
                    ),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                      size: 18,
                    ),
                    label: const Text(
                      "SAVATCHAGA BORISH",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      elevation: 0,
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () => cart.addToCart(
                      productId,
                      product.title,
                      product.imageUrl,
                      product.price,
                    ),
                    // ignore: sort_child_properties_last
                    child: const Text(
                      "SAVATCHAGA QO'SHISH",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
