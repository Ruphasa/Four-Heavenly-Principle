import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:pentagram/widgets/profil/camera/instruction_screen.dart';
import 'package:pentagram/widgets/profil/camera/camera_preview_screen.dart';
import 'package:pentagram/widgets/profil/camera/image_preview_screen.dart';

class KtpCameraPage extends StatefulWidget {
  const KtpCameraPage({super.key});

  @override
  State<KtpCameraPage> createState() => _KtpCameraPageState();
}

class _KtpCameraPageState extends State<KtpCameraPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  File? _capturedImage;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _showInstructionScreen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    // Kembalikan ke portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak ada kamera yang tersedia'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
        return;
      }

      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka kamera: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<File?> _cropImageToFrame(String imagePath, Size screenSize) async {
    try {
      // Baca image
      final bytes = await File(imagePath).readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) return null;

      // Dapatkan ukuran screen dan frame
      final size = screenSize;
      final frameHeight = size.height * 0.7;
      final frameWidth = frameHeight * 1.59; // KTP ratio landscape

      // Hitung posisi crop berdasarkan center screen
      final imageWidth = originalImage.width;
      final imageHeight = originalImage.height;

      // Scale factor untuk mapping screen coordinate ke image coordinate
      final scaleX = imageWidth / size.width;
      final scaleY = imageHeight / size.height;

      // Hitung posisi frame di image (center)
      final cropWidth = (frameWidth * scaleX).toInt();
      final cropHeight = (frameHeight * scaleY).toInt();
      final cropX = ((imageWidth - cropWidth) / 2).toInt();
      final cropY = ((imageHeight - cropHeight) / 2).toInt();

      // Crop image
      final croppedImage = img.copyCrop(
        originalImage,
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight,
      );

      // Simpan cropped image
      final croppedPath = imagePath.replaceAll('.jpg', '_cropped.jpg');
      final croppedFile = File(croppedPath);
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage, quality: 95));

      return croppedFile;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing || _cameraController == null) return;

    // Ambil screenSize sebelum async operation
    final screenSize = MediaQuery.of(context).size;

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();

      // Auto-crop image sesuai frame overlay
      final croppedFile = await _cropImageToFrame(image.path, screenSize);

      if (mounted) {
        // Kembalikan ke portrait mode untuk preview
        _setPortraitMode();
        setState(() {
          _capturedImage = croppedFile ?? File(image.path);
          _isCapturing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmPhoto() {
    if (_capturedImage != null) {
      Navigator.pop(context, _capturedImage);
    }
  }

  void _retakePhoto() {
    // Set landscape lagi saat kembali ke kamera
    _setLandscapeMode();
    setState(() {
      _capturedImage = null;
    });
  }

  void _startCamera() {
    // Set landscape mode saat kamera preview dibuka
    _setLandscapeMode();
    setState(() {
      _showInstructionScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showInstructionScreen) {
      return InstructionScreen(onStart: _startCamera);
    }

    if (_capturedImage != null) {
      return ImagePreviewScreen(
        image: _capturedImage!,
        onConfirm: _confirmPhoto,
        onRetake: _retakePhoto,
      );
    }

    if (!_isInitialized || _cameraController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return CameraPreviewScreen(
      cameraController: _cameraController!,
      onCapture: _capturePhoto,
      isCapturing: _isCapturing,
    );
  }
}
