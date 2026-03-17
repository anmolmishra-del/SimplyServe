class TeaModel {
  final String name;
  final String type;
  final String description;
  final double rating;
  final int reviews;
  final String image;
  final List<String> ingredients;

  TeaModel({
    required this.name,
    required this.type,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.ingredients,
  });
}
