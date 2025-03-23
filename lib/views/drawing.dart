import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawingBoard extends StatefulWidget {
  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  static const int rows = 11;
  static const int cols = 44;
  List<List<Color>> grid = List.generate(
    rows,
        (row) => List.generate(cols, (col) => Colors.white),
  );

  final List<Color> _colors = [Colors.black, Colors.red, Colors.blue, Colors.green, Colors.white];
  int _currentColorIndex = 0;
  TextEditingController _textController = TextEditingController();
  Map<int, int> _letterColors = {}; // Stores the color index for each letter

  void _toggleCell(int row, int col) {
    setState(() {
      grid[row][col] = _colors[_currentColorIndex];
    });
  }

  void _clearGrid() {
    setState(() {
      grid = List.generate(rows, (row) => List.generate(cols, (col) => Colors.white));
    });
  }

  void _setColor(int index) {
    setState(() {
      _currentColorIndex = index;
    });
  }

  void _setLetterColor(int letterIndex, int colorIndex) {
    setState(() {
      _letterColors[letterIndex] = colorIndex;
    });
  }

  void _drawTextOnGrid(String text) {
    _clearGrid();
    for (int i = 0; i < text.length && i < cols ~/ 4; i++) {
      int colorIndex = _letterColors[i] ?? _currentColorIndex; // Get color for the letter
      _drawCharacter(text[i].toUpperCase(), i * 4, colorIndex);
    }
  }

  void _drawCharacter(String char, int startCol, int colorIndex) {
    List<List<int>>? pattern = _getCharacterPattern(char);
    if (pattern == null) return;

    for (int row = 0; row < pattern.length; row++) {
      for (int col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          int targetCol = startCol + col;
          if (row < rows && targetCol < cols) {
            grid[row][targetCol] = _colors[colorIndex];
          }
        }
      }
    }
    setState(() {});
  }

  List<List<int>>? _getCharacterPattern(String char) {
    Map<String, List<List<int>>> patterns = {
      'A': [
        [0, 1, 0],
        [1, 0, 1],
        [1, 1, 1],
        [1, 0, 1],
        [1, 0, 1],
      ],
      'B': [
        [1, 1, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 0, 1],
        [1, 1, 0],
      ],
      'C': [
        [0, 1, 1],
        [1, 0, 0],
        [1, 0, 0],
        [1, 0, 0],
        [0, 1, 1],
      ],
      'D': [
        [1, 1, 0],
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [1, 1, 0],
      ],
      'E': [
        [1, 1, 1],
        [1, 0, 0],
        [1, 1, 0],
        [1, 0, 0],
        [1, 1, 1],
      ],
      'F': [
        [1, 1, 1],
        [1, 0, 0],
        [1, 1, 0],
        [1, 0, 0],
        [1, 0, 0],
      ],
      'G': [
        [0, 1, 1],
        [1, 0, 0],
        [1, 0, 1],
        [1, 0, 1],
        [0, 1, 1],
      ],
      'H': [
        [1, 0, 1],
        [1, 0, 1],
        [1, 1, 1],
        [1, 0, 1],
        [1, 0, 1],
      ],
      'I': [
        [1, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 1],
      ],
      'J': [
        [0, 0, 1],
        [0, 0, 1],
        [0, 0, 1],
        [1, 0, 1],
        [0, 1, 0],
      ],
      'K': [
        [1, 0, 1],
        [1, 1, 0],
        [1, 0, 0],
        [1, 1, 0],
        [1, 0, 1],
      ],
      'L': [
        [1, 0, 0],
        [1, 0, 0],
        [1, 0, 0],
        [1, 0, 0],
        [1, 1, 1],
      ],
      'M': [
        [1, 0, 0, 1],
        [1, 1, 0, 1],
        [1, 0, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
      ],
      'N': [
        [1, 0, 1],
        [1, 1, 1],
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
      ],
      'O': [
        [0, 1, 0],
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [0, 1, 0],
      ],
      'P': [
        [1, 1, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 0, 0],
        [1, 0, 0],
      ],
      'Q': [
        [0, 1, 0],
        [1, 0, 1],
        [1, 0, 1],
        [1, 1, 1],
        [0, 1, 1],
      ],
      'R': [
        [1, 1, 0],
        [1, 0, 1],
        [1, 1, 0],
        [1, 1, 0],
        [1, 0, 1],
      ],
      'S': [
        [0, 1, 1],
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1],
        [1, 1, 0],
      ],
      'T': [
        [1, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
      'U': [
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [0, 1, 0],
      ],
      'V': [
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [0, 1, 0],
        [0, 1, 0],
      ],
      'W': [
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 0, 1, 1],
        [1, 1, 0, 1],
        [1, 0, 0, 1],
      ],
      'X': [
        [1, 0, 1],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [1, 0, 1],
      ],
      'Y': [
        [1, 0, 1],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
      'Z': [
        [1, 1, 1],
        [0, 0, 1],
        [0, 1, 0],
        [1, 0, 0],
        [1, 1, 1],
      ],
      ' ': [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ],
    };
    return patterns[char];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_colors.length, (index) {
              return GestureDetector(
                onTap: () => _setColor(index),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _currentColorIndex == index ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter text',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        // Clear selected colors if text changes
                        _letterColors.clear();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _drawTextOnGrid(_textController.text),
                  child: Text('Draw'),
                ),
              ],
            ),
          ),
          if (_textController.text.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _textController.text.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        '${_textController.text[index]}: ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<int>(
                        value: _letterColors[index] ?? _currentColorIndex,
                        items: List.generate(_colors.length, (colorIndex) {
                          return DropdownMenuItem(
                            value: colorIndex,
                            child: Container(
                              width: 24,
                              height: 24,
                              color: _colors[colorIndex],
                            ),
                          );
                        }),
                        onChanged: (int? newColorIndex) {
                          if (newColorIndex != null) {
                            _setLetterColor(index, newColorIndex);
                          }
                        },
                      ),
                      SizedBox(width: 8),
                    ],
                  );
                },
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                int row = index ~/ cols;
                int col = index % cols;
                return GestureDetector(
                  onTap: () => _toggleCell(row, col),
                  child: Container(
                    margin: EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      color: grid[row][col],
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _clearGrid,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.clear, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
