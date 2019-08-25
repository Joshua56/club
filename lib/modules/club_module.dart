import 'package:club/modals/club_modal.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';


class ClubModule extends ChangeNotifier{

  // Firebase
  final databaseReference = FirebaseDatabase.instance.reference();

  // List<ClubModal> _clubs;

  // with exaples
  static List<ProductModal> _productsRezzy = [
    ProductModal(id:'1', name: 'drink 1', price: 200),
    ProductModal(id:'2', name: 'drink 2', price: 340),
    ProductModal(id:'3', name: 'drink 3', price: 600),
    ProductModal(id:'4', name: 'drink 4', price: 800),
    ProductModal(id:'5', name: 'drink 5', price: 1000),
  ];

  static List<ProductModal> _productsResnet50 = [
    ProductModal(id:'1', name: 'drink 1', price: 200),
    ProductModal(id:'2', name: 'drink 2', price: 340),
    ProductModal(id:'3', name: 'food 1', price: 300),
    ProductModal(id:'4', name: 'drink 4', price: 800),
    ProductModal(id:'5', name: 'food 2', price: 650),
  ];

  List<ClubModal> _clubs =[
    ClubModal(
      id: '1',
      name: 'rezzy',
      image: "assets/images/club1.jpg",
      position: LatLng(-1.290500, 36.823028),
      locationLabel: "Koinange St, Nairobi",
      tables: [
        TableModal(id: '1', maxNoChairs: 6, minNoChairs: 3, reserveCostPerChair: 50),
        TableModal(id: '2', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 50),
        TableModal(id: '3', maxNoChairs: 2, reserveCostPerChair: 50),
        TableModal(id: '4', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 50),
      ],
      products: _productsRezzy,
    ),
    ClubModal(
      id: '2',
      name: 'resnet50',
      image: "assets/images/club1.jpg",
      position: LatLng(-1.284486, 36.819134),
      locationLabel: "Koinange St, Nairobi",
      tables: [
        TableModal(id: '2', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 100),
        TableModal(id: '3', maxNoChairs: 2, reserveCostPerChair: 100),
        TableModal(id: '4', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 100),
      ],
      products: _productsResnet50,
    ),
  ];

  Set<Marker> _markers (){
    final Set<Marker> lst = {};

    _clubs.forEach((item){
      lst.add(item.marker);
    });
    return lst;
  }

  ClubModal _getClub(String key){
    ClubModal club;
    _clubs.forEach((item){
      if(item.key == key){
        club = item;
      }
    });
    return club;
  }


  get clubs => _clubs;
  get clubsCount => _clubs.length;
  Set<Marker> get markers => _markers();
  get getClub => (key) { return _getClub(key); };


  // set _setRestaurant(List<ClubModal> lst) {
  //   _restaurant = lst;
  //   notifyListeners();
  // }

  set addRestaurant(ClubModal restaurant){
    _clubs.add(restaurant);
    notifyListeners();
  }

  // id is preffered since each restaurant will have a unique id/key
  // set deleteRestaurant(String id)
  set deleteRestaurant(int index){
    _clubs.removeAt(index);
    notifyListeners();
  }








}