import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:service_app/redux/services/actions.dart';

class SyncButton extends StatelessWidget {
  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy\nHH:mm:ss');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        return GestureDetector(
          onTap: viewModel.syncServices,
          child: Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Icon(Icons.sync, color: Colors.green, size: 24.0),
                ),
                Container(
                  child: Text(viewModel.isLoading
                      ? 'Данные обновляются...'
                      : viewModel.syncDate != null
                          ? 'Обновлено ${formattedDate(viewModel.syncDate)}'
                          : 'Синхроинзировать'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final bool isLoading;
  final DateTime syncDate;
  final Function() syncServices;

  _ViewModel({@required this.isLoading, @required this.syncDate, @required this.syncServices});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        isLoading: store.state.servicesState.isLoading,
        syncDate: store.state.servicesState.syncDate,
        syncServices: () {
          store.dispatch(syncServicesAction());
        });
  }
}
