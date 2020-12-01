import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(new SingleImageUpload());

class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  var endPoint =
      'http://shifajeddah.nuacare.ai/nuacare-core/rest/nuacare/v1/file/resumableUpload/hr?';
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images.add("Add Image");
    });
  }



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Upload image'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),
      ),
    );
  }

  void _upload(ImageUploadModel file, index) async {
    String fileName = file.imageFile.path.split('/').last;
    var fileSize = await file.imageFile.length();
    endPoint +=
        "resumableChunkNumber=1&resumableChunkSize=1048576&resumableCurrentChunkSize=" +
            fileSize.toString() +
            "&resumableTotalSize=" +
            fileSize.toString() +
            "&resumableType=image%2Fjpeg&resumableIdentifier=" +
            fileName +
            "&resumableFilename=" +
            fileName +
            "&resumableRelativePath=" +
            fileName +
            "&resumableTotalChunks=1";
    FormData data = FormData.fromMap({
      "resumableChunkNumber": 1,
      "resumableChunkSize": 1048576,
      "resumableCurrentChunkSize": fileSize,
      "resumableTotalSize": fileSize,
      "resumableType": "image/jpeg",
      "resumableIdentifier": fileName,
      "resumableFilename": fileName,
      "resumableRelativePath": fileName,
      "resumableTotalChunks": 1,
      "file": await MultipartFile.fromFile(
        file.imageFile.path,
        filename: fileName,
      ),
    });
    print({
      "resumableChunkNumber": 1,
      "resumableChunkSize": 1048576,
      "resumableCurrentChunkSize": fileSize,
      "resumableTotalSize": fileSize,
      "resumableType": "image/jpeg",
      "resumableIdentifier": fileName,
      "resumableFilename": fileName,
      "resumableRelativePath": fileName,
      "resumableTotalChunks": 1,
      "file": await MultipartFile.fromFile(
        file.imageFile.path,
        filename: fileName,
      ),
    });
    Dio dio = new Dio();
    dio.options.headers[HttpHeaders.COOKIE] =
    "JSONToken=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdXBlcm1hbiIsImF1ZGllbmNlIjoidW5rbm93biIsImNyZWF0ZWQiOjE2MDY4MTE4MjU0MzgsImV4cCI6MTYwNjg1NTAyNSwiZmFjaWxpdHkiOjB9.0FNqqyhMvZ3Xq6n459q3lA_udOFt665nnhXR33zBMO7xBhzlvDxR3WVp4ifilN2IzxN7wps0p0hMr7yfUy9d8g";
    dio.post(endPoint, data: data).then((response) {
      print(response.data);
      setState(() {
        ImageUploadModel uploadModel = images[index];
        uploadModel.isUploaded = true;
      });
      //_getDocument(response.data);
    }).catchError((error) => {print(error)});
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          if (uploadModel.isUploaded == false) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    uploadModel.imageFile,
                    width: 300,
                    height: 300,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          images.replaceRange(index, index + 1, ['Add Image']);
                        });
                      },
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.file_upload,
                        size: 20,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        _upload(uploadModel, index);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    uploadModel.imageFile,
                    width: 300,
                    height: 300,
                  ),
                  Positioned(
                    right: 50,
                    top: 50,
                    child: InkWell(
                      child: Icon(
                        Icons.thumb_up,
                        size: 20,
                        color: Colors.green,
                      ),
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 480, maxHeight: 600);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      images.add("Add Image");
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
