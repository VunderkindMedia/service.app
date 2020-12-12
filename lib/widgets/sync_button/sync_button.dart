import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SyncButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> {
  DateTime _currentDate = DateTime.now();
  bool _isLoading = false;

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy\nHH:mm:ss');
    return formatter.format(date);
  }

  void _handleTap() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _currentDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: Icon(Icons.sync, color: Colors.green, size: 24.0),
            ),
            Container(
              child: Text(this._isLoading ? 'Данные обновляются...' : 'Обновлено ${formattedDate(this._currentDate)}'),
            )
          ],
        ),
      ),
    );
  }
}
