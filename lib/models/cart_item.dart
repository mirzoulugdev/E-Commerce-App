class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });
}
