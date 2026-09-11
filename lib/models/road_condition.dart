enum RoadCondition {
  normal('Normal'),
  congestion('Congestión'),
  obstruction('Obstrucción'),
  smoke('Humo detectado');

  const RoadCondition(this.label);

  final String label;
}
