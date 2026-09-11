enum RiskLevel {
  low('Riesgo Bajo', 'Condiciones estables'),
  medium('Riesgo Medio', 'Se requiere precaución'),
  high('Riesgo Alto', 'Atención inmediata');

  const RiskLevel(this.label, this.description);

  final String label;
  final String description;
}
