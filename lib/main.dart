import 'package:club/ui/clubs_display_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main(){
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: MainPage(),
    home: ClubsDisplayPage(),
  ));
}
