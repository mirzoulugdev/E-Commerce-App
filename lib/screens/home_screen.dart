import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../widgets/custom_cart.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';

enum FiltersOption {
  // ignore: constant_identifier_names
  All,
  // ignore: constant_identifier_names
  Favorites,
}

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mening Do'konim"),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  child: Text("Barchasi"),
                  value: FiltersOption.All,
                ),
                PopupMenuItem(
                  child: Text("Sevimlilar"),
                  value: FiltersOption.Favorites,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                child: child!,
                number: cart.itemsCount().toString(),
              );
            },
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                CartScreen.routeName,
              ),
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(
        _showOnlyFavorites,
      ),
    );
  }
}
