import 'dart:io';

Future<void> main() async {
  int commandCount = 0;
  final List<String> history = [];

  while (true) {
    stdout.write('aladadev($commandCount) \$ ');

    String? input = stdin.readLineSync();

    if (input == null) {
      continue;
    }

    input = input.trim();

    if (input.isEmpty) {
      print('Please enter something to proceed');
      continue;
    }

    // Run previous command
    if (input == '!!') {
      if (history.isEmpty) {
        print('No previous command');
        continue;
      }

      input = history.last;
      print('Running: $input');
    }

    history.add(input);

    bool handled = await handleBuiltInCommand(input, history, () {
      commandCount = 0;
    });

    if (handled) {
      if (input == 'exit') {
        break;
      }

      if (input != 'clear') {
        commandCount++;
      }
      continue;
    }

    await executeExternalCommand(input);

    commandCount++;
  }
}

Future<bool> handleBuiltInCommand(
  String input,
  List<String> history,
  void Function() resetCounter,
) async {
  switch (input) {
    case 'hello':
      print('You typed hello. So how are you doing');
      return true;

    case 'exit':
      print('GoodBye!');
      return true;

    case 'clear':
      await clearScreen();
      resetCounter();
      return true;

    case 'history':
      showHistory(history);
      return true;

    case 'help':
      showHelp();
      return true;

    default:
      return false;
  }
}

Future<void> clearScreen() async {
  try {
    final Process process;

    if (Platform.isWindows) {
      process = await Process.start('cmd', [
        '/c',
        'cls',
      ], mode: ProcessStartMode.inheritStdio);
    } else {
      process = await Process.start(
        'clear',
        [],
        mode: ProcessStartMode.inheritStdio,
      );
    }

    await process.exitCode;
  } catch (_) {
    // fallback
    stdout.write('\x1B[2J\x1B[H');
  }
}

void showHistory(List<String> history) {
  if (history.isEmpty) {
    print('No command yet');
    return;
  }

  for (int i = 0; i < history.length; i++) {
    print('${i + 1}. ${history[i]}');
  }
}

void showHelp() {
  print('''
Available commands:

hello     -> greeting
history   -> show previous commands
!!        -> run previous command
clear     -> clear terminal
help      -> show commands
exit      -> close terminal

Other commands will run on your OS
Example:
ls
pwd
whoami
echo hello
''');
}

Future<void> executeExternalCommand(String input) async {
  final parts = input.split(RegExp(r'\s+'));

  final String command = parts.first;

  final List<String> args = parts.length > 1 ? parts.sublist(1) : [];

  try {
    final result = await Process.run(command, args, runInShell: true);

    if (result.stdout.toString().isNotEmpty) {
      stdout.write(result.stdout);
    }

    if (result.stderr.toString().isNotEmpty) {
      stderr.write(result.stderr);
    }
  } catch (error) {
    print('Command not found → $command');
    print('Error → $error');
  }
}
