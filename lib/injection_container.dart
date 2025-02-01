import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/features/cart/data/models/cart_item_model_adapter.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/features/home/data/datasources/home_local_datasource.dart';
import 'package:e_commerce/features/home/data/datasources/home_remote_datasource.dart';
import 'package:e_commerce/features/home/data/repositories/home_repository_impl.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';
import 'package:e_commerce/features/home/domain/usecases/get_categories.dart';
import 'package:e_commerce/features/home/domain/usecases/get_products.dart';
import 'package:e_commerce/features/home/domain/usecases/get_products_by_category.dart';
import 'package:e_commerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:e_commerce/features/cart/data/repositories/cart_repository_imp.dart';
import 'package:e_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Home
  // Bloc
  sl.registerFactory(
    () => HomeBloc(
      getProducts: sl(),
      getCategories: sl(),
      getProductsByCategory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(
      productsBox: sl<Box<dynamic>>(instanceName: 'products'),
      categoriesBox: sl<Box<dynamic>>(instanceName: 'categories'),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final dio = Dio();
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => Connectivity());

  // Cart Feature
  await _initCartFeature();

  // Hive
  await _initHive();
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register the CartItemModel adapter
  Hive.registerAdapter(CartItemModelAdapter());

  // Open boxes
  final productsBox = await Hive.openBox('products');
  final categoriesBox = await Hive.openBox('categories');
  final cartBox = await Hive.openBox<CartItemModel>('cart');

  sl.registerLazySingleton<Box<dynamic>>(() => productsBox,
      instanceName: 'products');
  sl.registerLazySingleton<Box<dynamic>>(() => categoriesBox,
      instanceName: 'categories');
  sl.registerLazySingleton<Box<CartItemModel>>(() => cartBox);
}

Future<void> _initCartFeature() async {
  // Cart Bloc
  sl.registerFactory<CartBloc>(() => CartBloc(repository: sl()));

  // Cart Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(cartBox: sl<Box<CartItemModel>>()),
  );
}
