import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LanguageStrings on BuildContext {
  bool get isAr => AppLocalizations.of(this)!.localeName == 'ar';

  String get seda => AppLocalizations.of(this)!.seda;

  String get sedaTestNotification =>
      AppLocalizations.of(this)!.sedaTestNotification;

  String get designTextExample => AppLocalizations.of(this)!.designTextExample;

  String get facilitateText => AppLocalizations.of(this)!.facilitateText;

  String get english => AppLocalizations.of(this)!.english;

  String get arabic => AppLocalizations.of(this)!.arabic;

  String get rideStarted => AppLocalizations.of(this)!.rideStarted;

  String get emptyPhone => AppLocalizations.of(this)!.emptyPhone;

  String get codeSent => AppLocalizations.of(this)!.codeSent;

  String get enterCode => AppLocalizations.of(this)!.enterCode;

  String get enterName => AppLocalizations.of(this)!.enterName;

  String get shortName => AppLocalizations.of(this)!.shortName;

  String get needToAgree => AppLocalizations.of(this)!.needToAgree;

  String get selectLocation => AppLocalizations.of(this)!.selectLocation;

  String get rideTypesError => AppLocalizations.of(this)!.rideTypesError;

  String get errorOccurred => AppLocalizations.of(this)!.errorOccurred;

  String get promoAdded => AppLocalizations.of(this)!.promoAdded;

  String get rideRequested => AppLocalizations.of(this)!.rideRequested;

  String get micAllow => AppLocalizations.of(this)!.micAllow;

  String get language => AppLocalizations.of(this)!.language;

  String get appLangCh => AppLocalizations.of(this)!.appLangCh;

  String get appLangChErrAr => AppLocalizations.of(this)!.appLangChErrAr;

  String get appLangChErrEn => AppLocalizations.of(this)!.appLangChErrEn;

  String get appLangChErrEmpty => AppLocalizations.of(this)!.appLangChErrEmpty;

  String get terms => AppLocalizations.of(this)!.terms;

  String get termsText => AppLocalizations.of(this)!.termsText;

  String get termsAndPolicy => AppLocalizations.of(this)!.termsAndPolicy;

  String get yourTrip => AppLocalizations.of(this)!.yourTrip;

  String get settings => AppLocalizations.of(this)!.settings;

  String get notifications => AppLocalizations.of(this)!.notifications;

  String get security => AppLocalizations.of(this)!.security;

  String get contactUs => AppLocalizations.of(this)!.contactUs;

  String get profile => AppLocalizations.of(this)!.profile;

  String get myWallet => AppLocalizations.of(this)!.myWallet;

  String get inviteFriends => AppLocalizations.of(this)!.inviteFriends;

  String get inviteFriendsGift => AppLocalizations.of(this)!.inviteFriendsGift;

  String get history => AppLocalizations.of(this)!.history;

  String get fillProfile => AppLocalizations.of(this)!.fillProfile;

  String get checkout => AppLocalizations.of(this)!.checkout;

  String get home => AppLocalizations.of(this)!.home;

  String get payment => AppLocalizations.of(this)!.payment;

  String get enterStopPoint => AppLocalizations.of(this)!.enterStopPoint;

  String get totalPrice => AppLocalizations.of(this)!.totalPrice;

  String get distance => AppLocalizations.of(this)!.distance;

  String get youHaveCoupon => AppLocalizations.of(this)!.youHaveCoupon;

  String get time => AppLocalizations.of(this)!.time;

  String get price => AppLocalizations.of(this)!.price;

  String get logout => AppLocalizations.of(this)!.logout;

  String get cont => AppLocalizations.of(this)!.cont;

  String get search => AppLocalizations.of(this)!.search;

  String get select => AppLocalizations.of(this)!.select;

  String get selectRide => AppLocalizations.of(this)!.selectRide;

  String get selectRideError => AppLocalizations.of(this)!.selectRideError;

  String get whereTo => AppLocalizations.of(this)!.whereTo;

  String get now => AppLocalizations.of(this)!.now;

  String get addTip => AppLocalizations.of(this)!.addTip;

  String get minutes => AppLocalizations.of(this)!.minutes;

  String get seconds => AppLocalizations.of(this)!.seconds;

  String get endTrip => AppLocalizations.of(this)!.endTrip;

  String get tripSummary => AppLocalizations.of(this)!.tripSummary;

  String get date => AppLocalizations.of(this)!.date;

  String get backToHome => AppLocalizations.of(this)!.backToHome;

  String get rateDriver => AppLocalizations.of(this)!.rateDriver;

  String get choosePayment => AppLocalizations.of(this)!.choosePayment;

  String get chooseRide => AppLocalizations.of(this)!.chooseRide;

  String get sedaCash => AppLocalizations.of(this)!.sedaCash;

  String get paymentMethods => AppLocalizations.of(this)!.paymentMethods;

  String get choose => AppLocalizations.of(this)!.choose;

  String get startNow => AppLocalizations.of(this)!.startNow;

  String get termsApprove => AppLocalizations.of(this)!.termsApprove;

  String get ride => AppLocalizations.of(this)!.ride;

  String get online => AppLocalizations.of(this)!.online;

  String get scooter => AppLocalizations.of(this)!.scooter;

  String get scooterTrip => AppLocalizations.of(this)!.scooterTrip;

  String get scooterRideAsk => AppLocalizations.of(this)!.scooterRideAsk;

  String get scooterRideAskDesc =>
      AppLocalizations.of(this)!.scooterRideAskDesc;

  String get gov => AppLocalizations.of(this)!.gov;

  String get emptyRecent => AppLocalizations.of(this)!.emptyRecent;

  String get work => AppLocalizations.of(this)!.work;

  String get favourite => AppLocalizations.of(this)!.favourite;

  String get fav => AppLocalizations.of(this)!.fav;

  String get savedLocation => AppLocalizations.of(this)!.savedLocation;
  String get userLocation => AppLocalizations.of(this)!.userLocation;

  String get edit => AppLocalizations.of(this)!.edit;

  String get go => AppLocalizations.of(this)!.go;

  String get emergency => AppLocalizations.of(this)!.emergency;

  String get becomeDriver => AppLocalizations.of(this)!.becomeDriver;

  String get addOne => AppLocalizations.of(this)!.addOne;

  String get addFavourite => AppLocalizations.of(this)!.addFavourite;

  String stopPoint([String? val]) => AppLocalizations.of(this)!.stopPoint(
        val ?? '',
      );

  String endPoint([String? val]) => AppLocalizations.of(this)!.endPoint(
        val ?? '',
      );

  String activePassengers(String val) =>
      AppLocalizations.of(this)!.activePassenger(
        val,
      );

  String status(String val) => AppLocalizations.of(this)!.status(val);

  String valid(String val) => AppLocalizations.of(this)!.valid(val);

  String get reserveTrip => AppLocalizations.of(this)!.reserveTrip;

  String get startPoint => AppLocalizations.of(this)!.startPoint;

  String get whyCancel => AppLocalizations.of(this)!.whyCancel;

  String get cancelTrip => AppLocalizations.of(this)!.cancelTrip;

  String get doYouWantToCancelTrip =>
      AppLocalizations.of(this)!.doYouWantToCancelTrip;
  String get alternativelyYouCanFindAnotherDriver =>
      AppLocalizations.of(this)!.alternativelyYouCanFindAnotherDriver;

  String get yesCancelTrip => AppLocalizations.of(this)!.yesCancelTrip;

  String get addOrChange => AppLocalizations.of(this)!.addOrChange;

  String get findAnotherDriver => AppLocalizations.of(this)!.findAnotherDriver;

  String get personalReason => AppLocalizations.of(this)!.personalReason;

  String get anotherCarArrived => AppLocalizations.of(this)!.anotherCarArrived;

  String get reasonRelatedToCaptain =>
      AppLocalizations.of(this)!.reasonRelatedToCaptain;
  String get reasonRelatedToUser =>
      AppLocalizations.of(this)!.reasonRelatedToUser;

  String get anotherReason => AppLocalizations.of(this)!.anotherReason;
  String get capOrCar => AppLocalizations.of(this)!.capOrCar;

  String get sedaSorry => AppLocalizations.of(this)!.sedaSorry;

  String get yes => AppLocalizations.of(this)!.yes;

  String get no => AppLocalizations.of(this)!.no;
  String get skip => AppLocalizations.of(this)!.skip;
  String get change => AppLocalizations.of(this)!.change;
  String get share => AppLocalizations.of(this)!.share;
  String get currentFare => AppLocalizations.of(this)!.currentFare;
  String get raiseFare => AppLocalizations.of(this)!.raiseFare;
  String get toKeepYouSafe => AppLocalizations.of(this)!.toKeepYouSafe;
  String get reportProblem => AppLocalizations.of(this)!.reportProblem;
  String get shareYourTrip => AppLocalizations.of(this)!.shareYourTrip;
  String get tripRecording => AppLocalizations.of(this)!.tripRecording;
  String get tripIsAlreadyRecording =>
      AppLocalizations.of(this)!.tripIsAlreadyRecording;
  String get callPolice => AppLocalizations.of(this)!.callPolice;
  String get stayInformed => AppLocalizations.of(this)!.stayInformed;
  String get instantRideVerification =>
      AppLocalizations.of(this)!.instantRideVerification;
  String get sharingTripFare => AppLocalizations.of(this)!.sharingTripFare;
  String get beCarefulWithYourMovements =>
      AppLocalizations.of(this)!.beCarefulWithYourMovements;
  String get choosePassenger => AppLocalizations.of(this)!.choosePassenger;
  String get anyNotesOnTheMeetingPoint =>
      AppLocalizations.of(this)!.anyNotesOnTheMeetingPoint;
  String get thankYouForUsingOurServices =>
      AppLocalizations.of(this)!.thankYouForUsingOurServices;
  String get backToMyTrip => AppLocalizations.of(this)!.backToMyTrip;
  String get theTripHasBeenRequested =>
      AppLocalizations.of(this)!.theTripHasBeenRequested;

  String get waitLong => AppLocalizations.of(this)!.waitLong;

  String get capNotMove => AppLocalizations.of(this)!.capNotMove;

  String get capLate => AppLocalizations.of(this)!.capLate;

  String get playAudioRecord => AppLocalizations.of(this)!.playAudioRecord;

  String get capProf => AppLocalizations.of(this)!.capProf;

  String get carType => AppLocalizations.of(this)!.carType;

  String get askRideForOther => AppLocalizations.of(this)!.askRideForOther;

  String get askRideForOtherText =>
      AppLocalizations.of(this)!.askRideForOtherText;

  String get myCards => AppLocalizations.of(this)!.myCards;

  String get emptyCards => AppLocalizations.of(this)!.emptyCards;

  String get error => AppLocalizations.of(this)!.error;

  String get addressConf => AppLocalizations.of(this)!.addressConf;

  String get checkDrId => AppLocalizations.of(this)!.checkDrId;

  String get tripStart => AppLocalizations.of(this)!.tripStart;

  String get tripLocation => AppLocalizations.of(this)!.tripLocation;

  String get tripTime => AppLocalizations.of(this)!.tripTime;

  String get arrivalTime => AppLocalizations.of(this)!.arrivalTime;

  String get changePassenger => AppLocalizations.of(this)!.changePassenger;

  String get sedaServe => AppLocalizations.of(this)!.sedaServe;

  String get periodStop => AppLocalizations.of(this)!.periodStop;

  String get periodStopDesc => AppLocalizations.of(this)!.periodStopDesc;

  String get sedaOpinion => AppLocalizations.of(this)!.sedaOpinion;

  String get off => AppLocalizations.of(this)!.off;

  String get moreTrips => AppLocalizations.of(this)!.moreTrips;

  String get doNotHave => AppLocalizations.of(this)!.doNotHave;

  String get validCoupon => AppLocalizations.of(this)!.validCoupon;

  String get myPromos => AppLocalizations.of(this)!.myPromos;

  String get cong => AppLocalizations.of(this)!.cong;

  String get recharge => AppLocalizations.of(this)!.recharge;

  String get saveChanges => AppLocalizations.of(this)!.saveChanges;

  String get around => AppLocalizations.of(this)!.around;

  String get favPlaces => AppLocalizations.of(this)!.favPlaces;

  String get myVouchers => AppLocalizations.of(this)!.myVouchers;

  String get apply => AppLocalizations.of(this)!.apply;

  String get qrScan => AppLocalizations.of(this)!.qrScan;

  String get qrScanText => AppLocalizations.of(this)!.qrScanText;

  String get openFlash => AppLocalizations.of(this)!.openFlash;

  String get addCode => AppLocalizations.of(this)!.addCode;

  String get me => AppLocalizations.of(this)!.me;

  String get newPassenger => AppLocalizations.of(this)!.newPassenger;

  String get friendsAgreed => AppLocalizations.of(this)!.friendsAgreed;

  String get compDisabled => AppLocalizations.of(this)!.compDisabled;
  String get submit => AppLocalizations.of(this)!.submit;

  String get capRequestSent => AppLocalizations.of(this)!.capRequestSent;

  String get disabled => AppLocalizations.of(this)!.disabled;

  String get takePic => AppLocalizations.of(this)!.takePic;

  String get selectGallery => AppLocalizations.of(this)!.selectGallery;

  String get locationAdd => AppLocalizations.of(this)!.locationAdd;

  String get leftWindowClosed => AppLocalizations.of(this)!.leftWindowClosed;

  String get carCond => AppLocalizations.of(this)!.carCond;

  String get impol => AppLocalizations.of(this)!.impol;

  String get arrLate => AppLocalizations.of(this)!.arrLate;

  String get badDrive => AppLocalizations.of(this)!.badDrive;

  String get leaveComment => AppLocalizations.of(this)!.leaveComment;

  String get writePrice => AppLocalizations.of(this)!.writePrice;

  String get usageTime => AppLocalizations.of(this)!.usageTime;

  String get safetyWelcome => AppLocalizations.of(this)!.safetyWelcome;

  String get tripShare => AppLocalizations.of(this)!.tripShare;

  String get recordingAudio => AppLocalizations.of(this)!.recordingAudio;

  String get safetyText1 => AppLocalizations.of(this)!.safetyText1;

  String get rideVerify => AppLocalizations.of(this)!.rideVerify;

  String get safetyText2 => AppLocalizations.of(this)!.safetyText2;

  String get sedaHotline => AppLocalizations.of(this)!.sedaHotline;

  String get safetyText3 => AppLocalizations.of(this)!.safetyText3;

  String get trustedCont => AppLocalizations.of(this)!.trustedCont;

  String get safetyText4 => AppLocalizations.of(this)!.safetyText4;

  String get whiteThing => AppLocalizations.of(this)!.whiteThing;

  String get waitDriverOffer => AppLocalizations.of(this)!.waitDriverOffer;

  String get waitDriverResponse =>
      AppLocalizations.of(this)!.waitDriverResponse;

  String get driversOffer => AppLocalizations.of(this)!.driversOffer;

  String get newT => AppLocalizations.of(this)!.newT;

  String get special => AppLocalizations.of(this)!.special;

  String get tripDate => AppLocalizations.of(this)!.tripDate;

  String get promoCode => AppLocalizations.of(this)!.promoCode;

  String get start => AppLocalizations.of(this)!.start;

  String get end => AppLocalizations.of(this)!.end;

  String get goodMorning => AppLocalizations.of(this)!.goodMorning;
  String get goodAfternoon => AppLocalizations.of(this)!.goodAfternoon;
  String get goodEvening => AppLocalizations.of(this)!.goodEvening;

  String get confirm => AppLocalizations.of(this)!.confirm;

  String get saved => AppLocalizations.of(this)!.saved;

  String get singIn => AppLocalizations.of(this)!.signIn;

  String get signUp => AppLocalizations.of(this)!.signUp;

  String get login => AppLocalizations.of(this)!.login;

  String get register => AppLocalizations.of(this)!.register;

  String get next => AppLocalizations.of(this)!.next;

  String get or => AppLocalizations.of(this)!.or;

  String get fullName => AppLocalizations.of(this)!.fullName;

  String get nickName => AppLocalizations.of(this)!.nickName;

  String get birthDate => AppLocalizations.of(this)!.birthDate;

  String get email => AppLocalizations.of(this)!.email;

  String get phone => AppLocalizations.of(this)!.phone;

  String get resendCode => AppLocalizations.of(this)!.resendCode;

  String get phoneVerification => AppLocalizations.of(this)!.phoneVerification;

  String get otpCode => AppLocalizations.of(this)!.otpCode;

  String get walletBalance => AppLocalizations.of(this)!.walletBalance;

  String get addCoin => AppLocalizations.of(this)!.addCoin;

  String get addCard => AppLocalizations.of(this)!.addCard;

  String get addCardValidation => AppLocalizations.of(this)!.addCardValidation;

  String get cards => AppLocalizations.of(this)!.cards;

  String get savedCards => AppLocalizations.of(this)!.savedCards;

  String get cardName => AppLocalizations.of(this)!.cardName;

  String get cardNumber => AppLocalizations.of(this)!.cardNumber;

  String get exprDate => AppLocalizations.of(this)!.exprDate;

  String get cvv => AppLocalizations.of(this)!.cvv;

  String get messages => AppLocalizations.of(this)!.messages;

  String get send => AppLocalizations.of(this)!.send;

  String get cash => AppLocalizations.of(this)!.cash;

  String get visa => AppLocalizations.of(this)!.visa;

  String get wallet => AppLocalizations.of(this)!.wallet;

  String estimatedTime(String val) =>
      AppLocalizations.of(this)!.estimatedTime(val);

  String get credit => AppLocalizations.of(this)!.credit;

  String get finish => AppLocalizations.of(this)!.finish;

  String get shortPhone => AppLocalizations.of(this)!.shortPhone;

  String get cancel => AppLocalizations.of(this)!.cancel;

  String get offerRide => AppLocalizations.of(this)!.offerRide;

  String get enterThePickLocation =>
      AppLocalizations.of(this)!.enterThePickLocation;

  String get rememberMe => AppLocalizations.of(this)!.rememberMe;

  String get dontHaveAccount => AppLocalizations.of(this)!.dontHaveAccount;

  String get haveAccount => AppLocalizations.of(this)!.haveAccount;

  String get userRegisterError => AppLocalizations.of(this)!.userRegisterError;

  String get guestLoginError => AppLocalizations.of(this)!.guestLoginError;

  String get gender => AppLocalizations.of(this)!.gender;

  String get male => AppLocalizations.of(this)!.male;

  String get female => AppLocalizations.of(this)!.female;

  String get shareYourTripStatus =>
      AppLocalizations.of(this)!.shareYourTripStatus;
  String get addNewDropOff => AppLocalizations.of(this)!.addNewDropOff;
  String get addLocation => AppLocalizations.of(this)!.addLocation;
  String get recentLocations => AppLocalizations.of(this)!.recentLocations;
  String get favoriteLocations => AppLocalizations.of(this)!.favoriteLocations;

  String get justGo => AppLocalizations.of(this)!.justGo;
  String get byOffer => AppLocalizations.of(this)!.byOffer;
  String get byHours => AppLocalizations.of(this)!.byHours;
  String get upfrontFare => AppLocalizations.of(this)!.upfrontFare;
  String get offerPrice => AppLocalizations.of(this)!.offerPrice;
  String get betterShortTrip => AppLocalizations.of(this)!.betterShortTrip;
  String get betterLongTrip => AppLocalizations.of(this)!.betterLongTrip;
  String get bookDriverHour => AppLocalizations.of(this)!.bookDriverHour;
  String get rideInfoDes => AppLocalizations.of(this)!.rideInfoDes;

  String get chatSendError => AppLocalizations.of(this)!.chatSendError;
  String get micPermissionError =>
      AppLocalizations.of(this)!.micPermissionError;

  String get storagePermissionError =>
      AppLocalizations.of(this)!.storagePermissionError;

  String get recordPermissionsError =>
      AppLocalizations.of(this)!.recordPermissionsError;

  String get callCaptain => AppLocalizations.of(this)!.callCaptain;
  String get predictedLocations =>
      AppLocalizations.of(this)!.predictedLocations;

  String get deleteAccount => AppLocalizations.of(this)!.deleteAccount;
  String get deleteAccountWarning =>
      AppLocalizations.of(this)!.deleteAccountWarning;
  String get deleteAccountMessage =>
      AppLocalizations.of(this)!.deleteAccountMessage;
  String get makeOrderValidationError =>
      AppLocalizations.of(this)!.makeOrderValidationError;
  String get invalidSendCode => AppLocalizations.of(this)!.invalidSendCode;
  String minutesLeft(String val) => AppLocalizations.of(this)!.minutesLeft(val);

  String get chatMessage1 => AppLocalizations.of(this)!.chatMessage1;
  String get chatMessage2 => AppLocalizations.of(this)!.chatMessage2;
  String get chatMessage3 => AppLocalizations.of(this)!.chatMessage3;
  String get areYouSureRecord => AppLocalizations.of(this)!.areYouSureRecord;
  String get record => AppLocalizations.of(this)!.record;
  String thankDriverWithTip(String name) =>
      AppLocalizations.of(this)!.thankDriverWithTip(name);
  String get remainingTime => AppLocalizations.of(this)!.remainingTime;
  String get driverWaiting => AppLocalizations.of(this)!.driverWaiting;
  String get noHistoryHere => AppLocalizations.of(this)!.noHistoryHere;
  String get verificationCodeRequired =>
      AppLocalizations.of(this)!.verificationCodeRequired;
}
