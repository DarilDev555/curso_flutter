part of 'counter_cubit.dart';

class CounterState extends Equatable {
  final int counter;
  final int transactions;

  const CounterState({
    this.counter = 0,
    this.transactions = 0,
  });

  copyWhith({
    int? counter,
    int? transactions,
  }) =>
      CounterState(
        counter: counter ?? this.counter,
        transactions: transactions ?? this.transactions,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [counter, transactions];
}
