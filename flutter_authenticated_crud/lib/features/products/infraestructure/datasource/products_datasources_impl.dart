import 'package:dio/dio.dart';
import 'package:flutter_authenticated_crud/config/config.dart';
import 'package:flutter_authenticated_crud/features/products/domain/domain.dart';
import 'package:flutter_authenticated_crud/features/products/infraestructure/mappers/product_mapper.dart';

class ProductsDatasourcesImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourcesImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductsById(String id) {
    // TODO: implement getProductsById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await dio.get<List>(
      '/products?limit=$limit&offset=$offset',
    );
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
