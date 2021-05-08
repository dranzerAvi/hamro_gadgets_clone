import 'package:flutter/material.dart';
import 'package:hamro_gadgets/Constants/modals.dart';

const primarycolor = Color(0xff1a3e59);
const secondarycolor = Color.fromRGBO(245, 249, 255, 1);

const Color primary = Color(0xff1a3e59);
const Color primaryDark = Color(0xff470938);
const Color accent = Color(0xffffffff);
const Color activeData = Color(0xff1DD75F);

//AlgorithmTitles
const String bubbleSortTitle = 'Bubble Sort';
const String selectionSortTitle = 'Selection Sort';
const String insertionSortTitle = 'Insertion Sort';

//ComplexityString
const bigOh = 'O';
const logN = 'log(n)';
const nsquare = 'n2';
const logNsquare = 'log(n2)';

//Algorithms
final List<SortingAlgorithm> sortingAlgorithmsList = [
  SortingAlgorithm(
    title: selectionSortTitle,
    complexity: nsquare,
    resources: [
      Resource('GeeksForGeeks', 'https://www.geeksforgeeks.org/bubble-sort/'),
    ],
  ),
  SortingAlgorithm(
    title: insertionSortTitle,
    complexity: nsquare,
    resources: [
      Resource('GeeksForGeeks', 'https://www.geeksforgeeks.org/bubble-sort/'),
    ],
  ),
  SortingAlgorithm(
    title: bubbleSortTitle,
    complexity: logNsquare,
    resources: [
      Resource('GeeksForGeeks', 'https://www.geeksforgeeks.org/bubble-sort/'),
    ],
  ),
];
