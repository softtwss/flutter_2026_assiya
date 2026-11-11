import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  bool _versionB = false;

  late final Stream<int> _stream;
  StreamSubscription<int>? _sub;

  int _left = 10;

  @override
  void initState() {
    super.initState();

    _stream = countdown(10);
  }

  void _startSubscription() {
    _left = 10;

    _sub = countdown(10).listen((value) {
      if (!mounted) return;

      setState(() {
        _left = value;
      });
    });
  }

  void _changeVersion(bool versionB) {
    if (_versionB == versionB) return;

    if (versionB) {
      _startSubscription();
    } else {
      _sub?.cancel();
      _sub = null;
    }

    setState(() {
      _versionB = versionB;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('A: StreamBuilder')),
              ButtonSegment(value: true, label: Text('B: Subscription')),
            ],
            selected: {_versionB},
            onSelectionChanged: (selection) {
              _changeVersion(selection.first);
            },
          ),
          const SizedBox(height: 40),
          if (!_versionB)
            StreamBuilder<int>(
              stream: _stream,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 10}',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            )
          else
            Text('$_left', style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    );
  }
}
