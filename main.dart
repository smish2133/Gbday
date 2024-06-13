import 'package:flutter/material.dart';

void main() {
  runApp(WordleGame());
}

class WordleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordleHomePage(),
    );
  }
}

class WordleHomePage extends StatefulWidget {
  @override
  _WordleHomePageState createState() => _WordleHomePageState();
}

class _WordleHomePageState extends State<WordleHomePage> {
  final String targetWord = 'Globe'.toUpperCase();
  final TextEditingController _controller = TextEditingController();
  List<String> guesses = [];
  Map<String, Color> keyboardState = {
    for (var c in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) c: Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordle Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your guess',
              ),
            ),
            ElevatedButton(
              onPressed: _checkGuess,
              child: Text('Submit'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: guesses.length,
                itemBuilder: (context, index) {
                  return _buildGuessResult(guesses[index]);
                },
              ),
            ),
            _buildKeyboard(),
          ],
        ),
      ),
    );
  }

  void _checkGuess() {
    String guess = _controller.text.trim().toUpperCase();
    if (guess.length != targetWord.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Guess must be ${targetWord.length} letters long.')),
      );
      return;
    }
    setState(() {
      guesses.add(guess);
      _updateKeyboardState(guess);
    });
    _controller.clear();

    if (guess == targetWord) {
      _showSuccessDialog();
    }
  }

  void _updateKeyboardState(String guess) {
    for (int i = 0; i < guess.length; i++) {
      if (guess[i] == targetWord[i]) {
        keyboardState[guess[i]] = Colors.green;
      } else if (targetWord.contains(guess[i]) &&
          keyboardState[guess[i]] != Colors.green) {
        keyboardState[guess[i]] = Colors.yellow;
      } else if (!targetWord.contains(guess[i])) {
        keyboardState[guess[i]] = Colors.red;
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Good Job!'),
          content: Text('Make your way to the next challenge at USS'),
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

  Widget _buildGuessResult(String guess) {
    List<Widget> result = [];
    for (int i = 0; i < guess.length; i++) {
      Color color;
      if (guess[i] == targetWord[i]) {
        color = Colors.green;
      } else if (targetWord.contains(guess[i])) {
        color = Colors.yellow;
      } else {
        color = Colors.grey;
      }
      result.add(Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        color: color,
        child: Text(
          guess[i],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: result,
    );
  }

  Widget _buildKeyboard() {
    List<Widget> rows = [];
    String keys = 'QWERTYUIOPASDFGHJKLZXCVBNM';
    for (int i = 0; i < keys.length; i += 10) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys
            .substring(i, i + 10 > keys.length ? keys.length : i + 10)
            .split('')
            .map((e) => _buildKey(e))
            .toList(),
      ));
    }
    return Column(
      children: rows,
    );
  }

  Widget _buildKey(String key) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: keyboardState[key],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        key,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
