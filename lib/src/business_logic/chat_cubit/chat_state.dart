part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class MessagesLoading extends ChatState {}
class MessagesSuccess extends ChatState {}
class MessagesEmpty extends ChatState {}
class MessagesFail extends ChatState {}