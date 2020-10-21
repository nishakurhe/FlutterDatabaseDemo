import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_flutter_app/productwithsqlitedb/SqliteDatabase.dart';

import 'SqliteAddNewProduct.dart';
import 'SqliteProductModel.dart';
import 'Utility.dart';

class ProductListSqlite extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Sqlite Product List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  var productList = List<SqliteProductModel>();

  @override
  void initState() {
    refresh("init");
    super.initState();
  }

  void refresh(String where) async {
    List<Map<String, dynamic>> _results = await SqliteDatabase.getAllProduct();
    List<SqliteProductModel> productLst =
        _results.map((item) => SqliteProductModel.fromMap(item)).toList();
    setState(() {
      productList.clear();
      productList.addAll(productLst);

      for (int i = 0; i < productList.length; i++) {
        SqliteProductModel p = productList[i];
        print(
            " in product List id = ${p.id}  name = ${p.name}  image = ${p.image}");

        if (where == "init") listKey.currentState.insertItem(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lime[600],
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: AnimatedList(
        key: listKey,
        initialItemCount: productList.length,
        itemBuilder: (context, index, animation) {
          return createListItem(context, index, productList[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lime[600],
        foregroundColor: Colors.black,
        onPressed: () =>
            goToAddNewProduct("new", SqliteProductModel(), productList.length),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  void showConfirmationDialog(
      BuildContext context, String productName, int indexToRemove) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete'),
              content: Text('Are you sure to delete "$productName"?'),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      removeItem(context, indexToRemove);
                      Navigator.of(context).pop();

                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text("Deleted"),
                      ));
                    })
              ]);
        });
  }

  goToAddNewProduct(String call, SqliteProductModel itemToEdit, int ind) async {
    SqliteProductModel prod = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SqliteAddNewProduct(callFrom: call, product: itemToEdit)));

    if (call == "new" && prod != null) listKey.currentState.insertItem(ind);
    if (prod != null) refresh("");
  }

  insertProductItem(SqliteProductModel product, String call, int index) {
    var indexToInsert = productList.length;
    print(' productList length = $indexToInsert');
    if (call == "new") {
      productList.insert(indexToInsert, product);
      listKey.currentState.insertItem(indexToInsert);
    } else
      productList.insert(index, product);
  }

  removeItem(BuildContext ctx, int removeIndex) {
    var removedItem = productList.removeAt(removeIndex);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return createListItem(ctx, removeIndex, removedItem, animation);
    };

    SqliteDatabase.delete(removedItem);
    listKey.currentState.removeItem(removeIndex, builder);
  }

  Widget createListItem(BuildContext ctx, int itemIndex,
      SqliteProductModel product, Animation animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Card(
            color: Colors.lime[100],
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: product.image == "pickedImage"
                      ? Image.asset('images/sample.jpg',
                          width: 100, height: 100)
                      : Image.memory(
                          Utility.dataFromBase64String(product.image)),
                  title: Text('${product.id}',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  subtitle: Text(product.name,
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        goToAddNewProduct("edit", product, itemIndex);
                      },
                      tooltip: "Edit",
                      color: Colors.black,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showConfirmationDialog(ctx, product.name, itemIndex);
                      },
                      tooltip: "Delete",
                      color: Colors.black,
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text("Share product"),
                        ));
                      },
                      tooltip: "Share",
                      color: Colors.black,
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
