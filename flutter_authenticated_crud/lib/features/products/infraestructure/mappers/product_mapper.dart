import 'package:flutter_authenticated_crud/config/config.dart';
import 'package:flutter_authenticated_crud/features/auth/infraestructure/infraestructure.dart';
import 'package:flutter_authenticated_crud/features/products/domain/domain.dart';

class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: double.parse(json['price'].toString()),
    description: json['description'],
    slug: json['slug'],
    stock: json['stock'],
    sizes: List<String>.from(json['sizes'].map((size) => size)),
    gender: json['gender'],
    tags: List<String>.from(json['tags'].map((size) => size)),
    images: List<String>.from(
      json['images'].map(
        (image) =>
            image.startsWith('http')
                ? image
                : '${Environment.apiUrl}/files/product/$image',
      ),
    ),
    user: UserMapper.userjsonToEntity(json['user']),
  );
}
