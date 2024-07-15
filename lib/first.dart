import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  String _expression = "";
  String _result = "";

  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        _expression = "";
        _result = "";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression.replaceAll('x', '*'));
          ContextModel cm = ContextModel();
          _result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          _result = "Error";
        }
      } else {
        _expression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 40, color: Colors.orange),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 500,
            color: Colors.grey[900],
            child: Column(
              children: [
                _buildButtonRow(["7", "8", "9", "/"]),
                _buildButtonRow(["4", "5", "6", "x"]),
                _buildButtonRow(["1", "2", "3", "-"]),
                _buildButtonRow(["C", "0", "=", "+"]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return _buildButton(value);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String value) {
    return AnimatedButton(
      value: value,
      onPressed: () => _buttonPressed(value),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String value;
  final VoidCallback onPressed;

  const AnimatedButton({required this.value, required this.onPressed});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color _buttonColor;

    switch (widget.value) {
      case 'C':
        _buttonColor = Colors.redAccent;
        break;
      case '/':
        _buttonColor = Colors.orangeAccent;
        break;
      case 'x':
        _buttonColor = Colors.yellowAccent;
        break;
      case '-':
        _buttonColor = Colors.greenAccent;
        break;
      case '+':
        _buttonColor = Colors.blueAccent;
        break;
      case '=':
        _buttonColor = Colors.purpleAccent;
        break;
      default:
        _buttonColor = Colors.grey[800]!;
        break;
    }

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.9).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double buttonSize = constraints.maxWidth / 4 - 16;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: _buttonColor,
                onPrimary: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                textStyle: TextStyle(fontSize: 24),
                fixedSize: Size(buttonSize, buttonSize),
              ),
              onPressed: () {
                _controller.forward().then((_) {
                  _controller.reverse();
                  widget.onPressed();
                });
              },
              child: Text(widget.value),
            );
          },
        ),
      ),
    );
  }
}

