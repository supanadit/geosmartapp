import 'package:flutter/material.dart';
import 'package:geosmart/component/loader.dart';

class StartupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 50,
          child: Column(
            children: <Widget>[
              Loader(),
              SizedBox(
                height: 20.0,
              ),
              Text("Preparing System")
            ],
          ),
        ),
      ),
    );
  }
}
