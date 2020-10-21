import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

import 'file:///C:/Users/LENOVO/Documents/FlutterProjects/product_flutter_app/lib/productwithoutdb/Product.dart';

class AddNewProduct extends StatefulWidget {
  var product = Product();
  var callFrom = "new";
  AddNewProduct({Key key, this.product, this.callFrom}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddNewProductState();
}

class AddNewProductState extends State<AddNewProduct> {
  TextEditingController controller1;
  TextEditingController controller2;
  File pickedImage;
  bool validate1 = false;
  bool validate2 = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getImage(ImgSource source) async {
    var resultImg = await ImagePickerGC.pickImage(
        context: context,
        source: source,
        cameraIcon: Icon(
          Icons.add,
          color: Colors.red,
        ));

    setState(() {
      pickedImage = resultImg;
    });
  }

  @override
  void initState() {
    if (widget.callFrom == "edit") {
      controller1 =
          TextEditingController(text: widget.product.productId.toString());
      controller2 = TextEditingController(text: widget.product.productName);
      pickedImage = widget.product.productImg;
    } else {
      controller1 = TextEditingController();
      controller2 = TextEditingController();
    }
    super.initState();
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
                        ? Image.file(pickedImage,
                            width: 150, height: 150, fit: BoxFit.cover)
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
                            /* controller1.text.isEmpty ? validate1 = true : validate1 = false;
                            controller2.text.isEmpty ? validate2 = true : validate2 = false;*/

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
                              var product = Product(
                                  productImg: pickedImage,
                                  productId: int.parse(controller1.text),
                                  productName: controller2.text);
                              Navigator.pop(context, product);
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
