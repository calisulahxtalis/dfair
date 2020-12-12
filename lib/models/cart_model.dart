class CartProduct {
  final int id;
  final String name;
  final int price;
  final String color;
  final int quantity;
  final String size;
  final String image;

  CartProduct({
    this.id,
    this.name,
    this.price,
    this.color,
    this.image,
    this.quantity,
    this.size
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'color': color,
      'image': image,
      'quantity': quantity,
      'size': size
    };
  }
}
