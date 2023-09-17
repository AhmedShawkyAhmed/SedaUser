part of 'cards_cubit.dart';

abstract class CardsStates {}

class CardsInit extends CardsStates {}

class SaveCardLoading extends CardsStates {}

class SaveCardSuccess extends CardsStates {}

class SaveCardFailed extends CardsStates {}

class GetCardsLoading extends CardsStates {}

class GetCardsSuccess extends CardsStates {}

class GetCardsFailed extends CardsStates {}
