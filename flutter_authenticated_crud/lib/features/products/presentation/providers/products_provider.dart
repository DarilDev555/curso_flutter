import 'package:flutter_authenticated_crud/features/products/domain/domain.dart';
import 'package:flutter_authenticated_crud/features/products/presentation/providers/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//State Notifier Provider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);

    return ProductsNotifier(productsRepository: productsRepository);
  },
);

//Notifier

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
    : super(ProductsState()) {
    loadNextPage();
  }

  Future<bool> crearteOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final Product product = await productsRepository.createUpdateProduct(
        productLike,
      );

      final isProductInState = state.products.any(
        (element) => element.id == product.id,
      );

      if (!isProductInState) {
        state = state.copyWith(products: [...state.products, product]);
        return true;
      }

      state = state.copyWith(
        products:
            state.products
                .map(
                  (element) => (element.id == product.id) ? product : element,
                )
                .toList(),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
      limit: state.limit,
      offset: state.offset,
    );
    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      isLastPage: false,
      offset: state.offset + 1,
      products: [...state.products, ...products],
    );
  }
}

// State
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );
}
