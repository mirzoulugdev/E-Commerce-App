import 'package:flutter/material.dart';
import 'package:my_store/screens/home_screen.dart';
import 'package:my_store/screens/manage_products_screens.dart';
import 'package:my_store/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Salom Do'stim"),
          ),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text("Bosh Sahifa"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreens.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Buyurtmalar"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Mahsulotlarni Boshqarish"),
            onTap: () => Navigator.of(context)
                .pushNamed(ManageproductsScreens.routeName),
          )
        ],
      ),
    );
  }
}
