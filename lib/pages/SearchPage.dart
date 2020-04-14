import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
    Future<QuerySnapshot> futureSearchResults;


  searchPageHeader()
  {
    
    emptyTheTextFormField()
    {
      searchTextEditingController.clear();
    }

    controlSearch(String str){
      Future<QuerySnapshot> allUsers= userReference.where("profileName", isGreaterThanOrEqualTo: str).getDocuments();
      setState(() {
        futureSearchResults=allUsers;
      });
    }


    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        style : TextStyle(
          fontSize:20.0,
          color:Colors.white
          ),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Alohomora ...",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            prefixIcon: Icon(Icons.person_pin,color: Colors.white,size: 17.0,),
            suffixIcon: IconButton(icon: Icon(Icons.clear,color: Colors.white), onPressed: emptyTheTextFormField,),
          ),
          onFieldSubmitted: controlSearch,
      ),
    );

  }

  Container displayNoSearchResultsScreen()
  {
    final Orientation orientation=MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group,color:Colors.grey,size:100.0,),
            Text("Search Users..",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 25.0),
            ),

          ]
        ),
      ),

    );
  }

  displayUserFoundScreen(){
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapShot){
        if(!dataSnapShot.hasData){
          return circularProgress();
        }
        List<UserResult> searchUsersResult= [];
        dataSnapShot.data.documents.forEach((document)
        {
          User eachUser= User.fromDocument(document);
          UserResult userResult= UserResult(eachUser);
          searchUsersResult.add(userResult);
        });
        return ListView( children : searchUsersResult);
      },
    );
  }

  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searchPageHeader(),
      body: futureSearchResults == null ? displayNoSearchResultsScreen():displayUserFoundScreen(),
    );
  }
}

class UserResult extends StatelessWidget {

  final User eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children : <Widget>[
            GestureDetector(
              onTap:() => print("Yeah ..Tapped") ,
              child: ListTile(
                leading : CircleAvatar(backgroundColor:Colors.black ,
                backgroundImage: CachedNetworkImageProvider(eachUser.url),),
                title: Text(eachUser.profileName, style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),),
                subtitle: Text(eachUser.username, style: TextStyle(
                   color: Colors.black,
                  fontSize: 13.0,
                  
                ),),
              ),
              ),
          ]
        ),
      ),
      );
  }
}
