import 'package:flutter/material.dart';
import 'package:pokedex_tracker/util/color_extension.dart';

const Color primaryColor = Colors.red;
const Color appBarTextColor = Colors.white;
const Color unselectedTabColor = Color(0xFFFAD54F);
const Color displayTextColor = Colors.black;
Map<String, Color> typesColor = {
  "Grass": '#82C274'.hexToColor(),
  "Water": '#74ACF5'.hexToColor(),
  "Fire": '#EF7374'.hexToColor(),
  "Normal": "#C1C2C1".hexToColor(),
  "Flying": '#ADD2F5'.hexToColor(),
  "Bug": '#B8C26A'.hexToColor(),
  "Poison": "#B884DD".hexToColor(),
  "Electric": '#FCD659'.hexToColor(),
  "Fighting": '#FFAC59'.hexToColor(),
  "Rock": '#CBC7AD'.hexToColor(),
  "Ground": '#B88E6F'.hexToColor(),
  "Fairy": '#F5A2F5'.hexToColor(),
  "Psychic": '#F584A8'.hexToColor(),
  "Dark": '#998B8C'.hexToColor(),
  "Steel": '#98C2D1'.hexToColor(),
  "Dragon": "#8D98EC".hexToColor(),
  "Ice": '#81DFF7'.hexToColor(),
  "Ghost": "#A284A2".hexToColor()
};