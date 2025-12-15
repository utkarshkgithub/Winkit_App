import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    // Skip loading if already loaded and force is not true
    if (!event.force && state is CartLoaded) {
      return;
    }

    emit(const CartLoading());
    try {
      // Try to load cached cart first for instant display
      final cachedCart = cartRepository.getCachedCart();
      if (cachedCart != null && !event.force) {
        emit(CartLoaded(cart: cachedCart));
      }

      // Then fetch from server to get latest data
      final cart = await cartRepository.getCart();
      emit(CartLoaded(cart: cart));
    } catch (e) {
      // If network fails, try to use cached cart
      final cachedCart = cartRepository.getCachedCart();
      if (cachedCart != null) {
        emit(CartLoaded(cart: cachedCart));
      } else {
        emit(CartError(message: e.toString()));
      }
    }
  }

  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final cart = await cartRepository.addToCart(
        event.productId,
        event.quantity,
      );
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final cart = await cartRepository.updateCartItem(
        event.productId,
        event.quantity,
      );
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final cart = await cartRepository.updateCartItem(event.productId, 0);
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.clearCart();
      final cart = await cartRepository.getCart();
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
