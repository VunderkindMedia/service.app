import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/constants/app_colors.dart';

class MountingsFilter extends StatefulWidget {
  @override
  State createState() => MountingsFilterState();
}

class MountingsFilterState extends State<MountingsFilter> {
  final MountingsController mountingsController = Get.find();

  final List<String> _cast = <String>[
    ServiceStatus.Start,
    ServiceStatus.Done,
    ServiceStatus.End,
  ];

  Iterable<Widget> get statusWidgets sync* {
    var filters = mountingsController.statusFilters;

    for (final String stat in _cast) {
      bool selected = filters.contains(stat);

      yield FilterChip(
          showCheckmark: false,
          label: Text(stat),
          elevation: selected ? 0.0 : 2.0,
          selected: selected,
          selectedColor: kMainColor,
          backgroundColor: kBackgroundLight,
          tooltip: stat,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                mountingsController.statusFilters.add(stat);

                switch (stat) {
                  case ServiceStatus.Start:
                    mountingsController.statusFilters.add(ServiceState.New);
                    mountingsController.statusFilters.add(ServiceState.Updated);
                    mountingsController.statusFilters
                        .add(ServiceState.WorkInProgress);
                    break;
                  case ServiceStatus.Done:
                    mountingsController.statusFilters
                        .add(ServiceState.Exported);
                    mountingsController.statusFilters
                        .add(ServiceState.ExportError);
                    break;
                  case ServiceStatus.End:
                    mountingsController.statusFilters
                        .add(ServiceState.WorkFinished);
                    break;
                }
              } else {
                mountingsController.statusFilters.removeWhere((String name) {
                  return name == stat;
                });

                switch (stat) {
                  case ServiceStatus.Start:
                    mountingsController.statusFilters
                        .removeWhere((String name) {
                      return name == ServiceState.New;
                    });
                    mountingsController.statusFilters
                        .removeWhere((String name) {
                      return name == ServiceState.Updated;
                    });
                    mountingsController.statusFilters
                        .removeWhere((String name) {
                      return name == ServiceState.WorkInProgress;
                    });
                    break;
                  case ServiceStatus.Done:
                    mountingsController.statusFilters
                        .removeWhere((String name) {
                      return name == ServiceState.Exported;
                    });
                    mountingsController.statusFilters
                        .removeWhere((String name) {
                      return name == ServiceState.ExportError;
                    });
                    break;
                  case ServiceStatus.End:
                    mountingsController.statusFilters
                        .removeWhere((String name) {
                      return name == ServiceState.WorkFinished;
                    });
                    break;
                }
              }
              mountingsController.updateFilteredMountings();
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: statusWidgets.toList(),
    );
  }
}
