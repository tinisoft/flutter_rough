import 'dart:math';

import 'core.dart';
import 'entities.dart';

List<PointD> rotatePoints(List<PointD> points, PointD center, double degrees) {
  if (points != null && points.isNotEmpty) {
    return points.map((p) => rotatePoint(p, center, degrees)).toList();
  } else {
    return [];
  }
}

PointD rotatePoint(PointD point, PointD center, double degrees) {
  final double angle = (pi / 180) * degrees;
  final double angleCos = cos(angle);
  final double angleSin = sin(angle);

  return PointD(
    ((point.x - center.x) * angleCos) -
        ((point.y - center.y) * angleSin) +
        center.x,
    ((point.x - center.x) * angleSin) +
        ((point.y - center.y) * angleCos) +
        center.y,
  );
}

List<Line> rotateLines(List<Line> lines, PointD center, double degrees) => lines
    .map((line) => Line(rotatePoint(line.source, center, degrees),
        rotatePoint(line.target, center, degrees)))
    .toList();

enum PointsOrientation { collinear, clockwise, counterclockwise }

PointsOrientation getOrientation(PointD p, PointD q, PointD r) {
  final double val = (q.x - p.x) * (r.y - q.y) - (q.y - p.y) * (r.x - q.x);
  if (val == 0) {
    return PointsOrientation.collinear;
  }
  return val > 0
      ? PointsOrientation.clockwise
      : PointsOrientation.counterclockwise;
}

bool onSegmentPoints(PointD source, PointD point, PointD target) =>
    Line(source, target).onSegment(point);

class ComputedEllipsePoints {
  List<PointD> corePoints;
  List<PointD> allPoints;

  ComputedEllipsePoints({required this.corePoints, required this.allPoints});
}

class EllipseParams {
  final double rx;
  final double ry;
  final double increment;

  EllipseParams({required this.rx, required this.ry, required this.increment});
}

class EllipseResult {
  OpSet opSet;
  List<PointD> estimatedPoints;

  EllipseResult({required this.opSet, required this.estimatedPoints});
}

class Edge {
  double yMin;
  double yMax;
  double x;
  double slope;

  Edge(
      {required this.yMin,
      required this.yMax,
      required this.x,
      required this.slope});

  Edge copyWith({double? yMin, double? yMax, double? x, double? slope}) => Edge(
        yMin: yMin ?? this.yMin,
        yMax: yMax ?? this.yMax,
        x: x ?? this.x,
        slope: slope ?? this.slope,
      );

  @override
  String toString() {
    return 'Edge{yMin: $yMin, yMax: $yMax, x: $x, isLope: $slope}';
  }
}

class ActiveEdge {
  double s;
  Edge edge;

  ActiveEdge(this.s, this.edge);
}
