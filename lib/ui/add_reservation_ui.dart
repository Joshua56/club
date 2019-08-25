import 'package:club/modals/club_modal.dart';
import 'package:club/modals/preoder_modal.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/reservation_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:club/modals/user_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReservationUI extends StatefulWidget {

  final String clubKey;

  AddReservationUI({
    this.clubKey
  });

  @override
  _AddReservationUIState createState() => _AddReservationUIState();
}

class _AddReservationUIState extends State<AddReservationUI> {
  String _tableId;   
  TableModal _table;
  static double _minNoChairs = 1;
  double _maxNoChairs = 4;
  int _noChairs = _minNoChairs.floor();
  double _sliderValue = _minNoChairs;
  DateTime _reservationDateTime = null;
  double _quantitySliderValue = 1;
  int _quantity = 1;
  ProductModal _selectedProduct;

  List<OderItemModal> _productsItemAdded = [];

  List<Widget> _getProducts(){
    List<Widget> lst = [];
    _productsItemAdded.forEach((item){
      lst.add(_productCard(item));
    });

    return lst;
  }


  List<DropdownMenuItem> _tables({List<TableModal> tables}){
    List<DropdownMenuItem> _lst =[];
    tables.forEach((item){
      _lst.add(
        DropdownMenuItem(value: item.id, child: _menuItemLabel(item.id.toString()),)
      );
    });

    return _lst;
  }

  Container _menuItemLabel(String label){
    return Container(
      // padding: EdgeInsets.only(left: 8),
      width: 100,
      child: Text(
        label,
        style: TextStyle(color: Colors.blue, fontSize: 19),
      ),
    );
  }

  TextStyle _cardTitleStyle(){
    return TextStyle(
      color: Colors.orange,
      fontSize: 19
    );
  }

  Card _inputCard({String title, Widget body}){
    return Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style:  _cardTitleStyle(),),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: body
                ),            
              ],
            ),
          ),
        );
  }

  void _datePicker() async{
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
  }

  Widget _productCard(OderItemModal orderItem){
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 90,
      width: 130,
      child: Row(
        children: <Widget>[
          // Product image & name
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/product1.jpg'), fit: BoxFit.cover),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
              ),
              margin: EdgeInsets.only(right: 1),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8))),
                  // height: 17,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    orderItem.product.name.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Column(
            children: <Widget>[
              // Product cost
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8))
                  ),
                  margin: EdgeInsets.only(left: 1, bottom: 1),
                  child: Center(
                    child: Text(
                      'Ksh. ${orderItem.product.price.toString()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                    ),
                  ),
                ),
              ),
              // Quantity
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8))
                  ),
                  margin: EdgeInsets.only(left: 1, bottom: 1),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white,),
                        Text(
                          orderItem.quantity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),),
        ],
      ),
    );
  }

  Container _addProductItemMoadl(setModalState, ClubModal club){
    List<ProductModal> _products = club.products;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index){
                return InkWell(
                  onTap: (){
                    setModalState(() {
                      _selectedProduct = _products[index];
                    });
                  },
                  child: Card(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/product1.jpg'), fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: _products[index] == _selectedProduct ? Border.all(width: 5, color: Colors.orangeAccent) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Item Name
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.all(3),
                              child: Center(
                                child: Text(
                                  _products[index].name,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Item Price
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.all(3),
                              child: Center(
                                child: Text(
                                  _products[index].price.toString(),
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quantity slider
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,                
                children: <Widget>[
                  Text(
                    'Quantity',
                    style: _cardTitleStyle(),
                  ),
                  Row(
                    children: <Widget>[
                      Text(_quantity.toString(), style: TextStyle(fontSize: 21, color: Colors.blue),),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Slider(
                              min: 1,
                              max: 20,
                              onChanged: (value){
                                setModalState(() {
                                  _quantitySliderValue = value;
                                  _quantity = _quantitySliderValue.floor();
                                });
                              },
                              value: _quantitySliderValue,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 25,
                              child: Text("1"),// min value
                            ),
                            Positioned(
                              bottom: 0,
                              right: 20,
                              child: Text("20"),// max value
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15,),

          // Submit Button
          RaisedButton(
            onPressed: (){
              Navigator.pop(context);
              setState(() {
                _productsItemAdded.add(OderItemModal(
                  product: _selectedProduct,
                  quantity: _quantity,
                ));                
              });
            },
            color: Colors.blueAccent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.local_bar, color: Colors.white, size: 27,),
                SizedBox(width: 10,),
                Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModule = Provider.of<UserModule>(context);
    final clubModule = Provider.of<ClubModule>(context);
    final ReservationModule reservationModule = Provider.of<ReservationModule>(context);
    ClubModal _club = clubModule.getClub(widget.clubKey);
    return ListView(
        children: <Widget>[
          // Table card
          _inputCard(
            title: "Table No. :",
            body: DropdownButton(
              value: _tableId,
              onChanged: (value){
                setState(() {
                _tableId = value;  
                _club.tables.forEach((item){
                  if(item.id == value){
                    _table = item;
                    setState(() {
                      _minNoChairs = _table.minNoChairs.floorToDouble();
                      _maxNoChairs = _table.maxNoChairs.floorToDouble();
                      _sliderValue = _minNoChairs;
                      _noChairs = _minNoChairs.floor();
                    });
                  }
                });                    
                });
              },
              items: _tables(tables:  _club.tables),
            ),
          ),

          // No. of Chairs card
          _inputCard(
            title: "No. of chairs :",
            body: Row(
              children: <Widget>[
                Text(_noChairs.toString(), style: TextStyle(fontSize: 21, color: Colors.blue),),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Slider(
                        min: _minNoChairs,
                        max: _maxNoChairs,
                        onChanged: (value){
                          setState(() {
                            _sliderValue = value;
                            _noChairs = _sliderValue.floor();
                          });
                        },
                        value: _sliderValue,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 25,
                        child: Text(_minNoChairs.floor().toString()),// min value
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: Text(_maxNoChairs.floor().toString()),// max value
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Date Time
          _inputCard(
            title: 'Reservation date and time :',
            body: _reservationDateTime != null ? 
              Row(
                children: <Widget>[
                  Text(
                    _reservationDateTime.year.toString() + '/' + _reservationDateTime.month.toString() +'/' + _reservationDateTime.day.toString() + ' -- ' +
                    _reservationDateTime.hour.toString() + ':' + _reservationDateTime.minute.toString() ,
                    style: TextStyle(color: Colors.blue, fontSize: 19),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.redAccent, size: 20,),
                    onPressed: _datePicker,
                  ),
                ],
              )
              :
              RaisedButton(
                color: Colors.white,
                child: Text(
                  'Pick date and time',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: _datePicker,
              )
          ),
          // pre order
          _inputCard(
            title: 'Pre order :',
            body: Container(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 10,
                spacing: 10,
                children: _getProducts()..add(
                  // Add product to cart
                  InkWell(
                    splashColor: Colors.orangeAccent.withOpacity(.5),
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext contex){
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setModalState){
                              return _addProductItemMoadl(setModalState, _club);
                            },
                          );
                        }
                      );
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      height: 90,
                      width: 90,
                      child: Center(
                        child: Icon(Icons.add, color: Colors.blue, size: 50,)
                        
                      ),
                    ),
                  )),
              ),
            )
          ),

          RaisedButton(
            onPressed: (){
              UserModal _user = userModule.currentUser(0);
              // _club
              // _table
              // _noChairs
              // _reservationDateTime
              DateTime _dateTimeBooked = DateTime.now();
              PreoderModal _preoderModal = PreoderModal(oderItems: _productsItemAdded);

              ReservationModal _reservationModal = ReservationModal(
                user: _user,
                club: _club,
                table: _table,
                noChairs: _noChairs,
                reserveDateTime: _reservationDateTime,
                dateTimeBooked: _dateTimeBooked,
                preoderModal: _preoderModal
              );

              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Confirm Check out"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Row(children: <Widget>[Text("Table reservation cost :"), SizedBox(width: 10,),Text('Ksh. ${_reservationModal.tableReservationCost.toString()}'),],),
                          Row(children: <Widget>[Text("Preorder cost :"), SizedBox(width: 10,) ,Text('Ksh. ${_reservationModal.preoderCost.toString()}'),],),
                          Row(children: <Widget>[Text("Total amount :"), SizedBox(width: 10,) ,Text('Ksh. ${_reservationModal.totalCost.toString()}'),],),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      RaisedButton(
                        onPressed: () { 
                          Navigator.pop(context); 
                          reservationModule.addReservation = _reservationModal;
                        },
                        child: Text("Yes, Continue", style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  );
                }
              );
 

            },
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.check_circle_outline, color: Colors.white, size: 28,),
                SizedBox(width: 15,),
                Text(
                  'Check out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
        ],      
      );
      
  }
}