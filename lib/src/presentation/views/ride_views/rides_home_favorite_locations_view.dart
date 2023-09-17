import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/location_cubit/location_cubit.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/location_model.dart';
import 'package:seda/src/data/models/request_models/create_or_update_location_request.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/views/ride_views/select_location_view.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/ride_views/places_view.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class RidesHomeFavoriteLocationsView extends StatelessWidget {
  const RidesHomeFavoriteLocationsView({
    Key? key,
    required this.onFavLocationSelected,
  }) : super(key: key);

  final Function(LocationModel location) onFavLocationSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 100.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGrey : AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Container(
                    width: 15.w,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Text(
                  context.savedLocation,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: FavView(onFavLocationSelected: onFavLocationSelected),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const SelectLocationView();
                    },
                  ).then((value) {
                    if (value != null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoadingIndicator(),
                      );
                      final result = value as Map<String, dynamic>;
                      LocationCubit.get(context).createOrUpdateLocation(
                          createLocationRequest: CreateOrUpdateLocationRequest(
                            lat: result['lat'],
                            lon: result['lon'],
                            address: result['address'],
                            type: "fav",
                          ),
                          afterSuccess: () {
                            Navigator.pop(context);
                            LocationCubit.get(context).getFavouriteLocations();
                          },
                          afterError: () {
                            Navigator.pop(context);
                          });
                    }
                  });
                },
                splashColor: AppColors.midGreen,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(left: 25, bottom: 25),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                      color: AppColors.midGreen, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavView extends StatelessWidget {
  const FavView({
    super.key,
    required this.onFavLocationSelected,
  });

  final Function(LocationModel location) onFavLocationSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final favourite = LocationCubit.get(context).favouriteLocations;
        final home = LocationCubit.get(context).home;
        final work = LocationCubit.get(context).work;
        return ListView.builder(
          itemCount: favourite.length + 3,
          itemBuilder: (context, position) {
            if (position == 0) {
              return PlaceView(
                onDelete: home != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => const LoadingIndicator(),
                        );
                        LocationCubit.get(context).deleteLocation(
                          id: home.id!,
                          afterSuccess: () => Navigator.pop(context),
                          afterError: () => Navigator.pop(context),
                        );
                      }
                    : null,
                onUpdate: home != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SelectLocationView();
                          },
                        ).then((value) {
                          if (value != null) {
                            showDialog(
                                context: context,
                                builder: (context) => const LoadingIndicator());
                            final result = value as Map<String, dynamic>;
                            LocationCubit.get(context).createOrUpdateLocation(
                              createLocationRequest:
                                  CreateOrUpdateLocationRequest(
                                lat: result['lat'],
                                lon: result['lon'],
                                address: result['address'],
                                type: 'home',
                                locationId: home.id,
                              ),
                              afterSuccess: () => LocationCubit.get(context)
                                  .getFavouriteLocations(
                                afterSuccess: () => Navigator.pop(context),
                                afterError: () => Navigator.pop(context),
                              ),
                              afterError: () => Navigator.pop(context),
                            );
                          }
                        });
                      }
                    : null,
                onTap: () {
                  if (home == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const SelectLocationView();
                      },
                    ).then((value) {
                      if (value != null) {
                        showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator());
                        final result = value as Map<String, dynamic>;
                        LocationCubit.get(context).createOrUpdateLocation(
                          createLocationRequest: CreateOrUpdateLocationRequest(
                            lat: result['lat'],
                            lon: result['lon'],
                            address: result['address'],
                            type: 'home',
                          ),
                          afterSuccess: () =>
                              LocationCubit.get(context).getFavouriteLocations(
                            afterSuccess: () => Navigator.pop(context),
                            afterError: () => Navigator.pop(context),
                          ),
                          afterError: () => Navigator.pop(context),
                        );
                      }
                    });
                  } else {
                    onFavLocationSelected(home);
                  }
                },
                recent: false,
                icon: Icons.home_rounded,
                address: home != null ? home.address! : context.addLocation,
                title: context.home,
              );
            } else if (position == 1) {
              return PlaceView(
                onDelete: work != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => const LoadingIndicator(),
                        );
                        LocationCubit.get(context).deleteLocation(
                          id: work.id!,
                          afterSuccess: () => Navigator.pop(context),
                          afterError: () => Navigator.pop(context),
                        );
                      }
                    : null,
                onUpdate: work != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SelectLocationView();
                          },
                        ).then((value) {
                          if (value != null) {
                            showDialog(
                                context: context,
                                builder: (context) => const LoadingIndicator());
                            final result = value as Map<String, dynamic>;
                            LocationCubit.get(context).createOrUpdateLocation(
                              createLocationRequest:
                                  CreateOrUpdateLocationRequest(
                                lat: result['lat'],
                                lon: result['lon'],
                                address: result['address'],
                                type: 'work',
                                locationId: work.id,
                              ),
                              afterSuccess: () => LocationCubit.get(context)
                                  .getFavouriteLocations(
                                afterSuccess: () => Navigator.pop(context),
                                afterError: () => Navigator.pop(context),
                              ),
                              afterError: () => Navigator.pop(context),
                            );
                          }
                        });
                      }
                    : null,
                onTap: () {
                  if (work == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const SelectLocationView();
                      },
                    ).then((value) {
                      if (value != null) {
                        showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator());
                        final result = value as Map<String, dynamic>;
                        LocationCubit.get(context).createOrUpdateLocation(
                          createLocationRequest: CreateOrUpdateLocationRequest(
                            lat: result['lat'],
                            lon: result['lon'],
                            address: result['address'],
                            type: 'work',
                          ),
                          afterSuccess: () =>
                              LocationCubit.get(context).getFavouriteLocations(
                            afterSuccess: () => Navigator.pop(context),
                            afterError: () => Navigator.pop(context),
                          ),
                          afterError: () => Navigator.pop(context),
                        );
                      }
                    });
                  } else {
                    onFavLocationSelected(work);
                  }
                },
                recent: false,
                icon: Icons.work_rounded,
                address: work != null ? work.address! : context.addLocation,
                title: context.work,
              );
            } else if (position == 2) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultText(
                      text: context.favourite,
                      fontSize: 20,
                      textColor: Colors.blueGrey,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SelectLocationView();
                          },
                        ).then((value) {
                          if (value != null) {
                            showDialog(
                              context: context,
                              builder: (context) => const LoadingIndicator(),
                            );
                            final result = value as Map<String, dynamic>;
                            LocationCubit.get(context).createOrUpdateLocation(
                                createLocationRequest:
                                    CreateOrUpdateLocationRequest(
                                  lat: result['lat'],
                                  lon: result['lon'],
                                  address: result['address'],
                                  type: "fav",
                                ),
                                afterSuccess: () {
                                  Navigator.pop(context);
                                  LocationCubit.get(context)
                                      .getFavouriteLocations();
                                },
                                afterError: () {
                                  Navigator.pop(context);
                                });
                          }
                        });
                      },
                      child: DefaultText(
                        text: context.addOne,
                        fontSize: 18,
                        textColor: AppColors.green,
                      ),
                    ),
                  ],
                ),
              );
            }
            return PlaceView(
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (context) => const LoadingIndicator(),
                );
                LocationCubit.get(context).deleteLocation(
                  id: favourite[position - 3].id!.toInt(),
                  afterSuccess: () => Navigator.pop(context),
                  afterError: () => Navigator.pop(context),
                );
              },
              onUpdate: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const SelectLocationView();
                  },
                ).then((value) {
                  if (value != null) {
                    showDialog(
                        context: context,
                        builder: (context) => const LoadingIndicator());
                    final result = value as Map<String, dynamic>;
                    LocationCubit.get(context).createOrUpdateLocation(
                      createLocationRequest: CreateOrUpdateLocationRequest(
                        lat: result['lat'],
                        lon: result['lon'],
                        address: result['address'],
                        type: 'fav',
                        locationId: favourite[position - 3].id,
                      ),
                      afterSuccess: () =>
                          LocationCubit.get(context).getFavouriteLocations(
                        afterSuccess: () => Navigator.pop(context),
                        afterError: () => Navigator.pop(context),
                      ),
                      afterError: () => Navigator.pop(context),
                    );
                  }
                });
              },
              onTap: () {
                onFavLocationSelected(favourite[position - 3]);
              },
              recent: false,
              address: favourite[position - 3].address!,
              title: context.favoriteLocations,
            );
          },
        );
      },
    );
  }
}
