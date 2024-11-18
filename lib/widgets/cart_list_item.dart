import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });

  void _notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ishonchingiz komilmi? "),
          content: const Text("Savatchadan bu mahsulotni o'chirilmoqda..."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Bekor Qilish",
                style: TextStyle(
                  color: Colors.black54,
                  
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeItem();
                Navigator.of(context).pop();
              },
              // ignore: sort_child_properties_last
              child: const Text(
                "O'chirish",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Slidable(
      key: ValueKey(productId),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          ElevatedButton(
            onPressed: () => _notifyUserAboutDelete(
              context,
              () => cart.removeItem(productId),
            ),
            // ignore: sort_child_properties_last
            child: const Text(
              "O'chirish",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.all(20),
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          subtitle: Text("Umumiy: \$${(price * quantity).toStringAsFixed(2)},"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => cart.removeSingleItem(productId),
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                splashRadius: 10,
              ),
              Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300),
                child: Text("$quantity"),
              ),
              IconButton(
                onPressed: () => cart.addToCart(
                  productId,
                  title,
                  imageUrl,
                  price,
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                splashRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
