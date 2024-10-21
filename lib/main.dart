import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/helpers/bloc_observer.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';
import 'package:todo/features/layout/presentation/view/glocu_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://mipmap/ic_launcher',
    [
      NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        defaultColor: const Color(0xFF9D50BB),
        ledColor: Colors.white,
      )
    ],
  );

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..createDatabase(),
      child:  const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: GlucoLayout(),
      ),
    );
  }
}
