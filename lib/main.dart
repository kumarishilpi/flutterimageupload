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
  List<int> allIndexSelectedList=List<int>();
  Future<File> _imageFile;
  int tempIndex;
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
                    child: Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                // images.removeAt( images);
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
                          _uploadMultiple(images, i);

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
    "JSONToken=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdXBlcm1hbiIsImF1ZGllbmNlIjoidW5rbm93biIsImNyZWF0ZWQiOjE2MDc0MDg4ODEzODIsImV4cCI6MTYwNzQ1MjA4MSwiZmFjaWxpdHkiOjB9.7gu7NN8FWDCdJ-6SrbSNSXJz3p0LbUceDsuqVjqFNOzSkdQQn8a-WsegLYsXDEHhdsC6jg5rSH-Kb5nEX3NMAA";
    dio.post(endPoint, data: data).then((response) {
      print("shilpi $response.$data");
      setState(() {
        ImageUploadModel uploadModel = images[index];
        uploadModel.isUploaded = true;
      });
//_getDocument(response.data);
    }).catchError((error) => {print(error)});
  }
//   void _upload(ImageUploadModel file, index) async {
//     String fileName = file.imageFile.path.split('/').last;
//     var fileSize = await file.imageFile.length();
//     endPoint +=
//         "resumableChunkNumber=1&resumableChunkSize=1048576&resumableCurrentChunkSize=" +
//             fileSize.toString() +
//             "&resumableTotalSize=" +
//             fileSize.toString() +
//             "&resumableType=image%2Fjpeg&resumableIdentifier=" +
//             fileName +
//             "&resumableFilename=" +
//             fileName +
//             "&resumableRelativePath=" +
//             fileName +
//             "&resumableTotalChunks=1";
//     FormData data = FormData.fromMap({
//       "resumableChunkNumber": 1,
//       "resumableChunkSize": 1048576,
//       "resumableCurrentChunkSize": fileSize,
//       "resumableTotalSize": fileSize,
//       "resumableType": "image/jpeg",
//       "resumableIdentifier": fileName,
//       "resumableFilename": fileName,
//       "resumableRelativePath": fileName,
//       "resumableTotalChunks": 1,
//       "file": await MultipartFile.fromFile(
//         file.imageFile.path,
//         filename: fileName,
//       ),
//     });
//     print({
//       "resumableChunkNumber": 1,
//       "resumableChunkSize": 1048576,
//       "resumableCurrentChunkSize": fileSize,
//       "resumableTotalSize": fileSize,
//       "resumableType": "image/jpeg",
//       "resumableIdentifier": fileName,
//       "resumableFilename": fileName,
//       "resumableRelativePath": fileName,
//       "resumableTotalChunks": 1,
//       "file": await MultipartFile.fromFile(
//         file.imageFile.path,
//         filename: fileName,
//       ),
//     });
//     Dio dio = new Dio();
// dio.options.headers[HttpHeaders.COOKIE] =
// "JSONToken=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdXBlcm1hbiIsImF1ZGllbmNlIjoidW5rbm93biIsImNyZWF0ZWQiOjE2MDczMjQwODk5NzAsImV4cCI6MTYwNzM2NzI4OSwiZmFjaWxpdHkiOjB9.K3JT0XXt3dc_m_Ea7y8q7LzJQaaH-p-KKHz0Y4XXqNno8xAtXiBCnR9TZ_PdxHR3DED_HIH_27cc6ePkG1qgOw";
//     dio.post(endPoint, data: data).then((response) {
//       print("shilpi $response.$data");
//       setState(() {
//         ImageUploadModel uploadModel = images[index];
//         uploadModel.isUploaded = true;
//       });
// //_getDocument(response.data);
//     }).catchError((error) => {print(error)});
//   }

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
                    right: 5,
                    top: 5,
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 25,
                      color: Colors.green,
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

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 480, maxHeight: 600);
// getFileImage(index);
      _imageFile.then((file) {
        if (file != null) {
          setState(() {
            print(" shilpi filename$_imageFile");
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

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;
  bool isSelected;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
    this.isSelected,
  });
}
