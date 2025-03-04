import 'package:flutter_authenticated_crud/features/auth/providers/auth_provider.dart';
import 'package:flutter_authenticated_crud/features/products/domain/domain.dart';
import 'package:flutter_authenticated_crud/features/products/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourcesImpl(accessToken: accessToken),
  );

  return productsRepository;
});
