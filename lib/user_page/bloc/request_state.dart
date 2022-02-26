part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestInitial extends RequestState {}

class LoadingRequestState extends RequestState {}

class ErrorRequestState extends RequestState {
  final String errorMsg;

  ErrorRequestState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class SuccessRequestState extends RequestState {
  final data;

  SuccessRequestState({required this.data});
  @override
  List<Object> get props => [data];
}
