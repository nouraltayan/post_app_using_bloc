import 'package:hive/hive.dart';

import '../model/handling.dart';
import '../model/Productmodel.dart';
import 'core_service.dart';

abstract class ProductService extends CoreService {
  String baseurl = "";

  Future<ResultModel> getProduct();
  ResultModel getProductoflin();
}

class ProductServiceImp extends ProductService {
  List<ProductModel>? productModel;
  List<ProductModel>? fiveProducts;

  @override
  Future<ResultModel> getProduct([int startIndex = 0, int limit = 21]) async {
    try {
      var response = await dio.get(
          "https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit");

      productModel = List.generate(
        response.data.length,
        (index) => ProductModel.fromMap(response.data[index]),
      );
      fiveProducts = productModel!.sublist(0, 5);
      addproductModel(productModel!);
      return ListOf(data: productModel!);
    } catch (e) {
      return ExceptionModel();
    }
  }

  @override
  ResultModel getProductoflin() {
    if (fiveProducts != null) {
      print("From Cache");

      return ListOf(data: fiveProducts!);
    } else {
      return ExceptionModel();
    }
  }

  ResultModel getProductoflinhive() {
    try {
      final box = Hive.box<ProductModel>('products');
      productModel = box.values.toList();
      if (productModel != null && productModel!.isNotEmpty) {
        print("From hive");
        return ListOf(data: productModel!);
      } else {
        print("No cached data available in hive");
        return ExceptionModel();
      }
    } catch (e) {
      print("Error accessing cached data: $e");
      return ExceptionModel();
    }
  }

  void addproductModel(List<ProductModel> product) {
    final box = Hive.box<ProductModel>('products');
    box.addAll(product);
  }
}
