import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:productstore/screens/checkout_success_screen.dart';
import 'package:productstore/screens/splash_screen.dart';
import 'package:productstore/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'repositories/product_repository.dart';
import 'blocs/auth/auth_cubit.dart';
import 'blocs/cart/cart_cubit.dart';
import 'blocs/home/home_cubit.dart';
import 'blocs/product/product_cubit.dart';

import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/cart_screen.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final productRepository = ProductRepository();


  getIt.registerLazySingleton(() => NotificationService());



  await NotificationService.init();

  runApp(MyApp(productRepository: productRepository));
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;

  const MyApp({super.key, required this.productRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(
            create: (_) => ProductCubit(productRepository)..fetchProducts()),
        BlocProvider(
            create: (_) => HomeCubit(productRepository)..loadProducts()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.cairo().fontFamily,

        ),
        title: 'Qargo',
        debugShowCheckedModeBanner: false,

        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/cart': (context) => CartScreen(),
          '/checkout-success': (_) => const CheckoutSuccessScreen(),
        },
      ),
    );
  }
}
