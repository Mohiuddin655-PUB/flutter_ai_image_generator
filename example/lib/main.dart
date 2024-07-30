import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ai_image_generator/ai_image_generator.dart';

void main() {
  AiGenerator.init(key: "OPEN_AI_KEY");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AIImageGeneratorScreen(),
    );
  }
}

class AIImageGeneratorScreen extends StatefulWidget {
  const AIImageGeneratorScreen({super.key});

  @override
  State<AIImageGeneratorScreen> createState() => _AIImageGeneratorScreenState();
}

class _AIImageGeneratorScreenState extends State<AIImageGeneratorScreen> {
  final TextEditingController _controller = TextEditingController(text: "fox");
  AiResponse? response;
  bool _isLoading = false;

  void _generateImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      response = await AiGenerator.i.generate(
        _controller.text,
        n: 1,
      );
      log(response.toString());
      setState(() {});
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter prompt',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateImage,
              child: const Text('Generate Image'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : response != null
                      ? Builder(
                          builder: (context) {
                            final data = response?.data ?? [];
                            if (data.isNotEmpty) {
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final item = data.elementAt(index);
                                  return ListTile(
                                    title: SelectableText(item.url ?? ''),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text(
                                  response?.error?.message ?? "",
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
