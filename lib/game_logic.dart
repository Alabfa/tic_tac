import 'dart:math';

class Player {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';

  static List<int> playerX = [];
  static List<int> playerO = [];
}

extension on List<int> {
  bool containsAll(int x, int y, [z]) {
    if (z != null) {
      return contains(x) && contains(y) && contains(z);
    } else {
      return contains(x) && contains(y);
    }
  }
}

class Game {
  void playGame(int index, String activePlayer) {
    if (activePlayer == 'X') {
      Player.playerX.add(index);
    } else {
      Player.playerO.add(index);
    }
  }

  String checkWinner() {
    String winner = '';

    if (Player.playerX.containsAll(0, 1, 2) ||
        Player.playerX.containsAll(3, 4, 5) ||
        Player.playerX.containsAll(1, 4, 7) ||
        Player.playerX.containsAll(0, 3, 6) ||
        Player.playerX.containsAll(0, 4, 8) ||
        Player.playerX.containsAll(2, 5, 8) ||
        Player.playerX.containsAll(2, 4, 6) ||
        Player.playerX.containsAll(6, 7, 8)) {
      winner = 'X';
    } else if (Player.playerO.containsAll(0, 1, 2) ||
        Player.playerO.containsAll(3, 4, 5) ||
        Player.playerO.containsAll(1, 4, 7) ||
        Player.playerO.containsAll(0, 3, 6) ||
        Player.playerO.containsAll(0, 4, 8) ||
        Player.playerO.containsAll(2, 5, 8) ||
        Player.playerO.containsAll(2, 4, 6) ||
        Player.playerO.containsAll(6, 7, 8)) {
      winner = 'O';
    } else {
      winner = '';
    }

    return winner;
  }

  Future<void> autoPlay(String activePlayer) async {
    int index = 0;
    List<int> emptyCells = [];

    for (var i = 0; i < 9; i++) {
      if (!(Player.playerX.contains(i) || Player.playerO.contains(i))) {
        emptyCells.add(i);
      }
    }

    // Define win conditions (all rows, columns, and diagonals)
    List<List<int>> winConditions = [
      [0, 1, 2], // Row 1
      [3, 4, 5], // Row 2
      [6, 7, 8], // Row 3
      [0, 3, 6], // Column 1
      [1, 4, 7], // Column 2
      [2, 5, 8], // Column 3
      [0, 4, 8], // Diagonal 1
      [2, 4, 6], // Diagonal 2
    ];

    // 1. Check if the bot can win
    for (var condition in winConditions) {
      int countBot = 0;
      int emptySpot = -1;
      for (var cell in condition) {
        if (Player.playerO.contains(cell)) {
          countBot++;
        } else if (emptyCells.contains(cell)) {
          emptySpot = cell;
        }
      }
      if (countBot == 2 && emptySpot != -1) {
        index = emptySpot;
        playGame(index, activePlayer);
        return;
      }
    }

    // 2. Block the opponent (Player X) from winning
    for (var condition in winConditions) {
      int countOpponent = 0;
      int emptySpot = -1;
      for (var cell in condition) {
        if (Player.playerX.contains(cell)) {
          countOpponent++;
        } else if (emptyCells.contains(cell)) {
          emptySpot = cell;
        }
      }
      if (countOpponent == 2 && emptySpot != -1) {
        index = emptySpot;
        playGame(index, activePlayer);
        return;
      }
    }

    Random random = Random();
    int randomIndex = random.nextInt(emptyCells.length);
    index = emptyCells[randomIndex];

    playGame(index, activePlayer);
  }
}
