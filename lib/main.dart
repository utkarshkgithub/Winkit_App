import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/router.dart';
import 'core/di/injection_container.dart' as di;

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';

import 'features/cart/blocs/cart_bloc.dart';
import 'features/cart/blocs/cart_event.dart';
import 'features/home/blocs/home_bloc.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/category_repository.dart';

import 'features/home/screens/landing_page.dart';
import 'app/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(repository: di.sl<AuthRepository>())
                ..add(const AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) =>
              CartBloc(cartRepository: di.sl<CartRepository>())
                ..add(const LoadCart()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            productRepository: di.sl<ProductRepository>(),
            categoryRepository: di.sl<CategoryRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Winkit - Grocery Delivery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const AppRoot(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

/// ROOT AUTH DECISION
/// Uses the EXISTING loading UI via AuthState

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainScaffold();
        }

        if (state is AuthUnauthenticated) {
          return const LandingPage();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
