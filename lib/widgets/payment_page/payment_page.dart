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
        title: Text('Завершение работ'),
      ),
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Column(children: []),
            ]),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(null)),
    );
  }
}
