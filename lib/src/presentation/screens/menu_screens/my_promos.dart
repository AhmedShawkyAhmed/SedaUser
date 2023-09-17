import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/data_provider/remote/dio_helper.dart';
import 'package:seda/src/data/models/error_response.dart';
import 'package:seda/src/data/models/promo_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class MyPromos extends StatefulWidget {
  const MyPromos({super.key});

  @override
  State<MyPromos> createState() => _MyPromosState();
}

class _MyPromosState extends State<MyPromos> {
  PromoModel? promoModel;

  @override
  void initState() {
    super.initState();
    getPromo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isDark ? AppColors.darkGrey : AppColors.white,
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
            text: context.myPromos,
            fontSize: 18.sp,
            textColor: isDark ? AppColors.darkGrey : AppColors.white,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          text: context.validCoupon,
                          fontSize: 12.sp,
                          maxLines: 3,
                        ),
                        if (promoModel != null &&
                            promoModel!.data!.promoCodes.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 16),
                              itemCount: promoModel!.data!.promoCodes.length,
                              itemBuilder: (context, index) {
                                return Voucher(
                                    promoCodes:
                                        promoModel!.data!.promoCodes[index]);
                              },
                            ),
                          )
                        else
                          Expanded(
                              child: Center(
                            child: DefaultText(text: context.doNotHave),
                          ))
                      ])),
            ),
          ],
        ));
  }

  Future getPromo() async {
    try {
      final response = await DioHelper.getData(url: 'myPromo');
      promoModel = PromoModel.fromJson(response.data);
    } on DioError catch (dioError) {
      printError(dioError.toString());
      final errorResponse = ErrorResponse.fromJson(dioError.response!.data);
      showToast(errorResponse.message!);
    } catch (err) {
      printError(err.toString());
      showToast(context.errorOccurred);
    }
    setState(() {});
  }
}

class Voucher extends StatelessWidget {
  final PromoCodes promoCodes;

  const Voucher({super.key, required this.promoCodes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/voucher-background.png')),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 0,
                blurStyle: BlurStyle.outer)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DefaultText(
                  text: promoCodes.title!,
                  fontSize: 14.sp,
                  textColor: AppColors.green,
                  fontWeight: FontWeight.bold),
              DefaultText(
                  text: promoCodes.expireAt!,
                  fontSize: 12.sp,
                  textColor: AppColors.green),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                  text: promoCodes.code!,
                  fontSize: 14.sp,
                  textColor: AppColors.green,
                  fontWeight: FontWeight.bold),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      '${promoCodes.discount}${promoCodes.type != 1 ? '%' : '\$'}',
                  style: TextStyle(fontSize: 30.sp, color: AppColors.green),
                  children: [
                    TextSpan(
                        text: context.off,
                        style:
                            TextStyle(fontSize: 12.sp, color: AppColors.green)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColors.green,
          ),
          DefaultText(
              text: context.moreTrips,
              fontSize: 14.sp,
              textColor: Colors.grey.shade400),
        ],
      ),
    );
  }
}
