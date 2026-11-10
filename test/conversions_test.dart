import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/constants/conversions.dart';

void main() {
  group('showUnits', () {
    test('returns 0 units before the first full unit', () {
      expect(showUnits(0), 0);
      expect(showUnits(5), 0);
    });

    test('returns 1 unit once enough sips have been taken', () {
      // 13 sips * 25cl * 4.7% = 15.275cl, just over one unit (15.209cl).
      expect(showUnits(13), 1);
      expect(showUnits(26), 2);
    });
  });

  group('amountOfSipsUntilNextUnit', () {
    test('returns 0 when the current amount is an exact unit', () {
      expect(amountOfSipsUntilNextUnit(0), 0);
    });

    test('returns the rounded amount of sips left in the current unit', () {
      expect(amountOfSipsUntilNextUnit(5), 6);
      expect(amountOfSipsUntilNextUnit(6), 7);
    });
  });
}
