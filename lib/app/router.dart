import 'package:flutter/material.dart';
import '../features/home/screens/landing_page.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/product_details/screens/product_details_screen.dart';
import '../features/checkout/screens/checkout_screen.dart';
import '../features/order_tracking/screens/order_tracking_screen.dart';
import '../data/models/product_model.dart';
import 'main_scaffold.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainScaffold());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const MainScaffold(initialIndex: 1),
        );
      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const MainScaffold(initialIndex: 2),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const MainScaffold(initialIndex: 3),
        );
      case '/product':
        final product = settings.arguments as Product?;
        if (product == null) {
          return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Product not found'))),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case '/checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case '/order-tracking':
        final orderId = settings.arguments as int?;
        if (orderId == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Order ID not provided')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: orderId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
