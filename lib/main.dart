import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================================
// STEP 2: CREATING A STATE CLASS
// ============================================================================
// A state class extends ChangeNotifier to manage app state and notify listeners

class CounterProvider extends ChangeNotifier {
  // Private variable to store the counter value
  int _counter = 0;

  // Getter to access the counter value
  int get counter => _counter;

  // Method to increment counter
  void increment() {
    _counter++;
    notifyListeners(); // Notifies all listeners about the state change
  }

  // Method to decrement counter
  void decrement() {
    _counter--;
    notifyListeners(); // Notifies all listeners about the state change
  }

  // Method to reset counter
  void reset() {
    _counter = 0;
    notifyListeners(); // Notifies all listeners about the state change
  }
}


// STEP 3: PROVIDING THE STATE
// Wrap the app with ChangeNotifierProvider to make CounterProvider available
// to all widgets in the app

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Pattern Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

// ============================================================================
// STEP 4: ACCESSING THE STATE & STEP 5: UPDATING THE STATE
// STEP 6: HOW UI REBUILD HAPPENS
// ============================================================================
// Different ways to access and update state are shown below

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Pattern Demo')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // METHOD 1: Using Consumer (Recommended for most cases)
                // UI rebuilds ONLY inside Consumer when state changes
                const SizedBox(height: 20),
                const Text(
                  'Method 1: Using Consumer',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 10),
                const Text('Counter Value (rebuilds only this widget):'),
                Consumer<CounterProvider>(
                  builder: (context, counterProvider, child) {

                    return Text(
                      '${counterProvider.counter}',
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 20),

              
                // METHOD 2: Using context.watch() (Recommended in functions)
                // Allows you to access state value directly

                const Text(
                  'Method 2: Using context.watch()',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 10),
                const Text('Counter Value (using watch):'),
                Text(
                  '${context.watch<CounterProvider>().counter}',
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // METHOD 3: Using Provider.of with listen: true
                // Similar to watch but more traditional approach
                const Text(
                  'Method 3: Using Provider.of(listen: true)',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 63, 39, 3)),
                ),
                const SizedBox(height: 10),
                const Text('Counter Value (using Provider.of):'),
                Text(
                  '${Provider.of<CounterProvider>(context, listen: true).counter}',
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // BUTTONS TO UPDATE STATE
                // These buttons call methods on the provider using context.read()
                // context.read() does NOT trigger rebuild - just accesses the value
                const Text(
                  'Update State with Buttons:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterProvider>().decrement();
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrease'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        /// Using context.read() to increment
                        context.read<CounterProvider>().increment();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Increase'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 114, 241, 118)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        /// Using context.read() to reset
                        context.read<CounterProvider>().reset();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(153, 255, 153, 0)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ================================================================
                // UI REBUILD EXPLANATION
                // ================================================================
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 4, 133, 239), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How UI Rebuild Happens:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'How the rebuild happens:'
                        '1. User presses button (e.g., Increase)\n'
                        '2. Button calls context.read<CounterProvider>().increment()\n'
                        '3. increment() modifies _counter and calls notifyListeners()\n'
                        '4. notifyListeners() signals all listeners about state change\n'
                        '5. Widgets using Consumer/watch are marked for rebuild\n'
                        '6. Flutter calls build() on those widgets (NOT entire app)\n'
                        '7. UI updates with new counter value\n'
                        '8. Widgets using read() do NOT rebuild (no listen)\n\n'
                        'BENEFITS:\n'
                        '• Efficient - only necessary widgets rebuild\n'
                        '• Keeps state separate from UI code\n'
                        '• Easy to test business logic\n'
                        '• Predictable state management',
                        style: TextStyle(fontSize: 12, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
