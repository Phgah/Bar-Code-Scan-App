import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'payment_screen.dart';
import 'success_screen.dart';
import 'detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart & Payment Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFDF9F4),
      ),
      initialRoute: '/cart',
      routes: {
        '/cart': (context) => const CartScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/success': (context) => const SuccessScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}
