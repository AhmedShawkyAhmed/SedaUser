import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/presentation/widgets/toast.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  RateCubit() : super(RateInitial());

  static RateCubit get(context) => BlocProvider.of(context);

  Future addRate({
    required int rate,
    required String comment,
    required int driverId,
    required VoidCallback afterSuccess,
    required VoidCallback afterError,
  }) async {
    emit(AddRateLoading());
    try {
      await DioHelper.postData(
        url: EndPoints.epAddRate,
        body: {
          "rate": rate,
          "rateable_type": "User",
          "rateable_id": driverId,
          "comment": comment,
        },
      ).then((value) {
        printSuccess("AddRate Response: $value");
        showToast(value.data['message'].toString());
        afterSuccess();
        emit(AddRateSuccess());
      });
    } on DioError catch (dioError) {
      printError("AddRate Response Error: ${dioError.response}");
      afterError();
      emit(AddRateFail());
    } catch (error) {
      printError("AddRate Unknown Error: $error");
      afterError();
      emit(AddRateFail());
    }
  }
}
