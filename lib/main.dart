import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductsListPage(),
    );
  }
}

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  // ignore: unused_field
  late File _image;
  List<String> products = [];

  late final InputImage inputImage;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> _getImageAndRecognizeText(ImageSource source) async {
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
      textRecognizer.close();
    }

    // final pickedImage = await ImagePicker().pickImage(source: source);
    // if (pickedImage != null) {
    //   final image = GoogleMlKit.fromFile(File(pickedImage.path));
    //   final textRecognizer = GoogleMlKit.vision.textRecognizer();
    //   final visionText = await textRecognizer.processImage(image as InputImage);
    //   String? extractedText = visionText.text;
    //   setState(() {
    //     products.add(extractedText);
    //   });
    //   textRecognizer.close();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products List')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _getImageAndRecognizeText(ImageSource.gallery),
            child: const Text('Select Image'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(products[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
