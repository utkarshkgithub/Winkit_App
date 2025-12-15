import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_tracking_event.dart';
import 'order_tracking_state.dart';

class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  final OrderRepository orderRepository;

  OrderTrackingBloc({required this.orderRepository})
    : super(const OrderTrackingInitial()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<RefreshOrderDetails>(_onRefreshOrderDetails);
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderTrackingState> emit,
  ) async {
    emit(const OrderTrackingLoading());
    try {
      final order = await orderRepository.getOrderById(event.orderId);
      emit(OrderTrackingLoaded(order));
    } catch (e) {
      emit(OrderTrackingError(e.toString()));
    }
  }

  Future<void> _onRefreshOrderDetails(
    RefreshOrderDetails event,
    Emitter<OrderTrackingState> emit,
  ) async {
    // Keep the current state while refreshing
    try {
      final order = await orderRepository.getOrderById(event.orderId);
      emit(OrderTrackingLoaded(order));
    } catch (e) {
      // Don't emit error on refresh failure, keep current state
      if (state is! OrderTrackingLoaded) {
        emit(OrderTrackingError(e.toString()));
      }
    }
  }
}
