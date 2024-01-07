library better_date_picker;

import 'package:better_date_picker/better_wheel_chooser.dart';
import 'package:flutter/material.dart';

enum SelectionType { day, month, year }

class BetterDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final void Function(DateTime selectedDate) dateSelect;
  final SelectionType selectionType;
  final Color? textColor;
  final Color? selectedTextColor;
  final bool hideSelector;
  final Color? selectorColor;
  final BorderRadiusGeometry? selectorBorderRadius;
  final Border? selectorBorder;
  final double spaceBetween;
  const BetterDatePicker({
    super.key,
    required this.initialDate,
    required this.dateSelect,
    this.selectionType = SelectionType.day,
    this.textColor,
    this.selectedTextColor,
    this.hideSelector = false,
    this.selectorColor,
    this.selectorBorderRadius,
    this.selectorBorder,
    this.spaceBetween = 20,
  });

  @override
  State<BetterDatePicker> createState() => _BetterDatePickerState();
}

class _BetterDatePickerState extends State<BetterDatePicker> {
  late DateTime selectedDate;

  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  final List<int> days = const [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];
  final List<int> months = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> years = const [];

  final List<int> shortMonths = const [4, 6, 9, 11];

  int daysLength = 31;

  @override
  void initState() {
    super.initState();

    selectedDate = widget.initialDate;
    if (widget.selectionType == SelectionType.month) {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, 1);
    }
    if (widget.selectionType == SelectionType.year) {
      selectedDate = DateTime(selectedDate.year, 1, 1);
    }

    years = [for (var i = 1901; i <= 2099; i++) i];

    _dayController = FixedExtentScrollController(
      initialItem: days.indexWhere((element) => element == selectedDate.day),
    );
    _monthController = FixedExtentScrollController(
      initialItem: months.indexWhere((element) => element == selectedDate.month),
    );
    _yearController = FixedExtentScrollController(
      initialItem: years.indexWhere((element) => element == selectedDate.year),
    );

    _yearController.addListener(() {
      if (widget.selectionType == SelectionType.day) {
        setDayLength();
      }
      setDate();
    });
    _monthController.addListener(() {
      if (widget.selectionType == SelectionType.day) {
        setDayLength();
      }
      setDate();
    });
    _dayController.addListener(() {
      setDate();
    });

    setState(() {
      if (selectedDate.month == 2) {
        if (selectedDate.year % 4 == 0) {
          daysLength = 29;
        } else {
          daysLength = 28;
        }
      } else {
        if (shortMonths.contains(selectedDate.month)) {
          daysLength = 30;
        } else {
          daysLength = 31;
        }
      }
    });
  }

  void setDayLength() {
    setState(() {
      if (months[_monthController.selectedItem] == 2) {
        if (years[_yearController.selectedItem] % 4 == 0) {
          daysLength = 29;
        } else {
          daysLength = 28;
        }
      } else {
        if (shortMonths.contains(months[_monthController.selectedItem])) {
          daysLength = 30;
        } else {
          daysLength = 31;
        }
      }
    });
  }

  void setDate() {
    setState(() {
      if (widget.selectionType == SelectionType.year) {
        selectedDate = DateTime(
          years[_yearController.selectedItem],
        );
      } else if (widget.selectionType == SelectionType.month) {
        selectedDate = DateTime(
          years[_yearController.selectedItem],
          months[_monthController.selectedItem],
        );
      } else {
        selectedDate = DateTime(
          years[_yearController.selectedItem],
          months[_monthController.selectedItem],
          days[_dayController.selectedItem],
        );
      }
    });
    widget.dateSelect(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!widget.hideSelector)
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: widget.selectorColor ?? Colors.black.withOpacity(0.15),
                borderRadius: widget.selectorBorderRadius ?? BorderRadius.circular(10),
                border: widget.selectorBorder,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.selectionType == SelectionType.day)
                BetterWheelChooser(
                  controller: _dayController,
                  items: days,
                  itemCount: daysLength,
                  textColor: widget.textColor ?? Colors.black54,
                  selectedTextColor: widget.selectedTextColor ?? Colors.black,
                ),
              SizedBox(width: widget.spaceBetween),
              if (widget.selectionType != SelectionType.year)
                BetterWheelChooser(
                  controller: _monthController,
                  items: months,
                  textColor: widget.textColor ?? Colors.black54,
                  selectedTextColor: widget.selectedTextColor ?? Colors.black,
                ),
              SizedBox(width: widget.spaceBetween),
              BetterWheelChooser(
                controller: _yearController,
                items: years,
                textColor: widget.textColor ?? Colors.black54,
                selectedTextColor: widget.selectedTextColor ?? Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
