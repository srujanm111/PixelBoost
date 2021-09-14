import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:url_strategy/url_strategy.dart';

const lightBlue = Color(0xFF95D8EB);
const midBlue = Color(0xFF4DB4D7);
const darkBlue = Color(0xFF0076BE);

const srcnnUrl = 'https://srcnnimg.herokuapp.com/predict';

void main() {
  setPathUrlStrategy();
  runApp(PixelBoost());
}

class PixelBoost extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PixelBoost',
      theme: ThemeData(
        fontFamily: 'Raleway'
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

Future<Uint8List> useSrcnn(PlatformFile file, bool refine) async {
  final base64image = base64Encode(file.bytes);

  final dio = Dio();
  final response = await dio.post(
    srcnnUrl,
    data: json.encode({'image': base64image, 'enlarge': !refine}),
    options: Options(headers: {
      'Content-Type': 'application/json',
    })
  );

  var image = response.data['image'];
  image = base64Decode(image);

  return image;
}