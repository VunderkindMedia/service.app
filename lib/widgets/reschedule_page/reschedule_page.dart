import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReschedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
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
                    Text('Коментарий', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration.collapsed(hintText: 'Пару слов о причине переноса'),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text('Перенести дату'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
