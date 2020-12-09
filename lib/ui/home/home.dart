
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/models/image_upload_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var endPoint =
      'http://shifajeddah.nuacare.ai/nuacare-core/rest/nuacare/v1/file/resumableUpload/hr?';
  List<Object> images = List<Object>();
  List<int> allIndexSelectedList=List<int>();
  Future<File> _imageFile;
  int tempIndex;
  List<int> templist=List<int>();
  ImageUploadModel uploadModelTemp;

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
          title: const Text('Click and Upload image'),
        ),
        body: Column(
          children: <Widget>[

            Expanded(
              child: buildGridView(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                allIndexSelectedList.length>=1?Positioned(
                  right: 20,
                  top: 50,
                  child: InkWell(
                    child:
                    Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {

                        for(int i=0; i<allIndexSelectedList.length; ++i) {
                          images.removeAt(allIndexSelectedList[i]);
                          deleteMultipleImages(images, allIndexSelectedList[i]);
                        }
                      });
                    },
                  ),
                ):Container(),
                allIndexSelectedList.length>=1?Positioned(
                  right: 50,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.file_upload,
                      size: 25,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      // if(allIndexSelectedList.length==1){
                      //   _upload(uploadModelTemp, tempIndex);
                      // }else{
                      for(int i=0; i<=allIndexSelectedList.length;++i){
                        _uploadMultiple(images, allIndexSelectedList[i]);

                      }


                    },
                  ),
                ):Container(),
              ],
            )
          ],
        ),
      ),
    );
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
                  GestureDetector(
                    onDoubleTap: (){
                      setState(() {
                        print("image selected of index "+index.toString());
                        allIndexSelectedList.add(index);
                        // allIndexSelectedList.toSet().toList();
                        // new Collection(allIndexSelectedList).distinct();
                        uploadModel.isSelected=true;
                        tempIndex=index;
                        uploadModelTemp=uploadModel;
                      });


                    },
                    child: Image.file(
                      uploadModel.imageFile,
                      width: 300,
                      height: 300,
                    ),
                  ),
                  //     GestureDetector(
                  //
                  //     // When the child is tapped, show a snackbar.
                  //         onTap: () {
                  //           // here, Scaffold.of(context) returns the locally created Scaffold
                  //           Scaffold.of(context).showSnackBar(SnackBar(
                  //               content: Text('Hello.')
                  //           ));
                  //         }
                  // )
                  uploadModel.isSelected?
                  Positioned(
                    right: 25,
                    top: 5,

                    child: Icon(
                      Icons.check_circle_sharp,
                      size: 25,
                      color: Colors.blue,
                    ),
                  ):Container(),

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

  void _uploadMultiple(List<Object> fileList, index) async {
    ImageUploadModel file = fileList[index];
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
    "JSONToken=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdXBlcm1hbiIsImF1ZGllbmNlIjoidW5rbm93biIsImNyZWF0ZWQiOjE2MDc0ODgyNzUyNjYsImV4cCI6MTYwNzUzMTQ3NSwiZmFjaWxpdHkiOjB9.M06c8QnZMxnYb6QNugiEaQ2Z7m5b1AQn3xH-jYn8uaDG7o1GDJHGbhmrccyRuYiZGZ5Jxa-G5Xl4RjaD7LqIUQ";
    dio.post(endPoint, data: data).then((response) {
      print("shilpi" +response.data);
      setState(() {
        ImageUploadModel uploadModel = images[index];
        uploadModel.isUploaded = true;
      });
//_getDocument(response.data);
    }).catchError((error) => {print(error)});
  }

  Future<void> deleteMultipleImages(List<Object> fileList, index) async {
    try {
      ImageUploadModel file1 = fileList[index];
      var file = File(file1.imageFile.path);

      if (await file.exists()) {
        // file exits, it is safe to call delete on it
        await file.delete();
      }

    } catch (e) {
      // error in getting access to the file
    }
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 480, maxHeight: 600);
// getFileImage(index);
      _imageFile.then((file) {
        if (file != null) {
          setState(() {
            print(" shilpi filename"+_imageFile.toString());
            getFileImage(index);
          });
        }
      });

    });
  }

  void getFileImage(int index) async {
// var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      images.add("Add Image");
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        imageUpload.isSelected = false;
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }
}
