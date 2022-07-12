import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class ImageCapture extends StatefulWidget {
  final File? image;
  final Function(File?)? imageCallback;

  const ImageCapture({Key? key, this.imageCallback, this.image}) : super(key: key);
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _imageFile;
  late TextEditingController _postDescriptionController;

  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, maxHeight: 1920, maxWidth: 1920);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  // Future<void> _cropImage() async{
  //   File? cropped = await ImageCropper().cropImage(
  //     sourcePath: _imageFile!.path,
  //     androidUiSettings: const AndroidUiSettings(toolbarTitle: 'Crop Image'),
  //     iosUiSettings: const IOSUiSettings(title: 'Crop Image'),
  //   );
  //
  //
  //   setState(() {
  //     _imageFile = cropped ?? _imageFile;
  //   });
  // }

  Future<void> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFile!.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );
    if (croppedFile != null) {
      _imageFile = File(croppedFile.path);
      setState(() {});
    }
  }

  void _clear() {
    setState(() {
      _imageFile = null;
      widget.imageCallback!(_imageFile);
    });
  }

  @override
  void initState() {
    super.initState();
    _imageFile = widget.image;
    _postDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _postDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                heroTag: 'gallery',
                child: Icon(Icons.photo_library, color: AppColors.primaryRed,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  heroTag: 'camera',
                  child: Icon(Icons.camera_alt, color: AppColors.primaryRed,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: _imageFile != null ? _cropImage : (){},
                  heroTag: 'crop',
                  child: Icon(Icons.crop, color: AppColors.primaryRed,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: _clear,
                  heroTag: 'clear',
                  child: Icon(Icons.refresh, color: AppColors.primaryRed,),
                ),
              ),
            ],
          ),

          // Preview the image and crop it
          body: SafeArea(
            top: true,
            bottom: true,
            child: Container(
              color: Colors.grey[400],
              child: Stack(
                children: <Widget>[
                  if (_imageFile != null) ...[

                    Container(
                      alignment: Alignment.center,
                      child: Image.file(_imageFile!, fit: BoxFit.cover,),
                    ),

                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primaryRed,
                        onPressed: () {
                          widget.imageCallback!(_imageFile);
                          Navigator.pop(context);
                        },
                        heroTag: 'done',
                        child: const Icon(Icons.check, color: Colors.white,),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 15,
          child: SizedBox(
            width: 25,
            child: TextButton(
              child: const Icon(Icons.clear, color: Colors.white, size: 25,),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
