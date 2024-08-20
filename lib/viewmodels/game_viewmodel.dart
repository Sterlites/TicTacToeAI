import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../utils/constants.dart';

class GameViewModel extends ChangeNotifier {
  bool oTurn = true;
  List<String> bordState = ['', '', '', '', '', '', '', '', ''];
  List<int> winIndexes = [];
  int count = 0;
  int oScore = 0;
  int xScore = 0;
  String resultDeclaration = '';
  bool isOn = true;
  final bool isSinglePlayer;
  bool showConfetti = false;

  GameViewModel({required this.isSinglePlayer});

  void tapped(int index) {
    if (isOn && bordState[index].isEmpty) {
      if (count % 2 == 0) {
        bordState[index] = 'X';
        count++;
        checkWinner();
        if (isSinglePlayer && count < 9) {
          makeComputerMove();
        }
      } else {
        bordState[index] = 'O';
        count++;
        checkWinner();
      }
      notifyListeners();
    }
  }

  void makeComputerMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      List<int> availableMoves = [];
      for (int i = 0; i < 9; i++) {
        if (bordState[i].isEmpty) {
          availableMoves.add(i);
        }
      }
      for (int move in availableMoves) {
        List<String> tempBoard = List.from(bordState);
        tempBoard[move] = 'O';
        if (checkWin(tempBoard, 'O')) {
          tapped(move);
          return;
        }
      }
      for (int move in availableMoves) {
        List<String> tempBoard = List.from(bordState);
        tempBoard[move] = 'X';
        if (checkWin(tempBoard, 'X')) {
          tapped(move);
          return;
        }
      }
      if (availableMoves.isNotEmpty) {
        int randomIndex =
            availableMoves[Random().nextInt(availableMoves.length)];
        tapped(randomIndex);
      }
    });
  }

  bool checkWin(List<String> board, String player) {
    for (List<int> line in AppConstants.winLines) {
      if (board[line[0]] == player &&
          board[line[1]] == player &&
          board[line[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void checkWinner() {
    for (var line in AppConstants.winLines) {
      if (line.every((index) => bordState[index] == 'X')) {
        declareWinner('X', line);
        return;
      } else if (line.every((index) => bordState[index] == 'O')) {
        declareWinner('O', line);
        return;
      }
    }
    if (count == 9) {
      declareWinner('Nobody');
    }
  }

  void declareWinner(String winner, [List<int>? winningLine]) {
    if (winner == 'Nobody') {
      resultDeclaration = 'Nobody Wins';
    } else {
      resultDeclaration = 'Player $winner Wins';
      if (winningLine != null) {
        winIndexes.addAll(winningLine);
      }
      updateScore(winner);
      showConfetti = true;
      _playWinSound();
    }
    isOn = false;
    notifyListeners();
    // Hide confetti after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      showConfetti = false;
      notifyListeners();
    });
  }

  void _playWinSound() {
    FlutterRingtonePlayer.playNotification();
  }

  void updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
  }

  void clearBoard() {
    for (int i = 0; i < 9; i++) {
      bordState[i] = '';
    }
    resultDeclaration = '';
    winIndexes = [];
    count = 0;
    isOn = true;
    notifyListeners();
  }
}
