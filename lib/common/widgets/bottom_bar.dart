import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/account/screens/account_screen.dart';
import 'package:amazon_app/core/cart/screens/cart_screen.dart';
import 'package:amazon_app/core/home/screens/home_screen.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = "/actual-home";
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBorderWidth = 5;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserNotifier>().user.cart.length;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: (value) {
          setState(() {
             _page = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: _page == 0
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBorderWidth,
                ),
              )),
              child: const Icon(Icons.home_outlined),
            ),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: _page == 1
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBorderWidth,
                ),
              )),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: "",
          ),

          //profile
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: _page == 2
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                  width: bottomBorderWidth,
                ),
              )),
              child: badges.Badge(
                badgeContent: Text(userCartLen.toString()),
                badgeStyle: const badges.BadgeStyle(
                  elevation: 0,
                  badgeColor: Colors.white
                ),
                child: const Icon(Icons.shopping_cart_outlined)
                ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
