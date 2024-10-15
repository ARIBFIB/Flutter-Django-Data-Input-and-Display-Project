import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyInput());
}

class MyInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DjangoInputs(),
    );
  }
}

class DjangoInputs extends StatefulWidget {
  @override
  State<DjangoInputs> createState() => _DjangoInputsState();
}

class _DjangoInputsState extends State<DjangoInputs> {
  final TextEditingController _controller1 = TextEditingController();
  String _responseMessage = "";

  Future<void> _submitInputData() async {
    final String input1 = _controller1.text;

    if (input1.isEmpty) {
      setState(() {
        _responseMessage = 'Input fields should not be empty';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/save/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'input_text': input1,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _responseMessage = 'Data saved successfully!';
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to save data: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (error) {
      setState(() {
        _responseMessage = 'Error occurred: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save Input Flutter to Django"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(labelText: 'Enter First Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitInputData,
              child: Text("Submit"),
            ),
            SizedBox(height: 20),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}
