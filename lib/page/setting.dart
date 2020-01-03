import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_app/bloc/setting.dart';
import 'package:geo_app/bloc/unique_id_bloc.dart';
import 'package:geo_app/config.dart';
import 'package:geo_app/model/setting.dart';
import 'package:geo_app/page/map.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<Setting> {
  final _hostController = TextEditingController();
  SettingBloc _settingBloc;
  UniqueIDBloc _uniqueIDBloc;
  String id;
  String host;

  @override
  void initState() {
    _settingBloc = new SettingBloc();

    _settingBloc.getSetting();

    if (!Config.dynamicHostSetting) {
      _settingBloc.setSetting(new SettingModel(Config.api, null));
    }

    _settingBloc.subject.listen((settingModel) {
      if (!settingModel.isNullId()) {
        this.id = settingModel.id;
      }
      if (!settingModel.isNullHost()) {
        this.host = settingModel.host;
      }

      _hostController.text = this.host;

      if (!settingModel.isNullHost()) {
        _uniqueIDBloc = new UniqueIDBloc(settingModel);
        _uniqueIDBloc.getUniqueID();

        if (_uniqueIDBloc != null) {
          this._uniqueIDBloc.subject.listen((uniqueId) {
            print("Your Unique ID " + uniqueId.id.toString());
            if (uniqueId.id != null && uniqueId.id != "") {
              if (!settingModel.isNullId()) {
                mapPage();
              } else {
                this._settingBloc.setSetting(
                      new SettingModel(this._hostController.text, uniqueId.id),
                    );
                mapPage();
              }
            } else {
              Fluttertoast.showToast(msg: "Invalid host address");
            }
          });
        }
      }
    });
    super.initState();
  }

  mapPage() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => Map(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/server.png"),
                    ),
                  ),
                  height: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: this._hostController,
                  decoration: InputDecoration(
                    labelText: "Host",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      this._settingBloc.setSetting(
                            new SettingModel(this._hostController.text, null),
                          );
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            width: 200,
            height: 400,
          ),
        ),
      ),
    );
  }
}
