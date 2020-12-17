import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/service-status.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:service_app/widgets/call_button/call_button.dart';
import 'package:service_app/widgets/service_page/service_page.dart';
import 'package:service_app/widgets/sync_button/sync_button.dart';

class ServicesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool _hideFinished = false;

  Widget _buildRow(BuildContext context, Service service, List<Brand> brands) {
    var brand = brands.firstWhere((brand) => brand.externalId == service.brandId, orElse: () => null)?.name ?? 'Неизвестный бренд';
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage(serviceId: service.id)));
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(margin: EdgeInsets.only(right: 8), child: FlutterLogo(size: 24.0)),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$brand, ${service.number}', overflow: TextOverflow.ellipsis, maxLines: 1),
                      Text(service.customer, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(service.comment),
                      SizedBox(height: 8),
                      Text(service.customerAddress),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: PhoneButton(phone: service.phone),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Заявки'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemBuilder: (context, i) {
                        final filteredServices =
                        viewModel.services.where((service) => this._hideFinished ? service.status != 'Завершен' : true).toList();

                        if (i >= filteredServices.length) {
                          return null;
                        }

                        return _buildRow(context, filteredServices[i], viewModel.brands);
                      },
                    )),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    children: [
                      Flexible(flex: 1, child: SyncButton()),
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                Text('Скрыть\nзаверешнные', style: TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Switch(
                                      value: this._hideFinished,
                                      onChanged: (value) => {
                                            setState(() {
                                              this._hideFinished = value;
                                            })
                                          }),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
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
  final List<Service> services;
  final List<Brand> brands;

  _ViewModel({@required this.services, @required this.brands});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        services: store.state.servicesState.services,
        brands: store.state.catalogState.brands);
  }
}