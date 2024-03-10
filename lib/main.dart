import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import SystemNavigator
import 'package:tiktactoe/custom_dialogue.dart';
import 'package:tiktactoe/game_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartingPage(), // Initially show the starting page
    );
  }
}

class StartingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Tic Tac Toe',
          style: TextStyle(fontSize: 24), // Increased font size
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue, // Set background color to blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the game page when the "Play" button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text(
                'Play',
                style: TextStyle(fontSize: 24), // Increased font size
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Set button color to orange
                minimumSize: Size(200, 80), // Set button size
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exit the app when the "Quit" button is pressed
                SystemNavigator.pop();
              },
              child: Text(
                'Quit',
                style: TextStyle(fontSize: 24), // Increased font size
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Set button color to orange
                minimumSize: Size(200, 80), // Set button size
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonlist;
  late var activePlayer;
  List<int> player1 = []; // List to store player 1's moves
  List<int> player2 = []; // List to store player 2's moves

  @override
  void initState() {
    super.initState();
    buttonlist = doInit();
    activePlayer = 1; // Initialize the active player
  }

  List<GameButton> doInit() {
    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.blue;
        player1.add(gb.id); // Add the button ID to player1's list
        activePlayer = 2;
      } else {
        gb.text = "O";
        gb.bg = Colors.black;
        player2.add(gb.id); // Add the button ID to player2's list
        activePlayer = 1;
      }
      gb.enabled = false;
      var winner = checkWinner();
      if (winner == -1) {
        if (buttonlist.every((p) => p.text != "")) {
          showDialog(
            context: context,
            builder: (_) => CustomDialogue(
              "Game Tied",
              "Please press the reset button to start",
              resetGame,
            ),
          );
        }
      }
    });
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonlist = doInit();
      player1.clear(); // Clear player 1's moves
      player2.clear(); // Clear player 2's moves
    });
  }

  int checkWinner() {
    var winner = -1;

    // Check rows
    for (var i = 0; i < 3; i++) {
      if (buttonlist[i * 3].text != "" &&
          buttonlist[i * 3].text == buttonlist[i * 3 + 1].text &&
          buttonlist[i * 3 + 1].text == buttonlist[i * 3 + 2].text) {
        if (buttonlist[i * 3].text == "X") {
          winner = 1;
        } else {
          winner = 2;
        }
        break;
      }
    }

    // Check columns
    for (var i = 0; i < 3; i++) {
      if (buttonlist[i].text != "" &&
          buttonlist[i].text == buttonlist[i + 3].text &&
          buttonlist[i + 3].text == buttonlist[i + 6].text) {
        if (buttonlist[i].text == "X") {
          winner = 1;
        } else {
          winner = 2;
        }
        break;
      }
    }

    // Check diagonals
    if (buttonlist[0].text != "" &&
        buttonlist[0].text == buttonlist[4].text &&
        buttonlist[4].text == buttonlist[8].text) {
      if (buttonlist[0].text == "X") {
        winner = 1;
      } else {
        winner = 2;
      }
    }
    if (buttonlist[2].text != "" &&
        buttonlist[2].text == buttonlist[4].text &&
        buttonlist[4].text == buttonlist[6].text) {
      if (buttonlist[2].text == "X") {
        winner = 1;
      } else {
        winner = 2;
      }
    }

    // If no winner and all buttons are filled, it's a tie
    if (winner == -1 && buttonlist.every((p) => p.text != "")) {
      winner = 0; // Tie
    }

    if (winner != -1) {
      showDialog(
        context: context,
        builder: (_) => CustomDialogue(
          winner == 0 ? "Game Tied" : "Player $winner won",
          "Please press the reset button to start",
          resetGame,
        ),
      );
    }

    return winner;
  }

  @override
  Widget build(BuildContext context) {
    String currentPlayer = activePlayer == 1 ? "Player 1 (X)" : "Player 2 (O)";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tic Tac Toe"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xfff6921e), Color(0xffee4036)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Current Turn: $currentPlayer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 9.0,
                    ),
                    itemCount: buttonlist.length,
                    itemBuilder: (context, index) => SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: buttonlist[index].enabled
                              ? () => playGame(buttonlist[index])
                              : null,
                          child: Text(
                            buttonlist[index].text,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonlist[index].bg,
                            disabledBackgroundColor: buttonlist[index].bg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// this one better
