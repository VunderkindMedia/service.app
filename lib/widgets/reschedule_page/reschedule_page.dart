import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';

class ReschedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  final ServiceController serviceController = Get.find();
  DateTime _selectedDate = DateTime.now();

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
        title: Text('Форма переноса даты'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
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
                          )
                        ],
                      ),
                    ),
                    Text('Комментарий',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Пару слов о причине переноса'),
                    )
                  ],
                ),
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
