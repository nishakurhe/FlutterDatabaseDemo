import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Users/LENOVO/Documents/FlutterProjects/product_flutter_app/lib/productwithoutdb/Product.dart';

import 'AddNewProduct.dart';

class ProductList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Product List'),
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
  var product = Product(productId: 11, productName: "not added");
  var productList = List<Product>();

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
            goToAddNewProduct("new", Product(), productList.length),
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

  goToAddNewProduct(String call, Product itemToEdit, int ind) async {
    var newItem = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddNewProduct(callFrom: call, product: itemToEdit)));
    print('in response of await newItem = $newItem');
    if (newItem != null) insertProductItem(newItem, call, ind);
  }

  insertProductItem(Product product, String call, int index) {
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

    listKey.currentState.removeItem(removeIndex, builder);
  }

  Widget createListItem(
      BuildContext ctx, int itemIndex, Product product, Animation animation) {
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
                  leading:
                      Image.file(product.productImg, width: 100, height: 100),
                  //Image.asset('images/sample.jpg', width: 100, height: 100),
                  title: Text('${product.productId}',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  subtitle: Text(product.productName,
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
                        showConfirmationDialog(
                            ctx, product.productName, itemIndex);
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
