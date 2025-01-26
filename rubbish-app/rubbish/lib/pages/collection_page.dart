import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<int> integers = [];

  @override
  void initState() {
    super.initState();
    _loadIntegers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Page'),
      ),
      body: integers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: integers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Integer: ${integers[index]}'),
                );
              },
            ),
    );
  }
}
