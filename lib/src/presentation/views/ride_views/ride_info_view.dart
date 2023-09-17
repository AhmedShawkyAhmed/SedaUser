import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/order_cubit/order_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart' as end;
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/car.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/ride_views/ride_type_info_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:sizer/sizer.dart';


class RideInfoView extends StatefulWidget {
  const RideInfoView({Key? key}) : super(key: key);

  @override
  State<RideInfoView> createState() => _RideInfoViewState();
}

class _RideInfoViewState extends State<RideInfoView>
    with TickerProviderStateMixin {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // rideType = OrderCubit.get(context).carTypes.data!.data![0].id!;
    shipmentTypeId = 2;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pageController.addListener(() {
      // print(_pageController.position.pixels);
      // print(_pageController.position.userScrollDirection);
      if (page != _pageController.page?.toInt() &&
          _pageController.page != null) {
        setState(() {
          page = _pageController.page!.toInt();
        });
      }
      if ((((_pageController.position.pixels) / 100.w) % 1) > 0.00001) {
        fade = true;
        forward = _pageController.position.userScrollDirection ==
            ScrollDirection.forward;
        fadeValue = (1 - ((_pageController.position.pixels / 100.w) % 1)) * 0.1;
        setState(() {});
        if ((((_pageController.position.pixels) / 100.w) % 1) > 0.9) {
          fade = false;
          setState(() {});
        }
      } else {
        fade = false;
        setState(() {});
      }
    });
  }

  int page = 0;
  final List<bool> _selected = [true, false, false];
  bool fade = false;
  double fadeValue = 0;
  late AnimationController controller;
  bool forward = true;
  bool run = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 1.9.h,
                ),
                Container(
                  height: 1.w,
                  width: 15.w,
                  decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(15)),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Expanded(
                  child: BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      final types = <Car>[
                        Car(
                            id: 0,
                            name: 'Just Go',
                            price: 'SAR  87.80 ',
                            distance: context.betterShortTrip,
                            time: context.rideInfoDes,
                            image: "assets/images/car_just_go.png"),
                        Car(
                            id: 1,
                            name: 'By Offer',
                            price: context.offerPrice,
                            distance: context.betterLongTrip,
                            time: context.rideInfoDes,
                            image: "assets/images/car_offer.png"),
                        Car(
                            id: 2,
                            name: 'By Hours',
                            price: 'SAR  87.80 ',
                            distance: context.bookDriverHour,
                            time: context.rideInfoDes,
                            image: "assets/images/car_hours.png"),
                      ];
                      return PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          _selected[index] = true;
                          for (int i = 0; i < _selected.length; i++) {
                            if (i != index) {
                              _selected[i] = false;
                            }
                          }
                          setState(() {});
                        },
                        itemCount: types.length,
                        itemBuilder: (context, position) {
                          return RideWithInfoView(
                            fade: fade,
                            forward: forward,
                            index: position,
                            page: page,
                            types: types,
                            fadeValue: fadeValue,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100.w,
            height: 12.h,
            alignment: Alignment.center,
            color: isDark ? AppColors.darkGrey : AppColors.grey1,
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                  width: 20.w,
                  child: BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 50),
                            height: 1.w,
                            width: _selected[position] ? 6.w : 4.w,
                            decoration: BoxDecoration(
                                color: _selected[position]
                                    ? AppColors.primary
                                    : AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(15)),
                          );
                        },
                        separatorBuilder: (context, position) {
                          return SizedBox(
                            width: 2.w,
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    child: DefaultAppButton(
                      height: 7.h,
                      title: context.confirm,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RideWithInfoView extends StatelessWidget {
  final bool fade;
  final bool forward;
  final int index;
  final int page;
  final double? fadeValue;
  final List<Car> types;

  const RideWithInfoView(
      {super.key,
      required this.fade,
      required this.forward,
      required this.index,
      this.fadeValue,
      required this.types,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: fade ? fadeValue! + 0.2 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: RideTypeInfoView(
            key: ValueKey(index),
            image: types[index].image != null && types[index].image!.isNotEmpty
                ? '${end.EndPoints.imageBaseUrl}${types[index].image}'
                : "assets/images/carBlack.png",
            title: '${types[index].name}',
            time: "${types[index].time}",
            price: "${types[index].price}",
            subTitle: "${types[index].distance}",
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          right: fade && page == index
              ? forward
                  ? -200
                  : 200
              : 0,
          top: fade && page == index
              ? forward
                  ? 0
                  : 60
              : 0,
          child: Container(
            margin: EdgeInsets.only(
              top: 3.6.h,
            ),
            child: Transform.scale(
              scale: 1.3,
              child: Image.asset(
                types[index].image!,
                width: 40.w,
                height: 12.h,
              ),
              // child: types[index].image?.contains('http') == true
              //     ? Image.network(
              //         types[index].image!,
              //         width: 15.w,
              //         height: 6.h,
              //       )
              //     : Image.asset(
              //         types[index].image!,
              //         width: 40.w,
              //         height: 12.h,
              //       ),
            ),
          ),
        ),
      ],
    );
  }
}
