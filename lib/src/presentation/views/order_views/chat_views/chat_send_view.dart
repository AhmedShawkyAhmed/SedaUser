// ignore_for_file: unused_element

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/image_picker_dialog.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class ChatSendView extends StatefulWidget {
  const ChatSendView({
    Key? key,
    required this.sendMessage,
    required this.path,
    required this.recordAllowed,
    required this.requestPermissions,
  }) : super(key: key);

  final String path;
  final bool recordAllowed;
  final Function() requestPermissions;
  final Function({
    String? message,
    bool isMedia,
    String? path,
    String? type,
    required Function() afterSuccess,
  }) sendMessage;

  @override
  State<ChatSendView> createState() => _ChatSendViewState();
}

class _ChatSendViewState extends State<ChatSendView> {
  late final RecorderController recorderController;
  final TextEditingController _messageController = TextEditingController();
  bool _typing = false;
  bool isRecording = false;
  bool isRecordingCompleted = false;

  @override
  void initState() {
    super.initState();
    _initialiseControllers();
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  @override
  void dispose() {
    recorderController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();

        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController.record(path: widget.path);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 3.h, left: 2.w, right: 2.w),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isRecording
                  ? AudioWaveforms(
                      enableGesture: true,
                      size: Size(MediaQuery.of(context).size.width, 5.h),
                      recorderController: recorderController,
                      waveStyle: const WaveStyle(
                        waveColor: AppColors.darkGrey,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 1.sp,
                          color: AppColors.grey,
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 18),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                    )
                  : DefaultTextField(
                      controller: _messageController,
                      hintText: context.send,
                      color: AppColors.lightGrey,
                      radius: 100,
                      height: 6.h,
                      bottom: 2,
                      onChanged: (nVal) {
                        setState(() {
                          if (nVal.isNotEmpty) {
                            _typing = true;
                          } else {
                            _typing = false;
                          }
                        });
                      },
                      borderColor: AppColors.transparent,
                      suffix: InkWell(
                        onTap: () {
                          showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              backgroundColor: AppColors.transparent,
                              context: context,
                              builder: (BuildContext bc) {
                                return ImagePickerDialog(
                                  onImageSelect: (String path) {
                                    setState(() {
                                      widget.sendMessage(
                                        isMedia: true,
                                        path: path,
                                        type: 'image',
                                        afterSuccess: () {},
                                      );
                                    });
                                  },
                                );
                              });
                        },
                        child: const Icon(
                          Icons.image,
                          color: AppColors.black,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 1.4.w,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1F5087),
                    Color.fromRGBO(35, 87, 141, 0.8),
                  ],
                  stops: [
                    0,
                    100,
                  ],
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: GestureDetector(
                onLongPress: _typing
                    ? null
                    : () async {
                        if (widget.recordAllowed) {
                          _startOrStopRecording();
                        } else {
                          showToast(
                            context.recordPermissionsError,
                            color: AppColors.orange,
                            textColor: AppColors.white,
                          );
                          widget.requestPermissions();
                        }
                      },
                onLongPressEnd: _typing
                    ? null
                    : (details) async {
                        if (isRecording) {
                          final path = await recorderController.stop();
                          isRecording = false;
                          isRecordingCompleted = true;
                          if (isRecordingCompleted) {
                            widget.sendMessage(
                              isMedia: true,
                              path: path,
                              type: 'audio',
                              afterSuccess: () {
                                recorderController.reset();
                              },
                            );
                          }
                          isRecordingCompleted = false;
                        }
                      },
                onTap: _typing
                    ? () {
                        widget.sendMessage(
                          message: _messageController.text.trim(),
                          afterSuccess: () {
                            _messageController.clear();
                            setState(() {
                              _typing = false;
                            });
                          },
                        );
                      }
                    : null,
                child: Icon(
                  _typing ? Icons.send : Icons.mic,
                  size: 25,
                  color: AppColors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
