import 'package:equatable/equatable.dart';

enum LoadStatus { loading, success, failure }

class LoadState<T> extends Equatable {
  const LoadState._(this.status, {this.data, this.message});
  const LoadState.loading() : this._(LoadStatus.loading);
  const LoadState.success(T data) : this._(LoadStatus.success, data: data);
  const LoadState.failure(String message)
    : this._(LoadStatus.failure, message: message);

  final LoadStatus status;
  final T? data;
  final String? message;

  @override
  List<Object?> get props => [status, data, message];
}
