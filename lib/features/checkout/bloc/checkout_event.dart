import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted();
}

class CheckoutSubmitted extends CheckoutEvent {
  final String shippingAddress;
  final String phoneNumber;

  const CheckoutSubmitted({
    required this.shippingAddress,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [shippingAddress, phoneNumber];
}
