// lib/main.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api/api_client.dart';

void main() {
  runApp(const PocketWiseTestApp());
}

class PocketWiseTestApp extends StatelessWidget {
  const PocketWiseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketWise Test',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  final ApiClient _apiClient = ApiClient();
  String? _lastPing;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _pingBackend() async {
    setState(() {
      _lastPing = 'Pinging...';
    });
    try {
      final resp = await _apiClient.get('/');
      setState(() {
        _lastPing = 'Status: ${resp.statusCode} | Body: ${resp.data}';
      });
      print('[PING] success: ${resp.statusCode} ${resp.data}');
    } on DioException catch (e) {
      // very verbose logging
      print('=== DioException caught ===');
      print('type: ${e.type}');
      print('message: ${e.message}');
      print('uri: ${e.requestOptions.uri}');
      if (e.response != null) {
        print('response.statusCode: ${e.response?.statusCode}');
        print('response.data: ${e.response?.data}');
      }
      if (e.error != null) print('error: ${e.error}');
      setState(() {
        _lastPing = 'DioException: ${e.type} ${e.message}';
      });
    } catch (e, st) {
      print('=== Other error ===');
      print(e);
      print(st);
      setState(() {
        _lastPing = 'Error: $e';
      });
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_lastPing ?? 'No response')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PocketWise — Counter + Ping')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pingBackend,
              icon: const Icon(Icons.cloud),
              label: const Text('Ping Backend'),
            ),
            const SizedBox(height: 12),
            Text(_lastPing ?? 'No pings yet'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
