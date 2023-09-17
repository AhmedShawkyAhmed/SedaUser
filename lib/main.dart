import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seda/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/business_logic/bloc_observer.dart';
import 'package:seda/src/business_logic/cards_cubit/cards_cubit.dart';
import 'package:seda/src/business_logic/chat_cubit/chat_cubit.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/business_logic/govern_cubit/govern_cubit.dart';
import 'package:seda/src/business_logic/location_cubit/location_cubit.dart';
import 'package:seda/src/business_logic/notification_cubit/notification_cubit.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/business_logic/rate_cubit/rate_cubit.dart';
import 'package:seda/src/business_logic/ride_cubit/ride_cubit.dart';
import 'package:seda/src/business_logic/wallet_cubit/wallet_cubit.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/notifications/notification_service.dart';
import 'package:seda/src/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      HttpOverrides.global = MyHttpOverrides();
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await Firebase.initializeApp();
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FirebaseMessaging.onBackgroundMessage(onFirebaseBackgroundMessage);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await NotificationService.initialize();
      await initialize();
      Bloc.observer = MyBlocObserver();
      await CacheHelper.init();
      DioHelper.init();
      runApp(MyApp(appRouter: AppRouter()));
    },
    (error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      debugPrint("\x1B[31mGlobal Error: $error\x1B[0m");
      debugPrint("\x1B[31mGlobal StackTrace: $stackTrace\x1B[0m");
    },
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final AppRouter appRouter;

  const MyApp({
    required this.appRouter,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((context) => GlobalCubit()..checkConnection()),
        ),
        BlocProvider(
          create: ((context) => AuthCubit(FirebaseAuth.instance)),
        ),
        BlocProvider(
          create: ((context) => OrderCubit()),
        ),
        BlocProvider(
          create: ((context) => RateCubit()),
        ),
        BlocProvider(
          create: ((context) => ChatCubit()),
        ),
        BlocProvider(
          create: ((context) => LocationCubit()),
        ),
        BlocProvider(
          create: ((context) => WalletCubit()),
        ),
        BlocProvider(
          create: ((context) => NotificationCubit()),
        ),
        BlocProvider(
          create: ((context) => CardCubit()),
        ),
        BlocProvider(
          create: ((context) => AppCubit()..initAppCubit()),
        ),
        BlocProvider(
          create: ((context) => GovernCubit()),
        ),
        BlocProvider(
          create: ((context) => RideCubit()),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  final cubit = AppCubit.get(context);
                  return MaterialApp(
                    navigatorKey: navigatorKey,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: cubit.locale,
                    debugShowCheckedModeBanner: false,
                    title: 'Seda',
                    onGenerateRoute: widget.appRouter.onGenerateRoute,
                    darkTheme: cubit.darkTheme,
                    theme: cubit.lightTheme,
                    themeMode: cubit.themeMode,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
