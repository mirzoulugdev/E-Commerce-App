import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();

  var _product = Product(
    id: "",
    title: "",
    description: "",
    imageUrl: "",
    price: 0.0,
  );

  var _hasImage = true;
  var _init = true;
  // ignore: unused_field
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        // ignore: no_leading_underscores_for_local_identifiers
        final _editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        _product = _editingProduct;
      }
    }
    _init = false;
  }

  // @override
  // // void dispose() {
  //   super.dispose();
  //   _priceFocus.dispose();
  // }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Rasm URL manzilini kiriting!"),
          content: Form(
            key: _imageForm,
            child: TextFormField(
              initialValue: _product.imageUrl,
              decoration: const InputDecoration(
                labelText: "Rasm URL",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos, Mahsulot linkini kiriting!";
                } else if (!value.startsWith("http")) {
                  return "Iltimos to'g'ri rasm URL ini kiriting!";
                }
                return null;
              },
              onSaved: (newValue) {
                _product = Product(
                  id: _product.id,
                  title: _product.title,
                  description: _product.description,
                  imageUrl: newValue!,
                  price: _product.price,
                  isFavorite: _product.isFavorite,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'BEKOR QILISH',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveImageForm,
              // ignore: sort_child_properties_last
              child: const Text(
                "SAQLASH",
                style: TextStyle(
                  color: Colors.white,
                  // fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveImageForm() {
    final isValid = _imageForm.currentState!.validate();
    if (isValid) {
      _imageForm.currentState!.save();
      setState(() {
        _hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imageUrl.isNotEmpty;
    });
    if (isValid && _hasImage) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("Xatolik"),
                content: const Text("Xatolik sodir bo'ldi!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("Yopish."),
                  ),
                ],
              );
            },
          );
        } finally {
          setState(
            () {
              _isLoading = false;
            },
          );
          Navigator.of(context).pop();
        }
      } else {
        Provider.of<Products>(context, listen: false).updateProduct(_product);
      }
      setState(
        () {
          _isLoading = false;
        },
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulot Qo'shish"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _product.title,
                        decoration: const InputDecoration(
                          labelText: "Nomi",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos, mahsulot nomini kiriting!";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: newValue!,
                            description: _product.description,
                            imageUrl: _product.imageUrl,
                            price: _product.price,
                            isFavorite: _product.isFavorite,
                          );
                        },
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocus);
                        // },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _product.price == 0
                            ? ""
                            : _product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          labelText: "Narxi",
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos, mahsulot narxini kiriting!";
                          } else if (double.tryParse(value) == null) {
                            return "Iltimos, to'g'ri narx kiriting";
                          } else if (double.parse(value) < 1) {
                            return "Mahsulot narxi 0 dan katta bo'lishi kerak";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: _product.description,
                            imageUrl: _product.imageUrl,
                            price: double.parse(newValue!),
                            isFavorite: _product.isFavorite,
                          );
                        },
                        // focusNode: _priceFocus,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _product.description,
                        decoration: const InputDecoration(
                          labelText: "Qo'shimcha ma'lumot",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos, mahsulot ta'rifini kiriting!";
                          } else if (value.length < 10) {
                            return "Mahsulot ta'rifini uzunroq kiriting!";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: newValue!,
                            imageUrl: _product.imageUrl,
                            price: _product.price,
                            isFavorite: _product.isFavorite,
                          );
                        },
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,

                        // focusNode: _priceFocus,
                      ),
                      const SizedBox(height: 10),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _hasImage ? Colors.grey : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: InkWell(
                          onTap: () => _showImageDialog(context),
                          splashColor: Colors.teal,
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 180,
                            child: _product.imageUrl.isEmpty
                                ? Text(
                                    "Asosiy rasm URL-ni kiriting!",
                                    style: TextStyle(
                                      color: _hasImage
                                          ? Colors.black
                                          : Theme.of(context).colorScheme.error,
                                    ),
                                  )
                                : Image.network(
                                    _product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
