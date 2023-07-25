import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool _userLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    setState(() {
      _userLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return _userLoaded == false
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : widget.mobileScreenLayout;
    }));
  }
}
