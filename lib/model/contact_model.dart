class ContactModel {
  String? objectId;
  String? name;
  String? phone;
  String? email;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  ContactModel(
      {this.objectId,
      this.name,
      this.phone,
      this.email,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  ContactModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    imagePath = json['image_path'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['image_path'] = imagePath;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonSimplified() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['image_path'] = imagePath;
    return data;
  }
}
