import 'package:amazon_app/common/widgets/bottom_bar.dart';
import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/admin/screens/admin_screen.dart';
import 'package:amazon_app/core/auth/screens/auth_screen.dart';
import 'package:amazon_app/core/auth/services/auth_service.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:amazon_app/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return UserNotifier();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme:
              const ColorScheme.light(primary: GlobalVariables.secondaryColor),
          useMaterial3: false,
          //all appbar will have elevation of 0 and icontheme color will be black
          appBarTheme: const AppBarTheme(
              elevation: 0, iconTheme: IconThemeData(color: Colors.black))),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserNotifier>(context).user.token.isNotEmpty
          ? Provider.of<UserNotifier>(context).user.type == "user"
              ? const BottomBar()
              : const AdminScreen()
          : const AuthScreen(),
    );
  }
}
