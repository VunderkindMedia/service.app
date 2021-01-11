import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ServiceController serviceController = Get.find();
  String _selectedValue = 'Наличные';
  List<String> _paymentOptions = ['Наличные', 'Безнал Сбербанк', 'Безнал ВТБ'];

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fabsState.value = FabsState.Main;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Форма оплаты'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Сумма ТО-1'), Text('12.00')],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Сумма ТО-2'), Text('0.00')],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 24, right: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ИТОГО',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, top: 8, right: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Сумма'),
                              Text('12.00',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 24, right: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ОПЛАТА',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Вариант'),
                              DropdownButton(
                                  value: _selectedValue,
                                  underline: Container(
                                    height: 0,
                                  ),
                                  items: _paymentOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectedValue = newValue;
                                    });
                                  })
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Сумма'), Text('12.00')],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(null)),
    );
  }
}
