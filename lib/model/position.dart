import 'dart:convert';

import 'package:geosmart/config.dart';
import 'package:geosmart/model/response.dart';
import 'package:geosmart/model/unique_id_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Position {
  late String id;
  late String type;
  late String lat;
  late String lng;

  Position({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
  });

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }

  static Future<Position> getPosition() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String keyName = "unique_id";
    String? spId = (sp.getString(keyName));
    Position position = new Position(
      id: spId ?? "",
      type: "user",
      lat: "0.0",
      lng: "0.0",
    );
    if (spId == null) {
      final response = await http.get(("${Config.api}/id/get/unique") as Uri);
      if (response.statusCode == 200) {
        position.id = UniqueIDModel.fromJson(json.decode(response.body)).id;
      } else {
        throw Exception("Something Error");
      }
      sp.setString(keyName, position.id);
    }
    return position;
  }

  bool isValid() {
    // ignore: unnecessary_null_comparison
    return id != null;
  }

  Future<ResponseModel> sendPosition() async {
    ResponseModel result;
    final response = await http.post(
      ("${Config.api}/point/set") as Uri,
      body: json.encode(toJson()),
    );
    if (response.statusCode == 200) {
      result = ResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Something Error");
    }
    return result;
  }

  Future<ResponseModel> stopPosition() async {
    ResponseModel result;
    final response = await http.post(
      ("${Config.api}/point/unset") as Uri,
      body: json.encode(toJson()),
    );
    if (response.statusCode == 200) {
      result = ResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Something Error");
    }
    return result;
  }
}
