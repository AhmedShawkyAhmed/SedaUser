class ApplySharedOrderRequestModel {
  final int orderId;
  final int passenger;
  final int fromId;
  final int toId;

  ApplySharedOrderRequestModel(
    this.orderId,
    this.passenger,
    this.fromId,
    this.toId,
  );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'passenger': passenger,
        'from_id': fromId,
        'to_id': toId,
      };
}
