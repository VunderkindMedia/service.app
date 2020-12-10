import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefusePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefusePageState();
}

class _RefusePageState extends State<RefusePage> {
  String _selectedValue = '';
  List<String> _reasons = ['Высокая цена', 'Не берет трубку', 'Отремонтировали сами', 'Ушел к конкуренту', 'Нет потребности'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Форма отказа'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Причина отказа', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  ...this._reasons.map((reason) => GestureDetector(
                        onTap: () {
                          setState(() {
                            this._selectedValue = reason;
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: reason,
                              groupValue: this._selectedValue,
                              onChanged: (String value) {
                                setState(() {
                                  this._selectedValue = value;
                                });
                              },
                            ),
                            Text(reason),
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  Text('Коментарий', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  TextField(
                    maxLines: null,
                    decoration: InputDecoration.collapsed(hintText: 'Пару слов о причине отказа'),
                  )
                ],
              ),
            )),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Потвредить'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
