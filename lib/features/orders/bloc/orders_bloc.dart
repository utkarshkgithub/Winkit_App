import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/order_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository orderRepository;

  OrdersBloc({required this.orderRepository}) : super(const OrdersInitial()) {
    on<LoadUserOrders>(_onLoadUserOrders);
    on<RefreshUserOrders>(_onRefreshUserOrders);
  }

  Future<void> _onLoadUserOrders(
    LoadUserOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    try {
      final orders = await orderRepository.getUserOrders(event.userId);
      if (orders.isEmpty) {
        emit(const OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onRefreshUserOrders(
    RefreshUserOrders event,
    Emitter<OrdersState> emit,
  ) async {
    // Keep the current state while refreshing
    try {
      final orders = await orderRepository.getUserOrders(event.userId);
      if (orders.isEmpty) {
        emit(const OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      // Don't emit error on refresh failure, keep current state
      if (state is! OrdersLoaded) {
        emit(OrdersError(e.toString()));
      }
    }
  }
}
