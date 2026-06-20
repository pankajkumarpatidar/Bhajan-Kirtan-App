class CategoryModel {
  final String id;
  final String name;
  final String nameHi;
  final String icon;
  final String color;
  final int order;
  final bool status;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.icon,
    required this.color,
    required this.order,
    required this.status,
  });

  factory CategoryModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      nameHi: data['name_hi'] ?? '',
      icon: data['icon'] ?? '',
      color: data['color'] ?? '#FF9800',
      order: (data['order'] ?? 0) as int,
      status: data['status'] ?? true,
    );
  }
}