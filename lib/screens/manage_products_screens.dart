import 'package:flutter/material.dart';
import 'package:my_store/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class ManageproductsScreens extends StatelessWidget {
  const ManageproductsScreens({super.key});

  static const routeName = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).getProductFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulotlarni Boshqarish"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: productProvider.list.length,
          itemBuilder: (ctx, i) {
            final product = productProvider.list[i];
            return ChangeNotifierProvider.value(
              value: product,
              child: const UserProductItem(),
            );
          },
        ),
      ),
    );
  }
}
