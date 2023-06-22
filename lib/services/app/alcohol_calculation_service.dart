class AlcoholCalculationService {
  double calculateAlcoholUnits(double volumeInCl, double abv) {
    // Assuming 1 unit is 12 grams of alcohol
    // Density of Ethanol is 0.789 g/cm³
    // 1 cl of pure alcohol weighs 0.789 grams
    // So, 12/0.789 cl of pure alcohol forms 1 unit
    final double oneUnitVolume = 12 / 0.789;

    // Calculate the alcohol volume in the drink
    final double alcoholVolumeInCl = (volumeInCl * abv) / 100;

    // Return the number of units
    return alcoholVolumeInCl / oneUnitVolume;
  }
}
