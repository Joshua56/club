import 'package:club/club_detail_page.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/utils/openable_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ClubListView extends StatefulWidget {

  @override
  _ClubListViewState createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> with SingleTickerProviderStateMixin {

  OpenableController _clubListViewController;

  @override
  void initState() {
    super.initState();
    _clubListViewController = new OpenableController(
      vsync: this,
      openDuration: const Duration(milliseconds: 300),
      
    )..addListener(()=> setState((){}));
  }

  @override
  void dispose() {
    _clubListViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClubModule>(
      builder: (context, clubModule, _) =>Transform(
        transform: Matrix4.translationValues(
          0, 
          (1 - _clubListViewController.percentOpen) * MediaQuery.of(context).size.height * .54, 
          0,
        ),
        child: ClipPath(
          clipper: RestaurantListViewClipper(),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30),
                height: MediaQuery.of(context).size.height * .7,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: clubModule.clubsCount,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: Container(height: 60, width: 60, color: Colors.orangeAccent,),
                      title: Text(clubModule.clubs[index].name),
                      subtitle: Text('2km away'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ClubDetailPage(restaurant: clubModule.clubs[index],)));
                      },
                    );
                  },
                ),
                
              ),
              Positioned(
                top: 3,
                left: MediaQuery.of(context).size.width/2 -16,
                child: IconButton(
                  onPressed: (){
                    _clubListViewController.isOpen() ? _clubListViewController.close() : _clubListViewController.open();
                  },
                  icon: Icon(
                    _clubListViewController.isOpen() ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, 
                    size: 35,
                  ),
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestaurantListViewClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;

    Path path = Path();
    path.moveTo(0, 30);
    path.lineTo((width/2 -20), 30);
    path.quadraticBezierTo(width/2+5, 0, (width/2 + 40), 30);
    path.lineTo(width, 30);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();



    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}

