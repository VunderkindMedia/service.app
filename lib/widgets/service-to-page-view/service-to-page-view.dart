import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/widgets/goods_page/goods_page.dart';

class ServiceTOPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton.icon(
              onPressed: () => Get.to(GoodsPage()),
              color: Colors.blue,
              textColor: Colors.white,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text('Подобрать'))
        ],
      ),
    );
  }
}
