import 'package:flutter/material.dart';
import 'package:activity5/page_one.dart';

void main() {

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Permissions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageOne()
  ));
}