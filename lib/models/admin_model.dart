class AdminModel {
  final String uid;

  final String name;

  final String email;

  final String mobile;

  final String role;

  final bool status;

  final String createdBy;

  final DateTime? createdAt;

  final DateTime? lastLogin;

  final String photo;

  const AdminModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.lastLogin,
    required this.photo,
  });

  factory AdminModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return AdminModel(
      uid: id,
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      mobile: data["mobile"] ?? "",
      role: data["role"] ?? "admin",
      status: data["status"] ?? true,
      createdBy: data["createdBy"] ?? "",
      createdAt: data["createdAt"]?.toDate(),
      lastLogin: data["lastLogin"]?.toDate(),
      photo: data["photo"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "mobile": mobile,
      "role": role,
      "status": status,
      "createdBy": createdBy,
      "createdAt": createdAt,
      "lastLogin": lastLogin,
      "photo": photo,
    };
  }

  AdminModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? mobile,
    String? role,
    bool? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? photo,
  }) {
    return AdminModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      photo: photo ?? this.photo,
    );
  }
}