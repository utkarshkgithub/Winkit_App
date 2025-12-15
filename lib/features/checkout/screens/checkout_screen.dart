import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CheckoutBloc(cartRepository: sl(), orderRepository: sl())
            ..add(const CheckoutStarted()),
      child: const CheckoutView(),
    );
  }
}

class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _shippingAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _shippingAddressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submitCheckout(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<CheckoutBloc>().add(
        CheckoutSubmitted(
          shippingAddress: _shippingAddressController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), elevation: 0),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            // Navigate to order tracking screen
            Navigator.of(context).pushReplacementNamed(
              '/order-tracking',
              arguments: state.order.id,
            );
          } else if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () => _submitCheckout(context),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutInitial || state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CheckoutLoaded || state is CheckoutSubmitting) {
            final cart = (state is CheckoutLoaded) ? state.cart : null;
            final isSubmitting = state is CheckoutSubmitting;

            if (cart == null && state is! CheckoutSubmitting) {
              return const Center(child: Text('Cart not loaded'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Summary Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            if (cart != null) ...[
                              ...cart.items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.productDetails.name} x ${item.quantity}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        '\u{20B9}${item.subtotal}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Items:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${cart.totalItems}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9}${cart.totalPrice}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Shipping Details
                    Text(
                      'Shipping Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Shipping Address Field
                    TextFormField(
                      controller: _shippingAddressController,
                      enabled: !isSubmitting,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Shipping Address',
                        hintText: 'Enter your complete shipping address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter shipping address';
                        }
                        if (value.trim().length < 10) {
                          return 'Address should be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Field
                    TextFormField(
                      controller: _phoneNumberController,
                      enabled: !isSubmitting,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.trim().length < 10) {
                          return 'Phone number should be at least 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Place Order Button
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _submitCheckout(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
