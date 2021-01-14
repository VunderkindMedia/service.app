import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/text/commentField.dart';

class ReschedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  final ServiceController serviceController = Get.find();
  DateTime _selectedDate = DateTime.now();
  TextEditingController _commentController = TextEditingController();

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

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
        title: Text('Перенос даты'),
      ),
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Card(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Дата переноса: '),
                        Container(
                          child: Text(formattedDate(_selectedDate)),
                          margin: EdgeInsets.only(right: 16),
                        ),
                        FlatButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text('Выбрать дату'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CommentField(controller: _commentController),
            ]),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(() async {
                if (_commentController.text.length > 0) {
                  serviceController.fabsState.value = FabsState.Main;
                  await serviceController.rescheduleService(
                      serviceController.service.value,
                      _selectedDate,
                      _commentController.text);
                } else {
                  await Get.defaultDialog(
                      title: 'Ошибка!',
                      middleText: 'Введите причину переноса заявки!');
                }
              })),
    );
  }
}
