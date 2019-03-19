import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Home());
  }
}

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedProvider<double>(
      value: 00,
      curve: Curves.easeOut,
      duration: Duration(seconds: 1),
      child: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => Text(Provider.of<double>(context).toString()),
          ),
        ),
      ),
    );
  }
}
