import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testingproject/DjangoTesting/urls/url.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController(),
      _controller2 = TextEditingController(),
      _controller3 = TextEditingController();

  String _responseMessage = '';


  
  Future<void> _submitData() async {
    final String inputText = _controller.text;
    final String inputText2 = _controller2.text;
    final String inputText3 = _controller3.text;


    if (inputText.isEmpty || inputText2.isEmpty || inputText3.isEmpty) {
      setState(() {
        _responseMessage = 'All fields must be filled';
      });
      return;
    }

    try {
      final response = await http.post(
          Uri.parse(url),
        headers: {
            'Content-Type' : 'application/json',
        },
        body: jsonEncode({
          'input_text': inputText,
          'input_text2': inputText2,
          'input_text3': inputText3,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _responseMessage = 'Data saved successfully';
        });
      } else {
        setState(() {
          _responseMessage = 'Data Failed to save: ${response.statusCode} - ${response.body}';
        });
      }

    } catch (error) {
      setState(() {
        _responseMessage = 'An error occurred $error}';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Flutter to Django'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter Text'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(labelText: 'Enter Text 2'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller3,
              decoration: InputDecoration(labelText: 'Enter Text 3'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit')
            ),
            SizedBox(height: 20),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}

