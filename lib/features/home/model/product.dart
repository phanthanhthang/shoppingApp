class Product {
  int? id;
  String? title;
  String? description;
  String? price;
  double count = 0;
  String? image;
  String? stock;
  String? uid;
  bool isOpen = false;
  double productPrice = 1;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.stock,
      this.image,
      this.uid});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id']),
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      uid: json['uid'] as String,
      //image: json['image'] as String,
    );
  }
}
