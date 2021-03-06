import 'dart:io';

import 'package:club/modals/club_modal.dart';
import 'package:club/modals/event_model.dart';
import 'package:club/modals/preoder_modal.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/reservation_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/event_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:club/ui/create_event.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClubDetail extends StatefulWidget {
  final String clubId;
  ClubDetail({this.clubId});

  @override
  _ClubDetailState createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> with SingleTickerProviderStateMixin{


  // ClubModal _club = ClubModal(name: '', position: LatLng(0,0), locationLabel: '');
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ClubModule(),),
        ChangeNotifierProvider(builder: (context) => ReservationModule(),),
      ],
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
         
          return Scaffold(
            appBar: AppBar(
              title: Text(_club.name),
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text: 'Reservations',),
                  Tab(text: 'Events',),
                  Tab(text: 'Gallery',),
                  Tab(text: 'Info',),
                ],
              ),
            ),
            drawer: clubDetailDrawer(context, widget.clubId),
            // body: ClubReservations(widget.clubId),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[ 
                ClubReservations(widget.clubId),
                ClubEvents(widget.clubId),
                ClubGallery(widget.clubId),
                // TODO: create info page
                ClubInfo(widget.clubId),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ClubTables extends StatefulWidget {
  final String clubId;
  ClubTables(this.clubId);

  @override
  _ClubTablesState createState() => _ClubTablesState();
}

class _ClubTablesState extends State<ClubTables> {
  TextEditingController _labelController;

  TextEditingController _maxNoChairsController;

  TextEditingController _minNoChairsController;

  TextEditingController _reserveCostPerChairController;

  List<TableModal> _tables =[];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _maxNoChairsController = TextEditingController();
    _minNoChairsController = TextEditingController();
    _reserveCostPerChairController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _maxNoChairsController.dispose();
    _minNoChairsController.dispose();
    _reserveCostPerChairController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
            _tables= _club.tables;
          return Scaffold(
          appBar: AppBar(title: Text("Tables"),),
          drawer: clubDetailDrawer(context, widget.clubId),
          floatingActionButton: CircleAvatar(
            child: IconButton(
              onPressed: (){
                showModalBottomSheet(
                  context: context,
                  builder: (context){
                    return Column(
                      children: <Widget>[
                        // label 
                        TextField(
                          controller: _labelController,
                          decoration: InputDecoration(labelText: 'Table label'),
                        ),
                        // Max no chairs 
                        TextField(
                          controller: _maxNoChairsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Max No. of chairs'),
                        ),
                        // Max no chairs 
                        TextField(
                          controller: _minNoChairsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Min No. of chairs'),
                        ),
                        // Max no chairs 
                        TextField(
                          controller: _reserveCostPerChairController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Reservation cost per chair'),
                        ),
                        SizedBox(height: 15,),
                        RaisedButton(
                          child: Text('create'),
                          onPressed: (){
                            Navigator.pop(context);
                            TableModal _newTable = TableModal(
                              label: _labelController.text,
                              maxNoChairs: int.parse(_maxNoChairsController.text),
                              minNoChairs: int.parse(_minNoChairsController.text),
                              reserveCostPerChair: double.parse(_reserveCostPerChairController.text),
                            );
                            _tables.add(_newTable);
                            clubModule.updateTables(clubId: widget.clubId, tables: _tables);
                            
                          },
                        ),
                      ],
                    );
                  }
                );
              },
              icon: Icon(Icons.add),
            ),
          ),  

          ////////////////
          body: ListView.builder(
            itemCount: _tables.length,
            itemBuilder: (BuildContext context, int index){
              Row _row({String key, String value}){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(key),
                    Text(value),
                  ],
                );
              }
              return Card(
                child: Column(
                  children: <Widget>[
                    _row(key: 'Table label:', value: _tables[index].label.toString()),
                    _row(key: 'Max No. of chairs', value: _tables[index].maxNoChairs.toString()),
                    _row(key: 'Min No. of chairs', value: _tables[index].minNoChairs.toString()),
                    _row(key: 'Reservation cost per chair (Ksh.)', value: _tables[index].reserveCostPerChair.toString()),
                  ],
                ),
              );
            },
          )  
        );
       }
      ),
    );
  }
}

class ClubProducts extends StatefulWidget {
  final String clubId;
  ClubProducts(this.clubId);

  @override
  _ClubProductsState createState() => _ClubProductsState();
}

class _ClubProductsState extends State<ClubProducts> {
  TextEditingController _nameController;

  TextEditingController _priceController;

  List<ProductModal> _products =[];

  File _imageChoosen;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
                _products= _club.products;
            
          return Scaffold(
            appBar: AppBar(title: Text("Products"),),
            drawer: clubDetailDrawer(context, widget.clubId),
            floatingActionButton: CircleAvatar(
              child: IconButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Column(
                        children: <Widget>[
                          // name 
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Product name'),
                          ),
                          // price 
                          TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Product price'),
                          ),
                          SizedBox(height: 15,),

                          // image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: (){
                                  ImagePicker.pickImage(source: ImageSource.gallery).then((value){
                                    setState(() {
                                      _imageChoosen = value;
                                    });
                                  });
                                },
                                child: Text("Pick image"),
                              ),
                              SizedBox(width: 10,),
                              _imageChoosen == null ? Container() : Image.file(_imageChoosen, height: 150,),
                            ],
                          ),
                          
                          MaterialButton(
                          color: Colors.blue,
                          minWidth: 300,
                            child: Text('create'),
                            onPressed: (){
                              Navigator.pop(context);
                              clubModule.uploadImage(_imageChoosen).then((url){
                                ProductModal _newProduct = ProductModal(
                                  name: _nameController.text,
                                  price: double.parse(_priceController.text),
                                  image: url,
                                );
                                _products.add(_newProduct);
                                clubModule.updateProducts(clubId: widget.clubId, products: _products);

                              });
                              
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),  

          ////////////////
          body: GridView.builder(
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _products.length,
            itemBuilder: (BuildContext context, int index){
              return SizedBox(
                  height: 170,
                  width: 170,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // product image
                        Expanded(
                          child: _products[index].image == null ? Container() : Image.network(_products[index].image,  fit: BoxFit.cover,),
                        ),
                        // name
                        Text(_products[index].name.toString()),
                        // price
                        Text(_products[index].price.toString()),
                      ],
                    ),
                  ),
                );
            },
          )  
        );
       }
      ),
    );
  }
}

class ClubGallery extends StatefulWidget {
  final String clubId;
  ClubGallery(this.clubId);

  @override
  _ClubGalleryState createState() => _ClubGalleryState();
}

class _ClubGalleryState extends State<ClubGallery> {

  File _imageChoosen;

  List<String> _gallery;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
          _club.gallery == null ? _gallery = <String>[] : _gallery = _club.gallery;
            
          return Scaffold(
            // appBar: AppBar(title: Text("Gallery"),),
            // drawer: clubDetailDrawer(context, widget.clubId),
            floatingActionButton: CircleAvatar(
              child: IconButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Column(
                        children: <Widget>[
                          // image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: (){
                                  ImagePicker.pickImage(source: ImageSource.gallery).then((value){
                                    setState(() {
                                      _imageChoosen = value;
                                    });
                                  });
                                },
                                child: Text("Pick image"),
                              ),
                              SizedBox(width: 10,),
                              _imageChoosen == null ? Container() : Image.file(_imageChoosen, height: 150,),
                            ],
                          ),
                          
                          MaterialButton(
                          color: Colors.blue,
                          minWidth: 300,
                            child: Text('create'),
                            onPressed: (){
                              Navigator.pop(context);
                              clubModule.uploadImage(_imageChoosen).then((url){
                                _gallery.add(url);
                                clubModule.updateGallery(gallery: _gallery, clubId: widget.clubId);
                              });
                              
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),  

          ////////////////
          body: GridView.builder(
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _gallery.length,
            itemBuilder: (BuildContext context, int index){
              return SizedBox(
                  height: 170,
                  width: 170,
                  child: Card(
                    child: _gallery[index] == null ? Container() : Image.network(_gallery[index],  fit: BoxFit.cover,),
                        
                  ),
                );
            },
          )  
        );
       }
      ),
    );
  }
}

class ClubReservations extends StatefulWidget {
  final String clubId;

  ClubReservations(this.clubId);
  @override
  _ClubReservationsState createState() => _ClubReservationsState();
}

class _ClubReservationsState extends State<ClubReservations> {
  UserModule _userModule = UserModule();
  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationModule>(
      builder: (context, reservationModule, _){
        List<ReservationModal> _reservations = reservationModule.currenClubReservation(widget.clubId);
        return ListView.builder(
          itemCount: _reservations.length,
          itemBuilder: (BuildContext context, int index){
            Row _row(key, value){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(key.toString()),
                  Text(value.toString()),
                ],
              );
            }
            return InkWell(
              onTap: ()async{
                final Map<String, dynamic> _userMap = await _userModule.getUser(_reservations[index].user);
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    List<OderItemModal> _oderItems = _reservations[index].preoderModal.orderItems;
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: _oderItems != null ? _oderItems.length : 0,
                            itemBuilder: (BuildContext context, int index){
                              return Card(
                                child: Column(
                                  children: <Widget>[
                                    _row("product id", _oderItems[index].product.id),
                                    _row("product name", _oderItems[index].product.name),
                                    _row("product price", _oderItems[index].product.price),
                                    _row("Quantity", _oderItems[index].quantity),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Username: ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _userMap != null ? _userMap['username'] : "null",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Email: ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _userMap != null ? _userMap['email'] : "null",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Table: ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _reservations[index].table.label,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  
                                  SizedBox(width: 20,),
                                  Text(
                                    _reservations[index].preoderModal.totalAmount.toString(),
                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                );
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _row('User Id', _reservations[index].user),
                    _row('DateBooked', _reservations[index].dateTimeBooked),
                    _row('ResercationDate', _reservations[index].reserveDateTime),
                    _row('Table', _reservations[index].table.label),
                    _row('No. of Chairs', _reservations[index].noChairs),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class ClubEvents extends StatefulWidget {
  final String clubId;

  ClubEvents(this.clubId);
  @override
  _ClubEventsState createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => EventModule(),
      child: Consumer<EventModule>(
        builder: (context, eventsModule, _){
          List<EventModel> _events = eventsModule.currenClubEvents(widget.clubId);

          return Scaffold(
            // appBar: AppBar(title: Text('Events'),),
            // drawer: clubDetailDrawer(context, widget.clubId),
            body: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index){
                
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(_events[index].title),
                      Image.network( _events[index].image.toString(), height: 200, width: MediaQuery.of(context).size.width - 30, fit: BoxFit.fitWidth,),
                      SizedBox(height: 5,),
                      Text(_events[index].description),
                      SizedBox(height: 15,),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: CircleAvatar(
                child: IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (context){
                        return EventCreate(clubId: widget.clubId,);
                      }
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ),  
          );
        },
      ),
    );
  }
}

// TODO: create info page
class ClubInfo extends StatefulWidget {
  final String clubId;

  ClubInfo(this.clubId);
  @override
  _ClubInfoState createState() => _ClubInfoState();
}

class _ClubInfoState extends State<ClubInfo> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
} 

Drawer clubDetailDrawer (context, clubId,){
  return Drawer(
    child: Column(
      children: <Widget>[
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubProducts(clubId)));
          },
          title: Text('Products'),
        ),
        Divider(),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubTables(clubId)));
          },
          title: Text('Tables'),
        ),
        Divider(),
        // ListTile(
        //   onTap: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => ClubEvents(clubId)));
        //   },
        //   title: Text('Events'),
        // ),
        // Divider(),
        // ListTile(
        //   onTap: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => ClubGallery(clubId)));
        //   },
        //   title: Text('Gallery'),
        // ),
        // Divider(),
      ],
    ),
  );
}

