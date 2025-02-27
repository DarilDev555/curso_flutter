import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final String imageUrl = "http://192.168.1.82:8000/api/img/50.png";
  final String token = "1|i0061BhQGYd2PuxcCM0yb2AFpyEmZhQLk8IVfw7S0c53c322";
  Uint8List? imageBytes;

  Future<void> fetchImage() async {
    try {
      Dio dio = Dio();
      Response<List<int>> response = await dio.get<List<int>>(
        imageUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );
      setState(() {
        imageBytes = Uint8List.fromList(response.data!);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Imagen desde Laravel")),
      body: Center(
        child:
            imageBytes == null
                ? CircularProgressIndicator()
                : Image.memory(imageBytes!),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ImageScreen()));
}
