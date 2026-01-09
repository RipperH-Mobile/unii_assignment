import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/coin_repository.dart';
import 'logic/bloc/coin_bloc.dart';
import 'logic/bloc/coin_event.dart' hide CoinEvent;
import 'presentation/screens/home_screen.dart';

void main() {
  // สร้าง Repository และ Bloc ก่อนเริ่มรันแอป
  final coinRepository = CoinRepository();

  runApp(
    RepositoryProvider.value(
      value: coinRepository,
      child: BlocProvider(
        create: (context) => CoinBloc(coinRepository)..add(FetchCoins()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unii Crypto App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        fontFamily: 'Roboto', // หรือฟอนต์ตามใน Figma
      ),
      home: HomeScreen(), // เปลี่ยนจาก MyHomePage เป็น HomeScreen ของเรา
    );
  }
}