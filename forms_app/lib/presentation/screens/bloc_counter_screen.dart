import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/counter_bloc/counter_bloc.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) {
          return CounterBloc();
        },
        child: BlockCounterView());
  }
}

class BlockCounterView extends StatelessWidget {
  const BlockCounterView({
    super.key,
  });

  void increasedCounterBy(BuildContext context, [int value = 1]) {
    context.read<CounterBloc>().add(CounterIncreassed(value));
  }

  void resetCounter(BuildContext context) {
    context.read<CounterBloc>().resetCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          const Text('Bloc Counter'),
          context.select(
            (CounterBloc counterBloc) => Text(
                'Transaction value: ${counterBloc.state.transactionCount}'),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              resetCounter(context);
            },
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Center(
        child: context.select(
          (CounterBloc counterBloc) =>
              Text('Counter value: ${counterBloc.state.counter}'),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              increasedCounterBy(context, 3);
            },
            heroTag: 1,
            child: const Text('+3'),
          ),
          SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            onPressed: () {
              increasedCounterBy(context, 2);
            },
            heroTag: 2,
            child: const Text('+2'),
          ),
          SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            onPressed: () {
              increasedCounterBy(context);
            },
            heroTag: 3,
            child: const Text('+1'),
          ),
        ],
      ),
    );
  }
}
