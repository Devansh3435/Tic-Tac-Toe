import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic-Tac-Toe'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 47, 44, 44),
        ),
        body: Center(
          child: Board(),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  bool _isPlayerX = true;

  void _onTileTap(int row, int col) {
  if (_board[row][col] == '') {
    setState(() {
      _board[row][col] = _isPlayerX ? 'X' : 'O';
      _isPlayerX = !_isPlayerX;

      if (_checkWinner(row, col)) {
        _showWinnerDialog(_isPlayerX ? 'O' : 'X');
        _resetBoard();
      } else if (_checkDraw()) {
        _showDrawDialog();
        _resetBoard();
      }
    });
  }
}


  bool _checkWinner(int row, int col) {
  // Check row
  if (_board[row][0] == _board[row][1] && _board[row][1] == _board[row][2]) {
    return true;
  }
  // Check column
  if (_board[0][col] == _board[1][col] && _board[1][col] == _board[2][col]) {
    return true;
  }
  // Check left diagonal
  if ((row == col) && (_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2])) {
    return true;
  }
  // Check right diagonal
  if ((row + col == 2) && (_board[0][2] == _board[1][1] && _board[1][1] == _board[2][0])) {
    return true;
  }
  return false;
}


  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Winner!'),
          content: Text('Player $winner wins!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetBoard() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _isPlayerX = true;
    });
  }

  bool _checkDraw() {
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (_board[row][col] == '') {
        return false; // If any cell is empty, the game is not a draw yet
      }
    }
  }
  return true; // All cells are filled, indicating a draw
}

  void _showDrawDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Draw!'),
        content: Text('The game is a draw!'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;
              String cellValue = _board[row][col] ?? '';
              Color glowColor = cellValue == 'X' ? Colors.red : Colors.blue;
              
              return GestureDetector(
                onTap: () => _onTileTap(row, col),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Text(
                      _board[row][col] ?? '',
                      style: TextStyle(
                        fontSize: 48.0,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            color: glowColor, // Set the color of the shadow
                            blurRadius: 10.0, // Set the blur radius of the shadow
                            spreadRadius: 5.0, // Set the spread radius of the shadow
                            offset: Offset(3, 2), // Set the offset of the shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
