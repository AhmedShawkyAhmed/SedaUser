import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/cards_cubit/cards_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/cards.dart' as card_model;
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/add_card_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    CardCubit.get(context).getCards(afterSuccess: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 8.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.white,
            size: 20.sp,
          ),
        ),
        title: DefaultText(
          text: context.myCards,
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
      ),
      body: SizedBox(
        height: 92.h,
        child: BlocBuilder<CardCubit, CardsStates>(
          builder: (context, state) {
            final cards = CardCubit.get(context).cards.cards;
            if (state is GetCardsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (cards.isEmpty && state is! GetCardsLoading) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: DefaultText(
                          text: context.emptyCards,
                          maxLines: 3,
                          align: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 45),
                      DefaultAppButton(
                        title: context.addCard,
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            context: context,
                            builder: (builder) {
                              return const AddCardView();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: DefaultText(
                        text: context.savedCards,
                        textColor: AppColors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return CardItem(
                          selected: false,
                          card: cards[index],
                          color: AppColors.green.withAlpha(100),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white,
                        thickness: 2,
                        height: 0,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, AppRouterNames.addCards);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 50),
                        backgroundColor: AppColors.green,
                      ),
                      child: DefaultText(
                        text: context.addCard,
                        fontSize: 22,
                      )),
                  const SizedBox(height: 20)
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final card_model.Card card;
  final Color? selectedColor;
  final VoidCallback? onTap;
  final bool selected;
  final Color color;

  const CardItem(
      {super.key,
      required this.card,
      required this.color,
      this.selectedColor,
      this.onTap,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      leading: Image.asset(
        'assets/images/fake_credit_card_image.png',
        height: 25,
      ),
      title: DefaultText(
        text: '**** **** **** ${card.cardDigits}',
        fontSize: 14,
      ),
      tileColor: color,
      selectedColor: Colors.white,
      selectedTileColor: selectedColor,
      onTap: onTap,
    );
  }
}
