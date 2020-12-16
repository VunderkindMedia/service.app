import 'package:service_app/models/brand.dart';

class CatalogState {
  final List<Brand> brands;

  CatalogState({this.brands = const []});

  CatalogState copyWith({
    List<Brand> brands,
  }) {
    return CatalogState(
      brands: brands ?? this.brands,
    );
  }
}