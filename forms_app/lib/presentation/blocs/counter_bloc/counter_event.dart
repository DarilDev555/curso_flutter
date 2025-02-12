part of 'counter_bloc.dart';

abstract class CounterEvent {
  const CounterEvent();
}

class CounterIncreassed extends CounterEvent {
  final int value;
  const CounterIncreassed(this.value);
}

class ResetCounter extends CounterEvent {}
