import 'package:club/modals/club_modal.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ClubModule extends ChangeNotifier{

  // Firebase
  final databaseReference = Firestore.instance;

  List<ClubModal> _clubs;

  // // with exaples
  // static List<ProductModal> _productsRezzy = [
  //   ProductModal(id:'1', name: 'drink 1', price: 200),
  //   ProductModal(id:'2', name: 'drink 2', price: 340),
  //   ProductModal(id:'3', name: 'drink 3', price: 600),
  //   ProductModal(id:'4', name: 'drink 4', price: 800),
  //   ProductModal(id:'5', name: 'drink 5', price: 1000),
  // ];

  // static List<ProductModal> _productsResnet50 = [
  //   ProductModal(id:'1', name: 'drink 1', price: 200),
  //   ProductModal(id:'2', name: 'drink 2', price: 340),
  //   ProductModal(id:'3', name: 'food 1', price: 300),
  //   ProductModal(id:'4', name: 'drink 4', price: 800),
  //   ProductModal(id:'5', name: 'food 2', price: 650),
  // ];

  // List<ClubModal> _clubs =[
  //   ClubModal(
  //     id: '1',
  //     name: 'rezzy',
  //     image: "assets/images/club1.jpg",
  //     position: LatLng(-1.290500, 36.823028),
  //     locationLabel: "Koinange St, Nairobi",
  //     tables: [
  //       TableModal(id: '1', maxNoChairs: 6, minNoChairs: 3, reserveCostPerChair: 50),
  //       TableModal(id: '2', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 50),
  //       TableModal(id: '3', maxNoChairs: 2, reserveCostPerChair: 50),
  //       TableModal(id: '4', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 50),
  //     ],
  //     products: _productsRezzy,
  //   ),
  //   ClubModal(
  //     id: '2',
  //     name: 'resnet50',
  //     image: "assets/images/club1.jpg",
  //     position: LatLng(-1.284486, 36.819134),
  //     locationLabel: "Koinange St, Nairobi",
  //     tables: [
  //       TableModal(id: '2', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 100),
  //       TableModal(id: '3', maxNoChairs: 2, reserveCostPerChair: 100),
  //       TableModal(id: '4', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 100),
  //     ],
  //     products: _productsResnet50,
  //   ),
  // ];

  Set<Marker> _markers (){
    final Set<Marker> lst = {};

    _clubs.forEach((item){
      lst.add(item.marker);
    });
    return lst;
  }
  void _fetchClubs()async{
    QuerySnapshot _clubsSnapshot = await databaseReference.collection('clubs').getDocuments();
    setClubs = _convertToClubModal(_clubsSnapshot.documents);
    


    
    
  }

  Future<ClubModal> _getClub(String id) async{
    ClubModal club;
    DocumentSnapshot r = await databaseReference.document('clubs/$id').get();
    return _convertItemToClubModal(r);
    // _clubs.forEach((item){
    //   if(item.id == id){
    //     club = item;
    //   }
    // });
    // return club;
  }


  get clubs => _clubs;
  get clubsCount => _clubs.length;
  Set<Marker> get markers => _markers();
  get getClub => (id) { return _getClub(id); };
  get updateTables => ({List<TableModal> tables, String clubId}) {return _updateTables(tables: tables, clubId: clubId); };
  get updateProducts => ({List<ProductModal> products, String clubId}) {return _updateProducts(products: products, clubId: clubId); };

  get convertToClubModal => (List<DocumentSnapshot> data){
    _fetchClubs();
    return _convertToClubModal(data);
  };


  // set _setRestaurant(List<ClubModal> lst) {
  //   _restaurant = lst;
  //   notifyListeners();
  // }
  set setClubs(List<ClubModal> item){
    _clubs = item;
  }

  set addClub(ClubModal club){
    _clubs.add(club);
    createClub(club);
    notifyListeners();
    
  }

  set deleteClub(String id){
    _deleteClub(id);
    notifyListeners();
  }

  // id is preffered since each restaurant will have a unique id/key
  // set deleteClub(String id)
  void _deleteClub(String id) async {
    DocumentReference r = await databaseReference.document('clubs/$id');
    r.delete();
  }

  void createClub(ClubModal club) async {
    DocumentReference ref = await databaseReference.collection("clubs")
        .add(club.map);

  }

  void _updateTables({List<TableModal> tables, String clubId}) {
    List<Map<String, dynamic>> _tableMaps = [];
    tables.forEach((item){
      _tableMaps.add(item.map);
    });

    databaseReference.document('clubs/$clubId').updateData({'tables': _tableMaps});
  }

  void _updateProducts({List<ProductModal> products, String clubId}) {
    List<Map<String, dynamic>> _productMaps = [];
    products.forEach((item){
      _productMaps.add(item.map);
    });

    databaseReference.document('clubs/$clubId').updateData({'products': _productMaps});
  }

  List<ClubModal> _convertToClubModal(List<DocumentSnapshot> data){
    List<ClubModal> _clubModals=[];
    data.forEach((item){
      _clubModals.add(_convertItemToClubModal(item));
      
    });

    return _clubModals;
  }

  ClubModal _convertItemToClubModal(item){
    List<TableModal> _t=[];
      List<ProductModal> _p=[];

      if(item.data['tables'] != null){
        item.data['tables'].forEach((it){
          _t.add(
            TableModal(
              id: it['id'],
              label: it['label'],
              maxNoChairs: it['maxNoChairs'],
              minNoChairs: it['minNoChairs'],
              reserveCostPerChair: it['reserveCostPerChair']
            )
          );
        });
      }

      if(item.data['products'] != null){
        item.data['products'].forEach((p){
          _p.add(
            ProductModal(
              id: p['id'],
              name: p['name'],
              price: p['price']
            )
          );
        });
      }

      return
        ClubModal(
          id: item.documentID,
          name: item.data['name'],
          image: item.data['image'],
          position: LatLng(item.data['position'].latitude, item.data['position'].longitude),
          locationLabel: item.data['locationLabel'],
          tables: _t,
          products: _p,
        );
  }






}