import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/cards.dart';
import 'package:seda/src/presentation/widgets/toast.dart';

part 'cards_states.dart';

class CardCubit extends Cubit<CardsStates> {
  CardCubit() : super(CardsInit());

  static CardCubit get(context) => BlocProvider.of(context);

  Future saveCard({
    required String cardNumber,
    required String month,
    required String year,
    required String cvc,
    required VoidCallback afterSuccess,
    required VoidCallback error,
  }) async {
    emit(SaveCardLoading());
    try {
      await DioHelper.postData(url: EndPoints.epSaveCard, body: {
        "card_number": cardNumber,
        'card_expiration_month': month,
        'card_expiration_year': year,
        'card_security_code': cvc
      }).then((value) {
        printResponse(value.data.toString());
        showToast('Card Added Successfully');
        emit(SaveCardSuccess());
        afterSuccess();
      });
    } on DioError catch (dioError) {
      emit(SaveCardFailed());
      error();
      showToast(dioError.message.toString());
      printError("Dio ${dioError.toString()}");
      printError("Dio ${dioError.requestOptions.data}");
    } catch (err) {
      error();
      showToast('error has occurred');
      if (kDebugMode) {
        print(error);
      }
      emit(SaveCardFailed());
      printError("catch ${err.toString()}");
    }
  }

  Cards cards = Cards();

  Future<void> getCards({required VoidCallback afterSuccess}) async {
    emit(GetCardsLoading());
    try {
      await DioHelper.getData(
        url: EndPoints.epGetMyCard,
      ).then((value) {
        cards = Cards.fromJson({'cards': value.data['data'][0]});
        afterSuccess();
        emit(GetCardsSuccess());
      });
    } on DioError catch (dioError) {
      emit(GetCardsFailed());
      printError(dioError.toString());
      showToast(dioError.message);
    } catch (error) {
      emit(GetCardsFailed());
      printError(error.toString());
      showToast('error has occurred');
    }
  }
}
