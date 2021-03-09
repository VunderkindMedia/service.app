import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/widgets/mounting_page/pages/mounting_stage.dart';

class MountingStages extends StatefulWidget {
  MountingStages({this.mounting});

  final Mounting mounting;

  @override
  _MountingStagesState createState() => _MountingStagesState();
}

class _MountingStagesState extends State<MountingStages> {
  final MountingController mountingController = Get.find();
  List<Widget> cards = [];

  @override
  Widget build(BuildContext context) {
    cards.clear();

    mountingController.mountingStages.forEach((stage) {
      var done = false;
      var cStage = mountingController.constructionStages
          .firstWhere((consStage) => consStage.id == stage.stageId);

      String actionDate =
          DateFormat('HH:mm:ss').format(stage.updatedAt).toString();

      if (stage.createdAt.difference(widget.mounting.dateStart).inDays > 0)
        actionDate = actionDate +
            DateFormat(' - dd.MM.yyyy').format(stage.updatedAt).toString();

      done = stage.result == StageResult.Done;

      var textColor = done ? kFabAcceptColor : kFabNeutralColor;

      cards.add(
        GestureDetector(
          onTap: () => Get.to(
            MountStage(
              mounting: widget.mounting,
              mountingStage: stage,
              stage: cStage,
            ),
          ),
          child: Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cStage.name, style: kCardTextStyle),
                  Spacer(),
                  Text(
                    done ? 'Завершен' : 'Не выполнен',
                    style: TextStyle(fontSize: 14.0, color: textColor),
                  ),
                  SizedBox(width: 6.0),
                  Icon(
                    done ? Icons.check_box : Icons.check_box_outline_blank,
                    color: textColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cards,
    );
  }
}
