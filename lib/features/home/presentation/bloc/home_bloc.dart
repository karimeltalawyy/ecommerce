import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/usecases/usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_categories.dart';
import 'package:e_commerce/features/home/domain/usecases/get_products.dart';
import 'package:e_commerce/features/home/domain/usecases/get_products_by_category.dart';
import 'package:e_commerce/features/home/presentation/bloc/events/home_event.dart';
import 'package:e_commerce/features/home/presentation/bloc/states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProducts getProducts;
  final GetCategories getCategories;
  final GetProductsByCategory getProductsByCategory;

  HomeBloc({
    required this.getProducts,
    required this.getCategories,
    required this.getProductsByCategory,
  }) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SelectCategory>(_onSelectCategory);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final categoriesResult = await getCategories(NoParams());

    await categoriesResult.fold(
      (failure) async {
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (categories) async {
        final productsResult = await getProducts(NoParams());

        productsResult.fold(
          (failure) {
            emit(state.copyWith(
              isLoading: false,
              error: failure.message,
              categories: categories,
            ));
          },
          (products) {
            emit(state.copyWith(
              isLoading: false,
              products: products,
              categories: categories,
            ));
          },
        );
      },
    );
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
      selectedCategory: event.category,
    ));

    final result = await getProductsByCategory(
      CategoryParams(category: event.category),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (products) {
        emit(state.copyWith(
          isLoading: false,
          products: products,
        ));
      },
    );
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    if (state.selectedCategory != null) {
      final result = await getProductsByCategory(
        CategoryParams(category: state.selectedCategory!),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (products) {
          emit(state.copyWith(
            isLoading: false,
            products: products,
          ));
        },
      );
    } else {
      final result = await getProducts(NoParams());

      result.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (products) {
          emit(state.copyWith(
            isLoading: false,
            products: products,
          ));
        },
      );
    }
  }
}
