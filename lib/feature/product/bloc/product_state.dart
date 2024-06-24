// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

// class SuccessGetProduct extends ProductState {
// final  ProductModel productModel;
//   SuccessGetProduct({
//     required this.productModel,
//   });
// }
// class SuccessGetProduct extends ProductState {
//   List<ProductModel> productModel;
//   SuccessGetProduct({
//     required this.productModel,
//   });
// }

class SuccessGetProductofline extends ProductState {
  List<ProductModel> productModeloflin;
  SuccessGetProductofline({
    required this.productModeloflin,
  });
}

class SuccessGetProductoflinehive extends ProductState {
  List<ProductModel> productModeloflinhive;
  SuccessGetProductoflinehive({
    required this.productModeloflinhive,
  });
}

class ErrorToGetProoduct extends ProductState {}

class LoadingToGetProduct extends ProductState {}

@immutable
class SuccessGetProduct extends ProductState {
  final List<ProductModel> productModel;
  final bool hasReachedMax;

  SuccessGetProduct({
    required this.productModel,
    required this.hasReachedMax,
  });

  SuccessGetProduct copyWith({
    List<ProductModel>? productModel,
    bool? hasReachedMax,
  }) {
    return SuccessGetProduct(
      productModel: productModel ?? this.productModel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class SuccessGetProducthive extends ProductState {
  final List<ProductModel> productModel;

  SuccessGetProducthive({
    required this.productModel,
  });

  SuccessGetProducthive copyWith({
    List<ProductModel>? productModel,
    bool? hasReachedMax,
  }) {
    return SuccessGetProducthive(
      productModel: productModel ?? this.productModel,
    );
  }
}
