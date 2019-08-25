import 'package:club/modals/club_modal.dart';
import 'package:club/modals/preoder_modal.dart';
import 'package:club/modals/reservation_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:flutter/material.dart';


class ReservationModule extends ChangeNotifier{

  // List<ReservationModal> _reservations;

  // dummy data

  static UserModule _userModule = UserModule();
  static ClubModule _clubModule = ClubModule();

  static PreoderModal _preoder1 = PreoderModal(
    id: '1',
    oderItems: [
      OderItemModal(product: _clubModule.clubs[0].products[0], quantity: 2),
      OderItemModal(product: _clubModule.clubs[0].products[2], quantity: 1),
    ]
  );

  static PreoderModal _preoder2 = PreoderModal(
    id: '1',
    oderItems: [
      OderItemModal(product: _clubModule.clubs[1].products[1], quantity: 2),
      OderItemModal(product: _clubModule.clubs[1].products[2], quantity: 2),
    ]
  );

  List<ReservationModal> _reservations = [
    ReservationModal(
      user: _userModule.users[0],
      club: _clubModule.clubs[0],
      table: _clubModule.clubs[0].tables[2],
      noChairs: 2,
      dateTimeBooked: DateTime.now(),
      reserveDateTime: DateTime(2019, 9),
      preoderModal: _preoder1
    ),
    ReservationModal(
      user: _userModule.users[1],
      club: _clubModule.clubs[1],
      table: _clubModule.clubs[1].tables[0],
      noChairs: 2,
      dateTimeBooked: DateTime.now(),
      reserveDateTime: DateTime(2019, 10),
      preoderModal: _preoder2
    ),
  ];

  //////////////////////////
  
  get reservations => (ClubModal res){
    List<ReservationModal> items = [];

    _reservations.forEach((item){
      if(item.club == res){
        items.add(item);
      }
    });
    return items;
  };

  get resCount => _reservations.length;
  set addReservation(ReservationModal item){
    _reservations.add(item);
    notifyListeners();
  }

  // id is preffered since each reservation will have a unique id/key
  set _removeResevation(int index){
    _reservations.removeAt(index);
    notifyListeners();
  }

  void removeResevation(ClubModal res, int index){
    int i = 0;
    int j = 0;
    _reservations.forEach((item){
      if(item.club == res){
        if(j == index){
          _removeResevation = i;
        }
        j++;
      }
      i++;
    });
  }




}