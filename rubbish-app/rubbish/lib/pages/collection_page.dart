import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<int> integers = [];

  // Categories and their unlocking requirements
  final List<String> categories = [
    "batteries", "plastic_bottles", "cans", "cardboard", 
    "metal", "paper", "plastic_bags", "plastic_wrappers"
  ];
  
  final List<int> unlockRequirements = [1, 2, 5, 10, 15, 20, 25, 30];

  // Fun facts about each type of rubbish
  final Map<String, String> rubbishFacts = {
    "batteries": "Batteries can be recycled to avoid harmful chemicals entering the environment.",
    "plastic_bottles": "Plastic bottles take up to 450 years to decompose in landfills.",
    "cans": "Aluminum cans can be recycled indefinitely without losing quality.",
    "cardboard": "Recycling cardboard helps reduce deforestation and conserves energy.",
    "metal": "Recycling metal saves significant energy and reduces greenhouse gases.",
    "paper": "Recycling paper reduces the need for deforestation.",
    "plastic_bags": "Plastic bags can be recycled, but many end up in landfills or oceans.",
    "plastic_wrappers": "Plastic wrappers are commonly not recycled and can take centuries to break down."
  };

  @override
  void initState() {
    super.initState();
    _loadIntegers();
  }

  Future<void> _loadIntegers() async {
    try {
      List<int> data = await ApiService().getIntegers();  // Fetch the integers from your API
      setState(() {
        integers = data;
      });
    } catch (e) {
      print("Failed to load integers: $e");
    }
  }

  // Check if a specific category is unlocked
  bool isUnlocked(int index) {
    return integers[index] >= unlockRequirements[index];
  }

  // Show the fact about a specific rubbish type
  void showFact(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fact about $category"),
        content: Text(rubbishFacts[category]!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collection Page"),
      ),
      body: integers.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: categories.length, // Number of categories
              itemBuilder: (context, index) {
                String category = categories[index];
                String imagePath = 'assets/images/$category.jpg';

                return GestureDetector(
                  onTap: isUnlocked(index)
                      ? () => showFact(category) // Show fact if unlocked
                      : null,  // Do nothing if locked
                  child: Container(
                    decoration: BoxDecoration(
                      color: isUnlocked(index) ? Colors.transparent : Colors.grey,  // Green if unlocked, grey if locked
                      borderRadius: BorderRadius.circular(8.0),
                      image: isUnlocked(index)
                          ? DecorationImage(
                              image: AssetImage(imagePath),  // Use images for unlocked items
                              fit: BoxFit.cover,
                            )
                          : null,  // No image for locked items
                    ),
                    child: Center(
                      child: isUnlocked(index)
                          ? Icon(Icons.check, color: Colors.white, size: 40)  // Show checkmark if unlocked
                          : Icon(Icons.lock, color: Colors.white, size: 40),  // Show lock if locked
                    ),
                  ),
                );
              },
            ),
    );
  }
}
