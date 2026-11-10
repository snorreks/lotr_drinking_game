import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/constants/characters.dart';
import 'package:lotr_drinking_game/constants/game_rule.dart';
import 'package:lotr_drinking_game/constants/game_rules.dart';

String escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

String multiline(String value) => escapeHtml(value).replaceAll('\n', '<br>');

String difficultyBadge(RuleDifficulty difficulty) {
  return '<span class="badge ${difficulty.name}">'
      '${difficulty.displayName}</span>';
}

String ruleRow(String text, RuleDifficulty difficulty) {
  return '<div class="rule">${difficultyBadge(difficulty)}'
      '<div class="rule-text">${multiline(text)}</div></div>';
}

String ruleRows(List<GameRule> rules) {
  final StringBuffer buffer = StringBuffer();
  for (final GameRule rule in rules) {
    buffer.writeln(ruleRow(rule.text, rule.difficulty));
  }
  return buffer.toString();
}

String movieSection(String title, List<GameRule> rules) {
  return (StringBuffer()
        ..write('<div class="movie-block">')
        ..write('<h3>${escapeHtml(title)}</h3>')
        ..write(ruleRows(rules))
        ..write('</div>'))
      .toString();
}

String characterSection(Character character) {
  return (StringBuffer()
        ..write('<section class="character">')
        ..write('<h2>${escapeHtml(character.displayName)}</h2>')
        ..write(movieSection(
          'Fellowship of the Ring',
          character.rulesFellowship,
        ))
        ..write(movieSection('The Two Towers', character.rulesTwoTowers))
        ..write(movieSection('Return of the King', character.rulesROTK))
        ..write('</section>'))
      .toString();
}

String buildHtml() {
  final String logo = base64Encode(
    File('assets/images/logo/logo-title.png').readAsBytesSync(),
  );

  final StringBuffer additionalRules = StringBuffer();
  for (final RuleWithName rule in GameRules.additionalRules) {
    additionalRules
      ..write('<div class="rule additional">')
      ..write(difficultyBadge(rule.difficulty))
      ..write('<div class="rule-text">')
      ..write('<strong>${escapeHtml(rule.ruleName)}</strong><br>')
      ..write(multiline(rule.ruleDescription))
      ..write('</div></div>')
      ..writeln();
  }

  final StringBuffer characterSections = StringBuffer();
  for (final Character character in Character.values) {
    characterSections.write(characterSection(character));
  }

  final StringBuffer difficultyLegend = StringBuffer();
  for (final RuleDifficulty difficulty in RuleDifficulty.values) {
    difficultyLegend.writeln(
      '<div class="legend-row">'
      '${difficultyBadge(difficulty)}'
      '<span>${escapeHtml(difficulty.description)}</span>'
      '</div>',
    );
  }

  return '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Fellowship of the Drink - The Rulebook</title>
<style>
  @page {
    size: A4;
    margin: 14mm 13mm 16mm;
  }
  * { box-sizing: border-box; }
  body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
      Helvetica, Arial, sans-serif;
    color: #1f2937;
    font-size: 10.2pt;
    line-height: 1.42;
  }
  h1, h2, h3 { page-break-after: avoid; }
  h1 { font-size: 22pt; margin: 0 0 8px; }
  h2 {
    font-size: 17pt;
    margin: 0 0 12px;
    padding-bottom: 6px;
    border-bottom: 2px solid #d4af37;
  }
  h3 {
    font-size: 12pt;
    margin: 16px 0 6px;
    color: #374151;
  }
  p { margin: 0 0 10px; }
  .cover {
    page-break-after: always;
    min-height: 250mm;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
  }
  .cover img { width: 78%; max-width: 150mm; margin-bottom: 28px; }
  .cover h1 { font-size: 27pt; letter-spacing: 0.5px; }
  .cover h2 {
    border: 0;
    margin: 0 0 16px;
    font-size: 18pt;
    font-weight: 500;
    color: #4b5563;
  }
  .cover .lead {
    max-width: 135mm;
    font-size: 11pt;
    color: #4b5563;
    margin-bottom: 26px;
  }
  .cover .legend {
    width: 145mm;
    text-align: left;
    border-top: 1px solid #e5e7eb;
    border-bottom: 1px solid #e5e7eb;
    padding: 14px 0;
  }
  .legend-row {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 4px 0;
    font-size: 9.5pt;
  }
  .legend-row .badge { flex: 0 0 auto; margin-top: 1px; }
  .section { margin-bottom: 22px; }
  .section-intro {
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 12px 14px;
    margin-bottom: 14px;
    font-size: 9.8pt;
  }
  .rule {
    display: flex;
    align-items: flex-start;
    gap: 9px;
    padding: 5px 0;
    border-bottom: 1px solid #f0f1f3;
    page-break-inside: avoid;
  }
  .rule:last-child { border-bottom: 0; }
  .rule-text { flex: 1; }
  .badge {
    display: inline-block;
    flex: 0 0 auto;
    border-radius: 999px;
    padding: 1px 8px;
    font-size: 7.8pt;
    font-weight: 700;
    line-height: 1.5;
    border: 1px solid;
    white-space: nowrap;
  }
  .badge.easy { color: #166534; background: #f0fdf4; border-color: #16a34a; }
  .badge.medium { color: #9a3412; background: #fff7ed; border-color: #ea580c; }
  .badge.hard { color: #991b1b; background: #fef2f2; border-color: #dc2626; }
  .movie-block { margin-bottom: 12px; page-break-inside: avoid; }
  .character { page-break-before: always; }
  .additional { padding: 9px 0; }
  .additional .rule-text { font-size: 9.8pt; }
  .note {
    font-size: 9pt;
    color: #6b7280;
    margin-top: 4px;
  }
  @media print {
    body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  }
</style>
</head>
<body>
  <div class="cover">
    <img src="data:image/png;base64,$logo" alt="Fellowship of the Drink">
    <h1>The Rulebook</h1>
    <h2>All rules for the evening</h2>
    <p class="lead">
      Read through before the evening, pick your difficulty when you join,
      and keep this handy while the films are on.
    </p>
    <div class="legend">
      $difficultyLegend
    </div>
  </div>

  <div class="section">
    <h1>Before we start</h1>
    <div class="section-intro">
      ${multiline(GameRules.basicRules)}
    </div>
    <p class="note">
      Difficulty works as a personal rule set. Easy rules are always active.
      Medium adds the medium rules on top. Hard includes every rule below.
    </p>
  </div>

  <div class="section">
    <h1>Everyone takes a drink when</h1>
    ${movieSection('All movies', GameRules.normalRulesAllMovies)}
    ${movieSection('Fellowship of the Ring', GameRules.normalRulesFellowship)}
    ${movieSection('The Two Towers', GameRules.normalRulesTwoTowers)}
    ${movieSection('Return of the King', GameRules.normalRulesROTK)}
  </div>

  <div class="section">
    <h1>Down the Hatch</h1>
    <div class="section-intro">
      Finish whatever is left in your vessel. These story milestones are always
      active, regardless of difficulty.
    </div>
    ${ruleRows(GameRules.dthRules)}
  </div>

  <div class="section">
    <h1>Additional rules</h1>
    <div class="section-intro">
      Optional table rules and safety mechanics. Agree on these with the group
      before starting.
    </div>
    $additionalRules
  </div>

  <div class="section">
    <h1>Character rules</h1>
    <div class="section-intro">
      Only the rules for the character you chose apply to you. Each movie has
      its own list, and the difficulty badge shows when that rule becomes
      active.
    </div>
  </div>

  $characterSections
</body>
</html>
''';
}

void main() {
  test('writes the shareable rulebook HTML', () {
    Directory('build/rulebook').createSync(recursive: true);
    File('build/rulebook/rulebook.html').writeAsStringSync(buildHtml());
  });
}
