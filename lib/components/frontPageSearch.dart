import 'dart:async';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/utils/screenUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ball_iq/state/state.dart';

class FrontPageSearchForm extends StatefulWidget {
  const FrontPageSearchForm({super.key});

  @override
  _FrontPageSearch createState() => _FrontPageSearch();
}

class _FrontPageSearch extends State<FrontPageSearchForm> {
  final TextEditingController searchTextController = TextEditingController();
  Timer textTimer = Timer(Duration(milliseconds: 300), () => {});

  // While user is typing, wait 300ms before updating list.
  void _handleSearchTerm() {
    textTimer.cancel();
    textTimer = Timer(Duration(milliseconds: 300),
        () => {context.read<ToolFilter>().set(searchTextController.text)});
  }

  @override
  void initState() {
    super.initState();

    searchTextController.addListener(_handleSearchTerm);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(20, 255, 255, 255),
        margin: EdgeInsets.only(
            top: isTallScreen(context) && !isMobileScreen(context) ? 160 : 20),
        child: TextField(
          controller: searchTextController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
                onPressed: searchTextController.clear, icon: Icon(Icons.clear)),
            labelText: 'Search for a tools.',
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: themePrimary)),
          ),
        ));
  }
}
