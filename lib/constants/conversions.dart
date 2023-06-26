int showUnits(int currentSips) {
  // 1 unit is 12 grams of alcohol SRC: Norwegian government / HelseNorge
  //SRC: https://avogtil.no/fakta/en-alkoholenhet/ in Norwegian.

  // The density of Ethanol is 0.789 g/cm³ which means that 1 cl of pure alcohol weighs 0.789 grams
  // So, 12/0.789 cl of pure alcohol forms 1 unit

  //One average sip of a beer is roughly 2.5cl, while for spirit and wine it's around 1-2cl.
  //LAZY IMPLEMENTATION: we assume that the users drink beer, where the typical ABV in Norway is 4.7%
  const double oneUnitVolume = 12 / 0.789;

  // Calculate the alcohol volume in the drink
  final double alcoholVolumeInCl = ((currentSips * 25) * 4.7) / 100;

  // Return the number of units
  return alcoholVolumeInCl ~/ oneUnitVolume;
}

int amountOfSipsUntilNextUnit(int currentSips) {
  const double oneUnitVolume = 12 / 0.789;

  // Calculate the alcohol volume in the drink
  final double alcoholVolumeInCl = ((currentSips * 25) * 4.7) / 100;

  final int howManyToNext = (alcoholVolumeInCl % oneUnitVolume).round();

  return howManyToNext;
}
