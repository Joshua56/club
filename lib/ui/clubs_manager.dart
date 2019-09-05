import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/modals/club_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/ui/club_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';



class ClubsManager extends StatelessWidget {

  TextEditingController _clubNameController = TextEditingController();
  TextEditingController _clubLocationLabelController = TextEditingController();
  TextEditingController _clubLatitudeController = TextEditingController();
  TextEditingController _clubLongitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      final clubModule = Provider.of<ClubModule>(context);
      final reservationModule  = Provider.of<ReservationModule>(context);
      List<Widget> _clubsHolder(List<ClubModal> clubz){
      List<Widget> lst=[];
      clubz.forEach((ClubModal item){
        lst.add(
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ClubDetail(clubId: item.id,)));
            },
            onLongPress: (){
              clubModule.deleteClub = item.id;
            },
            leading: Image.network(item.image),
            title: Text(item.name.toString()),
            subtitle: Text(item.position.toString()),
          )
        );
      });
      return lst;
      }
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('clubs').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Fetching.......');
                break;
              case ConnectionState.none:
                return Text('Check your connection');
                break;
              default:

              
              return SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: _clubsHolder(clubModule.convertToClubModal(snapshot.data.documents)),));
            }
            
          },
      ),
      floatingActionButton: IconButton(
        color: Colors.blue,
        icon:Icon(Icons.add,size: 39,),
        onPressed: (){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return Column(
                children: <Widget>[
                  // name
                  TextField(
                    controller: _clubNameController,
                    decoration: InputDecoration(
                      labelText: 'Club Name:'
                    ),
                  ),

                  // image
                  // RaisedButton(
                  //   onPressed: (){},
                  //   child: Text("Pick image"),
                  // ),

                  // location label
                  TextField(
                    controller: _clubLocationLabelController,
                    decoration: InputDecoration(
                      labelText: 'Position Label:'
                    ),
                  ),

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
                  SizedBox(height: 12,),
                  RaisedButton(
                    child: Text("Create"),
                    onPressed: (){
                      ClubModal _newClub = ClubModal(
                        name: _clubNameController.text,
                        position: LatLng(double.parse(_clubLatitudeController.text), double.parse(_clubLongitudeController.text)),
                        locationLabel: _clubLocationLabelController.text,
                        image: 'https://images.freeimages.com/images/small-previews/280/clubbing-in-london-1-1519219.jpg'
                      );
                      clubModule.createClub(_newClub);
                    },
                  ),

                ],
              );
            }
          );
        },
      ),
    );
  }
}