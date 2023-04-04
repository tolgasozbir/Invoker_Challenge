String numberFormatter(double val) {
  if(val < 1000000){ // less than a million
    double result = val/1000;
    return result.toStringAsFixed(0)+"K";
  }else if(val >= 1000000 && val < (1000000*10*100)){ // less than 100 million
    double result = val/1000000;
    return result.toStringAsFixed(2)+"M";
  } else {
    double result = val/100000000;
    return result.toStringAsFixed(2)+"T";
  }
}

String priceString(double val) {
    final numberString = val.toStringAsFixed(0);
    final numberDigits = List.from(numberString.split(''));
    int index = numberDigits.length - 3;
    while (index > 0) {
      numberDigits.insert(index, '.');
      index -= 3;
    }
    return numberDigits.join();
  }