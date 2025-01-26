import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> integers = [];
  List<String> items = [
    "batteries",
    "bottles",
    "cans",
    "pieces of cardboard",
    "pieces of metal",
    "pieces of paper",
    "plastic bags",
    "wrappers",
  ];
  List<String> item = [
    "battery",
    "bottle",
    "can",
    "piece of cardboard",
    "piece of metal",
    "piece of paper",
    "plastic bag",
    "wrapper",
  ];
  List<String> texts = [
    "Did you know? Glass bottles can be recycled endlessly without losing quality!",
    "Clean and dry items before recycling to prevent contamination.",
    "Pizza boxes can be recycled if they are free of grease and food residue.",
    "Plastic takes up to 500 years to decompose in landfills!",
    "Recycling one aluminum can saves enough energy to run a TV for three hours.",
    "Every ton of recycled paper saves 17 trees!",
  ];
  late String currentText;

  @override
  void initState() {
    super.initState();
    _loadIntegers();
    currentText = texts[0];
  }

  Future<void> _loadIntegers() async {
    try {
      List<int> data = await ApiService().getIntegers();
      setState(() {
        integers = data;
      });
    } catch (e) {
      print("Failed to load integers: $e");
    }
  }

  int? touchedIndex;
  bool _isDialogShowing = false;

  //Rectangle text randomizer
  void _changeText() {
    setState(() {
      currentText = (texts..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 40.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 80,
                      sections: showingSections(),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
          
                            final index = pieTouchResponse!.touchedSection!.touchedSectionIndex;
                            List<int> filteredIntegers = integers.where((value) => value != 0).toList();                       
                            if (!_isDialogShowing && index != -1 && filteredIntegers[index] != 0) {
                              String rubbish = item[index];
                              if (filteredIntegers[index] > 1){
                                rubbish = items[index];
                              }
                              _isDialogShowing = true;
                              setState(() {
                                touchedIndex = index;
                              });
                              
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Woohoo!'),
                                  content: Text('You have thrown away ${filteredIntegers[index]} $rubbish'),
                                ),
                              ).then((_) {             
                                setState(() {
                                  _isDialogShowing = false;
                                  touchedIndex = null;
                                });
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  //Centered Text in the Pie Chart
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total rubbish:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${integers.isNotEmpty ? integers.reduce((a, b) => a + b) : 0}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          //Fun fact rectangle
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                
                _changeText();
              } else if (details.primaryVelocity! < 0) {
                
                _changeText();
              }
            },
            child: Container(
              width: double.infinity,
              height: 150,
              color: const Color.fromARGB(255, 71, 51, 107),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        currentText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 30,  
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    if (integers.isEmpty) {
      return [];
    }
    int total = integers.reduce((a, b) => a + b);

    if (total == 0) return [];

    return List.generate(integers.length, (index) {
      final value = integers[index];
      final percentage = value / total;
      bool isSelected = touchedIndex == index;

      return PieChartSectionData(
        color: getColorForIndex(index),
        value: percentage * 100,
        title: '${(percentage * 100).toStringAsFixed(1)}%',
        radius: isSelected ? 100 : 90,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  //Piechart colors
  Color getColorForIndex(int index) {
    const colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Color.fromRGBO(227, 205, 1, 1),
      Colors.cyan,
      Colors.pink
    ];

    return colors[index % colors.length];
  }
}
