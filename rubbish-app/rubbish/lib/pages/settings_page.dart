import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/data_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _updateBooleans(DataProvider dataProvider) async {
    try {
      await ApiService().setBooleans(dataProvider.booleans);
      await dataProvider.updateBooleans(dataProvider.booleans);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booleans updated successfully")));
    } catch (e) {
      print("Error updating booleans: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update booleans")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings Page'),
          ),
          body: Column(
            children: [
              ...List.generate(8, (index) {
                return SwitchListTile(
                  title: Text('Setting ${index + 1}'),
                  value: dataProvider.booleans[index],
                  onChanged: (bool value) {
                    setState(() {
                      dataProvider.booleans[index] = value;
                    });
                  },
                );
              }),
              ElevatedButton(
                onPressed: () => _updateBooleans(dataProvider),
                child: Text('Update Settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}
