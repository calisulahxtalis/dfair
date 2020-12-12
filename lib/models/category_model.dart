class CategoryModel {
  String name;
  String image;
  int id;
  List products;

  CategoryModel({
    this.name,
    this.image,
    this.id,
    this.products
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      products: json['products']
    );
  }
}