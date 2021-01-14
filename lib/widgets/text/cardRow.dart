import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardRow extends StatelessWidget {
  final Widget leading;
  final Widget tailing;

  const CardRow({this.leading, this.tailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: leading),
          Expanded(flex: 2, child: tailing),
        ],
      ),
    );
  }
}

class MoneyPlate extends StatelessWidget {
  final double amount;
  final TextStyle style;
  MoneyPlate({this.amount, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      NumberFormat.currency(locale: 'ru', name: 'руб.').format(amount),
      style: style,
    );
  }
}

class QtyPlate extends StatelessWidget {
  final double qty;
  final TextStyle style;
  final f = NumberFormat("#,##");
  QtyPlate({this.qty, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      qty.toStringAsFixed(2),
      style: style,
    );
  }
}
