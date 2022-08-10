// import 'dart:js';

import 'package:blog_app/services/crud.dart';
import 'package:blog_app/views/create_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  CrudMethods crudMethods = new CrudMethods();

  // QuerySnapshot blogsSnapshot;
  // List<BlogModel> blogsSnapshot;
  Stream blogsStream;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    crudMethods.getData().then((result){
      setState(() {
        blogsStream = result;
      });
      // print(blogsSnapshot.docs[0].data());
    });
  }




  Widget blogList(){
    return Container(
      child: blogsStream!=null ?  Column(
        children: <Widget>[
          StreamBuilder(
              stream: blogsStream,
              builder: (context, snapshot){
                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    // itemCount: blogsSnapshot.docs.length,
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return BlogsTile(
                        imageUrl: snapshot.data.docs[index].get('imageUrl'),
                        authorName: snapshot.data.docs[index].get('authorName'),
                        title: snapshot.data.docs[index].get('title'),
                        description: snapshot.data.docs[index].get('desc'),
                      );
                    }) ;
              })

        ],
      ) : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text('Blogger',
              style: TextStyle(
                fontSize: 25,
              ),),
          Text("Spot",
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue,
              ),)
        ],),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: blogList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog()));
                },
                child: Icon(Icons.add),)
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  // const ({Key? key}) : super(key: key);
  String imageUrl;
  String authorName;
  String title;
  String description;
  BlogsTile({@required this.imageUrl,@required this.authorName,@required this.title,@required this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
              )),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4,),
                Text(description,
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                ),
                SizedBox(height: 4,),
                Text(authorName,
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

