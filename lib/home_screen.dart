import 'package:flutter/material.dart';
import 'package:tic_tac/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text(
                      'Turn on/off Two player',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    value: isSwitched,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isSwitched = newValue!;
                      });
                    },
                  ),
                  Text(
                    "It's $activePlayer turn",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      children: List.generate(
                        9,
                        (index) => InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: gameOver ? null : () => _onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                Player.playerX.contains(index)
                                    ? 'X'
                                    : Player.playerO.contains(index)
                                        ? 'O'
                                        : '',
                                style: TextStyle(
                                  color: Player.playerX.contains(index)
                                      ? Colors.blue
                                      : Colors.pink,
                                  fontSize: 56,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        Player.playerX = [];
                        Player.playerO = [];
                        activePlayer = 'X';
                        gameOver = false;
                        turn = 0;
                        result = '';
                      });
                    },
                    label: const Text('Repeat the game'),
                    icon: const Icon(Icons.replay),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).splashColor,
                    ),
                  )
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          title: const Text(
                            'Turn on/off Two player',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          value: isSwitched,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isSwitched = newValue!;
                            });
                          },
                        ),
                        Text(
                          "It's $activePlayer turn",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              Player.playerX = [];
                              Player.playerO = [];
                              activePlayer = 'X';
                              gameOver = false;
                              turn = 0;
                              result = '';
                            });
                          },
                          label: const Text('Repeat the game'),
                          icon: const Icon(Icons.replay),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Theme.of(context).splashColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      children: List.generate(
                        9,
                        (index) => InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: gameOver ? null : () => _onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                Player.playerX.contains(index)
                                    ? 'X'
                                    : Player.playerO.contains(index)
                                        ? 'O'
                                        : '',
                                style: TextStyle(
                                  color: Player.playerX.contains(index)
                                      ? Colors.blue
                                      : Colors.pink,
                                  fontSize: 56,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;

      String winner = game.checkWinner();
      if (winner != '') {
        gameOver = true;
        result = '$winner is the winner';
      } else if (!gameOver && turn == 9) {
        result = "It's a Draw";
      }
    });
  }
}
