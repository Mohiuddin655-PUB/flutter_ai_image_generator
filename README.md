# flutter_ai_generator

## INIT

```dart
void main() async {
  AiGenerator.init(
    key: "OPEN_AI_GPT_KEY",
  );
  // ...
}
```

## GENERATE IMAGE

```dart
Future<AiResponse> generate(String topic) {
  return AiGenerator.i.generate(topic);
}
```