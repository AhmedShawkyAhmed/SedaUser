import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/location_model.dart';
import 'package:seda/src/data/models/reponse_models/favourite_locations_response.dart';
import 'package:seda/src/data/models/reponse_models/recent_palces_reponse.dart';
import 'package:seda/src/data/models/request_models/create_or_update_location_request.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  static LocationCubit get(BuildContext context) => BlocProvider.of(context);

  LocationModel? home;
  LocationModel? work;
  List<LocationModel> favouriteLocations = [];
  List<LocationModel> recentLocations = [];

  Future getFavouriteLocations({
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    const tag = 'getFavouriteLocations';
    try {
      emit(GetAllLocationsLoadingState());
      DioHelper.getData(
        url: EndPoints.epGetFav,
      ).then((value) {
        printWarning('$tag - response: ${value.data}');
        if (value.statusCode == 200) {
          final response = FavouriteLocationsResponse.fromJson(value.data);
          home = response.data?.home;
          work = response.data?.work;
          if (response.data != null && response.data?.fav != null) {
            favouriteLocations.clear();
            favouriteLocations.addAll(response.data!.fav!);
          }
          afterSuccess?.call();
          emit(GetAllLocationsSuccessState());
        } else {
          printError('$tag - response error: $value');
          afterError?.call();
          emit(GetAllLocationsProblemState());
        }
      });
    } on DioError catch (e) {
      printError('$tag - response error: ${e.response}');
      afterError?.call();
      emit(GetAllLocationsProblemState());
    } catch (e) {
      printError('$tag - unknown error: $e');
      afterError?.call();
      emit(GetAllLocationsFailureState());
    }
  }

  Future createOrUpdateLocation({
    required CreateOrUpdateLocationRequest createLocationRequest,
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    const tag = 'createOrUpdateLocation';
    final bool isUpdate = createLocationRequest.locationId != null;
    try {
      emit(
        isUpdate ? UpdateLocationLoadingState() : AddLocationLoadingState(),
      );
      DioHelper.postData(
        url: EndPoints.epAddLocation,
        body: createLocationRequest.toJson(),
      ).then((value) {
        printWarning('$tag - response: ${value.data}');
        if (value.statusCode == 200) {
          afterSuccess?.call();
          emit(
            isUpdate ? UpdateLocationSuccessState() : AddLocationSuccessState(),
          );
        } else {
          printError('$tag - response error: $value');
          afterError?.call();
          emit(
            isUpdate ? UpdateLocationProblemState() : AddLocationProblemState(),
          );
        }
      }).onError((error, stackTrace) {
        printError('$tag - response error: $error');
        afterError?.call();
        emit(
          isUpdate ? UpdateLocationProblemState() : AddLocationProblemState(),
        );
      });
    } on DioError catch (e) {
      printError('$tag - response error: ${e.response}');
      afterError?.call();
      emit(
        isUpdate ? UpdateLocationProblemState() : AddLocationProblemState(),
      );
    } catch (e) {
      printError('$tag - unknown error: $e');
      afterError?.call();
      emit(
        isUpdate ? UpdateLocationFailureState() : AddLocationFailureState(),
      );
    }
  }

  Future deleteLocation({
    required int id,
    Function()? afterSuccess,
    Function()? afterError,
  }) async {
    const tag = 'deleteLocation';
    try {
      emit(DeleteLocationLoadingState());
      DioHelper.deleteData(
        url: '${EndPoints.epAddLocation}/$id',
      ).then((value) {
        printWarning('$tag - response: ${value.data}');
        if (value.statusCode == 200) {
          afterSuccess?.call();
          if (id == home?.id) {
            home = null;
          } else if (id == work?.id) {
            work = null;
          } else {
            favouriteLocations.removeWhere(
              (element) => element.id?.toInt() == id,
            );
          }
          emit(DeleteLocationSuccessState());
        } else {
          printError('$tag - response error: $value');
          afterError?.call();
          emit(DeleteLocationProblemState());
        }
      });
    } on DioError catch (e) {
      printError('$tag - response error: ${e.response}');
      afterError?.call();
      emit(DeleteLocationProblemState());
    } catch (e) {
      printError('$tag - unknown error: $e');
      afterError?.call();
      emit(DeleteLocationFailureState());
    }
  }

  Future<void> getRecentLocations({
    Function()? afterSuccess,
    Function()? afterFail,
  }) async {
    const tag = 'getRecentLocations';
    emit(GetRecentLocationLoadingState());
    try {
      await DioHelper.getData(
        url: EndPoints.epGetLastLocation,
      ).then((value) {
        printResponse("getRecentLocations response: $value");
        final recentPlaces = RecentPlacesResponse.fromJson(value.data);
        if (recentPlaces.data?.lastLocations != null) {
          recentLocations.clear();
          recentLocations.addAll(recentPlaces.data!.lastLocations);
          recentLocations.removeWhere((element) => element.address == null);
        }
        afterSuccess?.call();
        emit(GetRecentLocationSuccessState());
      });
    } on DioError catch (dioError) {
      printError('$tag - response error: ${dioError.response}');
      afterFail?.call();
      emit(GetRecentLocationProblemState());
    } catch (error) {
      printError('$tag - unknown error: $error');
      afterFail?.call();
      emit(GetRecentLocationFailureState());
    }
  }
}
