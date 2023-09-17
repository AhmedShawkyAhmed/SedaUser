import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/message_model.dart';
import 'package:seda/src/data/models/reponse_models/chat_response.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  ChatRoom? room;
  List<MessageModel> allMessages = [];
  int? roomId;
  int? toUserId;

  updateChatList(MessageModel message) {
    allMessages.add(message);
    allMessages.sort((a, b) => a.id!.compareTo(b.id!));
    emit(MessagesSuccess());
  }

  Future getMessages({required int orderId}) async {
    printResponse("tye chat");
    printResponse(
        "token: ${CacheHelper.getDataFromSharedPreference(key: SharedPreferenceKeys.userToken)}");
    printResponse("order: $orderId");
    emit(MessagesLoading());
    try {
      final Map<String, dynamic> queryMap = {
        "order_id": orderId,
      };
      await DioHelper.getData(url: EndPoints.epGetMassages, query: queryMap)
          .then((value) {
        printSuccess("GetMassages Response: $value");
        ChatResponse messagesResponse = ChatResponse.fromJson(value.data);
        allMessages.clear();
        allMessages.addAll(messagesResponse.data!.massages!);
        room = messagesResponse.data;
        roomId = messagesResponse.data!.roomId!;
        toUserId = messagesResponse.data!.toUser!.id;
        emit(MessagesSuccess());
      });
    } on DioError catch (dioError) {
      printError(dioError.toString());
      printError("GetMassages Error Response: ${dioError.response}");
      emit(MessagesFail());
    } catch (error) {
      printError("GetMassages Unknown Error: $error");
      emit(MessagesFail());
    }
  }

  Future sendMessages({
    String? message,
    String? mediafile,
    String? fileType,
    String? type,
    required Function() afterSuccess,
  }) async {
    emit(MessagesLoading());
    try {
      var formData = {
        "room_id": roomId,
        "user_id": toUserId,
        "message": message,
        'media[filename]': mediafile != null
            ? await MultipartFile.fromFile(
                mediafile,
              )
            : null,
        'media[filetype]': fileType,
        'media[type]': type,
      };
      await DioHelper.postData(
        url: EndPoints.epSendMassages,
        body: formData,
        isForm: true,
      ).then((value) {
        printSuccess("SendMessage Response: $value");
        final newMessage = MessageModel.fromJson(value.data['data']["data"]);
        allMessages.add(newMessage);
        allMessages.sort((a,b) => a.id!.compareTo(b.id!));
        afterSuccess();
        emit(MessagesSuccess());
      });
    } on DioError catch (dioError) {
      printError("SendMessage Error request: ${dioError.requestOptions}");
      printError("SendMessage Error Response: ${dioError.response}");
      emit(MessagesFail());
    } catch (error) {
      printError("SendMessage Unknown Error: $error");
      emit(MessagesFail());
    }
  }
}
