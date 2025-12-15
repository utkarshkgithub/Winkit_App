import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/order_repository.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CartRepository cartRepository;
  final OrderRepository orderRepository;

  CheckoutBloc({required this.cartRepository, required this.orderRepository})
    : super(const CheckoutInitial()) {
    on<CheckoutStarted>(_onCheckoutStarted);
    on<CheckoutSubmitted>(_onCheckoutSubmitted);
  }

  Future<void> _onCheckoutStarted(
    CheckoutStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(const CheckoutLoading());
      final cart = await cartRepository.getCart();
      emit(CheckoutLoaded(cart));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  Future<void> _onCheckoutSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is! CheckoutLoaded) return;

    final currentCart = (state as CheckoutLoaded).cart;

    try {
      emit(const CheckoutSubmitting());

      // Create order
      final order = await orderRepository.createOrder(
        event.shippingAddress,
        event.phoneNumber,
      );

      // Clear cart after successful order creation
      await cartRepository.clearCart();

      emit(CheckoutSuccess(order));
    } catch (e) {
      // On error, go back to CheckoutLoaded state to preserve form data
      emit(CheckoutError(e.toString()));

      // Return to loaded state so user can retry
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) {
          emit(CheckoutLoaded(currentCart));
        }
      });
    }
  }
}
