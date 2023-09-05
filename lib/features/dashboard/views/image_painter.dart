import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';

class ImagePainterView extends StatefulWidget {
  final File imageFile;
  final Function(File) onImageEdited;
  const ImagePainterView(
      {super.key, required this.imageFile, required this.onImageEdited});

  @override
  ImagePainterViewState createState() => ImagePainterViewState();
}

class ImagePainterViewState extends State<ImagePainterView> {
  final _imageKey = GlobalKey<ImagePainterState>();

  void saveImage() async {
    final image = await _imageKey.currentState!.exportImage();

    File file = File(
        '/data/user/0/com.example.gristum_notes_app/cache/${DateTime.now().toString()}.jpg');
    final editedImage = await file.writeAsBytes(image!);
    if (widget.imageFile == editedImage) {
      return;
    }
    widget.onImageEdited(editedImage);
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // final image = await _imageKey.currentState?.exportImage();
    // final directory = (await getApplicationDocumentsDirectory()).path;
    // await Directory('$directory/sample').create(recursive: true);
    // final fullPath =
    //     '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    // final imgFile = File('$fullPath');
    // if (image != null) {
    //   imgFile.writeAsBytesSync(image);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       backgroundColor: Colors.grey[700],
    //       padding: const EdgeInsets.only(left: 10),
    //       content: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           const Text("Image Exported successfully.",
    //               style: TextStyle(color: Colors.white)),
    //           TextButton(
    //             onPressed: () => OpenFile.open("$fullPath"),
    //             child: Text(
    //               "Open",
    //               style: TextStyle(
    //                 color: Colors.blue[200],
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // --------------------
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Painter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: saveImage,
          )
        ],
      ),
      body: ImagePainter.file(
        widget.imageFile,
        key: _imageKey,
        scalable: true,
        initialStrokeWidth: 2,
        textDelegate: TextDelegate(),
        initialColor: Colors.green,
        initialPaintMode: PaintMode.line,
      ),
    );
  }
}
