import 'package:bid_driving/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import '../../car_details/screens/buy_cars_screen.dart';
import '../../sell_car/screens/sell_car_number_screen.dart';
import '../../sell_car/screens/my_cars_screen.dart';


class MainScreen extends StatefulWidget {
  final String? brand; // 👈 ADD THIS

  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0,    this.brand,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _screens = [
      const HomeScreen(),
      BuyCarsScreen(brand: widget.brand), // 👈 PASS HERE
      const SellCarNumberScreen(),
      const MyCarsScreen(),
      const ProfileScreen(),
    ];
    AppSizes.init(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}
