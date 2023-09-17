part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthVerifyPhoneLoadingState extends AuthState {}

class AuthVerifyPhoneSuccessState extends AuthState {}

class AuthVerifyPhoneErrorState extends AuthState {
  final String message;

  AuthVerifyPhoneErrorState(this.message);
}

class AuthVerifyOTPLoadingState extends AuthState {}

class AuthVerifyOTPSuccessState extends AuthState {
  final bool isUser;

  AuthVerifyOTPSuccessState(this.isUser);
}

class AuthVerifyOTPErrorState extends AuthState {
  final String message;

  AuthVerifyOTPErrorState(this.message);
}

class AuthRegisterLoadingState extends AuthState {}

class AuthRegisterSuccessState extends AuthState {}

class AuthRegisterErrorState extends AuthState {
  final String message;

  AuthRegisterErrorState(this.message);
}

class AuthUpdateProfileLoadingState extends AuthState {}

class AuthUpdateProfileSuccessState extends AuthState {}

class AuthUpdateProfileErrorState extends AuthState {
  final String message;

  AuthUpdateProfileErrorState(this.message);
}

class AuthGetProfileLoadingState extends AuthState {}

class AuthGetProfileSuccessState extends AuthState {}

class AuthGetProfileErrorState extends AuthState {
  final String message;

  AuthGetProfileErrorState(this.message);
}

class AuthLogoutLoadingState extends AuthState {}

class AuthLogoutSuccessState extends AuthState {}

class AuthLogoutErrorState extends AuthState {
  final String message;

  AuthLogoutErrorState(this.message);
}

class AuthFcmSendingLoadingState extends AuthState {}
class AuthFcmSendingSuccessState extends AuthState {}
class AuthFcmSendingProblemState extends AuthState {}
class AuthFcmSendingFailureState extends AuthState {}

class AuthOrderHistoryLoadingState extends AuthState{}
class AuthOrderHistorySuccessState extends AuthState{}
class AuthOrderHistoryProblemState extends AuthState{}
class AuthOrderHistoryFailureState extends AuthState{}

class AuthOrderDetailsLoadingState extends AuthState{}
class AuthOrderDetailsSuccessState extends AuthState{}
class AuthOrderDetailsProblemState extends AuthState{}
class AuthOrderDetailsFailureState extends AuthState{}

class AuthNearestCarLoadingState extends AuthState{}
class AuthNearestCarSuccessState extends AuthState{}
class AuthNearestCarProblemState extends AuthState{}
class AuthNearestCarFailureState extends AuthState{}

class AuthGoogleLoginLoadingState extends AuthState{}
class AuthGoogleLoginSuccessState extends AuthState{}
class AuthGoogleLoginProblemState extends AuthState{}
class AuthGoogleLoginFailureState extends AuthState{}

class AuthFacebookLoginLoadingState extends AuthState{}
class AuthFacebookLoginSuccessState extends AuthState{}
class AuthFacebookLoginProblemState extends AuthState{}
class AuthFacebookLoginFailureState extends AuthState{}

class AuthVerifyPhoneSocialLoadingState extends AuthState{}
class AuthVerifyPhoneSocialSuccessState extends AuthState{}
class AuthVerifyPhoneSocialProblemState extends AuthState{}
class AuthVerifyPhoneSocialFailureState extends AuthState{}

class VerifyPhoneCodeReceivedState extends AuthState {
  final String code;

  VerifyPhoneCodeReceivedState(this.code);
}
class VerifyPhoneVerifiedState extends AuthState {}
class VerifyPhoneVerifyErrorState extends AuthState {}

class VerifyingOtpLoadingState extends AuthState {}
class VerifyingOtpSuccessState extends AuthState {}
class VerifyingOtpFailureState extends AuthState {}
