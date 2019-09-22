import 'package:flutter/material.dart';
import './ui/klimatic.dart';

void main(){
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Climatic Weather App",
      home: Klimatic(),
    )
  );
}