import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    var counterProvider = CounterProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('exemplo'),
      ),
      body: Column(
        children: [
          Text(counterProvider?.state.value.toString() ?? '0'),
          IconButton(
            onPressed: () {
              setState(() {
                counterProvider?.state.inc();
              });
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                counterProvider?.state.dec();
              });
            },
            icon: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
