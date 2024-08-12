import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader(
      {super.key,
      required this.title,
      required this.onBack,
      required this.onRightPressed});

  final String title;
  final void Function() onBack;
  final void Function() onRightPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            onBack();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        IconButton(
          onPressed: () {
            onRightPressed();
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
