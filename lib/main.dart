import 'package:bloc_test_teasher4/core/model/Productmodel.dart';
import 'package:bloc_test_teasher4/feature/product/bloc/product_bloc.dart';
import 'package:bloc_test_teasher4/internetbloc/bloc/internet_bloc.dart';
import 'package:bloc_test_teasher4/internetbloc/bloc/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox<ProductModel>('products');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void dispose() {
    Hive.close();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InternetBloc(),
          ),
          BlocProvider(
            create: (context) => ProductBloc(),
          ),
        ],
        child: ProductPage(),
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _scrollController = ScrollController();
  final _scrollControllerofline = ScrollController();
  bool hasLoadedOfflineData = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollControllerofline.addListener(_onScrolloflin);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerofline.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final productBloc = context.read<ProductBloc>();
      if (productBloc.state is SuccessGetProduct &&
          !(productBloc.state as SuccessGetProduct).hasReachedMax) {
        productBloc.add(FetchMoreProducts());
      }
    }
  }

  void _onScrolloflin() {
    if (_scrollControllerofline.position.pixels ==
        _scrollControllerofline.position.maxScrollExtent) {
      final productBloc = context.read<ProductBloc>();
      if (productBloc.state is SuccessGetProductofline &&
          !hasLoadedOfflineData) {
        productBloc.add(GetProductoflinhive());
        hasLoadedOfflineData = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app post on/off internet'),
      ),
      body: BlocListener<InternetBloc, InternetState>(
        listener: (context, state) {
          if (state is Connected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You are connected to the internet'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ProductBloc>().add(GetProduct());
          } else if (state is NotConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You are not connected to the internet'),
                backgroundColor: Colors.red,
              ),
            );
            context.read<ProductBloc>().add(GetProductoflin());
          }
        },
        child: BlocBuilder<InternetBloc, InternetState>(
          builder: (context, internetState) {
            if (internetState is Connected) {
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is LoadingToGetProduct) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ErrorToGetProoduct) {
                    return Center(child: Text("Failed to load product"));
                  } else if (state is SuccessGetProduct) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.productModel.length
                          : state.productModel.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= state.productModel.length) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListTile(
                          title: Text(
                            state.productModel[index].title!,
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Text(state.productModel[index].body!),
                          trailing: Text(
                            state.productModel[index].userId.toString(),
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is LoadingToGetProduct) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ErrorToGetProoduct) {
                    return Center(child: Text("Failed to load product"));
                  } else if (state is SuccessGetProductofline) {
                    if (!hasLoadedOfflineData) {
                      context.read<ProductBloc>().add(GetProductoflinhive());
                      hasLoadedOfflineData = true;
                    }

                    return ListView.builder(
                      controller: _scrollControllerofline,
                      itemCount: state.productModeloflin.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            state.productModeloflin[index].title!,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          subtitle: Text(state.productModeloflin[index].body!),
                          trailing: Text(
                            state.productModeloflin[index].userId.toString(),
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
