
// small models
class Product {
  final String name;
  final int price;
  final String image;
  Product({required this.name, required this.price, required this.image});

  // override equality so we can use this object as Map key
  @override
  bool operator ==(Object other) => identical(this, other) || other is Product && name == other.name && price == other.price && image == other.image;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ image.hashCode;
}

class OfferCardModel {
  final String title;
  final String image;
  OfferCardModel({required this.title, required this.image});
}
