library better_date_picker;

import 'package:flutter/material.dart';

enum SelectionType { day, month, year }

class BetterDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final void Function(DateTime selectedDate) dateSelect;
  final SelectionType selectionType;
  const BetterDatePicker({
    super.key,
    required this.initialDate,
    required this.dateSelect,
    this.selectionType = SelectionType.day,
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.selectionType == SelectionType.day)
                WheelChooser(
                  controller: _dayController,
                  items: days,
                  itemCount: daysLength,
                ),
              if (widget.selectionType != SelectionType.year)
                WheelChooser(
                  controller: _monthController,
                  items: months,
                ),
              WheelChooser(
                controller: _yearController,
                items: years,
              ),
            ],
          ),
          IgnorePointer(
            child: Container(
              width: 500,
              height: 60,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class WheelChooser extends StatelessWidget {
  final FixedExtentScrollController controller;
  final List<int> items;
  final int? itemCount;
  const WheelChooser({
    super.key,
    required this.controller,
    required this.items,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount ?? items.length,
          builder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: Text(
                  items[index].toString(),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
