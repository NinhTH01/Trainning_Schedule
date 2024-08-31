import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/data/models/storage/special_event/special_event.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class SpecialEventItem extends StatefulWidget {
  const SpecialEventItem({
    super.key,
    required this.event,
    required this.onTap,
    required this.isEditing,
  });

  final SpecialEvent event;
  final bool isEditing;

  final void Function({
    required bool isEdit,
    SpecialEvent event,
  }) onTap;

  @override
  State<SpecialEventItem> createState() => _SpecialEventItemState();
}

class _SpecialEventItemState extends State<SpecialEventItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.event.description!,
                      style: AppTextStyles.s14w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat(AppConstants.yyyyMMddhhmmFormat)
                            .format(widget.event.createdTime!),
                        style: AppTextStyles.s12w700,
                      ),
                      widget.isEditing
                          ? const Row(
                              children: [
                                Icon(
                                  Icons.menu,
                                  size: 20,
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        widget.onTap(isEdit: true, event: widget.event);
      },
    );
  }
}
