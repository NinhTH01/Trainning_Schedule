import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.event, required this.onTap});

  final Event event;
  final void Function({required bool isEdit, Event event}) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: ColorName.black),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('HH:mm').format(event.createdTime!),
              style: AppTextStyles.itemTimeStyle,
            ),
            Text(
              event.description!,
              style: AppTextStyles.itemDescriptionStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      onTap: () {
        onTap(isEdit: true, event: event);
      },
    );
  }
}
