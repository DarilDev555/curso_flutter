import 'package:flutter_authenticated_crud/config/const/environment.dart';
import 'package:flutter_authenticated_crud/features/products/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../../shared/infraestructure/inputs/inputs.dart';
import '../../domain/entities/product.dart';

final productFromProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFromState, Product>((ref, product) {
      final createUpdateCallBack =
          // ref.watch(productsRepositoryProvider).createUpdateProduct;
          ref.watch(productsProvider.notifier).crearteOrUpdateProduct;

      return ProductFormNotifier(
        product: product,
        onSubmitCallBack: createUpdateCallBack,
      );
    });

class ProductFormNotifier extends StateNotifier<ProductFromState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
  onSubmitCallBack;

  ProductFormNotifier({this.onSubmitCallBack, required Product product})
    : super(
        ProductFromState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          sizes: product.sizes,
          gender: product.gender,
          stock: Stock.dirty(product.stock),
          description: product.description,
          tags: product.tags.join(', '),
          images: product.images,
        ),
      );

  Future<bool> onFormSumit() async {
    _touchEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallBack == null) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.stock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images':
          state.images
              .map(
                (image) => image.replaceAll(
                  '${Environment.apiUrl}/files/product/',
                  '',
                ),
              )
              .toList(),
    };

    try {
      return await onSubmitCallBack!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void updateProductImage(String path) {
    state = state.copyWith(images: [...state.images, path]);
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      stock: Stock.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value),
      ]),
    );
  }

  void onSizedChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class ProductFromState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFromState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.stock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFromState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFromState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    stock: stock ?? this.stock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );
}
