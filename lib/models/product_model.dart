class Product {
  String name;
  String image;
  String price;
  int id;
  int category;

  Product({
    this.name,
    this.price,
    this.image,
    this.id,
    this.category
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      category: json['category']
    );
  }
}