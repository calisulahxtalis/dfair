import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dsg/components/horinzontal_list_view.dart';
import 'package:dsg/pages/cart.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  String token;
  String names;
  String profilePicture;
  String email;
  String username;
  AccountPage(
      {@required this.token,
      @required this.names,
      @required this.profilePicture,
      @required this.email,
      @required this.username});
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget imageCarousel = new Container(
    height: 200.0,
    child: new Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage("images/c1.jpg"),
        AssetImage("images/m2.jpg"),
        AssetImage("images/w3.jpeg"),
        AssetImage("images/m1.jpeg"),
        AssetImage("images/w4.jpeg"),
      ],
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 5.0,
      dotColor: Colors.purple,
      indicatorBgPadding: 9.0,
      dotBgColor: Colors.transparent,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.2,
        backgroundColor: Colors.purple,
        title: InkWell(
          onTap: () {},
          child: Center(child: Text("Your Profile")),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/home',
                  arguments: widget.token);
            },
          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    widget.profilePicture,
                  ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: 250.0,
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.8)),
              child: Column(children: <Widget>[
                SizedBox(height: 30.0),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.profilePicture,
                  ),
                  backgroundColor: Colors.grey,
                  maxRadius: 70.0,
                ),
                Text(
                  widget.names,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("@${widget.username}",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: 14.0))
              ]),
            ),
          ),
          Container(
            height: 65.0,
            alignment: Alignment.center,
            color: Color.fromRGBO(0, 0, 0, .7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "206",
                          style: TextStyle(fontSize: 20.0, color: Colors.grey),
                        ),
                        Text(
                          "Orders",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 5.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "\$160",
                          style: TextStyle(fontSize: 20.0, color: Colors.grey),
                        ),
                        Text(
                          "Spent",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 5.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "\$958",
                          style: TextStyle(fontSize: 20.0, color: Colors.grey),
                        ),
                        Text(
                          "Budget",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 5.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "\$436",
                          style: TextStyle(fontSize: 20.0, color: Colors.grey),
                        ),
                        Text(
                          "Saved",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          imageCarousel,
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: Icon(Icons.edit_rounded,),
            label: "Edit",
            backgroundColor: Colors.black,
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle,),
            label: "Profile",
            backgroundColor: Colors.black,
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.privacy_tip_rounded),
            label: "Policies",
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
