import 'package:flutter/material.dart';
import 'package:hackfest/services/service_imp.dart';

class OpenAIEntryScreen extends StatefulWidget {
  const OpenAIEntryScreen({super.key});
  @override
  State<OpenAIEntryScreen> createState() => _OpenAIEntryScreenState();
}

class _OpenAIEntryScreenState extends State<OpenAIEntryScreen> {
  TextEditingController promptController = TextEditingController();
  String? response;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helper"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: promptController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Prompt",
                        hintText: "Enter your prompt here",
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        promptController.text = '';
                        setState(() {});
                      },
                      icon: Icon(Icons.close)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                response ?? "",
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            loading
                ? CircularProgressIndicator(
                    color: Colors.deepPurple,
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 20)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      response =
                          await ChatService().request(promptController.text);
                      setState(() {
                        loading = false;
                      });
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ))
          ],
        ),
      ),
    );
  }
}
