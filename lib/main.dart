// import 'package:flutter/material.dart';

import 'dart:ffi';

void showMultyply() {
  for (var i = 1; i <= 10; i++) {
    for (var j = 1; j <= 10; j++) {
      print('${i} * ${j} = ${i * j}');
    }
    print("\n");
  }
}

String showNextData(List<int> dateArray) {
  int days = 0;

  switch (dateArray[1]) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
      days = 31;
      break;

    case 4:
    case 6:
    case 9:
    case 11:
      days = 30;
      break;

    case 2:
      if ((dateArray[2] % 4 == 0 && dateArray[2] % 100 != 0) ||
          dateArray[2] % 400 == 0) {
        days = 29;
      } else {
        days = 28;
      }
      break;
  }

  if (dateArray[0] < days) {
    dateArray[0] = dateArray[0] + 1;
  } else {
    dateArray[0] = 1;

    if (dateArray[1] < 12) {
      dateArray[1] = dateArray[1] + 1;
    } else {
      dateArray[1] = 1;
      dateArray[2] = dateArray[2] + 1;
    }
  }

  return dateArray.join('.');
}

int showVowel(String text) {
  List<String> vowel = ["a", "e", "i", "o", "u", "y"];
  String lowerText = text.toLowerCase();
  int count = 0;

  for (var i = 0; i < vowel.length; i++) {
    for (var j = 0; j < lowerText.length; j++) {
      if (vowel[i] == lowerText[j]) {
        count++;
      }
    }
  }
  return count;
}

void showMaxAndMin(List<int> numberOfArray, int first) {
  int max = first;
  int min = first;
  for (var i = 1; i < numberOfArray.length; i++) {
    if (max < numberOfArray[i]) {
      max = numberOfArray[i];
    }
    if (min > numberOfArray[i]) {
      min = numberOfArray[i];
    }
  }
  print("Max: ${max}, Min:${min}");
}

String prineNumber(int number) {
  if (number <= 1) {
    return ('not prime number');
  }
  ;

  for (int i = 2; i * i <= number; i++) {
    if (number % i == 0) {
      return ("not prime number");
    }
  }
  return "prime number";
  ;
}

void main() {
  // runApp(const MyApp());
  String day = '31.12.2026';
  List<int> dateArray = day.split('.').map(int.parse).toList();
  print(showNextData(dateArray));

  // showMultyply();

  List<int> numbers = [12, 88, 3, 42, 99, 12, 67];
  int first = numbers[0];

  showMaxAndMin(numbers, first);

  String text = "flutter mobile development";
  print(showVowel(text));

  print(prineNumber(6));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: .center,
//           children: [
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
