import 'dart:io';

void main() async {
  while (true) {
    stdout.write('aladadev \$ ');

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
  }
}
