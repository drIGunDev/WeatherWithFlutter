import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../services/location/types/location.dart';
import '../../app/themes.dart';
import '../../services/open_weather_service/di.dart';
import '../../services/open_weather_service/weather_service.dart';

class LocationRow extends StatelessWidget {
  final Location _location;

  const LocationRow({
    super.key,
    required this._location,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: BorderRadius.circular(AppSpacing.medium),
      child: Consumer(
        builder: (context, ref, _) {
          return InkWell(
            onTap: () {
              ref.read(appProvider.notifier).setLocation(_location);
              ref.read(meteoProvider.notifier).fetchForecast(
                MeteoFetchParameters(
                  location: _location,
                ),
              );
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(AppSpacing.medium),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.medium),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(AppSpacing.medium),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Row(
                  crossAxisAlignment: .center,
                  children: [
                    Icon(
                      Icons.place,
                      size: 22,
                      color: AppColors.iconsTint,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          _location.name,
                          style: TextStyle(fontSize: AppFontSizes.medium, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text('${_location.city}, ${_location.country}', style: TextStyle(fontSize: AppFontSizes.small)),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => {},
                      child: Text('selected', style: TextStyle(fontSize: AppFontSizes.small)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
