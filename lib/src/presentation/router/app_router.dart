import 'package:flutter/material.dart';
import 'package:seda/src/data/models/order_model.dart';
import 'package:seda/src/data/models/reponse_models/govern_response_model.dart';
import 'package:seda/src/data/models/user_model.dart';
import 'package:seda/src/presentation/router/app_animation.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/views/order_views/add_drop_off_screen.dart';
import 'package:seda/src/presentation/screens/order_screens/chat_screen.dart';
import 'package:seda/src/presentation/screens/government_screens/govern_ride_details_screen.dart';
import 'package:seda/src/presentation/screens/government_screens/govern_rides_screen.dart';
import 'package:seda/src/presentation/screens/home_screen.dart';
import 'package:seda/src/presentation/screens/auth_screens/login_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/become_driver_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/captain_profile_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/cards_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/history_details_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/history_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/invite_friends_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/my_promos.dart';
import 'package:seda/src/presentation/screens/menu_screens/profile_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/setting_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/terms_screen.dart';
import 'package:seda/src/presentation/screens/menu_screens/wallet_screen.dart';
import 'package:seda/src/presentation/screens/notifications_screen.dart';
import 'package:seda/src/presentation/screens/order_screens/checkout_screen.dart';
import 'package:seda/src/presentation/screens/auth_screens/fill_profile_screen.dart';
import 'package:seda/src/presentation/views/ride_views/rides_home_view.dart';
import 'package:seda/src/presentation/screens/scooter_screens/qr_scan_screen.dart';
import 'package:seda/src/presentation/screens/scooter_screens/scooter_ask_screen.dart';
import 'package:seda/src/presentation/screens/scooter_screens/scooter_map_screen.dart';
import 'package:seda/src/presentation/screens/scooter_screens/scooter_trip_screen.dart';
import 'package:seda/src/presentation/screens/splash_screen.dart';
import 'package:seda/src/presentation/screens/auth_screens/otp_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouterNames.splash:
        return CustomPageRouteTransiton.fadeOut(
          page: const SplashScreen(),
        );
      case AppRouterNames.login:
        return CustomPageRouteTransiton.fadeOut(
          page: const LoginScreen(),
        );
      case AppRouterNames.fillProfile:
        return CustomPageRouteTransiton.fadeOut(
          page: const FillProfileScreen(),
        );
      case AppRouterNames.verification:
        return CustomPageRouteTransiton.fadeOut(
          page: const OtpScreen(),
        );
      case AppRouterNames.terms:
        final int key = settings.arguments as int;
        return CustomPageRouteTransiton.fadeOut(
          page: TermsScreen(key: ValueKey(key),),
        );
      case AppRouterNames.home:
        final OrderModel? orderProcessing = settings.arguments as OrderModel?;
        return CustomPageRouteTransiton.fadeOut(
          page: HomeScreen(
            orderProcessing: orderProcessing,
          ),
        );
      case AppRouterNames.ridesHome:
        return CustomPageRouteTransiton.fadeOut(
          page: const RidesHomeView(),
        );
      case AppRouterNames.checkout:
        return CustomPageRouteTransiton.fadeOut(
          page: const CheckoutScreen(),
        );
      case AppRouterNames.historyDetails:
        return CustomPageRouteTransiton.fadeOut(
          page: const HistoryDetailsScreen(),
        );
      case AppRouterNames.qrScan:
        return CustomPageRouteTransiton.fadeOut(
          page: const QrScanScreen(),
        );
      case AppRouterNames.scooterAsk:
        return CustomPageRouteTransiton.fadeOut(
          page: const ScooterAskScreen(),
        );
      case AppRouterNames.scooterMap:
        return CustomPageRouteTransiton.fadeOut(
          page: const ScooterMapScreen(),
        );
      case AppRouterNames.inviteFriends:
        return CustomPageRouteTransiton.fadeOut(
          page: InviteFriendsScreen(),
        );
      case AppRouterNames.wallet:
        return CustomPageRouteTransiton.fadeOut(
          page: const WalletScreen(),
        );
      case AppRouterNames.cards:
        return MaterialPageRoute(builder: (_) => const CardsScreen());
      case AppRouterNames.scooterTrip:
        return CustomPageRouteTransiton.fadeOut(
          page: const ScooterTripScreen(),
        );
      case AppRouterNames.setting:
        return CustomPageRouteTransiton.fadeOut(
          page: const SettingScreen(),
        );
      case AppRouterNames.notifications:
        return CustomPageRouteTransiton.fadeOut(
          page: const NotificationsScreen(),
        );
      case AppRouterNames.history:
        return CustomPageRouteTransiton.fadeOut(
          page: const HistoryScreen(),
        );
      case AppRouterNames.profile:
        return CustomPageRouteTransiton.fadeOut(
          page: const ProfileScreen(),
        );
      case AppRouterNames.captainProfile:
        final captain = settings.arguments as UserModel;
        return CustomPageRouteTransiton.fadeOut(
          page: CaptainProfileScreen(captain: captain),
        );
      case AppRouterNames.addDropOff:
        return CustomPageRouteTransiton.fadeOut(
          page: const AddDropOffScreen(),
        );
      case AppRouterNames.chat:
        return CustomPageRouteTransiton.fadeOut(
          page: const ChatScreen(),
        );
      case AppRouterNames.becomeDriver:
        return CustomPageRouteTransiton.fadeOut(
          page: const BecomeDriverScreen(),
        );
      case AppRouterNames.governs:
        return CustomPageRouteTransiton.fadeOut(
          page: const GovernsRidesScreen(),
        );
      case AppRouterNames.governDetails:
        final trip = settings.arguments as Order;
        return CustomPageRouteTransiton.fadeOut(
          page: GovernRideDetailsScreen(
            trip: trip,
          ),
        );
      case AppRouterNames.myVoucher:
        return MaterialPageRoute(builder: (_) => const MyPromos());
      default:
        return null;
    }
  }
}
