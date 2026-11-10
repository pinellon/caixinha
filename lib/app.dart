import 'package:caixinha/core/app_theme.dart';
import 'package:caixinha/data/repositories/transaction_repository.dart';
import 'package:caixinha/data/services/rates_service.dart';
import 'package:caixinha/logic/rates_controller.dart';
import 'package:caixinha/logic/transaction_controller.dart';
import 'package:caixinha/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class CaixinhaApp extends StatelessWidget {
  const CaixinhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionController(TransactionRepository())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => RatesController(RatesService())..load(),
        ),
      ],
      child: MaterialApp(
        title: 'Caixinha',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const HomeScreen(),
      ),
    );
  }
}
