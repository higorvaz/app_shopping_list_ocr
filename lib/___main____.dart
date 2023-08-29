import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';

// Create the CameraController
CameraController? _camera;

// Initializing the TextDetector
final textDetector = GoogleMlKit.vision.textRecognizer();
const String recognizedText = "";

@override
void initState() {
  initState();
  _initializeCamera(); // for camera initialization
}

void _initializeCamera() async {
  // Get list of cameras of the device
  List<CameraDescription> cameras = await availableCameras();

  _camera = CameraController(cameras[0], ResolutionPreset.low);

// Initialize the CameraController
  _camera?.initialize().then((_) async {
    // Start streaming images from platform camera
    await _camera?.startImageStream((CameraImage image) =>
        _processCameraImage(image)); // image processing and text recognition.
  });
}

void _processCameraImage(CameraImage image) async {
// getting InputImage from CameraImage
  InputImage inputImage = getInputImage(image);
  RecognizedText recognizedText =
      await textDetector.processImage(inputImage);
// Using the recognised text.
  for (TextBlock block in recognizedText.blocks) {
    recognizedText = "${block.text} " as RecognizedText;
  }
}

InputImage getInputImage(CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
 
    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
 
    var InputImageRotationMethods;
    final InputImageRotation imageRotation =
        InputImageRotationMethods.fromRawValue(
                _camera!.description.sensorOrientation) ??
            InputImageRotation.rotation0deg;
 
    var InputImageFormatMethods;
    final InputImageFormat inputImageFormat =
        InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
            InputImageFormat.nv21;
 
    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();
 
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
 
    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData, metadata: null);
  }
  
  InputImageData({required Size size, required InputImageRotation imageRotation, required InputImageFormat inputImageFormat, required List<InputImage> planeData}) {
  }
  
  InputImage InputImagePlaneMetadata({required int bytesPerRow, int? height, int? width}) {
  }
  



CameraPreview(
      _camera!,
      child: Text("Show your recognized text${recognizedText}"),
           )

