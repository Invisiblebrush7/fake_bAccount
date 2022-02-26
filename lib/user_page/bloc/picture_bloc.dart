import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial()) {
    on<ChangeImageEvent>(_onChangeImage);
    // on<AnotherEvent>(_anotherMethod);
  }

  void _onChangeImage(PictureEvent event, Emitter emit) async {
    File? img = await getImage();
    try {
      if (img != null) {
        emit(PictureSelectedState(picture: img));
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      emit(PictureErrorState(
          errorMsg: "Falla en obtener imagen. Error: ${e.toString()}"));
    }
  }

  Future<File?> getImage() async {
    final picker = ImagePicker();
    final XFile? chosenImage = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720.0,
        maxWidth: 720.0,
        imageQuality: 85);
    return chosenImage != null ? File(chosenImage.path) : null;
  }
}
