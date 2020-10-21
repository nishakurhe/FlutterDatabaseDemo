import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:product_flutter_app/productwithsqlitedb/SqliteDatabase.dart';
import 'package:product_flutter_app/productwithsqlitedb/SqliteProductModel.dart';

import 'Utility.dart';

class SqliteAddNewProduct extends StatefulWidget {
  var product = SqliteProductModel();
  var callFrom = "new";
  SqliteAddNewProduct({Key key, this.product, this.callFrom}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SqliteAddNewProductState();
}

class SqliteAddNewProductState extends State<SqliteAddNewProduct> {
  TextEditingController controller1;
  TextEditingController controller2;
  String pickedImage;
  bool validate1 = false;
  bool validate2 = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getImage(ImgSource source) async {
    String imgString;
    await ImagePickerGC.pickImage(
        context: context,
        source: source,
        cameraIcon: Icon(
          Icons.add,
          color: Colors.red,
        )).then((imgFile) {
      imgString = Utility.base64String(imgFile.readAsBytesSync());
    });

    setState(() => pickedImage = imgString);
  }

  @override
  void initState() {
    if (widget.callFrom == "edit") {
      controller1 = TextEditingController(text: widget.product.id.toString());
      controller2 = TextEditingController(text: widget.product.name);
      pickedImage = widget.product.image;
    } else {
      controller1 = TextEditingController();
      controller2 = TextEditingController();
    }
    super.initState();
  }

  void printData() async {
    List<Map<String, dynamic>> _results = await SqliteDatabase.getAllProduct();
    print("in printData() results = ${_results.length}");
    List<SqliteProductModel> productLst =
        _results.map((item) => SqliteProductModel.fromMap(item)).toList();

    for (int i = 0; i < productLst.length; i++) {
      SqliteProductModel p = productLst[i];
      print("id = ${p.id}  name = ${p.name}  image = ${p.image}");
    }
  }

  void saveProduct(SqliteProductModel product) async {
    if (widget.callFrom == "edit")
      await SqliteDatabase.update(product);
    else
      await SqliteDatabase.insert(product);

    printData();
    Navigator.pop(context, product);
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Colors.lime[600],
            title: Text(
              'Add Product',
              style: TextStyle(color: Colors.black),
            )),
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => getImage(ImgSource.Both),
                    child: pickedImage != null
                        ? Image.memory(
                            Utility.dataFromBase64String(pickedImage),
                            width: 150,
                            height: 150)
                        //  Image.asset('images/sample.jpg', width: 100, height: 100)
                        : Container(
                            width: 150,
                            height: 150,
                            color: Colors.lime[400],
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 50,
                            )),
                  ),
                  Text(
                    'Select image from gallery',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 24, horizontal: 12),
                            child: TextField(
                              enabled: widget.callFrom != "edit",
                              style: TextStyle(height: 1.5),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.go,
                              maxLines: 1,
                              textCapitalization: TextCapitalization.words,
                              controller: controller1,
                              decoration: InputDecoration(
                                  errorText: validate1
                                      ? 'product id can\'t Be Empty'
                                      : null,
                                  labelText: 'Product id',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Colors.blue))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 24, horizontal: 12),
                            child: TextField(
                              style: TextStyle(height: 1.5),
                              textCapitalization: TextCapitalization.words,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              controller: controller2,
                              decoration: InputDecoration(
                                  labelText: 'Product name',
                                  errorText: validate2
                                      ? 'product name can\'t Be Empty'
                                      : null,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Colors.blue))),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: 200,
                    height: 55,
                    child: FlatButton(
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 16),
                      ),
                      color: Colors.lime[600],
                      onPressed: () {
                        setState(() {
                          if (pickedImage == null) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Select image")));
                          } else {
                            if (controller1.text.isEmpty ||
                                controller2.text.isEmpty) {
                              if (controller1.text.isEmpty)
                                validate1 = true;
                              else
                                validate1 = false;

                              if (controller2.text.isEmpty)
                                validate2 = true;
                              else
                                validate2 = false;
                            } else {
                              var product = SqliteProductModel(
                                  id: int.parse(controller1.text),
                                  name: controller2.text,
                                  image: pickedImage);

                              /*var product1 = SqliteProductModel(
                                  id: int.parse(controller1.text),
                                  name: controller2.text,
                                  image: "pickedImage");*/

                              print(
                                  "BEFORE SAVE id = ${product.id}  name = ${product.name}  image = ${product.image}");
                              saveProduct(product);
                            }
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}
