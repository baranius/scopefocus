enum ShapeKind { circle, triangle, square, hexagon }

enum ShapeColor { blue, red, green, yellow }

class ShapePiece {
  const ShapePiece(this.kind, this.color);

  final ShapeKind kind;
  final ShapeColor color;

  String get assetPath => '${color.name}_${kind.name}.png';

  bool matches(ShapePiece other) =>
      kind == other.kind && color == other.color;

  @override
  bool operator ==(Object other) =>
      other is ShapePiece && kind == other.kind && color == other.color;

  @override
  int get hashCode => Object.hash(kind, color);
}
