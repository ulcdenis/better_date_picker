import 'package:flutter/material.dart';

class BetterWheelChooser extends StatelessWidget {
  final FixedExtentScrollController controller;
  final List<int> items;
  final int? itemCount;
  final Color textColor;
  final Color selectedTextColor;
  const BetterWheelChooser({
    super.key,
    required this.controller,
    required this.items,
    this.itemCount,
    required this.textColor,
    required this.selectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount ?? items.length,
          builder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: Text(
                  items[index].toString(),
                  style: TextStyle(
                    fontSize: 40,
                    color: controller.selectedItem == index ? selectedTextColor : textColor, //textColor,
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
