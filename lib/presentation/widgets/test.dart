import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(_Test());

class _Test extends StatelessWidget {
  final TextEditingController _query = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text('Hello World'),
              SizedBox(height: 16),
              TextField(
                controller: _query,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
                onSubmitted: (value) {
                  print(value);
                },
              )
            ],
          ),
        )
      ),
    );
  }
}