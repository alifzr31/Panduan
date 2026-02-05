import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  static const String routeName = '/camera';

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  int _cameraIndex = 0;
  FlashMode _currentFlashMode = FlashMode.off;
  bool _isLoading = true;

  Future<void> _initCamera(int selectedCamera) async {
    try {
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[selectedCamera],
          ResolutionPreset.veryHigh,
          enableAudio: false,
        );

        await _cameraController.setFlashMode(_currentFlashMode);
        _cameraController.initialize().then((_) {
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

      _initCamera(_cameraIndex);
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  @override
  void initState() {
    _initCamera(_cameraIndex);
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CameraPreview(_cameraController),
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
                          final picture = await _cameraController.takePicture();

                          if (context.mounted) {
                            Navigator.pop(context, {
                              'fileName': picture.name,
                              'filePath': picture.path,
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

                          _cameraController.setFlashMode(_currentFlashMode);
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
