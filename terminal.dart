import 'dart:io';

void main() async {
  int commandCount = 0;
  List<String> history = [];

  while (true) {
    stdout.write('aladadev ($commandCount) \$ ');

    String? input = stdin.readLineSync();

    if (input == null || input.trim() == '') {
      print('Please enter something to proceed');

      continue;
    }

    if (input.toLowerCase() == 'hello') {
      print('You typed hello. So how are you doing');
      continue;
    }

    if (input.trim() == 'exit') {
      print('GoodBye!');
      break;
    }

    //manually clearing
    if (input.trim() == 'clear') {
      for (int i = 0; i < 50; i++) {
        print('');
      }
      continue;
    }

    // show history
    if (input.trim() == 'history') {
      if (history.isEmpty) {
        print('no command yet');
      } else {
        for (int i = 0; i < history.length; i++) {
          print('${i + 0} ${history[i]}');
        }
      }

      continue;
    }

    // show last command when user types !!
    if (input.trim() == '!!') {
      if (history.isEmpty) {
        print('No previous command');
        continue;
      }

      input = history.last;
      print('Running: $input');
    }

    history.add(input.trim());
    List<String> parts = input.trim().split(' ');
    // print(parts);

    String mainCommand = parts[0];

    dynamic args = parts.skip(1).toList();
    // print('Arguments is $args');

    try {
      final result = await Process.run(mainCommand, args);

      if (result != '') {
        print(result.stdout);
      }

      if (result.stderr != '') {
        print('Error: ${result.stderr}');
      }
    } catch (error) {
      print('Command not found: $mainCommand and error is $error');
    }

    commandCount++;
  }
}
