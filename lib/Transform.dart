import 'dart:ui';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class CoordinateTransformer {
  final Matrix3 transform;

  CoordinateTransformer(this.transform);

  Offset transformPoint(Offset point) {
    Vector3 p = Vector3(point.dx, point.dy, 1.0);
    Vector3 q = transform * p;
    return Offset(q.x, q.y);
  }
}

class CoordinateSystem {
  final Offset origin;
  final double angle;

  CoordinateSystem({this.origin = Offset.zero, this.angle = 0.0});

  CoordinateTransformer getTransformerTo(CoordinateSystem target) {
    Matrix3 transform = Matrix3.identity();
    transform.transform2(Vector2(-origin.dx, -origin.dy));
    transform.setRotationZ(-angle);
    transform.transform2(Vector2(target.origin.dx, target.origin.dy));
    transform.setRotationZ(target.angle);
    return CoordinateTransformer(transform);
  }
}