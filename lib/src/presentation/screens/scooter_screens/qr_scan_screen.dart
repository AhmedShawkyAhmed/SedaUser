import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkGrey : AppColors.midGreen,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          right: 20,
          left: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 100.w,
              height: 13.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.white,
                      size: 22.sp,
                    ),
                  ),
                  // SizedBox(
                  //   width: 40.w,
                  //   child: Image.asset("assets/images/logo4.png"),
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: DefaultText(
                text: context.qrScan,
                textColor: AppColors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Calibri',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 35,
                bottom: 10,
              ),
              child: Container(
                width: 70.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey : AppColors.midGreen,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 10,
              ),
              child: DefaultText(
                text: context.qrScanText,
                textColor: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                maxLines: 2,
                align: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, AppRouterNames.scooterTrip),
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.33),
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Image.asset(
                      'assets/images/camera.png',
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 36.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await controller!.toggleFlash();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/flash.png',
                              color: AppColors.darkGrey,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            DefaultText(
                              textColor: AppColors.darkGrey,
                              text: context.openFlash,
                              fontFamily: 'Calibri',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 36.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/keyboard.png',
                              color: AppColors.darkGrey,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            DefaultText(
                              textColor: AppColors.darkGrey,
                              text: context.addCode,
                              fontFamily: 'Calibri',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Center(
            //   child: (result != null)
            //       ? Text(
            //           'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
            //       : Text('Scan a code'),
            // ),
          ],
        ),
      ),
    );
  }
}
