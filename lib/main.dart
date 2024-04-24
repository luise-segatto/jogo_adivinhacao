import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SelectDifficultyPage(),
  ));
}

class SelectDifficultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione a Dificuldade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: Difficulty.easy)),
                );
              },
              child: Text('Fácil (1 - 100)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: Difficulty.medium)),
                );
              },
              child: Text('Médio (1 - 500)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: Difficulty.hard)),
                );
              },
              child: Text('Difícil (1 - 1000)'),
            ),
          ],
        ),
      ),
    );
  }
}

enum Difficulty {
  easy,
  medium,
  hard,
}

class GuessNumberGame extends StatefulWidget {
  final Difficulty difficulty;
  GuessNumberGame({required this.difficulty});

  @override
  _GuessNumberGameState createState() => _GuessNumberGameState();
}

class _GuessNumberGameState extends State<GuessNumberGame> {
  late int _numeroAleatorio;
  late int _tentativas;
  late int _palpite;
  late String _feedback;

  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  void _iniciarJogo() {
    setState(() {
      Random random = Random();
      switch(widget.difficulty) {
        case Difficulty.easy:
          _numeroAleatorio = random.nextInt(100) + 1;
          _tentativas = 10;
          break;
        case Difficulty.medium:
          _numeroAleatorio = random.nextInt(500) + 1;
          _tentativas = 5;
          break;
        case Difficulty.hard:
          _numeroAleatorio = random.nextInt(1000) + 1;
          _tentativas = 3;
          break;
      }
      _palpite = 0;
      _feedback = 'Tente adivinhar o número';
    });
  }

  void _adivinharNumero() {
    setState(() {
      _tentativas--;
      if (_palpite == _numeroAleatorio) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WonPage(tentativas: 10 - _tentativas, difficulty: widget.difficulty)),
        );
      } else if (_tentativas == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LostPage(numeroGerado: _numeroAleatorio)),
        );
      } else if (_palpite < _numeroAleatorio) {
        _feedback = 'Tente um número maior.';
      } else {
        _feedback = 'Tente um número menor.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Adivinhação'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _feedback,
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _palpite = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: 'Digite seu palpite',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _adivinharNumero,
              child: Text('Verificar'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _iniciarJogo();
              },
              child: Text('Reiniciar'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retorna para a página anterior (SelectDifficultyPage)
              },
              child: Text('Selecionar Dificuldade'),
            ),
          ],
        ),
      ),
    );
  }
}

class WonPage extends StatelessWidget {
  final int tentativas;
  final Difficulty difficulty;
  WonPage({required this.tentativas, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Você Ganhou!!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Parabéns! Você ganhou em $tentativas tentativas!',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GuessNumberGame(difficulty: difficulty)),
                );
              },
              child: Text('Jogar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class LostPage extends StatelessWidget {
  final int numeroGerado;
  LostPage({required this.numeroGerado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Você Perdeu:('),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Você perdeu após exceder o número de tentativas.',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            Text(
              'O número gerado era: $numeroGerado',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retorna para a página anterior (SelectDifficultyPage)
                Navigator.pop(context); // Retorna para a página do jogo e reinicia
              },
              child: Text('Jogar Novamente'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retorna para a página anterior (SelectDifficultyPage)
              },
              child: Text('Selecionar Dificuldade'),
            ),
          ],
        ),
      ),
    );
  }
}
