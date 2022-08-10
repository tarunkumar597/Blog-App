import 'dart:io';
import 'package:blog_app/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateBlog extends StatefulWidget {
  // const CreateBlog({Key? key}) : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String authorName;
  String title;
  String desc;

  CrudMethods crudMethods = new CrudMethods();

  File selectedImage;

  bool _isLoading = false;

  Future getImage() async{
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image.path);
    });
  }

  uploadBlog() async{
    if(selectedImage!=null){
      setState(() {
        _isLoading = true;
      });
      Reference firebaseStorageref = FirebaseStorage.instance.ref().child("blogImages").child("${randomAlphaNumeric(9)}.jpg");
      // final StorageUploadTask
      final UploadTask task = firebaseStorageref.putFile(selectedImage);
      var downloadUrl = await (await task).ref.getDownloadURL();
      // print('///////////${downloadUrl}/////////////');
      Map<String,String> blogMap = {
        "imageUrl" : downloadUrl,
        "authorName" : authorName,
        "title" : title,
        "desc" : desc,
      };

      crudMethods.addData(blogMap).then((result) {
    Navigator.pop(context);
    });

    }
    else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Blog',
              style: TextStyle(
                fontSize: 25,
              ),),
            Text("APP",
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue,
              ),)
          ],),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: selectedImage !=null ? Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.file(
                    selectedImage, 
                    fit: BoxFit.cover,
                  ),
                ),
              ) : Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0)
                ),
                child: Icon(Icons.add_a_photo,
                        color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 8,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Author Name"),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Title"),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description"),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
