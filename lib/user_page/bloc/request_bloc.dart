import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<NewRequestEvent>(_onNewRequest);
  }

  void _onNewRequest(RequestEvent event, Emitter emit) async {
    emit(LoadingRequestState());
    var body = await _getData();
    if (body != null) {
      emit(SuccessRequestState(data: body));
    } else {
      emit(ErrorRequestState(errorMsg: "Error while getting the data"));
    }
  }

  Future _getData() async {
    final String url =
        "https://api.sheety.co/979fda11b7e210c933987d2d6e7c4e0f/tarea4/hoja1";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      // if everything is ok
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
