import 'package:cerengul_store/core/constants.dart';
import 'package:cerengul_store/providers/build_provider.dart';
import 'package:cerengul_store/providers/favorites_provider.dart';
import 'package:cerengul_store/data/favorites_repository.dart';
import 'package:cerengul_store/screens/home_screen.dart';
import 'package:cerengul_store/widgets/budget_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget _wrap(Widget child, {BuildProvider? build}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => build ?? BuildProvider()),
      ChangeNotifierProvider(
          create: (_) => FavoritesProvider(FavoritesRepository())),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('HomeScreen bütçe seçeneklerini gösterir', (tester) async {
    await tester.pumpWidget(_wrap(const HomeScreen()));
    await tester.pump();

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.chooseBudget), findsOneWidget);
    expect(find.text(r'$5,000'), findsOneWidget);
    expect(find.text(r'$10,000'), findsOneWidget);
  });

  testWidgets('BudgetBar harcanan ve kalanı yansıtır', (tester) async {
    final build = BuildProvider()..setBudget(2000);
    await tester.pumpWidget(_wrap(
      const Scaffold(body: BudgetBar()),
      build: build,
    ));
    await tester.pump();

    expect(find.text(r'Kalan $2,000'), findsOneWidget);
    expect(find.text(r'Toplam bütçe $2,000'), findsOneWidget);
    expect(find.text(r'Harcanan $0'), findsOneWidget);
  });
}
