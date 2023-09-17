import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/location_cubit/location_cubit.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/location_model.dart';
import 'package:seda/src/presentation/views/ride_views/places_view.dart';

class RidesHomeRecentLocationView extends StatelessWidget {
  const RidesHomeRecentLocationView({
    Key? key,
    required this.onRecentLocationSelect,
  }) : super(key: key);

  final Function(LocationModel location) onRecentLocationSelect;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final recent = LocationCubit.get(context).recentLocations;
        return ListView.builder(
          itemCount: recent.length,
          itemBuilder: (context, position) {
            return PlaceView(
              onTap: () => onRecentLocationSelect(recent[position]),
              address: "${recent[position].address}",
              title: context.recentLocations,
            );
          },
        );
      },
    );
  }
}
