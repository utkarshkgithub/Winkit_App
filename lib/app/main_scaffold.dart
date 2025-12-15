import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../features/home/screens/home_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/orders/screens/past_orders_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/home/blocs/home_bloc.dart';
import '../features/home/blocs/home_event.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    // Load home data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const LoadHomeData());
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const PastOrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Theme.of(context).primaryColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(
                context,
              ).primaryColor.withOpacity(0.1),
              color: Colors.grey[600],
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                ),
                GButton(
                  icon: Icons.shopping_cart_outlined,
                  text: 'Cart',
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                ),
                GButton(
                  icon: Icons.receipt_long_outlined,
                  text: 'Orders',
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                  iconActiveColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
