import 'package:club/modals/club_modal.dart';
import 'package:flutter/material.dart';

class ClubDetailPage extends StatefulWidget {
  final ClubModal restaurant;

  ClubDetailPage({this.restaurant});
  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  TextEditingController _noChairs = TextEditingController();
  String tableId;
  DateTime _reservationDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)..addListener(()=> setState((){}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> tables (){
      List<DropdownMenuItem> lst = [];
      widget.restaurant.tables.forEach((item){
        lst.add(DropdownMenuItem(value: item.id, child: Text(item.id),));
      });
      return lst;
    }
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            color: Colors.orangeAccent,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
                child: Text(
                  widget.restaurant.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab( child: Text('Reviews', style: TextStyle(color: Colors.black),),),
              Tab( child: Text('Reserve', style: TextStyle(color: Colors.black),),),
            ],
          ),

          _tabController.index == 0 ?
          Container(height: 450, child: Center(child: Text("Reviews"),),) :
           Column(
             children: <Widget>[
               Row(
                 children: <Widget>[
                   Text("Table:"),
                   DropdownButton(
                     value: tableId,
                     onChanged: (value){
                       setState(() {
                       tableId = value;                         
                       });
                     },
                     items: tables(),
                   )
                 ],
               ),
               Row(
                 children: <Widget>[
                   Text("No. chairs:"),
                   Container(
                     width: 100,
                     child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _noChairs,
                      decoration: InputDecoration(
                        labelText: 'Amount',              
                      ),
                  ),
                   ),
                 ],
               ),
               Row(
                 children: <Widget>[
                   Text("DateTime"),
                   RaisedButton(
                     child: Text("Date"),
                     onPressed: () async{
                       DateTime dateValue = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2019),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year, DateTime.now().month+6),
                        );
                        TimeOfDay timeValue = TimeOfDay.now();
                        if (dateValue != null){
                          timeValue = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                          );
                        }
                          
                        setState(() {
                          if (dateValue != null && timeValue != null){
                            _reservationDateTime= DateTime(
                                dateValue.year,
                                dateValue.month,
                                dateValue.day,
                                timeValue.hour,
                                timeValue.minute,
                            );
                          }
                        });
                     },
                   ),

                 ],
               ),

              Text("Pre Order"),
              Wrap(
                children: <Widget>[
                  Card(child: Container(height: 60, width: 60, color: Colors.black12, ), ),
                  Card(child: Container(height: 60, width: 60, color: Colors.black12, ), ),
                  Card(child: Container(height: 60, width: 60, color: Colors.black12, ), ),
                ],
              )

             ],
          ),
            
        ],
      ),
    );
  }
}