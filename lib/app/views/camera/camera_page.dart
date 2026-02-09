import 'package:camera/camera.dart';
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

      if (status.isDenied || status.isPermanentlyDenied) {
        setState(() {
          _isGranted = false;
        });
      }

      if (status.isGranted) {
        setState(() {
          _isGranted = true;
        });
        await _openCamera(_cameraIndex);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  Future<void> _openCamera(int selectedCamera) async {
    try {
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[selectedCamera],
          ResolutionPreset.veryHigh,
          enableAudio: false,
        );

        await _cameraController?.setFlashMode(_currentFlashMode);
        _cameraController?.initialize().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  Future<void> _switchCamera() async {
    try {
      setState(() {
        _cameraIndex = _cameraIndex == 0 ? 1 : 0;
      });

      _openCamera(_cameraIndex);
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
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
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
                _isLoading && _cameraController == null
                    ? const Center(child: CircularProgressIndicator())
                    : CameraPreview(_cameraController!),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          BaseIconButton(
                            icon: MingCute.camera_rotate_line,
                            size: 44,
                            color: Colors.black,
                            onPressed: _switchCamera,
                          ),
                          Expanded(
                            child: BaseIconButton(
                              icon: MingCute.camera_2_fill,
                              size: 44,
                              color: Colors.black,
                              onPressed: () async {
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
                              onPressed: () {
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
                ),
              ],
            ),
    );
  }
}
