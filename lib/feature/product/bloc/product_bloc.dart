import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/model/handling.dart';
import '../../../core/model/Productmodel.dart';
import '../../../core/service/product_service.dart';

part 'product_event.dart';
part 'product_state.dart';

ProductServiceImp service = ProductServiceImp();

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(LoadingToGetProduct()) {
    on<GetProduct>((event, emit) async {
      emit(LoadingToGetProduct());
      ResultModel result = await service.getProduct();
      if (result is ListOf<ProductModel>) {
        emit(
            SuccessGetProduct(productModel: result.data, hasReachedMax: false));
      } else {
        emit(ErrorToGetProoduct());
      }
    });

    on<GetProductoflin>((event, emit) {
      emit(LoadingToGetProduct());
      ResultModel result = service.getProductoflin();
      if (result is ListOf<ProductModel>) {
        emit(SuccessGetProductofline(
          productModeloflin: result.data,
        ));
      } else {
        emit(ErrorToGetProoduct());
      }
    });

    on<GetProductoflinhive>((event, emit) {
      if (state is SuccessGetProductofline) {
        final currentState = state as SuccessGetProductofline;
        final currentProducts = currentState.productModeloflin;

        ResultModel result = service.getProductoflinhive();
        if (result is ListOf<ProductModel>) {
          final newProducts = result.data;
          emit(SuccessGetProductofline(
            productModeloflin: currentProducts + newProducts,
          ));
        } else {
          emit(ErrorToGetProoduct());
        }
      }
    });
    on<FetchMoreProducts>((event, emit) async {
      if (state is SuccessGetProduct) {
        final currentState = state as SuccessGetProduct;
        if (currentState.hasReachedMax) return;

        final currentProducts = currentState.productModel;

        ResultModel result = await service.getProduct(currentProducts.length);
        if (result is ListOf<ProductModel>) {
          final newProducts = result.data;
          emit(newProducts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : SuccessGetProduct(
                  productModel: currentProducts + newProducts,
                  hasReachedMax: newProducts.length <= 20,
                ));
        } else {
          emit(ErrorToGetProoduct());
        }
      }
    });
  }
}
 
// false
