import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_vision/google_vision.dart';

class TextExtraction {
  getText(path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    String textExtracted = '';

    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          textExtracted += element.text;
        }
      }
      textExtracted += '\n';
    }

    textRecognizer.close();
    return textExtracted;
  }

  getText2(path) async {
    final jsonString = await rootBundle.loadString('assets/files/key.json');

    final googleVision = await GoogleVision.withJwt(jsonString);

    final painter = Painter.fromFilePath(path);
    Image img = Image(imageUri: path, painter: painter);

    final requests = AnnotationRequests(requests: [
      AnnotationRequest(image: img, features: [
        Feature(type: 'TEXT_DETECTION'),
      ])
    ]);

    AnnotatedResponses annotatedResponses =
        await googleVision.annotate(requests: requests);

    String text = '';
    text = annotatedResponses.responses[0].fullTextAnnotation!.text ?? '';
    return text;
  }
}
