import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:service_app/constants/app_colors.dart';

class FilterPanel extends StatefulWidget {
  final DateTime selectedDate;
  final PanelController controller;
  final Function onDateChange;
  final Function hideFilterButton;

  FilterPanel(
      {this.selectedDate,
      this.controller,
      this.onDateChange,
      this.hideFilterButton});

  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  DatePickerController _controller = DatePickerController();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(12.0),
      topRight: Radius.circular(12.0),
      bottomLeft: Radius.circular(12.0),
      bottomRight: Radius.circular(12.0),
    );

    return SlidingUpPanel(
      controller: widget.controller,
      minHeight: 0.0,
      maxHeight: 135.0,
      color: kMainColor,
      collapsed: Center(child: Icon(Icons.keyboard_arrow_up)),
      backdropOpacity: 0.0,
      panelSnapping: true,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      borderRadius: radius,
      boxShadow: [BoxShadow(blurRadius: 5.0, color: kMainColor)],
      panel: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DatePicker(
            DateTime.now().add(Duration(days: -2)),
            controller: _controller,
            initialSelectedDate: widget.selectedDate,
            onDateChange: (selectedDate) {
              widget.onDateChange(selectedDate);
            },
            selectionColor: kDarkMainColor,
            locale: 'ru_ru',
            daysCount: 7,
          ),
          StatusFilter(),
        ],
      ),
      onPanelClosed: () {
        widget.hideFilterButton();
      },
    );
  }
}

class StatusFilter extends StatefulWidget {
  @override
  State createState() => StatusFilterState();
}

class StatusFilterState extends State<StatusFilter> {
  final ServicesController servicesController = Get.find();

  final List<String> _cast = <String>[
    ServiceStatus.Start,
    ServiceStatus.Done,
    ServiceStatus.End,
    ServiceStatus.Refuse,
    ServiceStatus.DateSwap
  ];

  Iterable<Widget> get statusWidgets sync* {
    var filters = servicesController.statusFilters;

    for (final String stat in _cast) {
      bool selected = filters.contains(stat);

      yield Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: FilterChip(
            showCheckmark: false,
            avatar: CircleAvatar(
              backgroundColor: selected ? kDarkMainColor : kMainColor,
              child: Icon(ServiceStatus().getStatusIcon(stat),
                  color: Colors.white),
            ),
            label: Text(stat),
            elevation: 2.0,
            selected: selected,
            selectedColor: kDarkMainColor,
            backgroundColor: kMainColor,
            onSelected: (bool value) {
              setState(() {
                if (value) {
                  servicesController.statusFilters.add(stat);
                } else {
                  servicesController.statusFilters.removeWhere((String name) {
                    return name == stat;
                  });
                }
                servicesController.updateFilteredServices();
              });
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: statusWidgets.toList()),
    );
  }
}
