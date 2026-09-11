#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter no está instalado o no está disponible en PATH."
  exit 1
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"

if [[ ! -d android ]]; then
  backup_dir="$(mktemp -d)"
  trap 'rm -rf "$backup_dir"' EXIT

  cp -R lib test assets "$backup_dir/"
  cp pubspec.yaml analysis_options.yaml README.md ARCHITECTURE.md "$backup_dir/"

  flutter create \
    --empty \
    --platforms=android \
    --org edu.sipsva \
    --project-name sipsva \
    .

  cp -R "$backup_dir/lib" "$backup_dir/test" "$backup_dir/assets" .
  cp \
    "$backup_dir/pubspec.yaml" \
    "$backup_dir/analysis_options.yaml" \
    "$backup_dir/README.md" \
    "$backup_dir/ARCHITECTURE.md" \
    .
fi

flutter pub get
dart format .
flutter analyze
flutter test

echo "Proyecto Android preparado. Ejecute: flutter run"
