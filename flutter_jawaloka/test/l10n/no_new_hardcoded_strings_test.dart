import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

int countHardcodedOccurrences(String content, String relativePath) {
  final isAppStringsDefinition = relativePath.endsWith('app_strings.dart');

  int count = 0;

  // 1. Text(' or Text(" (including const Text(' / const Text("))
  count += RegExp(
    r'\b(?:const\s+)?Text\s*\(\s*[\x27\x22]',
  ).allMatches(content).length;

  // 2. SnackBar(content: Text( where string literal might have leading expression
  // Note: if it has literal Text('...'), pattern #1 already counted it.
  // We check for any remaining literal pattern if not already captured.

  // 3. labelText: '...' or "..."
  count += RegExp(r'\blabelText\s*:\s*[\x27\x22]').allMatches(content).length;

  // 4. hintText: '...' or "..."
  count += RegExp(r'\bhintText\s*:\s*[\x27\x22]').allMatches(content).length;

  // 5. title: '...' or "..." (literal string titles, e.g. title: 'Halo')
  count += RegExp(r'\btitle\s*:\s*[\x27\x22]').allMatches(content).length;

  // 6. tooltip: '...' or "..."
  count += RegExp(r'\btooltip\s*:\s*[\x27\x22]').allMatches(content).length;

  // 7. Semantics(label: '...' or Semantics(..., label: '...')
  count += RegExp(
    r'\bSemantics\s*\([^)]*\blabel\s*:\s*[\x27\x22]',
  ).allMatches(content).length;

  // 8. AppStrings usage
  if (!isAppStringsDefinition) {
    count += RegExp(r'\bAppStrings\.[a-zA-Z0-9_]+').allMatches(content).length;
  }

  return count;
}

Map<String, int> scanDirectoryHardcodedCounts(String projectRoot) {
  final Map<String, int> results = {};
  final dirsToScan = [
    Directory('$projectRoot/lib/features'),
    Directory('$projectRoot/lib/core'),
  ];

  for (final dir in dirsToScan) {
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        // Exclude lib/l10n and any generated l10n files
        final normalizedPath = entity.path.replaceAll('\\', '/');
        if (normalizedPath.contains('/lib/l10n/')) continue;

        final relativePath = normalizedPath.substring(
          normalizedPath.indexOf('/lib/') + 1,
        );
        final content = entity.readAsStringSync();
        final count = countHardcodedOccurrences(content, relativePath);
        if (count > 0) {
          results[relativePath] = count;
        }
      }
    }
  }

  return results;
}

void main() {
  test('Ratchet: No new hardcoded UI strings allowed', () {
    final baseDir = Directory.current.path.endsWith('flutter_jawaloka')
        ? Directory.current.path
        : '${Directory.current.path}/flutter_jawaloka';

    final baselineFile = File('$baseDir/test/l10n/hardcoded_baseline.json');
    final currentCounts = scanDirectoryHardcodedCounts(baseDir);

    if (!baselineFile.existsSync()) {
      // Create baseline from current clean state if not yet created
      final sortedEntries = currentCounts.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final sortedMap = Map.fromEntries(sortedEntries);
      baselineFile.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(sortedMap),
      );
    }

    final baselineData =
        json.decode(baselineFile.readAsStringSync()) as Map<String, dynamic>;
    final violations = <String>[];

    // Check all scanned files against baseline
    for (final entry in currentCounts.entries) {
      final file = entry.key;
      final currentCount = entry.value;
      final baselineCount = (baselineData[file] as int?) ?? 0;

      if (!baselineData.containsKey(file)) {
        violations.add(
          'NEW FILE WITH HARDCODED STRINGS: "$file" has $currentCount strings but is not in baseline.',
        );
      } else if (currentCount > baselineCount) {
        violations.add(
          'INCREASED HARDCODED STRINGS: "$file" increased from $baselineCount to $currentCount (+${currentCount - baselineCount}).',
        );
      }
    }

    const ruleMessage =
        'ATURAN LOKALISASI: Jangan menulis teks UI sebagai string literal. '
        'Tambahkan kunci ke lib/l10n/app_id.arb, app_jv.arb, dan app_en.arb, '
        'jalankan flutter gen-l10n, lalu pakai context.l10n.<kunci>.';

    expect(
      violations,
      isEmpty,
      reason: '$ruleMessage\nPelanggaran ditemukan:\n${violations.join('\n')}',
    );
  });
}
