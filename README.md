# flutter_ai_generator

## INIT

```dart
void main() async {
  AiImageGenerator.init(
    key: "OPEN_AI_GPT_KEY",
  );
  // ...
}
```

## GENERATE IMAGE

```dart
Future<AiResponse> generate(String topic) {
  return AiImageGenerator.i.generate(topic);
}
```