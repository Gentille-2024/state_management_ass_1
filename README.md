Flutter Provider State Management
A step-by-step guide to implementing Provider-based state management in Flutter. Provider is the recommended approach for sharing and managing state across your widget tree — it keeps your UI and business logic cleanly separated.

Flutter Provider State Management
Manage and share state across your Flutter app using the Provider package — keeping UI and business logic cleanly separated.

Setup
Add the provider package to pubspec.yaml and run flutter pub get to install it.

1. Create a State Class
Create a dedicated file (e.g. counter_provider.dart) for your state. The class extends ChangeNotifier, which makes it observable. It holds a private counter variable, exposes a getter to read it, and an increment() method that updates the value and calls notifyListeners() — signaling all widgets to rebuild.

2. Provide the State
Wrap your entire app with MultiProvider in main.dart. This registers CounterProvider into the widget tree so any widget — no matter how deeply nested — can access it without passing it manually through constructors.

3. Read the State
There are three ways to read the current value in a widget:
OptionBest ForConsumerRebuilds only the specific widget that needs the data — most efficientcontext.watch()Rebuilds the whole widget on change — good for simple screensProvider.of()The traditional approach; works the same as watch() but more verbose

4. Update the State
Call the provider's method using context.read() inside a button's onPressed. Unlike watch(), read() doesn't listen for changes — it just fires the action once, keeping things efficient.

Flow
When a user taps a button, the provider method runs, notifyListeners() fires, and any widget listening via Consumer or watch() automatically rebuilds with the new value.
