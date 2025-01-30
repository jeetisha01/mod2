import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
//Starting of the file add


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return AuthScreen();
          //return snapshot.hasData ? DiceGameApp() : AuthScreen();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;

  void handleAuth() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: handleAuth, child: Text(isLogin ? "Login" : "Sign Up")),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Create an account" : "Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}

/*void main() {
  runApp(DiceGameApp());
}*/

class DiceGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceGame(),
    );
  }
}

class DiceGame extends StatefulWidget {
  @override
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  int walletBalance = 10;
  int wager = 0;
  String selectedGameType = "2 Alike";
  //Take Wager as input
  final TextEditingController wagerController = TextEditingController();

  //Initialize all dice to 1
  List<int> dice = [1, 1, 1, 1]; // Initialize all dice to 1

  //Roll dice to get random number in for loop
  void rollDice() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        dice[i] = Random().nextInt(6) + 1; // Random number between 1 and 6
      }
    });
  }

  void checkGameResult() {
    rollDice();

    bool win = false;

    //Manipulate dice result to arrive new wallet balance
    if (selectedGameType == "2 Alike" && dice[0] == dice[1]) {
      walletBalance += wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[0] == dice[2]){
      walletBalance += wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[0] == dice[3]){
      walletBalance += wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[1] == dice[2]){
      walletBalance += wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[1] == dice[3]){
      walletBalance += wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[3] == dice[2]){
      walletBalance += wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[0] == dice[1] && dice[0] == dice[2]) {
      walletBalance -= wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[0] == dice[1] && dice[0] == dice[3]) {
      walletBalance -= wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[0] == dice[3] && dice[0] == dice[2]) {
      walletBalance -= wager * 2;
      win = true;
    } else if (selectedGameType == "2 Alike" && dice[3] == dice[1] && dice[3] == dice[2]) {
      walletBalance -= wager * 2;
      win = true;
    }
    else if (selectedGameType == "3 Alike" && dice[0] == dice[1] && dice[0] == dice[2]) {
      walletBalance += wager * 3;
      win = true;
    } else if (selectedGameType == "3 Alike" && dice[0] == dice[1] && dice[0] == dice[3]) {
      walletBalance += wager * 3;
      win = true;
    } else if (selectedGameType == "3 Alike" && dice[0] == dice[3] && dice[0] == dice[2]) {
      walletBalance += wager * 3;
      win = true;
    } else if (selectedGameType == "3 Alike" && dice[3] == dice[1] && dice[3] == dice[2]) {
      walletBalance += wager * 3;
      win = true;
    } else if (selectedGameType == "4 Alike" && dice[0] == dice[1] && dice[0] == dice[2] && dice[0] == dice[3]) {
      walletBalance += wager * 4;
      win = true;
    } else {
      if (selectedGameType == "4 Alike") {
        walletBalance -= wager * 4;
      } else if (selectedGameType == "3 Alike") {
        walletBalance -= wager * 3;
      } else if (selectedGameType == "2 Alike") {
        walletBalance -= wager * 2;
      }
    }

    // Display result via Toast
    String resultMessage =
        "Dice: ${dice.join(", ")}\nYou ${win ? 'Won' : 'Lost'}! New Balance: $walletBalance";
    Fluttertoast.showToast(
      msg: resultMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );


    // Clear wager input
    wagerController.clear();
  }

  bool validateWager()
  {
    if (wager <= 0 || wager > walletBalance) {
      Fluttertoast.showToast(
        msg: "Invalid Wager",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return true;
    }

    int maxWager = 0;
    if (selectedGameType == "2 Alike") {
      maxWager = walletBalance ~/ 2;
    } else if (selectedGameType == "3 Alike") {
      maxWager = walletBalance ~/ 3;
    } else if (selectedGameType == "4 Alike") {
      maxWager = walletBalance ~/ 4;
    }

    if (wager > maxWager)
    {
      Fluttertoast.showToast(
        msg: "Wager exceeds maximum allowed wager for $selectedGameType.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return true;
    }

    return true;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Game'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Wallet Balance: $walletBalance coins",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: wagerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Wager Amount",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  wager = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedGameType,
              items: ["2 Alike", "3 Alike", "4 Alike"]
                  .map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGameType = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (validateWager()) {
                  checkGameResult();
                }
              },
              child: Text("GO"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Dice Rolls:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dice.map((d) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/dice$d.png',
                    width: 50,
                    height: 50,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


