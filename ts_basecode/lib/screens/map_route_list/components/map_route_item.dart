import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class MapRouteItem extends StatelessWidget {
  const MapRouteItem({
    super.key,
    required this.mapRoute,
    required this.onPress,
    required this.isEditing,
  });

  final MapRouteModel mapRoute;

  final VoidCallback onPress;

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorName.grayF2F6FA,
          border: Border.all(width: 0.5, color: ColorName.grayFFCCCCCC),
        ),
        child: InkWell(
          onTap: onPress,
          hoverColor: ColorName.transparent,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mapRoute.name!,
                      style: AppTextStyles.s14w600,
                    ),
                    Text(
                      mapRoute.description ?? '',
                      style: AppTextStyles.s16w400,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        mapRoute.markerLocations?.length.toString() ?? '0',
                        style: AppTextStyles.s14w400,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const Icon(
                      Icons.pin_drop_outlined,
                      size: 16,
                      color: ColorName.blue,
                    )
                  ],
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
      ),
    );
  }
}
