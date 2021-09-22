import 'package:flutter_test/flutter_test.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  testWidgets('Teste do título da AppBar', (WidgetTester tester) async {
    await _createWidget(tester);

    expect(find.text('MicroNews'), findsOneWidget);
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
          title: "MicroNews",
          theme: ThemeData(
              primarySwatch: Colors.blue, primaryColor: Colors.blueAccent),
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        )),
  );

  await tester.pump();
}
