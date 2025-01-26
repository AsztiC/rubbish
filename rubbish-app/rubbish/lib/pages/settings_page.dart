import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/data_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Default settings
  final List<bool> defaultBooleans = [false, true, false, true, false, true, false, false];
   List<String> items = [
    "batteries",
    "plastic bottles",
    "cans",
    "cardboard",
    "metal",
    "paper",
    "plastic bags",
    "plastic wrappers",
  ];

  // Function to update the booleans in the backend
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

  // Function to reset to default settings
  void _resetToDefaults(DataProvider dataProvider) {
    setState(() {
      dataProvider.updateBooleans(List.from(defaultBooleans));  // Reset to default values
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),  // Adjust vertical padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,  // Align the text to the right
                  children: [
                    Text(
                      'Accepts',  // This is the label
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // SwitchListTile for each setting
              ...List.generate(8, (index) {
                return SwitchListTile(
                  title: Text(items[index]),
                  value: dataProvider.booleans[index],
                  onChanged: (bool value) {
                    setState(() {
                      dataProvider.booleans[index] = value;  // Update the individual setting
                    });
                  },
                );
              }),
              // Padding added to the Row of buttons
              Padding(
                padding: const EdgeInsets.only(top: 20.0),  // Add top padding (adjust value as needed)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Space buttons evenly across the row
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Confirm reset action before resetting
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Reset'),
                            content: Text('Are you sure you want to revert to default settings?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _resetToDefaults(dataProvider);  // Reset the settings to default
                                  Navigator.pop(context);  // Close the dialog
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),  // Close the dialog without resetting
                                child: Text('No'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Revert to Default'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateBooleans(dataProvider),
                      child: Text('Update Settings'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}