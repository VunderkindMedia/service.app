import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_status.dart';

class GoodsList extends StatefulWidget {
  final String workType;
  final List<ServiceGood> goodsList;
  final Function onAdd;

  GoodsList({this.workType, this.goodsList, this.onAdd});

  @override
  _GoodsListState createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  final ServiceController serviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    var summ = 0.0;
    widget.goodsList.forEach((good) {
      summ = summ + good.price / 100 * good.qty / 100;
    });

    return Card(
      child: ExpansionTile(
        title: Text(
          'Услуги: ${widget.workType} (${widget.goodsList.length} шт)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${summ > 0 ? 'Итого: $summ' : ''}'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: widget.onAdd,
        ),
        onExpansionChanged: (expanded) {
          var sState = expanded &&
                  serviceController.service.value.status == ServiceStatus.Start
              ? FabsState.AddGood
              : FabsState.Main;
          serviceController.fabsState.value = sState;
          serviceController.workType.value = expanded ? widget.workType : '';
        },
        children: List.generate(widget.goodsList.length, (index) {
          ServiceGood serviceGood = widget.goodsList[index];

          return GoodListTile(serviceGood: serviceGood);
        }),
      ),
    );
  }
}

class GoodListTile extends StatelessWidget {
  final ServiceGood serviceGood;
  final ServiceController serviceController = Get.find();

  GoodListTile({@required this.serviceGood});

  @override
  Widget build(BuildContext context) {
    var good =
        serviceController.goods.firstWhere((g) => g.id == serviceGood.goodId);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Card(
        color: kGoodCardColor,
        child: ListTile(
          title: Text('${good.article} - ${good.name}'),
          isThreeLine: true,
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${serviceGood.construction.isNotEmpty ? 'Конструкция: ' + serviceGood.construction : ''}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Количество: ${serviceGood.qty / 100}'),
                  Text('Цена: ${serviceGood.price / 100}'),
                ],
              ),
            ],
          ),
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.redAccent,
          onTap: () async {
            await serviceController.deleteServiceGood(serviceGood);
          },
        )
      ],
    );
  }
}
