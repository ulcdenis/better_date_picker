import 'package:better_date_picker/better_date_picker.dart';
import 'package:flutter/material.dart';

class BetterWheelChooser extends StatelessWidget {
  final FixedExtentScrollController controller;
  final List<int> items;
  final int? itemCount;
  final Color textColor;
  final Color selectedTextColor;
  final bool showWords;
  final List<String> words;
  final bool showDot;
  final SelectionType selectionType;
  final double size;
  const BetterWheelChooser({
    super.key,
    required this.controller,
    required this.items,
    this.itemCount,
    required this.textColor,
    required this.selectedTextColor,
    this.showWords = false,
    this.words = const [],
    required this.showDot,
    required this.selectionType,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    double getWidth() {
      if (selectionType == SelectionType.year) {
        return 100 * size;
      } else if (selectionType == SelectionType.month && showWords) {
        return 200 * size;
      } else {
        return 60 * size;
      }
    }

    String getText(int index) {
      if (showWords) {
        return words[index];
      } else if (selectionType != SelectionType.year && showDot) {
        return '${items[index]}.';
      } else {
        return items[index].toString();
      }
    }

    return SizedBox(
      width: getWidth(),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 55,
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
                  getText(index),
                  style: TextStyle(
                    fontSize: 40 * size,
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
