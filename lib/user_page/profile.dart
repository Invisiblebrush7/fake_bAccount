import 'dart:io';
import 'dart:typed_data';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'bloc/picture_bloc.dart';
import 'bloc/request_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? image;
  ScreenshotController screenshotController = ScreenshotController();

  void captureSS() async {
    await screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles([imagePath.path]);
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<RequestBloc>(context).add(NewRequestEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: 'Share ID',
              tapTarget: Icon(Icons.share),
              title: Text("Toma una captura de Pantalla y compártela"),
              child: IconButton(
                tooltip: "Compartir pantalla",
                onPressed: () async {
                  captureSS();
                },
                icon: Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocConsumer<PictureBloc, PictureState>(
                  listener: (context, state) {
                    if (state is PictureErrorState) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text("${state.errorMsg}"),
                          ),
                        );
                    } else {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text("Acción realizada"),
                          ),
                        );
                    }
                  },
                  builder: (context, state) {
                    if (state is PictureSelectedState) {
                      return CircleAvatar(
                        backgroundImage: FileImage(state.picture),
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    } else {
                      return CircleAvatar(
                        // backgroundImage: NetworkImage(
                        //   "https://www.nicepng.com/png/detail/413-4138963_unknown-person-unknown-person-png.png",
                        // ),
                        backgroundColor: Colors.grey,
                        minRadius: 40,
                        maxRadius: 80,
                      );
                    }
                  },
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
                    DescribedFeatureOverlay(
                      contentLocation: ContentLocation.above,
                      overflowMode: OverflowMode.extendBackground,
                      title: Text("Conoce los datos de tu tarjeta"),
                      featureId: 'Ver tarjeta ID',
                      tapTarget: Icon(Icons.credit_card),
                      child: CircularButton(
                        textAction: "Ver tarjeta",
                        iconData: Icons.credit_card,
                        bgColor: Color(0xff123b5e),
                        action: null,
                      ),
                    ),
                    DescribedFeatureOverlay(
                      title: Text("Elige una foto cool"),
                      featureId: 'Cambiar foto ID',
                      overflowMode: OverflowMode.extendBackground,
                      tapTarget: Icon(Icons.camera_alt),
                      child: CircularButton(
                        textAction: "Cambiar foto",
                        iconData: Icons.camera_alt,
                        bgColor: Colors.orange,
                        action: () {
                          BlocProvider.of<PictureBloc>(context)
                              .add(ChangeImageEvent());
                        },
                      ),
                    ),
                    CircularButton(
                      textAction: "Ver tutorial",
                      iconData: Icons.play_arrow,
                      bgColor: Colors.green,
                      action: () {
                        FeatureDiscovery.discoverFeatures(
                          context,
                          const <String>{
                            'Ver tarjeta ID',
                            'Cambiar foto ID',
                            'Share ID',
                          },
                        );
                        FeatureDiscovery.clearPreferences(context, <String>{
                          'Ver tarjeta ID',
                          'Cambiar foto ID',
                          'Share ID',
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 48),
                BlocConsumer<RequestBloc, RequestState>(
                    builder: (context, state) {
                  if (state is LoadingRequestState) {
                    return CircularProgressIndicator();
                  } else if (state is SuccessRequestState) {
                    return getCuentas(state);
                  } else {
                    return Text("Error");
                  }
                }, listener: (context, state) {
                  if (state is LoadingRequestState) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("Cargando"),
                        ),
                      );
                  } else if (state is ErrorRequestState) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("Error"),
                        ),
                      );
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("Éxito al obtener la información"),
                        ),
                      );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column getCuentas(SuccessRequestState state) {
    List<CuentaItem> cuentas = [];
    for (var cuenta in state.data["hoja1"]) {
      cuentas.add(
        CuentaItem(
          saldoDisponible: "${cuenta["dinero"]}",
          terminacion: "${cuenta["tarjeta"]}".substring(5),
          tipoCuenta: "${cuenta["cuenta"]}",
        ),
      );
    }
    return Column(
      children: cuentas,
    );
  }
}
