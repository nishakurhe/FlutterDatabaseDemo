import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_flutter_app/productwithoutdb/ProductList.dart';
import 'package:product_flutter_app/productwithsqlitedb/ProductListSqlite.dart';
import 'package:product_flutter_app/productwithsqlitedb/SqliteDatabase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqliteDatabase.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Assignment'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
          child: ListView(
            children: <Widget>[
              FlatButton(
                color: Colors.greenAccent,
                child: Text('Simple Product Assignment'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductList())),
              ),
              FlatButton(
                color: Colors.greenAccent,
                child: Text('Sqlite Db Product Assignment'),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListSqlite())),
              ),
              FlatButton(
                color: Colors.greenAccent,
                child: Text('Room Db Product Assignment'),
                onPressed: () {},
                //  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => )),
              )
            ],
          ),
        ));
  }
}
