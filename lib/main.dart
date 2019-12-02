import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'gamelogic.dart';
import 'dart:math';

//import 'package:flutter/animation.dart';
bool computerPlayerMode = false;
bool computerTurn = false;

void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {
// When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => ChooseGameModePage(),
// When navigating to the "/second" route, build the SecondScreen widget.
    '/homepage': (context) => TicTacToePage(),
  }));
}

class ChooseGameModePage extends StatefulWidget {
  @override
  _ChooseGameModePageState createState() => _ChooseGameModePageState();
}

class _ChooseGameModePageState extends State<ChooseGameModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "TIC TAC TOE",
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontFamily: 'Quicksand'),
                ),
                SizedBox(height: 30,),
                Text(
                  "Choose Game Mode",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'Quicksand'),
                ),
                SizedBox(height: 20,),
                Column(
                  children: <Widget>[
                    RaisedButton(
                      
                      color: Colors.transparent,
                      child: Text('Single Player (v/s Computer)',style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Quicksand'),),
                      onPressed: () {
                        computerPlayerMode = true;
                        print("computer mode selected",);
                        setState(() {});
                        // Navigator.push(context,MaterialPageRoute(builder: (context)=> HomePage()));
                        Navigator.pushNamed(context, '/homepage');
                      },
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      color: Colors.transparent,
                      child: Text('Two Players',style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Quicksand'),),
                      onPressed: () {
                        computerPlayerMode = false;
                        // Navigator.push(context,MaterialPageRoute(builder: (context)=> HomePage()));
                        Navigator.pushNamed(context, '/homepage');
                      },
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),

        );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _animation;

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this, value: 0);
    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      //print(controller.value);
      setState(() {});
    });
    super.initState();
  }

  Widget createIconFromToken(Token t) {
    if (t == null) {
      return null;
    }
    if (t == Token.x) {
      return Transform.scale(
        scale: Tween(begin: 1.0, end: 1.5).transform(controller.value),
        child: Icon(
          Icons.close,
          size: 90,
          color: Colors.white,
        ),
      );
    } else {
      return Transform.scale(
        scale: Tween(begin: 1.0, end: 1.5).transform(controller.value),
        child: Icon(
          Icons.radio_button_unchecked,
          size: 90,
          color: Colors.white,
        ),
      );
    }
  }

  Color createColorFromBool(bool isHighlighted) {
    if (isHighlighted) {
      return Colors.yellow.withOpacity(0.6);
    } else {
      return Colors.white24;
    }
  }

  Widget createExpandedCell(int row, int col) {
    return Expanded(
      child: OneBox(
        buttonChild: createIconFromToken(board[row][col]),
        backgroundColor: createColorFromBool(colorBoard[row][col]),
        onPressed: () {
          controller.forward();
          updateBox(row, col);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CurvedAnimation smoothAnimation =
        CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    return Scaffold(
      backgroundColor: Color(0xFFD6AA7C),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Tic-Tac-Toe",
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontFamily: 'Quicksand'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Transform.scale(
                  scale: winnerCheck(board)
                      ? Tween(begin: 1.0, end: 1.5).transform(controller.value)
                      : 1.0,
                  child: Text(
                    getCurrentStatus(),
                    style: TextStyle(
                        fontSize: 25,
                        color: winnerCheck(board)
                            ? ColorTween(
                                    begin: Colors.white, end: Colors.yellow)
                                .transform(controller.value)
                            : Colors.white.withOpacity(0.6),
                        fontFamily: 'Quicksand'),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.all(6),
                child: Column(
                  children: <Widget>[
                    createExpandedRow(0),
                    createExpandedRow(1),
                    createExpandedRow(2),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: FlatButton(
                        color: Color(0xFF848AC1),
                        onPressed: () {
                          gameReset();
                          setState(() {});
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text("Reset",
                            style:
                                TextStyle(fontSize: 25, color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                    flex: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateBox(int r, int c) {
    print("update box method called");
    if (!computerPlayerMode) {
      print("user turn");

      if (legitMove(board[r][c])) {
        print("Move registered player mode");
        board[r][c] = currentPlayer;
        changePlayerIfGameIsNotOver();
      }
    }else if(computerPlayerMode && !computerTurn){
      if (legitMove(board[r][c])) {
        controller.forward();
        board[r][c] = currentPlayer;
        print("Player Moves in computer mode ");
        print("hi");
        computerTurn=!computerTurn;
        changePlayerIfGameIsNotOver();
        setState(() {
        });

        int row;
        int col;
        Random rand= new Random();
        do{
          row=rand.nextInt(3);
          col=rand.nextInt(3);
          print("row=$row");
          print("col=$col");
        }
        while(!legitMove(board[row][col]) && !fullBoard(board) && !winnerCheck(board));

        updateBox(row, col);
      }
    }

    if(computerPlayerMode && computerTurn){
       controller.forward();
        board[r][c] = currentPlayer;
        print("Computer Moves in computer mode ");
        computerTurn=!computerTurn;
        changePlayerIfGameIsNotOver();
        setState(() {});
    }
  }

  Widget createExpandedRow(int row) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          createExpandedCell(row, 0),
          createExpandedCell(row, 1),
          createExpandedCell(row, 2),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class OneBox extends StatelessWidget {
  final Widget buttonChild;
  final Function onPressed;
  final Color backgroundColor;

  OneBox(
      {this.buttonChild = const Text(''),
      this.onPressed,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: buttonChild == null ? 0.0 : 1.0,
            child: buttonChild),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
      ),
    );
  }
}
