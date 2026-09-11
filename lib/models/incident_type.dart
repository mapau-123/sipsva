enum IncidentType {
  accident('Accidente', 'Colisión o siniestro vial'),
  brokenVehicle('Vehículo averiado', 'Vehículo detenido en la vía'),
  fire('Incendio', 'Fuego o presencia de humo'),
  obstruction('Obstrucción', 'Objeto o bloqueo sobre la calzada');

  const IncidentType(this.label, this.description);

  final String label;
  final String description;
}
