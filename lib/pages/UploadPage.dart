import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File file;

  captureImageWithCamera() async{ 

    Navigator.pop(context);
    File imageFile= await ImagePicker.pickImage(source: ImageSource.camera,
    maxHeight: 680,
    maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });

  }

  pickImageFromGallery() async{

    Navigator.pop(context);
    File imageFile= await ImagePicker.pickImage(source: ImageSource.gallery,
    );
    setState(() {
      this.file = imageFile;
    });

  }

  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (context){

        return SimpleDialog(
          title: Text("New Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Take a photo", style: TextStyle(color : Colors.white,),),
              onPressed: captureImageWithCamera,
            ),
             SimpleDialogOption(
              child: Text("Browse Image from Gallery", style: TextStyle(color : Colors.white,),),
              onPressed: pickImageFromGallery,
            ),
             SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color : Colors.white,),),
              onPressed: ()=>Navigator.pop(context),
            ),
            
          ],
        );

      },
      );
  }

  displayUploadScreen(){
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment:MainAxisAlignment.center ,
        children: <Widget>[
          Icon(Icons.add_photo_alternate,color: Colors.grey,size:100.0,),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius : BorderRadius.circular(7.0),),
              child: Text("Upload Image",style: TextStyle(color:Colors.white, fontSize: 20.0,),),
              color: Colors.blue,
              onPressed:() => takeImage(context),
              ),
            ),
        ],
      ),
    );

  }






  @override
  Widget build(BuildContext context) {
    return displayUploadScreen();
  }
}
