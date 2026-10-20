import 'package:equatable/equatable.dart';

enum OnboardingStatus { initial, loading, done }

class OnboardingState extends Equatable {
  const OnboardingState({this.status = OnboardingStatus.initial});

  final OnboardingStatus status;

  @override
  List<Object> get props => [status];
}
