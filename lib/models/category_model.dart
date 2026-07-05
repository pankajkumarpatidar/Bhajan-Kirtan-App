class CategoryModel {

  final String id;

  final String name;

  final String nameHi;

  final String icon;

  final String color;

  final int order;

  final bool status;

  final String createdBy;

  const CategoryModel({

    required this.id,

    required this.name,

    required this.nameHi,

    required this.icon,

    required this.color,

    required this.order,

    required this.status,

    required this.createdBy,

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

      createdBy: data['createdBy'] ?? '',

    );

  }
  Map<String, dynamic> toMap() {

    return {

      'name': name,

      'name_hi': nameHi,

      'icon': icon,

      'color': color,

      'order': order,

      'status': status,

      'createdBy': createdBy,

    };

  }

  CategoryModel copyWith({

    String? id,

    String? name,

    String? nameHi,

    String? icon,

    String? color,

    int? order,

    bool? status,

    String? createdBy,

  }) {

    return CategoryModel(

      id: id ?? this.id,

      name: name ?? this.name,

      nameHi: nameHi ?? this.nameHi,

      icon: icon ?? this.icon,

      color: color ?? this.color,

      order: order ?? this.order,

      status: status ?? this.status,

      createdBy: createdBy ?? this.createdBy,

    );

  }

}