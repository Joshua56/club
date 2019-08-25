import 'package:club/modules/club_module.dart';
import 'package:club/club_list_view.dart';
import 'package:club/modules/user_module.dart';
import 'package:club/ui/club_detail_page.dart';
import 'package:club/ui/clubs_display_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
void main(){
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: MainPage(),
    home: ClubsDisplayPage(),
  ));
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black12,
            child: Center(child: Text("Map placeholder"),),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(builder: (context) => ClubModule()),
                ChangeNotifierProvider(builder: (context) => UserModule()),
              ],              
              child: ClubListView()
              ),
          ),
        ],
      ),

    );
  }
}

