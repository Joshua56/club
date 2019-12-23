import 'dart:io';

import 'package:club/auth/authentication.dart';
import 'package:club/modals/club_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClubCreate extends StatefulWidget {
  @override
  _ClubCreateState createState() => _ClubCreateState();
}

class _ClubCreateState extends State<ClubCreate> {

  // Position _userLocation;

  TextEditingController _clubNameController = TextEditingController();
  TextEditingController _clubLocationLabelController = TextEditingController();
  TextEditingController _clubLatitudeController = TextEditingController();
  TextEditingController _clubLongitudeController = TextEditingController();
  File _imageChoosen;

  BaseAuth _auth = Auth();

  Future<String> _userId ()async{
    FirebaseUser _user = await _auth.getCurrentUser();
    return _user.uid;
  }


  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<ClubModule>(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // name
                  TextField(
                    controller: _clubNameController,
                    decoration: InputDecoration(
                      labelText: 'Club Name:'
                    ),
                  ),

                  
                  

                  // location label
                  TextField(
                    controller: _clubLocationLabelController,
                    decoration: InputDecoration(
                      labelText: 'Position Label:'
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // position latitude
                            TextField(
                              controller: _clubLatitudeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Position Latitude:'
                              ),
                            ),

                            // position latitude
                            TextField(
                              controller: _clubLongitudeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Position Longitude:'
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                    
                    ],
                  ),
                  SizedBox(height: 10,),

                  // image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: (){
                          ImagePicker.pickImage(source: ImageSource.gallery).then((value){
                            setState(() {
                              _imageChoosen = value;
                            });
                          });
                        },
                        child: Text("Pick image"),
                      ),
                      SizedBox(width: 10,),
                      _imageChoosen == null ? Container() : Image.file(_imageChoosen, height: 150,),
                    ],
                  ),

                  SizedBox(height: 12,),
                  MaterialButton(
                    color: Colors.blue,
                    minWidth: 300,
                    child: Text("Create"),
                    onPressed: () async{
                      String _id = await _userId();
                      // 
                      // upload image first
                      clubModule.uploadImage(_imageChoosen).then((url){
                        ClubModal _newClub = ClubModal(
                          name: _clubNameController.text,
                          position: LatLng(double.parse(_clubLatitudeController.text), double.parse(_clubLongitudeController.text)),
                          locationLabel: _clubLocationLabelController.text,
                          image: url,
                          users: [_id]
                        );

                        clubModule.createClub(_newClub);

                      });

                      Navigator.pop(context);

                    },
                  ),

                ],
              ),
            );
        },
      ),
    );
    
  }
}