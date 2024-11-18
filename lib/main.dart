import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../screens/product_details.dart';
import '../styles/my_store_style.dart';
import '../screens/home_screen.dart';
import '../providers/orders.dart';
import '../screens/orders_screen.dart';
import '../screens/manage_products_screens.dart';
import '../screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';
import '../providers/auth.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  ThemeData theme = MyStoreStyle.theme;
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const AuthScreen(),
        routes: {
          HomeScreens.routeName: (ctx) => const HomeScreens(),
          ProductDetails.routeName: (ctx) => const ProductDetails(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          ManageproductsScreens.routeName: (ctx) =>
              const ManageproductsScreens(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}
