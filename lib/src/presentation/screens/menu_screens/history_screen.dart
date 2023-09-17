import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/history_card_view.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  double rate = 1.0;
  int currentPage = 1;
  bool loadMore = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    AuthCubit.get(context).getHistory();
    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          if (kDebugMode) {
            print('At the top');
          }
        } else {
          if (kDebugMode) {
            print('At the bottom');
          }
          if (currentPage < AuthCubit.get(context).pages && !loadMore) {
            loadMore = true;
            currentPage += 1;
            await AuthCubit.get(context)
                .getHistory(afterSuccess: () {}, page: currentPage);
            loadMore = false;
          }
        }
      }
    });
    super.initState();
  }

  DateTime picked = DateTime.now();
  Future<void> _getDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(3000),
    );
    if (date != null) {
      picked = date;
      setState(() {});
      AuthCubit.get(context).getHistory(
          date: DateFormat('dd-MM-yyyy').format(date), afterSuccess: () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        centerTitle: false,
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
          text: context.history,
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
        actions: [
          InkWell(
            onTap: () => _getDate(context),
            child: Row(
              children: [
                DefaultText(
                  text: DateFormat('EE, dd MMM yyyy').format(picked),
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.white,
                  fontSize: 12.sp,
                ),
                SizedBox(
                  width: 0.5.w,
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return SizedBox(
            width: 100.w,
            height: 92.h,
            child: state is AuthOrderHistorySuccessState &&
                    cubit.historyOrders.isEmpty
                ? Center(
                    child: DefaultText(
                      text: context.noHistoryHere,
                      textColor: isDark ? AppColors.white : AppColors.black,
                      fontSize: 20.sp,
                    ),
                  )
                : ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    itemCount: state is AuthOrderHistoryLoadingState
                        ? cubit.historyOrders.length + 1
                        : cubit.historyOrders.length,
                    itemBuilder: (context, index) {
                      // print(historyOrders[position].status);
                      if (state is AuthOrderHistoryLoadingState &&
                          index == cubit.historyOrders.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return HistoryCardView(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const LoadingIndicator(),
                          );
                          AuthCubit.get(context).getOrderDetails(
                            afterSuccess: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                AppRouterNames.historyDetails,
                                // AppRouterNames.tripHistory,
                              );
                            },
                            afterError: () => Navigator.pop(context),
                            id: cubit.historyOrders[index].id,
                          );
                        },
                        order: cubit.historyOrders[index],
                      );
                    }),
          );
        },
      ),
    );
  }
}
