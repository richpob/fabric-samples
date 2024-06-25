#!/bin/bash

# Directorio base
BASE_DIR="./universidades_g7"

# Buscar y reemplazar recursivamente en archivos .yaml
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/universidadesg7.com/universidadesiebs.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/universidadesg7.com/universidadesiebs.com/g' {} +
echo "Reemplazo completado en todos los archivos .yaml dentro del directorio $BASE_DIR"
