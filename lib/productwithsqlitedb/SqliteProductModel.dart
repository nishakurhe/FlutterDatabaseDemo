import 'Model.dart';

class SqliteProductModel extends Model {
  int id;
  String name;
  String image;

  SqliteProductModel({this.id, this.name, this.image});

  static SqliteProductModel fromMap(Map<String, dynamic> map) {
    return SqliteProductModel(
        id: map['id'], name: map['name'], image: map['image']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"id": id, "name": name, "image": image};
    return map;
  }
}
