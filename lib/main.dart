import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services/_DB%20services/Repositories/worker_profiles_repo.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Views/splash_screen.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_cubit.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_cubit.dart';
import 'package:home_services/_DB%20services/bloc/order_cubit/orders_cubit.dart';
import 'package:home_services/_DB%20services/bloc/product%20cubit/products_cubit.dart';
import 'package:home_services/firebase_options.dart';

import '_DB services/bloc/worker-cubit/wokers_profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => WokersProfileCubit(),
          ),
          BlocProvider(
            create: (context) => BookingCubit(),
          ),
          BlocProvider(
            create: (context) => ProductsCubit(),
          ),
          BlocProvider(
            create: (context) => OrdersCubit(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              title: 'Home Services',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: AppColors.appColor),
                  useMaterial3: true,
                  // Set default font theme
                  textTheme: GoogleFonts.robotoCondensedTextTheme(
                    Theme.of(context).textTheme,
                  )),
              home: const SplashScreen(),
            );
          },
        ));
  }
}
