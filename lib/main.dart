import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/user_page/bloc/picture_bloc.dart';
import 'package:money_track/user_page/bloc/request_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';

import 'user_page/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PictureBloc>(
              create: (BuildContext context) => PictureBloc(),
            ),
            BlocProvider<RequestBloc>(
              create: (BuildContext context) => RequestBloc(),
            ),
          ],
          child: Profile(),
        ),
      ),
    );
  }
}
