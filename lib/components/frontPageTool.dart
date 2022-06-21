import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:ball_iq/utils/screenUtils.dart';

class FrontPageToolData {
  String title = "";
  String subtitle = "";
  String text = "";
  IconData icon = Icons.shield;
  String callToAction = "";
  String landingPage = "";

  FrontPageToolData(this.title, this.subtitle, this.text, this.icon,
      this.callToAction, this.landingPage);
}

class FrontPageTool extends StatelessWidget {
  final FrontPageToolData toolData;
  const FrontPageTool({Key? key, required this.toolData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        color: brightText,
        child: Column(
          children: [
            ListTile(
              leading: Icon(toolData.icon, color: themePrimary, size: 40),
              title: Text(toolData.title),
              subtitle: Text(
                toolData.subtitle,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                toolData.text,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              layoutBehavior: ButtonBarLayoutBehavior.constrained,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    fixedSize: Size(270, 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    primary: darkText,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/${toolData.landingPage}');
                  },
                  label: Text(toolData.callToAction),
                  icon: Icon(color: themePrimary, Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FrontPageDisplay extends StatelessWidget {
  FrontPageDisplay({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO fill out these tools.
    List<FrontPageTool> tools = [];
    tools.add(FrontPageTool(
        toolData: FrontPageToolData(
            "Montage Maker",
            "Custom Highlight Reels",
            "Customized highlight reels featuring your favorite player. Select a game, player, and stat to build your perfect montage.",
            Icons.movie,
            "Customize",
            "montage")));
    tools.add(FrontPageTool(
        toolData: FrontPageToolData(
            "Shot Chart",
            "Graph & Plot",
            "Generate beautiful shot charts to display and analyze shooting behavior.",
            Icons.auto_graph,
            "Create",
            "https://")));
    tools.add(FrontPageTool(
        toolData: FrontPageToolData(
            "Insights",
            "Explore & Predict",
            "Explore patterns and deep statistics to win every twitter argument.",
            Icons.data_object,
            "Explore",
            "https://")));

    // Filter tools by the data stored in ToolFilter state.
    if (context.watch<ToolFilter>().filter != null &&
        context.watch<ToolFilter>().filter.toString().isNotEmpty) {
      List<String> terms = context
          .watch<ToolFilter>()
          .filter
          .toString()
          .toLowerCase()
          .split(' ');
      tools = tools.where((FrontPageTool tool) {
        List<String> titleTerms = tool.toolData.title.toLowerCase().split(' ');
        List<String> subtitleTerms =
            tool.toolData.subtitle.toLowerCase().split(' ');
        return terms.any((term) =>
            titleTerms.contains(term) || subtitleTerms.contains(term));
      }).toList();
    }

    return Container(
        margin: EdgeInsets.only(
            top: 20,
            left: isMobileScreen(context) ? 5 : 30,
            right: isMobileScreen(context) ? 5 : 30,
            bottom: 0),
        height: isMobileScreen(context)
            ? MediaQuery.of(context).size.height - 350
            : 285,
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: isMobileScreen(context)
                        ? Colors.transparent
                        : inactiveBackground),
                right: BorderSide(
                    color: isMobileScreen(context)
                        ? Colors.transparent
                        : inactiveBackground),
                top: BorderSide(
                    color: !isMobileScreen(context)
                        ? Colors.transparent
                        : inactiveBackground),
                bottom: BorderSide(
                    color: !isMobileScreen(context)
                        ? Colors.transparent
                        : inactiveBackground),
              ),
            ),
            child: ListView.builder(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: tools.length,
              scrollDirection:
                  isMobileScreen(context) ? Axis.vertical : Axis.horizontal,
              itemBuilder: (_, int i) {
                return tools[i];
              },
            ),
          ),
        ));
  }
}
