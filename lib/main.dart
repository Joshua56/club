import 'package:club/modules/club_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:club/ui/root_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ClubModule()),
        ChangeNotifierProvider(builder: (context) => UserModule()),
        ChangeNotifierProvider(builder: (context) => ReservationModule()),
      ],
      child: RootPage(),
    ),
  ));
}

