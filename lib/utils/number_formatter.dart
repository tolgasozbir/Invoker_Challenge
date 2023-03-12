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