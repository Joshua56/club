import 'package:club/modals/product_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ClubModal{
  final String id;
  final String name;
  final String image;
  final List<TableModal> tables;
  final List<ProductModal> products;
  final LatLng position;
  final String locationLabel;


  // TODO: 
  // icon
  // reviews
  // rating

  ClubModal({
    this.id = '1',
    @required this.name,
    this.image,
    this.position,
    this.locationLabel,
    this.tables = const[],
    this.products = const [],
  });

  get totalNoTables => tables.length;
  get key => _key();
  get marker => _marker();


  String _key(){
    return position.latitude.toString()+'-' + position.longitude.toString();
  }

  Marker _marker (){
  return Marker(
      markerId: MarkerId(_key()),
      position: position,
      infoWindow: InfoWindow(title: name),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
    );
  }

  

}

