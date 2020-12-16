import 'package:redux/redux.dart';
import 'package:service_app/models/account_info.dart';
import 'package:service_app/redux/account/actions.dart';

final accountReducer = combineReducers<AccountState>([
  TypedReducer<AccountState, SetAccountInfoAction>(_setAccountInfo),
]);

AccountState _setAccountInfo(AccountState state, SetAccountInfoAction action) {
  return state.copyWith(accountInfo: action.accountInfo);
}

class AccountState {
  final AccountInfo accountInfo;

  AccountState({this.accountInfo});

  AccountState copyWith({
    AccountInfo accountInfo
  }) {
    return AccountState(
      accountInfo: accountInfo ?? this.accountInfo,
    );
  }
}

