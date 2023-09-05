// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/features/dashboard/views/video_player_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../core/utils.dart';
import '../../../models/stump_model.dart';
import '../widgets/stump_details_field.dart';

class AddorEditStumpView extends ConsumerStatefulWidget {
  final Function(StumpModel)? addStumpToProject;
  final StumpModel? editableStump;
  const AddorEditStumpView(
      {super.key, this.addStumpToProject, this.editableStump});

  @override
  ConsumerState<AddorEditStumpView> createState() => _AddStumpViewState();
}

class _AddStumpViewState extends ConsumerState<AddorEditStumpView> {
  final _formKey = GlobalKey<FormState>();

  File? _pickedImage;
  // File? _pickedVideo;
  List<File> _images = [];

  String _height = '0';
  String _width = '0';
  String _price = '0';
  String _cost = '0';

  String _note = '';

  void getStumpPrice(double height, double width, double price) {
    // Tree dimensions
    double widthInch = double.parse(_width);
    double heightInch = double.parse(_height);

    // Price per inch for width
    double widthPricePerInch = double.parse(_price);

    // Calculate total price for width
    double totalWidthPrice = widthInch * widthPricePerInch;

    // Calculate price for height
    double heightPrice = 0;

    if (heightInch > 24) {
      // Price for the first 12 inches (free)
      heightPrice += totalWidthPrice * 0 * 12;

      // Price for the next 12 inches (from 12 - 24 inches)
      heightPrice += totalWidthPrice * 0.01 * (heightInch - 24 - 12);

      // Price for anything above 24 inches
      heightPrice += totalWidthPrice * 0.2;
    } else if (heightInch > 12) {
      // Price for the first 12 inches (free)
      heightPrice += totalWidthPrice * 0 * 12;

      // Price for the next (heightInch - 12) inches
      heightPrice += totalWidthPrice * 0.01 * (heightInch - 12);
    } else {
      // Price for the first (heightInch) inches (free)
      heightPrice += totalWidthPrice * 0 * heightInch;
    }

    // Calculate total cutting price
    double totalCuttingPrice = totalWidthPrice + heightPrice;
    setState(() {
      _cost = totalCuttingPrice.ceil().toString();
    });
  }

  void _onPickImage() async {
    _pickedImage = await pickImage();
    if (_pickedImage != null) {
      _images.add(_pickedImage!);
    }
    setState(() {});
  }

  // void _onPickVideo() async {
  //   final pickedVideo = await pickVideo();
  //   if (pickedVideo != null) {
  //     setState(() {
  //       _pickedVideo = pickedVideo;
  //     });
  //   }
  // }

  void addStump() {
    if (_height == '0' ||
        _width == '0' ||
        _images.isEmpty ||
        _height.isEmpty ||
        _width.isEmpty) {
      showSnackbar(context, 'Must add height, width & image(s)');
      return;
    }

    List<String> listOfImagePaths = [];
    for (var element in _images) {
      listOfImagePaths.add(element.path);
    }

    StumpModel stump = widget.editableStump == null
        ? StumpModel(
            width: double.parse(_width),
            height: double.parse(_height),
            price: double.parse(_price),
            imagesPath: listOfImagePaths,
            cost: double.parse(_cost),
            note: _note,
            videoPath: _videoFile != null ? _videoFile!.path : '',
          )
        : widget.editableStump!.copyWith(
            width: double.parse(_width),
            height: double.parse(_height),
            price: double.parse(_price),
            imagesPath: listOfImagePaths,
            cost: double.parse(_cost),
            note: _note,
            videoPath: _videoFile != null ? _videoFile!.path : '',
          );

    // ref.read(singleProjectControllerProvider.notifier).addStump(stump);

    widget.addStumpToProject!(stump);

    Navigator.of(context).pop();
  }

  // -------------
  File? _videoFile;
  late VideoPlayerController _controller;

  Future<void> pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      setState(() {
        _videoFile = videoFile;
        _controller = VideoPlayerController.file(videoFile)
          ..initialize().then((_) {
            _controller.setLooping(true);
            setState(() {});
          });
      });
    }
  }

  void setVideo(String existingVideoPath) {
    setState(() {
      _videoFile = File(existingVideoPath);
      _controller = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          _controller.setLooping(true);
          setState(() {});
        });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/placeholder.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {});
      });

    if (widget.editableStump != null) {
      List<File> imageList = [];

      for (String i in widget.editableStump!.imagesPath) {
        imageList.add(File(i));
      }

      if (widget.editableStump!.videoPath != '') {
        setState(() {
          setVideo(widget.editableStump!.videoPath.toString());
        });
      }

      setState(() {
        _height = widget.editableStump!.height.toString();
        _width = widget.editableStump!.width.toString();
        _price = widget.editableStump!.price.toString();
        _cost = widget.editableStump!.cost.toString();
        _note = widget.editableStump!.note;
        _images = imageList;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  // -------------

  @override
  Widget build(BuildContext context) {
    getStumpPrice(
        double.parse(_height), double.parse(_width), double.parse(_price));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editableStump == null ? 'Add Stump' : 'Edit Stump'),
        actions: [
          IconButton(
            onPressed: addStump,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StumpDetailsField(
                initialValue: _height,
                labelText: 'Height',
                onSetState: (String value) {
                  setState(() {
                    _height = value;
                  });
                },
              ),
              StumpDetailsField(
                initialValue: _width,
                labelText: 'Width',
                onSetState: (String value) {
                  setState(() {
                    _width = value;
                  });
                },
              ),
              StumpDetailsField(
                initialValue: _price,
                labelText: 'Price Per Inch',
                onSetState: (String value) {
                  setState(() {
                    _price = value;
                  });
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: StumpDetailsField(
                      initialValue: _note,
                      needColumn: false,
                      labelText: 'Notes',
                      onSetState: (String value) {
                        setState(() {
                          _note = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Card(
                    child: SizedBox(
                      width: 50,
                      height: 45,
                      child: IconButton(
                        onPressed: pickVideo,
                        icon: const Icon(Icons.video_camera_back),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Card(
                    child: SizedBox(
                      width: 50,
                      height: 45,
                      child: IconButton(
                        onPressed: _onPickImage,
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (_videoFile != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerView(videoFile: _videoFile!),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 5),
              if (_images.isNotEmpty)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: _images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Container(
                              height: 300,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 10,
                              child: CircleAvatar(
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _images.remove(_images[index]);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      // -----------------------------------------------------------------------
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Center(child: Text('Total : \$ $_cost')),
      ),
    );
  }
}
