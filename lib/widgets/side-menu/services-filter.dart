import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/constants/app_colors.dart';

class ServicesFilter extends StatefulWidget {
  @override
  State createState() => ServicesFilterState();
}

class ServicesFilterState extends State<ServicesFilter> {
  final ServicesController servicesController = Get.find();

  final List<String> _cast = <String>[
    ServiceStatus.Start,
    ServiceStatus.Done,
    ServiceStatus.End,
  ];

  Iterable<Widget> get statusWidgets sync* {
    var filters = servicesController.statusFilters;

    for (final String stat in _cast) {
      bool selected = filters.contains(stat);

      yield FilterChip(
          showCheckmark: false,
          /* avatar: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: CircleAvatar(
              backgroundColor: selected ? kMainColor : kMainSecondColor,
              child: Icon(ServiceStatus().getStatusIcon(stat),
                  color: Colors.black),
              radius: 25.0,
            ),
          ), */
          label: Text(stat),
          elevation: selected ? 0.0 : 2.0,
          selected: selected,
          selectedColor: kMainColor,
          backgroundColor: kBackgroundLight,
          tooltip: stat,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                servicesController.statusFilters.add(stat);

                if (stat == ServiceStatus.Done) {
                  servicesController.statusFilters.add(ServiceStatus.Refuse);
                  servicesController.statusFilters.add(ServiceStatus.DateSwap);
                }
              } else {
                servicesController.statusFilters.removeWhere((String name) {
                  return name == stat;
                });

                if (stat == ServiceStatus.Done) {
                  servicesController.statusFilters.removeWhere((String name) {
                    return name == ServiceStatus.Refuse;
                  });
                  servicesController.statusFilters.removeWhere((String name) {
                    return name == ServiceStatus.DateSwap;
                  });
                }
              }
              servicesController.updateFilteredServices();
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
