import 'package:e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:e_commerce/features/cart/data/models/cart_item_model_adapter.dart';
import 'package:e_commerce/features/cart/data/repositories/cart_repository_imp.dart';
import 'package:e_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:e_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await _initHive();
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Cart Feature
  await _initCartFeature();

  // Ensure CartBloc is registered
  sl.registerFactory<CartBloc>(
    () => CartBloc(repository: sl<CartRepository>()),
  );
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  // Register manual adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CartItemModelAdapter());
  }
}

Future<void> _initCartFeature() async {
  // Data Sources
  final cartBox = await Hive.openBox<CartItemModel>('cart_items');
  sl.registerLazySingleton<Box<CartItemModel>>(() => cartBox);

  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(cartBox: sl()),
  );
}
