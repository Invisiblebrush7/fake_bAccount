import 'package:flutter/material.dart';

import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future _captureAndShare() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Compartir pantalla",
            onPressed: () async {
              await _captureAndShare();
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://www.nicepng.com/png/detail/413-4138963_unknown-person-unknown-person-png.png",
                ),
                minRadius: 40,
                maxRadius: 80,
              ),
              SizedBox(height: 16),
              Text(
                "Bienvenido",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 8),
              Text("Usuario${UniqueKey()}"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularButton(
                    textAction: "Ver tarjeta",
                    iconData: Icons.credit_card,
                    bgColor: Color(0xff123b5e),
                    action: null,
                  ),
                  CircularButton(
                    textAction: "Cambiar foto",
                    iconData: Icons.camera_alt,
                    bgColor: Colors.orange,
                    action: null,
                  ),
                  CircularButton(
                    textAction: "Ver tutorial",
                    iconData: Icons.play_arrow,
                    bgColor: Colors.green,
                    action: null,
                  ),
                ],
              ),
              SizedBox(height: 48),
              CuentaItem(),
              CuentaItem(),
              CuentaItem(),
            ],
          ),
        ),
      ),
    );
  }
}
