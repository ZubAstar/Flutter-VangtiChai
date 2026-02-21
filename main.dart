import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VangtiChai(),
  ));
}

class VangtiChai extends StatefulWidget {
  const VangtiChai({super.key});

  @override
  State<VangtiChai> createState() => _VangtiChaiState();
}

class _VangtiChaiState extends State<VangtiChai> {
  int amount = 0;
  final List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];

  // Teal color matching the screenshot
  static const Color tealColor = Color(0xFF00897B);

  void addDigit(int digit) {
    setState(() {
      amount = amount * 10 + digit;
    });
  }

  void clearAmount() {
    setState(() {
      amount = 0;
    });
  }

  Map<int, int> calculateChange() {
    int remaining = amount;
    Map<int, int> change = {};
    for (int note in notes) {
      change[note] = remaining ~/ note;
      remaining = remaining % note;
    }
    return change;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tealColor,
        title: Text(
          'VangtiChai',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        elevation: 4,
      ),
      body: orientation == Orientation.portrait
          ? _buildPortrait()
          : _buildLandscape(),
    );
  }

  // ──────────────────────────────── PORTRAIT ────────────────────────────────

  Widget _buildPortrait() {
    final change = calculateChange();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: Text(
              amount == 0 ? 'Taka:' : 'Taka: $amount',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        // Notes list + Keypad side by side
        Expanded(
          child: Row(
            children: [
              // Notes column
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: notes.map((note) {
                      return Text(
                        '$note: ${change[note]}',
                        style: const TextStyle(fontSize: 17),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Keypad (3 columns)
              Expanded(
                flex: 3,
                child: _buildPortraitKeypad(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitKeypad() {
    // Portrait: 3 columns — 1..9 then 0, CLEAR
    final buttons = <_KeyItem>[
      for (int d = 1; d <= 9; d++) _KeyItem(label: '$d', onTap: () => addDigit(d)),
      _KeyItem(label: '0', onTap: () => addDigit(0)),
      _KeyItem(label: 'CLEAR', onTap: clearAmount, wide: false),
    ];

    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: buttons
          .map((item) => _buildKeyButton(item.label, item.onTap))
          .toList(),
    );
  }

  // ──────────────────────────────── LANDSCAPE ───────────────────────────────

  Widget _buildLandscape() {
    final change = calculateChange();
    return Row(
      children: [
        // Left: Amount + Notes (split two columns)
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Center(
                  child: Text(
                    amount == 0 ? 'Taka:' : 'Taka: $amount',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildLandscapeNotes(change),
                ),
              ),
            ],
          ),
        ),
        // Right: Keypad (4 columns)
        Expanded(
          flex: 4,
          child: _buildLandscapeKeypad(),
        ),
      ],
    );
  }

  Widget _buildLandscapeNotes(Map<int, int> change) {
    // Split 8 notes into two columns of 4
    final left = notes.sublist(0, 4);
    final right = notes.sublist(4);

    Widget noteEntry(int note) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text('$note: ${change[note]}',
          style: const TextStyle(fontSize: 16)),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: left.map(noteEntry).toList(),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: right.map(noteEntry).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeKeypad() {
    // Landscape: 4 columns — 1..9, 0, CLEAR (3 rows)
    final buttons = <_KeyItem>[
      for (int d = 1; d <= 9; d++) _KeyItem(label: '$d', onTap: () => addDigit(d)),
      _KeyItem(label: '0', onTap: () => addDigit(0)),
      _KeyItem(label: 'CLEAR', onTap: clearAmount),
    ];

    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: buttons
          .map((item) => _buildKeyButton(item.label, item.onTap))
          .toList(),
    );
  }

  // ──────────────────────────────── SHARED ──────────────────────────────────

  Widget _buildKeyButton(String label, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(6),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyItem {
  final String label;
  final VoidCallback onTap;
  final bool wide;
  const _KeyItem({required this.label, required this.onTap, this.wide = false});
}