import 'package:redux/redux.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/redux/catalog/reducer.dart';

final catalogReducer = combineReducers<CatalogState>([
  TypedReducer<CatalogState, SetBrandsAction>(_setBrandsAction)
]);

CatalogState _setBrandsAction(CatalogState state, SetBrandsAction action) {
  return state.copyWith(brands: action.brands);
}

class SetBrandsAction {
  final List<Brand> brands;

  SetBrandsAction(this.brands);

  @override
  String toString() {
    return 'SetBrandsAction{brands: $brands}';
  }
}