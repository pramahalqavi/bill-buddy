import 'dart:collection';
import 'dart:math';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class BillScanHelper {
  RecognizedText recognizedText;

  BillScanHelper(this.recognizedText);

  List<String> constructLines() {
    List<WordBox> mergedLines = [];
    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        List<List<num>> tempVertices=[];
        String words = "";
        for (Point<int> point in line.cornerPoints){
          tempVertices.add([point.x, point.y]);
        }
        for(TextElement element in line.elements){
          words = words + " " + element.text;
        }
        mergedLines.add(WordBox(words, tempVertices));
      }
    }
    _getBoundingPolygon(mergedLines);
    _combineBoundingPolygon(mergedLines);
    var finalLines = _constructLineWithBoundingPolygon(mergedLines);
    return finalLines;
  }

  void _getBoundingPolygon(List<WordBox> mergedLines) {
    for (int i = 0; i < mergedLines.length; i++){
      var points = [];

      num h1 = (mergedLines[i].vertices[0][1] - mergedLines[i].vertices[3][1]).abs();
      num h2 = (mergedLines[i].vertices[1][1] - mergedLines[i].vertices[2][1]).abs();

      num h = max(h1, h2);
      num avgHeight = h * 0.6;
      num threshold = h * 1;
      points.add(mergedLines[i].vertices[1]);
      points.add(mergedLines[i].vertices[0]);
      List<num> topLine = _getLineMesh(points, avgHeight, true);

      points = [];

      points.add(mergedLines[i].vertices[2]);
      points.add(mergedLines[i].vertices[3]);
      List<num> bottomLine = _getLineMesh(points, avgHeight, false);

      mergedLines[i].setBox([[topLine[0], topLine[2]-threshold], [topLine[1], topLine[3]-threshold], [bottomLine[1], bottomLine[3]+threshold], [bottomLine[0], bottomLine[2]+threshold]]);//top left corner, then clockwise
      // mergedLines[i].setBox([[topLine[0], topLine[2]], [topLine[1], topLine[3]], [bottomLine[1], bottomLine[3]], [bottomLine[0], bottomLine[2]]]);//top left corner, then clockwise

      mergedLines[i].setlineNum(i);

    }
  }

  List<num> _getLineMesh(List p, avgHeight, bool isTopLine) {
    if (isTopLine) { //expand the boundingBox
      p[1][1] += avgHeight;
      p[0][1] += avgHeight;
    } else {
      p[1][1] -= avgHeight;
      p[0][1] -= avgHeight;
    }
    num xDiff = (p[1][0] - p[0][0]);
    num yDiff = (p[1][1] - p[0][1]);

    num gradient = yDiff / xDiff; // if gradient is 0, the line is flat
    num xThreshMin = 1; // min width of the image
    num xThreshMax = 3000;

    num yMin = 0;
    num yMax = 0;

    if (gradient == 0){ // if line is flat line will be flat
      yMin = p[0][1];
      yMax = p[0][1];
    } else { // there will be variance in y
      yMin = p[0][1] - (gradient * (p[0][0] - xThreshMin));
      yMax = p[0][1] + (gradient * (p[0][0] + xThreshMax));
    }
    return [xThreshMin, xThreshMax, yMin, yMax];
  }

  void _combineBoundingPolygon(List<WordBox> mergedLines) {
    for (int i = 0; i < mergedLines.length; i++) {
      for (int k = i; k < mergedLines.length; k++) {
        if (k != i && mergedLines[k].matched == false) {
          int insideCount = 0;
          for (int j = 0; j < 4; j++) {
            var coordinate = mergedLines[k].vertices[j];

            if (_isPointContainsInPolygon(mergedLines[i].boundingBox, coordinate[0], coordinate[1])) {
              insideCount++;
            }
          }
          if (insideCount == 4) { //all vertices are inside the bounding box
            var match = HashMap<String, int>();
            match['matchCount'] = insideCount;
            match['matchLineNum'] = k;
            mergedLines[i].pushMatch(match);
            mergedLines[k].setMatched(true);
          }
        }
      }
    }
  }

  bool _isPointContainsInPolygon(List<List<num>> points, num px, num py) {
    num ax = 0;
    num ay = 0;
    num bx = points[points.length - 1][0] - px;
    num by = points[points.length - 1][1] - py;
    int depth = 0;

    for (int i = 0; i < points.length; i++) {
      ax = bx;
      ay = by;
      bx = points[i][0] - px;
      by = points[i][1] - py;

      if (ay < 0 && by < 0) continue; // both "up" or both "down"
      if (ay > 0 && by > 0) continue; // both "up" or both "down"
      if (ax < 0 && bx < 0) continue; // both points on left

      num lx = ax - ay * (bx - ax) / (by - ay);

      if (lx == 0) return true; // point on edge
      if (lx > 0) depth++;
    }

    return (depth & 1) == 1;
  }

  List<String> _constructLineWithBoundingPolygon(List<WordBox> mergedLines) {
    List<String> finalLines = [];
    for (int i = 0; i < mergedLines.length; i++) {
      if (mergedLines[i].matched == false) {
        if (mergedLines[i].match.length == 0) {
          finalLines.add(mergedLines[i].text);
        } else {
          finalLines.add(_arrangeWordsInOrder(mergedLines, i));
        }
      }
    }
    return finalLines;
  }

  String _arrangeWordsInOrder(List<WordBox> mergedLines, int i){
    String mergedLine = '';
    var line = mergedLines[i].match;
    for(int j = 0; j < line.length; j++){
      int index = line[j]['matchLineNum'];
      String matchedWordForLine = mergedLines[index].text;
      // order by top left x vertex
      num mainX = mergedLines[i].vertices[0][0];
      num compareX = mergedLines[index].vertices[0][0];
      if(compareX > mainX){
        mergedLine = mergedLines[i].text + ' ' + matchedWordForLine;
      }else{
        mergedLine = matchedWordForLine + ' ' + mergedLines[i].text;
      }
    }
    return mergedLine;
  }
}

class WordBox {
  String text;
  List<List<num>> vertices;
  late List<List<num>> boundingBox;
  late num lineNum;
  List match = [];
  bool matched = false;

  WordBox(this.text, this.vertices);

  setBox(List<List<num>> boundingBox){
    this.boundingBox = boundingBox;
  }
  pushMatch(HashMap<String, int> match){
    this.match.add(match);
  }
  setlineNum(num lineNum){
    this.lineNum = lineNum;
  }
  setMatched(bool matched){
    this.matched = matched;
  }
}