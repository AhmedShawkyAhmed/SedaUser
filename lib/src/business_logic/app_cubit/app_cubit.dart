import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  late ThemeMode _themeMode;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  ThemeMode get themeMode => _themeMode;

  ThemeData get darkTheme => _darkTheme;

  ThemeData get lightTheme => _lightTheme;

  final _lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
    ),
  );

  final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(
        color: AppColors.black,
      ),
    ),
  );

  initAppCubit() {
    initLocale();
    initDarkTheme();
  }

  Future initLocale() async {
    final lang = CacheHelper.getDataFromSharedPreference(
        key: SharedPreferenceKeys.appLanguageSharedKey) ??
        'en';
    _locale = Locale(lang);
    emit(AppLanguageUpdateState());
  }

  Future changeAppLanguage(Locale locale) async {
    _locale = locale;
    CacheHelper.saveDataSharedPreference(
      key: SharedPreferenceKeys.appLanguageSharedKey,
      value: _locale.languageCode,
    );
    emit(AppLanguageUpdateState());
  }

  Future initDarkTheme() async {
    final isDarkTheme = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.isDarkTheme,
        ) ??
        false;
    _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    isDark = isDarkTheme;
    await CacheHelper.saveDataSharedPreference(
      key: SharedPreferenceKeys.isDarkTheme,
      value: isDarkTheme,
    );
    emit(AppThemeUpdateState());
  }

  Future toggleTheme() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await CacheHelper.saveDataSharedPreference(
      key: SharedPreferenceKeys.isDarkTheme,
      value: _themeMode == ThemeMode.dark,
    );
    isDark = _themeMode == ThemeMode.dark;
    emit(AppThemeUpdateState());
  }
}
