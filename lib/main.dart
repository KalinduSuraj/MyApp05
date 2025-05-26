import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web-safe initialization
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDxKUXHe5D4z4cGRGAgW9VnBG9H7e7Bo2k",
      authDomain: "iot-project-01-92462.firebaseapp.com",
      databaseURL: "https://iot-project-01-92462-default-rtdb.firebaseio.com/",
      projectId: "iot-project-01-92462",
      storageBucket: "iot-project-01-92462.appspot.com",
      messagingSenderId: "255215661436",
      appId: "1:255215661436:web:f9c26932499f724e30aa16",
    ),
  );

  runApp(const MyApp04());
}

class MyApp04 extends StatefulWidget {
  const MyApp04({super.key});
  @override
  State createState() => _MyApp04State();
}

class _MyApp04State extends State<MyApp04> {
  int switchState = 0;
  Color bulbCol = Colors.grey;
  Text buttonText = const Text("ON");

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    // Listen for changes in Firebase
    dbRef.child('LED').onValue.listen((event) {
      final ledVal = event.snapshot.value;
      setState(() {
        switchState = (ledVal == 1) ? 1 : 0;
        bulbCol = (switchState == 1) ? Colors.yellow : Colors.grey;
        buttonText = (switchState == 1) ? const Text("OFF") : const Text("ON");
      });
    });
  }

  Future<void> toggleLED() async {
    final newState = (switchState == 1) ? 0 : 1; // Flip the LED state
    print("Attempting to set LED state to: $newState");

    try {
      await dbRef.child('LED').set(newState); // Write new state to Firebase
      print("Successfully updated LED state in database.");
    } catch (e) {
      print("Failed to write to database: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "IOT APP 05",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("LED 01",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
                const SizedBox(height: 10),
                Icon(Icons.lightbulb, size: 60, color: bulbCol),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: toggleLED,
                  child: buttonText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
