import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/bloc/bloc/notification_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationBloc bloc) => Text(
            '${bloc.state.status}',
            style: TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationBloc>().requestPermission();
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        return const ListTile();
      },
    );
  }
}
