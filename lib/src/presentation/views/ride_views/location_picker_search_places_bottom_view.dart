import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/views/ride_views/places_view.dart';
import 'package:sizer/sizer.dart';

class LocationPickerSearchPlacesBottomView extends StatefulWidget {
  const LocationPickerSearchPlacesBottomView(
      {Key? key,
      required this.mapsPlaces,
      required this.predictions,
      required this.updateLocation})
      : super(key: key);
  final GoogleMapsPlaces mapsPlaces;
  final List<Prediction> predictions;
  final Function(
    double lat,
    double lon,
    String address,
  ) updateLocation;

  @override
  State<LocationPickerSearchPlacesBottomView> createState() =>
      _LocationPickerSearchPlacesBottomViewState();
}

class _LocationPickerSearchPlacesBottomViewState
    extends State<LocationPickerSearchPlacesBottomView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => PlaceView(
        onTap: () async {
          showDialog(
            context: context,
            builder: (_) => const LoadingIndicator(),
          );
          widget.mapsPlaces
              .getDetailsByPlaceId('${widget.predictions[index].placeId}')
              .then((value) {
            Navigator.pop(context);
            if (value.result.geometry != null &&
                value.result.adrAddress != null) {
              widget.updateLocation(
                value.result.geometry!.location.lat,
                value.result.geometry!.location.lng,
                value.result.formattedAddress!,
              );
            }
          });
        },
        address: '${widget.predictions[index].description}',
        title: widget.predictions[index].structuredFormatting!.mainText,
      ),
      separatorBuilder: (context, index) => SizedBox(
        height: 1.h,
      ),
      itemCount: widget.predictions.length,
    );
  }
}
