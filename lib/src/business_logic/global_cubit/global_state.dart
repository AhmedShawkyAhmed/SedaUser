part of 'global_cubit.dart';

@immutable
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}

class GlobalLoading extends GlobalState {}

class GlobalSuccess extends GlobalState {}

class GlobalFailure extends GlobalState {}

class DistanceLoading extends GlobalState {}

class NoDriverAcceptedOrFoundedState extends GlobalState {}

class CancelAfterArrived extends GlobalState {}

class UserLiveTracking extends GlobalState {}

class DistanceFailure extends GlobalState {}

class SearchPlacesEnd extends GlobalState {}

class SearchPlacesFailure extends GlobalState {}

class SocketSuccess extends GlobalState {
  final OrderModel? orderModel;

  SocketSuccess({this.orderModel});
}

class SocketFailure extends GlobalState {}

class SocketDisconnected extends GlobalState {}

class SocketConfirmOrder extends GlobalState {}

class SocketAcceptOrder extends GlobalState {
  final OrderModel? orderModel;

  SocketAcceptOrder({this.orderModel});
}

class SocketDriverArrived extends SocketAcceptOrder {
  final OrderModel? orderDModel;

  SocketDriverArrived({this.orderDModel});
}

class SocketStartOrder extends GlobalState {}

class SocketEndOrder extends GlobalState {
  final OrderModel? orderModel;

  SocketEndOrder({this.orderModel});
}

class SocketCancelOrder extends GlobalState {}

class SocketNewMessage extends GlobalState {
  final MessageModel newMessage;

  SocketNewMessage(this.newMessage);
}

class SocketNewDriverOffer extends GlobalState {}
