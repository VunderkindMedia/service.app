import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/models/brand.dart';

class MountingListTile extends StatelessWidget {
  final MountingsController mountingsController = Get.find();
  final Mounting mounting;
  final Brand brand;

  MountingListTile({this.mounting, this.brand});

  Widget buildTitle(bool isSearching) {
    String mountingInterval =
        DateFormat.Hm().format(mounting.dateStart).toString();
    String mountingDate =
        DateFormat('dd.MM').format(mounting.dateStart).toString();

    Color brandColor = brand.bColor();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          ServiceState().getStateIcon(mounting.state, ServiceStatus.Start),
          color: brandColor,
        ),
        SizedBox(width: 5.0),
        Expanded(
            child: Text(
          '${mounting.number}',
          style: TextStyle(color: kTextLightColor),
          maxLines: 1,
        )),
        Spacer(),
        Text(
          '$mountingDate $mountingInterval',
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget buildSubtitle() {
    String outputAddress = mounting.getShortAddress();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            outputAddress,
            maxLines: 2,
            style: TextStyle(fontSize: 18.0, color: kTextLightColor),
          ),
          SizedBox(height: 6.0),
          Text(
            mounting.customer,
            style: TextStyle(fontSize: 16.0, color: kTextLightColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        isThreeLine: true,
        title: buildTitle(mountingsController.isSearching.value ||
            mountingsController.selectedDateStart.value !=
                mountingsController.selectedDateEnd.value),
        subtitle: buildSubtitle(),
      ),
      actions: [],
      secondaryActions: [
        IconSlideAction(
          caption: 'Позвонить',
          icon: Icons.call,
          onTap: () {
            mountingsController.callMethod(context, mounting.phone);
          },
        ),
        IconSlideAction(
          caption: 'Навигатор',
          icon: Icons.navigation,
          onTap: () {
            mountingsController.openNavigator(mounting);
          },
        ),
      ],
    );
  }
}
