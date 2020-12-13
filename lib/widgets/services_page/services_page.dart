import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:service_app/models/service-status.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/redux/root_reducer.dart';
import 'package:service_app/widgets/call_button/call_button.dart';
import 'package:service_app/widgets/service_page/service_page.dart';
import 'package:service_app/widgets/sync_button/sync_button.dart';

class ServicesPage extends StatelessWidget {
  bool _hideFinished = false;

  Widget _buildRow(BuildContext context, Service service) {
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
                  Text('${service.brandId}, ${service.number}', overflow: TextOverflow.ellipsis, maxLines: 1),
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
    return StoreConnector<AppState, List<Service>>(
      converter: (store) => store.state.servicesState.services,
      builder: (context, services) {
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
                        services.where((service) => this._hideFinished ? service.status != ServiceStatus.Finished.toString() : true).toList();

                    if (i >= filteredServices.length) {
                      return null;
                    }

                    return _buildRow(context, filteredServices[i]);
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
//                                  setState(() {
//                                    this._hideFinished = value;
//                                  })
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
