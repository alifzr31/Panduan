import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/views/camera/widgets/camera_handle.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  static const String routeName = '/camera';

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  bool _isGranted = false;
  CameraController? _cameraController;
  int _cameraIndex = 0;
  FlashMode _currentFlashMode = FlashMode.off;
  bool _isLoading = true;

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.status;

      if (!mounted) return;

      if (status.isGranted) {
        setState(() {
          _isGranted = true;
        });
        await _openCamera(_cameraIndex);
      } else {
        setState(() {
          _isGranted = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  Future<void> _openCamera(int selectedCamera) async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) return;

      if (_cameraController != null) {
        await _cameraController?.dispose();
      }

      final newController = CameraController(
        cameras[selectedCamera],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _cameraController = newController;

      await newController.initialize();

      await newController.setFlashMode(_currentFlashMode);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) print(e);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _switchCamera() async {
    try {
      setState(() {
        _cameraIndex = _cameraIndex == 0 ? 1 : 0;
      });

      await _openCamera(_cameraIndex);
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (_cameraController == null ||
          !(_cameraController?.value.isInitialized ?? false)) {
        return;
      }

      final CameraController? oldController = _cameraController;

      if (mounted) {
        setState(() {
          _cameraController = null;
          _isLoading = true;
        });
      }

      oldController?.dispose();
    }

    if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isGranted
          ? CameraHandle(
              icon: MingCute.camera_2_fill,
              title: 'Kamera Tidak Diizinkan',
              description:
                  'Silahkan izinkan aplikasi untuk mengakses kamera pada perangkat anda agar aplikasi dapat melakukan pengambilan foto langsung dengan kamera.',
              buttonLabel: 'Izinkan Kamera',
              onPressedButton: () async {
                try {
                  final status = await Permission.camera.status;

                  if (status.isDenied) {
                    final requestPermission = await Permission.camera.request();

                    if (requestPermission.isDenied ||
                        requestPermission.isPermanentlyDenied) {
                      await openAppSettings();
                    }
                  }

                  if (status.isPermanentlyDenied) {
                    await openAppSettings();
                  }
                } catch (e) {
                  rethrow;
                }
              },
            )
          : Column(
              children: [
                _isLoading ||
                        _cameraController == null ||
                        !(_cameraController?.value.isInitialized ?? false)
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    : Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: AspectRatio(
                                aspectRatio:
                                    1 /
                                    (_cameraController?.value.aspectRatio ?? 0),
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
                            if (Platform.isIOS) ...{
                              Positioned(
                                top: 0,
                                right: 0,
                                child: SafeArea(
                                  bottom: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(2),
                                      minimumSize: Size.zero,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Tutup Kamera',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Jost',
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              MingCute.close_circle_fill,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 48,
                    horizontal: 16,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        BaseIconButton(
                          icon: MingCute.camera_rotate_line,
                          size: 44,
                          color: Colors.black,
                          onPressed:
                              (_isLoading ||
                                  !(_cameraController?.value.isInitialized ??
                                      false))
                              ? null
                              : _switchCamera,
                        ),
                        Expanded(
                          child: BaseIconButton(
                            icon: MingCute.camera_2_fill,
                            size: 44,
                            color: Colors.black,
                            onPressed:
                                (_isLoading ||
                                    !(_cameraController?.value.isInitialized ??
                                        false))
                                ? null
                                : () async {
                                    final picture = await _cameraController
                                        ?.takePicture();

                                    if (context.mounted) {
                                      Navigator.pop(context, {
                                        'fileName': picture?.name,
                                        'filePath': picture?.path,
                                      });
                                    }
                                  },
                          ),
                        ),
                        if (_cameraIndex == 0) ...{
                          BaseIconButton(
                            icon: _currentFlashMode == FlashMode.off
                                ? Icons.flash_on
                                : Icons.flash_off,
                            size: 44,
                            color: Colors.black,
                            onPressed:
                                (_isLoading ||
                                    !(_cameraController?.value.isInitialized ??
                                        false))
                                ? null
                                : () {
                                    setState(() {
                                      switch (_currentFlashMode) {
                                        case FlashMode.off:
                                          _currentFlashMode = FlashMode.torch;
                                          break;
                                        case FlashMode.torch:
                                          _currentFlashMode = FlashMode.off;
                                          break;
                                        default:
                                          _currentFlashMode = FlashMode.off;
                                      }
                                    });

                                    _cameraController?.setFlashMode(
                                      _currentFlashMode,
                                    );
                                  },
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
