// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/components/common/background.dart';
import 'common/constants.dart';
import 'components/home/advertisement.dart';
import 'components/home/frontPageSearch.dart';
import 'components/home/frontPageTool.dart';
import 'components/home/topBar.dart';
import 'components/montageMaker/montageMaker.dart';
import 'services/nbaStatsService.dart';
import 'state/state.dart';
import 'utils/screenUtils.dart';

void main() {
  //MobileAds.instance.initialize();

  runApp(
    // Hook up state listeners.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DateSelect()),
        ChangeNotifierProvider(create: (_) => ToolFilter()),
        ChangeNotifierProvider(create: (_) => FrontPageScoreboardState()),
        ChangeNotifierProvider(create: (_) => MontageStat()),
        ChangeNotifierProvider(create: (_) => MontagePlayer()),
        ChangeNotifierProvider(create: (_) => MontageGame()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // for testing only
    Future.delayed(const Duration(milliseconds: 1000), () {
      context.read<DateSelect>().set(DateTime.parse("2022-03-11 00:00:00.000"));
      context.read<FrontPageScoreboardState>().markIsLoading(true);
      gameData(DateTime.parse("2022-03-11 00:00:00.000"))
          .then((List<Scoreboard> allGames) {
        context.read<FrontPageScoreboardState>().set(allGames);

        playerData("0022100997").then((List<PlayerBoxScore> players) {
          context.read<MontageGame>().set("0022100997", players);
        });
      });
    });
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              trackVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(2.0),
              radius: const Radius.circular(0.0),
              thumbColor: MaterialStateProperty.all(
                darkText.withOpacity(0.5),
              ),
              trackColor: MaterialStateProperty.all(
                themePrimary.withOpacity(0.25),
              ))),
      scrollBehavior: TotalScrollBehavior(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/montage': (context) => const MontageMaker(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          title: const SelectableText('BBall IQ'),
          backgroundColor: themePrimary,
          foregroundColor: darkText,
        ),
      ),
      body: MouseRegion(
        cursor: SystemMouseCursors.precise,
        // This part is wack. I use a stack to make a cool background.
        // Layer 1: gif image.
        // Layer 2: gradient background.
        // Layer 3: Actual widgets for the site.
        child: Background(
            color: themePrimary,
            child:
                // Layer 1: gif background.
                // Layer 3: side widgets
                SingleChildScrollView(
              child: Column(
                children: [
                  const TopBar(),
                  FrontPageAdvertisement(),
                  const FrontPageSearchForm(),
                  FrontPageDisplay(),
                ],
              ),
            )),
      ),
    );
  }
}
