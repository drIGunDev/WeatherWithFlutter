import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/themes.dart';
import '../../services/location/types/location.dart';

class const LocationRow({
  super.key,
  required final Location? _location,
  final void Function()? _onDelete,
  final void Function()? _onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgSurface,
      borderRadius: BorderRadius.circular(AppSpacing.medium),
      child: Consumer(
        builder: (context, ref, _) {
          return InkWell(
            onTap: () {
              _onTap?.call();
            },
            borderRadius: BorderRadius.circular(AppSpacing.medium),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.medium),
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                border: _location?.isActive == true ? Border.all(color: Colors.red) : Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(AppSpacing.medium),
              ),
              child: Row(
                crossAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.place,
                    size: 22,
                    color: AppColors.iconsTint,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (_location != null) ...[
                          Text(
                            _location.name,
                            style: TextStyle(fontSize: AppFontSizes.medium, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_location.city}, ${_location.country}',
                            style: TextStyle(fontSize: AppFontSizes.small),
                          ),
                        ] else ...[
                          Text(
                            'Select location',
                            style: TextStyle(fontSize: AppFontSizes.medium, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_onDelete != null && _location != null) ...[
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete, size: 22, color: Colors.red[400]),
                      onPressed: () => _onDelete(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
