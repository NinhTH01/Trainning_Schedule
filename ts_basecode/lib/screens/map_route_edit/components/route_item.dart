import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class RouteItem extends StatelessWidget {
  const RouteItem({
    super.key,
    required this.name,
    required this.location,
    required this.isEditing,
  });

  final int name;
  final LatLng location;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: ColorName.grayFFFAFAFA,
          border: Border.all(width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "$name",
                style: AppTextStyles.s14w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 0.5,
              color: ColorName.black,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "(${location.latitude}, ${location.longitude})",
                style: AppTextStyles.s14w400,
              ),
            ),
            isEditing
                ? const Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(
                        Icons.menu,
                        size: 16,
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
