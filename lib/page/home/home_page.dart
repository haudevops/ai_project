import 'package:ai_project/routes/screen_argument.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.data}) : super(key: key);
  final ScreenArguments data;

  static const routeName = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = widget.data.arg1;
    password = widget.data.arg2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
