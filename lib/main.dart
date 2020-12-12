import 'dart:convert';
import 'package:kommunicate_flutter_plugin/kommunicate_flutter_plugin.dart';
import 'package:share/share.dart';
import 'package:dsg/models/product_model.dart';
import 'package:dsg/pages/account.dart';
import 'package:dsg/pages/cart.dart';
import 'package:dsg/pages/login.dart';
import 'package:dsg/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dsg/globals/login_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart'; # Failed Import

//My packages
import 'package:dsg/components/horinzontal_list_view.dart';
import 'package:dsg/components/painters.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsg/pages/products_overview.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // home: ProductsOverviewScreen(),
    ),
  );
}

class HomePage extends StatefulWidget {
  final userToken;
  HomePage({this.userToken});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin fltrNotification;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String tokenKey;
  Map data;
  Map userData;
  List prodList = [];
  List searchList = [];
  List _cartList = [];
  Future<bool> prodData;

  // PRODUCTS API REQUEST
  Future getProducts() async {
    final SharedPreferences prefs = await _prefs;
    final tok = prefs.getString('token');
    final test = prefs.getString('urk');
    print("TOKEN: " + tok);
    print("TEST: " + test.toString());
    http.Response response =
        await http.get("https://dfair.herokuapp.com/api/shop/products/");
    final data = json.decode(response.body);
    final products = <Product>[];
    for (var item in data) {
      final product = Product(
          id: item['id'],
          name: item['name'],
          price: item['price'],
          image: item['image'],
          category: item['category']);
      products.add(product);
    }
    print(data);
    setState(() {
      prodList = products;
      prodData = prefs.setString("products", response.body);
    });
  }

  // USER DATA API REQUEST
  Future getData() async {
    http.Response response = await http.get(
        'https://dfair.herokuapp.com/api/accounts/user/',
        headers: {"Authorization": "Token ${widget.userToken}"});
    data = json.decode(response.body);
    print(data.toString());
    setState(() {
      userData = data;
    });
  }

  // LIVE SEARCH IMPLEMENTATION
  bool _isVisible = true;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    searchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    prodList.forEach((f) {
      if (f.name.contains(text) || f.price.toString().contains(text))
        searchList.add(f);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
    getProducts();
    searchList = prodList;
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var iOSinitialize = new IOSInitializationSettings();
    var intializationSettings =
        new InitializationSettings(androidInitialize, iOSinitialize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(intializationSettings,
        onSelectNotification: notificationSelected);
    _showDailyNotification();
  }

  Future _showDailyNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Joshua Franklin", "This is my channel",
        importance: Importance.Max);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationsDetails =
        new NotificationDetails(androidDetails, iosDetails);

    // await fltrNotification.show(
    //     0, "Task", "You added something to cart", generalNotificationsDetails);
    var breakFirstTime = Time(10, 30, 00);
    var lunchTime = Time(13, 00, 00);
    var supperTime = Time(20, 00, 00);
    var morningTime = Time(7, 30, 00);
    await fltrNotification.showDailyAtTime(
        1,
        "D-Fair Greetings",
        "Good Morning,\nHave a nice BreakFirst",
        breakFirstTime,
        generalNotificationsDetails);
    await fltrNotification.showDailyAtTime(
        2,
        "D-Fair Greetings",
        "Good Afternoon,\nHave a nice Lunch",
        lunchTime,
        generalNotificationsDetails);
    await fltrNotification.showDailyAtTime(
        3,
        "D-Fair Greetings",
        "Good Evening,\nHave a nice Supper(Dinner) and we wish you a Good Night",
        supperTime,
        generalNotificationsDetails);
    await fltrNotification.showDailyAtTime(
        4,
        "D-Fair Greetings",
        "Good Morning,\nHave a nice Day",
        morningTime,
        generalNotificationsDetails);
    // var scheduledTime = DateTime.now();
    // fltrNotification.schedule(index, "Task", "Scheuled Notification", scheduledTime, generalNotificationsDetails);
  }

  Future _showNotification(String action) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID2", "Joshua Franklin Mayanja", "This is my second channel",
        importance: Importance.Max);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationsDetails =
        new NotificationDetails(androidDetails, iosDetails);

    await fltrNotification.show(
        0, "D-Fair Shop", "You $action cart", generalNotificationsDetails);
  }

  chatSupport() async {
    try {
      dynamic conversationObject = {
        'appId':
            '3fc855e96ddc75980387233d395b9f6af' // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
      };
      dynamic result =
          await KommunicateFlutterPlugin.buildConversation(conversationObject);
      print("Conversation builder success : " + result.toString());
    } on Exception catch (e) {
      print("Conversation builder error occurred : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageCarousel = new Container(
      height: 150.0,
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.purple,
        title: Text("D-Fair Shop"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: showToast,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 14.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 30.0,
                  ),
                  if (_cartList.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        radius: 6.0,
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        child: Text(
                          _cartList.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                if (_cartList.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Cart(cartList: _cartList),
                    ),
                  );
              },
            ),
          ),
          new IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('check out my website https://www.drexnet.xyz',
                  subject: 'Look what I made!');
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            // header
            (userData == null)
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                    height: 80.0,
                  )
                : new UserAccountsDrawerHeader(
                    accountName: Text(
                        userData["first_name"] + " " + userData["last_name"]),
                    accountEmail: Text(userData["email"]),
                    currentAccountPicture: GestureDetector(
                      child: new CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          userData["picture"],
                        ),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.purple,
                    ),
                  ),
            // body

            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/home');
              },
              child: ListTile(
                title: Text("Home Page"),
                leading: Icon(
                  Icons.home,
                  color: Colors.purple,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountPage(
                    token: sharedPreferences.getString('token'),
                    names: '${userData['first_name']} ${userData['last_name']}',
                    profilePicture: userData['picture'],
                    username: userData['username'],
                    email: userData['email'],
                  ),
                ));
              },
              child: ListTile(
                title: Text("My Account"),
                leading: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("My Orders"),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.purple,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/cart');
              },
              child: ListTile(
                title: Text("Shopping Cart"),
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.purple,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Favourites"),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.purple,
                ),
              ),
            ),
            Divider(),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Settings"),
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("About"),
                leading: Icon(
                  Icons.help,
                  color: Colors.purple,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginForm()),
                    (route) => false);
              },
              child: ListTile(
                title: Text("Logout"),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          new ListView(
            children: <Widget>[
              // Image carousel
              new Visibility(
                visible: _isVisible,
                child: imageCarousel,
                // Search Bar
                replacement: Container(
                  color: Colors.teal,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        onChanged: onSearch,
                        decoration: new InputDecoration(
                            hintText: "Search", border: InputBorder.none),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          onSearch("");
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Horinzontal List Begins here
              HorinzontalList(),

              // Recent Products

              searchList.length != 0 || controller.text.isNotEmpty
                  ? Container(
                      height: size.height,
                      child: searchList == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: GridView.builder(
                                itemCount:
                                    searchList == null ? 0 : searchList.length,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  final prod = searchList[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    child: Hero(
                                      tag: new Text("Hero 1"),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/details',
                                                arguments: prod.id);
                                          },
                                          child: GridTile(
                                            footer: Container(
                                              height: 62.0,
                                              color: Colors.white70,
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: new Text(
                                                      prod.name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                  new Center(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: IconButton(
                                                            icon: (!_cartList
                                                                    .contains(
                                                                        prod))
                                                                ? Icon(
                                                                    Icons
                                                                        .add_shopping_cart,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .remove_shopping_cart,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (!_cartList
                                                                    .contains(
                                                                        prod)) {
                                                                  _cartList.add(
                                                                      prod);
                                                                  print(_cartList
                                                                      .toString());
                                                                  _showNotification(
                                                                      "added ${prod.name} to cart");
                                                                } else {
                                                                  _cartList
                                                                      .remove(
                                                                          prod);
                                                                  _showNotification(
                                                                      "removed ${prod.name} from cart");
                                                                }
                                                              });
                                                            },
                                                            color:
                                                                Colors.purple,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: new Text(
                                                            "\$${prod.price}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .purple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: prod.image,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ))
                  : Container(
                      height: 401.0,
                      child: prodList == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: GridView.builder(
                                itemCount:
                                    prodList == null ? 0 : prodList.length,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  final prod = prodList[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    child: Hero(
                                      tag: new Text("Hero 1"),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/details',
                                                arguments: prod.id);
                                          },
                                          child: GridTile(
                                            footer: Container(
                                              height: 62.0,
                                              color: Colors.white70,
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: new Text(
                                                      prod.name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                  new Center(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: IconButton(
                                                            icon: (!_cartList
                                                                    .contains(
                                                                        prod))
                                                                ? Icon(
                                                                    Icons
                                                                        .add_shopping_cart,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .remove_shopping_cart,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (!_cartList
                                                                    .contains(
                                                                        prod)) {
                                                                  _cartList.add(
                                                                      prod);
                                                                  print(_cartList.toString());
                                                                  _showNotification(
                                                                      "added ${prod.name} to");
                                                                } else {
                                                                  _cartList
                                                                      .remove(
                                                                          prod);
                                                                  _showNotification(
                                                                      "removed ${prod.name} from");
                                                                }
                                                              });
                                                            },
                                                            color:
                                                                Colors.purple,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: new Text(
                                                            "\$${prod.price}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .purple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: prod.image,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 70,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 70),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      onPressed: chatSupport,
                      child: Icon(Icons.chat),
                      elevation: 0.1,
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage(
                                      userToken: widget.userToken,
                                    )));
                          },
                          color: Colors.white,
                        ),
                        IconButton(
                          icon: Icon(Icons.restaurant_menu),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AccountPage(
                                token: sharedPreferences.getString('token'),
                                names:
                                    '${userData['first_name']} ${userData['last_name']}',
                                profilePicture: userData['picture'],
                                username: userData['username'],
                                email: userData['email'],
                              ),
                            ));
                          },
                          color: Colors.white,
                        ),
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future notificationSelected(String payload) async {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => lo()));
  }
}
