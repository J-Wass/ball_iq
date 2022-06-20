import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'state/state.dart';
import 'utils/screenUtils.dart';
import 'components/frontPageTool.dart';
import 'components/frontPageSearch.dart';
import 'components/topBar.dart';
import 'components/advertisement.dart';
import 'components/montageMaker/montageMaker.dart';
import 'services/nbaStatsService.dart';

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
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
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
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage("assets/dunk_background.gif"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const TopBar(),
                    FrontPageAdvertisement(),
                    const FrontPageSearchForm(),
                    FrontPageDisplay(),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.transparent,
                          themePrimary.withAlpha(150),
                        ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}