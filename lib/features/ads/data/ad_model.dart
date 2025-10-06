class CreateAdModel {
  final String title;
  final String description;
  final String imageUrl;
  final String status; // pending / approved

  CreateAdModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.status = 'pending',
  });
}
