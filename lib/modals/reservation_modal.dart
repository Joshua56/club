import 'package:club/modals/club_modal.dart';
import 'package:club/modals/preoder_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:club/modals/user_modal.dart';
import 'package:flutter/material.dart';


class ReservationModal{
  ReservationState state;
  final UserModal user;
  final ClubModal club;
  final TableModal table;
  final int noChairs;
  final DateTime reserveDateTime;
  final DateTime dateTimeBooked;
  final PreoderModal preoderModal;

  get id => _id();

  get tableReservationCost => noChairs * table.reserveCostPerChair;
  get preoderCost => preoderModal.totalAmount;

  get totalCost => calcTotalCost();

  get autoCompleteReservation => _autoCompleteState;

  set updateState(ReservationState stt){
    state = stt;
  }

  
  ReservationModal({
    this.state = ReservationState.pending,
    @required this.user,
    @required this.club,
    @required this.table,
    this.noChairs = 1,
    @required this.reserveDateTime,
    this.dateTimeBooked,
    this.preoderModal,
  });

  double calcTotalCost(){
    double total = 0;
    total = noChairs * table.reserveCostPerChair;
    if(preoderModal != null){
      total += preoderModal.totalAmount;
    }
    return total;
  }

  void _autoCompleteState(){
    if(
      state != ReservationState.cancled && 
      state != ReservationState.complete &&
      DateTime.now().isAfter(reserveDateTime)
    ){
      updateState = ReservationState.complete;
    }
  }

  String _id(){
    return club.key + user.id.toString() + dateTimeBooked.toString();
  }

}

enum ReservationState{
  pending,
  cancled,
  complete,
}