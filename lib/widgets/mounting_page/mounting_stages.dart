import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/models/stage.dart';
import 'package:service_app/widgets/mounting_page/mounting_stage.dart';

class MountingStages extends StatefulWidget {
  MountingStages({this.mounting, this.stages});

  final Mounting mounting;
  final List<Stage> stages;

  @override
  _MountingStagesState createState() => _MountingStagesState();
}

class _MountingStagesState extends State<MountingStages> {
  final MountingController mountingController = Get.find();
  List<Widget> cards = [];

  @override
  Widget build(BuildContext context) {
    cards.clear();

    widget.stages.forEach((stage) {
      var done = false;

      if (mountingController.mountingStages.length > 0)
        done = mountingController.mountingStages.firstWhere((mountingStage) =>
                mountingStage.stageId == stage.id &&
                mountingStage.result == MountingResult.Done) !=
            null;

      var textColor = done ? kFabAcceptColor : kFabNeutralColor;

      cards.add(
        GestureDetector(
          onTap: () => Get.to(
            MountStage(mounting: widget.mounting, stage: stage),
          ),
          child: Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stage.name, style: kCardTextStyle),
                  Spacer(),
                  Icon(
                    done ? Icons.check_box : Icons.check_box_outline_blank,
                    color: textColor,
                  ),
                  Text(
                    done ? 'Выполнен' : 'Не выполнен',
                    style: TextStyle(fontSize: 14.0, color: textColor),
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
