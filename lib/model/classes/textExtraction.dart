import 'package:get/get.dart';

class HandleExtraction {
  handleWeight(String roughText) {
    return roughText;
  }

  handleOxi(String text) {
    List values = ['', ''];
    List num_found = [];
    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.isNum) {
        num val = num.parse(line);
        if (val < 0) {
          val *= -1;
        }
        num_found.add({'value': val.toString(), 'index': i});
      }
    }

    if (num_found.length > 1) {
      values[0] = num_found[0]['value'];
      values[1] = num_found[1]['value'];
    } else if (num_found.length == 1) {
      if (num_found[0]['index'] > (lines.length / 2)) {
        values[1] = num_found[0]['value'];
      } else {
        values[0] = num_found[0]['value'];
      }
    }

    return values;
  }

  handleBloodPressure(String text) {
    List values = ['', '', ''];
    List num_found = [];
    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      line = line.replaceAll(RegExp(r'[:;.]'), '');
      if (line.isNum) {
        num val = num.parse(line);
        if (val > 0 && val < 200) {
          num_found.add({'value': val.toString(), 'index': i});
        }
      }
    }

    if (num_found.length > 1) {
      values[0] = num_found[0]['value'];
      values[1] = num_found[1]['value'];
      values[2] = num_found[2]['value'];
    } else if (num_found.length == 1) {
      if (num_found[0]['index'] > (lines.length / 2)) {
        values[1] = num_found[0]['value'];
      } else {
        values[0] = num_found[0]['value'];
      }
    }
    print(values);

    return values;
  }

  handlePulse(String text) {
    String pulse = '';
    List<String> lines = text.split('\n');

    int counter = 0;
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      line = line.replaceAll(RegExp(r'[:;.()]'), '');
      if (line.isNum) {
        num val = num.parse(line);
        if (val > 0 && val < 250) {
          counter += 1;
          if (counter == 3) {
            pulse = val.toString();
            return pulse;
          }
        }
      }
    }
    return pulse;
  }

  handleTemp(text) {
    String retVal = '';

    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.isNum) {
        retVal = line;
        break;
      }
    }
    return retVal;
  }
}
