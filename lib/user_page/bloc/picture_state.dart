part of 'picture_bloc.dart';

// Son los estados que podrías utilizar
// Ej -> Cuando hay un error, cuando se actualiza la foto

abstract class PictureState extends Equatable {
  const PictureState();
  // los props sirven para comprobar si el estado es el mismo
  // o ha cambiado. Comparan el estado y revisa cuál es el más nuevo
  @override
  List<Object> get props => [];
}

class PictureInitial extends PictureState {}

class PictureErrorState extends PictureState {
  final String errorMsg;

  PictureErrorState({required this.errorMsg});
  @override
  List<Object> get props => [this.errorMsg];
}

class PictureSelectedState extends PictureState {
  final File picture;

  PictureSelectedState({required this.picture});
  @override
  List<Object> get props => [this.picture];
}
