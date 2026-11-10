import 'dart:io';

/// Generates a shareable PDF rulebook from the rules in lib/constants.
///
/// Usage:
///   dart run tool/rulebook/generate_rulebook.dart
///   dart run tool/rulebook/generate_rulebook.dart path/to/output.pdf
///
/// The default output is build/rulebook/Fellowship-of-the-Drink-Rulebook.pdf,
/// which is already ignored by git.
Future<void> main(List<String> args) async {
  final Directory repoRoot = _findRepoRoot();
  Directory.current = repoRoot;

  final String outputArgument = args.isNotEmpty
      ? args.first
      : 'build/rulebook/Fellowship-of-the-Drink-Rulebook.pdf';
  final String outputPath = File(outputArgument).absolute.path;
  final String htmlPath = File('build/rulebook/rulebook.html').absolute.path;

  Directory(File(outputPath).parent.path).createSync(recursive: true);
  Directory(File(htmlPath).parent.path).createSync(recursive: true);

  await _generateHtml();
  final String browser = _findBrowser();
  await _generatePdf(
    browser: browser,
    htmlPath: htmlPath,
    outputPath: outputPath,
  );

  stdout.writeln();
  stdout.writeln('Rulebook written to:');
  stdout.writeln(outputPath);
}

Directory _findRepoRoot() {
  final Directory scriptDirectory = File.fromUri(Platform.script).parent;
  final Directory scriptRoot = scriptDirectory.parent.parent;

  if (File('${scriptRoot.path}${Platform.pathSeparator}pubspec.yaml')
      .existsSync()) {
    return scriptRoot;
  }

  Directory directory = Directory.current;
  while (!File('${directory.path}${Platform.pathSeparator}pubspec.yaml')
      .existsSync()) {
    final Directory parent = directory.parent;
    if (parent.path == directory.path) {
      throw StateError(
        'Could not find the repository root. Run this from the project.',
      );
    }
    directory = parent;
  }
  return directory;
}

Future<void> _generateHtml() async {
  stdout.writeln('Generating HTML from the current rule data...');
  final ProcessResult result = await Process.run(
    'flutter',
    <String>['test', 'tool/rulebook/rulebook_export_test.dart'],
    runInShell: true,
  );

  if (result.exitCode != 0) {
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    throw StateError('Could not generate the rulebook HTML.');
  }
}

String _findBrowser() {
  final String? configured = Platform.environment['RULEBOOK_BROWSER'];
  if (configured != null && configured.isNotEmpty) {
    if (File(configured).existsSync()) {
      return configured;
    }
    throw StateError(
      'RULEBOOK_BROWSER is set but does not point to a file: $configured',
    );
  }

  for (final String path in _browserCandidates()) {
    if (File(path).existsSync()) {
      return path;
    }
  }

  for (final String command in <String>[
    'microsoft-edge',
    'google-chrome',
    'google-chrome-stable',
    'chromium',
    'chromium-browser',
  ]) {
    final ProcessResult result = Process.runSync(
      'which',
      <String>[command],
    );
    if (result.exitCode == 0) {
      final String path = (result.stdout as String).trim();
      if (path.isNotEmpty && File(path).existsSync()) {
        return path;
      }
    }
  }

  throw StateError(
    'Could not find a Chromium-based browser. Install Edge or Chrome, or set '
    'RULEBOOK_BROWSER to the browser executable.',
  );
}

List<String> _browserCandidates() {
  final Map<String, String> environment = Platform.environment;

  if (Platform.isWindows) {
    final List<String> roots = <String>[
      if (environment['ProgramFiles'] != null) environment['ProgramFiles']!,
      if (environment['ProgramFiles(x86)'] != null)
        environment['ProgramFiles(x86)']!,
      if (environment['ProgramW6432'] != null) environment['ProgramW6432']!,
      if (environment['LOCALAPPDATA'] != null) environment['LOCALAPPDATA']!,
    ];

    return <String>[
      for (final String root in roots)
        '$root\\Microsoft\\Edge\\Application\\msedge.exe',
      for (final String root in roots)
        '$root\\Google\\Chrome\\Application\\chrome.exe',
    ];
  }

  if (Platform.isMacOS) {
    return const <String>[
      '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
      '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
      '/Applications/Chromium.app/Contents/MacOS/Chromium',
    ];
  }

  return const <String>[
    '/usr/bin/microsoft-edge',
    '/usr/bin/google-chrome',
    '/usr/bin/google-chrome-stable',
    '/usr/bin/chromium',
    '/usr/bin/chromium-browser',
  ];
}

Future<void> _generatePdf({
  required String browser,
  required String htmlPath,
  required String outputPath,
}) async {
  stdout.writeln('Rendering PDF with $browser...');

  final Directory userDataDirectory =
      Directory.systemTemp.createTempSync('lotr-rulebook-');

  try {
    final ProcessResult result = await Process.run(
      browser,
      <String>[
        '--headless=new',
        '--disable-gpu',
        '--disable-extensions',
        '--no-pdf-header-footer',
        '--allow-file-access-from-files',
        '--virtual-time-budget=5000',
        '--user-data-dir=${userDataDirectory.path}',
        '--print-to-pdf=$outputPath',
        Uri.file(htmlPath).toString(),
      ],
    );

    if (result.exitCode != 0) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
      throw StateError('The browser could not render the PDF.');
    }
  } finally {
    if (userDataDirectory.existsSync()) {
      userDataDirectory.deleteSync(recursive: true);
    }
  }

  if (!File(outputPath).existsSync() || File(outputPath).lengthSync() == 0) {
    throw StateError('The browser did not create the PDF.');
  }
}
