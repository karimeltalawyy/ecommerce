import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class SelectCategory extends HomeEvent {
  final String category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}
