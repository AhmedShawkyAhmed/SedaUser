import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/ride_cubit/ride_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/views/ride_views/select_location_view.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';

class RidesHomeTextFieldView extends StatefulWidget {
  const RidesHomeTextFieldView({
    Key? key,
    required this.count,
    required this.updateCount,
    required this.autoCompleteSearch,
    required this.updateState,
    required this.updateFocusedLocation,
  }) : super(key: key);

  final int count;
  final Function(int index) updateCount;
  final Function(String input) autoCompleteSearch;
  final Function() updateState;
  final Function(int selectedLocation) updateFocusedLocation;

  @override
  State<RidesHomeTextFieldView> createState() => _RidesHomeTextFieldViewState();
}

class _RidesHomeTextFieldViewState extends State<RidesHomeTextFieldView> {
  List<bool> removeLocation = [false, false, false, false];
  List<bool> focused = [false, true, false, false];
  bool onReorder = true;
  bool reOrdering = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 1.h,
        left: 1.w,
        right: 1.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 4.w,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 3.h),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (_, index) => index == 0
                  ? Container(
                      width: 3.w,
                      height: 3.w,
                      margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                      decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(50)),
                    )
                  : Container(
                      width: 3.w,
                      height: 3.w,
                      margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                      decoration: BoxDecoration(
                          color: AppColors.lightRed,
                          borderRadius: BorderRadius.circular(3)),
                    ),
              separatorBuilder: (_, index) => Container(
                width: 1,
                height: 5.5.h + 4 * index,
                margin: EdgeInsets.symmetric(horizontal: 1.7.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.lightGrey : AppColors.grey,
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              itemCount: widget.count + 1,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 88.w,
            child: Row(
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(
                        canvasColor: AppColors.transparent,
                        shadowColor: AppColors.transparent),
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index) => Container(
                        key: ObjectKey(toLocations[index] == 1
                            ? toLocationAddressController
                            : toLocations[index] == 2
                                ? toLocationAddressController1
                                : toLocationAddressController2),
                        // margin: const EdgeInsets.symmetric(
                        //     vertical: 7.5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: AppColors.transparent,
                            borderRadius: BorderRadius.circular(2)),
                        child: DefaultTextField(
                          height: 5.5.h,
                          onChanged: (val) {
                            RideCubit.get(context).toggleIsSearching(true);
                            if (val.isNotEmpty) {
                              widget.autoCompleteSearch(val);
                              RideCubit.get(context).toggleIsSearching(true);
                              setState(() {
                                removeLocation[index + 1] = true;
                              });
                            } else {
                              RideCubit.get(context).toggleIsSearching(false);
                              setState(() {
                                removeLocation[index + 1] = false;
                              });
                            }
                            widget.updateState();
                          },
                          onTap: () {
                            widget.updateFocusedLocation(toLocations[index]);
                            setState(() {
                              focused[index + 1] = true;
                              for (int i = 0; i < focused.length; i++) {
                                if (i != index + 1) {
                                  focused[i] = false;
                                }
                              }
                              final controller = toLocations[index] == 1
                                  ? toLocationAddressController
                                  : toLocations[index] == 2
                                      ? toLocationAddressController1
                                      : toLocationAddressController2;
                              if (controller.text.trim().isNotEmpty) {
                                setState(() {
                                  removeLocation[index + 1] = true;
                                });
                              } else {
                                setState(() {
                                  removeLocation[index + 1] = false;
                                });
                              }
                              widget.updateState();
                            });
                          },
                          bottom: 2,
                          suffix: SizedBox(
                            width: removeLocation[index + 1]
                                ? 20.w
                                : toLocations.length != 1
                                    ? 18.w
                                    : 10.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (removeLocation[index + 1])
                                  InkWell(
                                    onTap: () {
                                      if (toLocations[index] == 1) {
                                        toLocationAddressController.clear();
                                        toLocationLat = 0;
                                        toLocationLon = 0;
                                      } else if (toLocations[index] == 2) {
                                        toLocationAddressController1.clear();
                                        toLocationLat1 = 0;
                                        toLocationLon1 = 0;
                                      } else {
                                        toLocationAddressController2.clear();
                                        toLocationLat2 = 0;
                                        toLocationLon2 = 0;
                                      }
                                      removeLocation[index + 1] = false;
                                      RideCubit.get(context)
                                          .toggleIsSearching(false);
                                      setState(() {});
                                      widget.updateState();
                                    },
                                    child: Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(
                                            color: AppColors.darkGrey
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: AppColors.white,
                                          size: 14,
                                        )),
                                  ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const SelectLocationView();
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        final result =
                                            value as Map<String, dynamic>;
                                        if (toLocations[index] == 1) {
                                          toLocationLat = result['lat'];
                                          toLocationLon = result['lon'];
                                          toLocationAddressController.text =
                                              result['address'];
                                        } else if (toLocations[index] == 2) {
                                          toLocationLat1 = result['lat'];
                                          toLocationLon1 = result['lon'];
                                          toLocationAddressController1.text =
                                              result['address'];
                                        } else {
                                          toLocationLat2 = result['lat'];
                                          toLocationLon2 = result['lon'];
                                          toLocationAddressController2.text =
                                              result['address'];
                                        }
                                        widget.updateState();
                                      }
                                    });
                                  },
                                  child: const Icon(
                                    Icons.my_location,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                if (toLocations.length != 1)
                                  ReorderableDragStartListener(
                                    index: index,
                                    key: ObjectKey(toLocations[index] == 1
                                        ? toLocationAddressController
                                        : toLocations[index] == 2
                                            ? toLocationAddressController1
                                            : toLocationAddressController2),
                                    child: Image.asset(
                                      "assets/images/list.png",
                                      color: focused[index + 1]
                                          ? AppColors.lightBlue
                                          : isDark
                                              ? AppColors.lightGrey
                                              : AppColors.darkGrey,
                                    ),
                                  ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          controller: toLocations[index] == 1
                              ? toLocationAddressController
                              : toLocations[index] == 2
                                  ? toLocationAddressController1
                                  : toLocationAddressController2,
                          hintText: context.whereTo,
                          borderColor: AppColors.lightGrey,
                          radius: 50,
                          shadow: const BoxShadow(),
                          textColor: isDark && !focused[index + 1]
                              ? AppColors.lightGrey
                              : AppColors.darkGrey,
                          hintTextColor: isDark && !focused[index + 1]
                              ? AppColors.lightGrey
                              : AppColors.darkGrey,
                          focused: focused[index + 1],
                          color: AppColors.transparent,
                        ),
                      ),
                      itemCount: widget.count,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final int item = toLocations.removeAt(oldIndex);
                          toLocations.insert(newIndex, item);
                          final clear = removeLocation[oldIndex];
                          removeLocation.removeAt(oldIndex);
                          focused[oldIndex + 1] = false;
                          removeLocation.insert(newIndex, clear);
                          focused[newIndex + 1] = true;
                        });
                      },
                      onReorderEnd: (int index) {
                        setState(() {
                          reOrdering = true;
                        });
                      },
                      onReorderStart: (int index) {
                        setState(() {
                          reOrdering = false;
                        });
                      },
                      header: DefaultTextField(
                        height: 5.5.h,
                        readOnly: widget.key != const ValueKey(1),
                        onChanged: (val) {
                          RideCubit.get(context).toggleIsSearching(true);
                          if (val.isNotEmpty) {
                            widget.autoCompleteSearch(val);
                            setState(() {
                              removeLocation[0] = true;
                            });
                          } else {
                            setState(() {
                              removeLocation[0] = false;
                            });
                          }
                          widget.updateState();
                        },
                        onTap: () {
                          widget.updateFocusedLocation(0);
                          setState(() {
                            focused[0] = true;
                            for (int i = 0; i < focused.length; i++) {
                              if (i != 0) {
                                focused[i] = false;
                              }
                            }
                            if (fromLocationAddressController.text
                                .trim()
                                .isNotEmpty) {
                              setState(() {
                                removeLocation[0] = true;
                              });
                            } else {
                              setState(() {
                                removeLocation[0] = false;
                              });
                            }
                            widget.updateState();
                          });
                        },
                        bottom: 2,
                        suffix: widget.key != const ValueKey(1)
                            ? const SizedBox()
                            : SizedBox(
                                width: 8.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (removeLocation[0])
                                      InkWell(
                                        onTap: () {
                                          fromLocationAddressController.clear();
                                          fromLocationLat = 0;
                                          fromLocationLon = 0;
                                          removeLocation[0] = false;
                                          RideCubit.get(context)
                                              .toggleIsSearching(false);
                                          setState(() {});
                                          widget.updateState();
                                        },
                                        child: Container(
                                            height: 14,
                                            width: 14,
                                            decoration: BoxDecoration(
                                                color: AppColors.darkGrey
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: AppColors.white,
                                              size: 14,
                                            )),
                                      ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const SelectLocationView();
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            final result =
                                                value as Map<String, dynamic>;
                                            fromLocationLat = result['lat'];
                                            fromLocationLon = result['lon'];
                                            fromLocationAddressController.text =
                                                result['address'];
                                            setState(() {});
                                            widget.updateState();
                                          }
                                        });
                                      },
                                      child: const Icon(
                                        Icons.my_location,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                        controller: fromLocationAddressController,
                        hintText: context.enterThePickLocation,
                        borderColor: AppColors.lightGrey,
                        radius: 50,
                        shadow: const BoxShadow(),
                        textColor: isDark && !focused[0]
                            ? AppColors.lightGrey
                            : AppColors.darkGrey,
                        hintTextColor: isDark && !focused[0]
                            ? AppColors.lightGrey
                            : AppColors.darkGrey,
                        focused: focused[0],
                        color: AppColors.transparent,
                      ),
                    ),
                  ),
                ),
                reOrdering
                    ? SizedBox(
                        width: 8.w,
                        child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 1.h),
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (_, index) => index == 0
                                ? SizedBox(
                                    height: 5.75.w,
                                    width: 4.w,
                                  )
                                : InkWell(
                                    onTap: () {
                                      widget.updateCount(index - 1);
                                      if (widget.count == 1 && index - 1 == 0) {
                                        toLocations.add(
                                            toLocations.contains(2) ? 1 : 2);
                                      } else if (widget.count == 2 &&
                                          index - 1 == 1) {
                                        final data = [1, 2, 3];
                                        final remains = data.where((element) =>
                                            !toLocations.contains(element));
                                        toLocations.add(remains.toList()[0]);
                                      } else {
                                        final removed =
                                            toLocations.removeAt(index - 1);
                                        if (removed == 1) {
                                          toLocationAddressController.clear();
                                          toLocationLat = 0;
                                          toLocationLon = 0;
                                        } else if (removed == 2) {
                                          toLocationAddressController1.clear();
                                          toLocationLat1 = 0;
                                          toLocationLon1 = 0;
                                        } else {
                                          toLocationAddressController2.clear();
                                          toLocationLat2 = 0;
                                          toLocationLon2 = 0;
                                        }
                                      }
                                      setState(() {});
                                      widget.updateState();
                                    },
                                    child: Container(
                                      width: 5.w,
                                      height: 5.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.transparent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Icon(
                                        widget.count == 1 && index - 1 == 0
                                            ? Icons.add
                                            : widget.count == 2 &&
                                                    index - 1 == 1
                                                ? Icons.add
                                                : Icons.close_outlined,
                                        color: isDark
                                            ? AppColors.lightGrey
                                            : AppColors.darkGrey,
                                      ),
                                    ),
                                  ),
                            separatorBuilder: (_, index) => Container(
                                  width: 0.3.w,
                                  height: 4.75.h + 4 * index,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 1.5.w),
                                ),
                            itemCount: widget.count + 1),
                      )
                    : SizedBox(
                        width: 8.w,
                      ),
                // SizedBox(width: 1.w)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
