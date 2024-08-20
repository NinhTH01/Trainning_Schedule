import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/screens/calendar/components/hollow.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    super.key,
    required this.event,
    required this.onTap,
  });

  final Event event;
  final void Function({
    required bool isEdit,
    Event event,
  }) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hollow(
              isStroke: DateTime.now().isBefore(event.createdTime!),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      event.description!,
                      style: AppTextStyles.s14w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    DateFormat(AppConstants.hhmmFormat)
                        .format(event.createdTime!),
                    style: AppTextStyles.s12w700,
                  ),
                ],
              ),
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
