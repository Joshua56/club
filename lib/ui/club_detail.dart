import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/modals/club_modal.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ClubDetail extends StatefulWidget {
  final String clubId;
  ClubDetail({this.clubId});

  @override
  _ClubDetailState createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> with SingleTickerProviderStateMixin{


  ClubModal _club = ClubModal(name: '', position: LatLng(0,0), locationLabel: '');
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          Future<ClubModal> _clubFuture = clubModule.getClub(widget.clubId);
          _clubFuture.then((value){
           setState(() {
              _club = value;
           });
          });
          return Scaffold(
            appBar: AppBar(
              title: Text(_club.name),
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text: 'Tables',),
                  Tab(text: 'Products',),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ClubTables(widget.clubId),
                ClubProducts(widget.clubId),
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

  ClubModal _club;
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
    return Consumer<ClubModule>(
      builder: (context, clubModule, _){
        Future<ClubModal> _clubFuture = clubModule.getClub(widget.clubId);
          _clubFuture.then((value){
           setState(() {
              _club = value;
              _tables= _club.tables;
          });
          });
        return Scaffold(
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

  ClubModal _club;
  List<ProductModal> _products =[];

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
    return Consumer<ClubModule>(
      builder: (context, clubModule, _){
        Future<ClubModal> _clubFuture = clubModule.getClub(widget.clubId);
          _clubFuture.then((value){
           setState(() {
              _club = value;
              _products= _club.products;
          });
          });
        return Scaffold(
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
                        decoration: InputDecoration(labelText: 'Table label'),
                      ),
                      // price 
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Max No. of chairs'),
                      ),
                      SizedBox(height: 15,),
                      RaisedButton(
                        child: Text('create'),
                        onPressed: (){
                          Navigator.pop(context);
                          ProductModal _newProduct = ProductModal(
                            name: _nameController.text,
                            price: double.parse(_priceController.text),
                          );
                          _products.add(_newProduct);
                          clubModule.updateProducts(clubId: widget.clubId, products: _products);
                          
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
                      Image.asset('assets/images/product1.jpg', height: 100, fit: BoxFit.cover,),
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
    );
  }
}

