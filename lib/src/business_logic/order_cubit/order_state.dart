part of 'order_cubit.dart';

@immutable
abstract class OrderState {}

class MakeOrderInitial extends OrderState {}

class MakeOrderLoading extends OrderState {}

class MakeOrderSuccess extends OrderState {}

class MakeOrderNoDrivers extends OrderState {}

class MakeOrderFail extends OrderState {}

class GetLastOrderStatusLoading extends OrderState {}

class GetLastOrderStatusSuccess extends OrderState {}

class GetLastOrderStatusFail extends OrderState {}

class CancelOrderLoading extends OrderState {}

class CancelOrderSuccess extends OrderState {}

class CancelOrderFail extends OrderState {}

class CarsLoading extends OrderState {}

class GetCarsSuccess extends OrderState {}

class GetCarsFail extends OrderState {}

class PaymentsLoading extends OrderState {}

class GetPaymentsSuccess extends OrderState {}

class GetPaymentsFail extends OrderState {}

class ChangePaymentLoading extends OrderState {}

class ChangePaymentSuccess extends OrderState {}

class ChangePaymentFail extends OrderState {}

class ConfirmDriverOfferLoading extends OrderState {}

class ConfirmDriverOfferSuccess extends OrderState {}

class ConfirmDriverOfferFail extends OrderState {}

class AddNewDropOffLoading extends OrderState {}

class AddNewDropOffSuccess extends OrderState {}

class AddNewDropOffFail extends OrderState {}

class SendRecordLoading extends OrderState {}

class SendRecordSuccess extends OrderState {}

class SendRecordFail extends OrderState {}
