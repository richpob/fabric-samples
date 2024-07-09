#!/bin/bash

#Paso 1: Borrar instancias de Dockers y redes
--> Borrar instalaciones previas
#docker stop $(docker ps -a -q)
docker ps -q | xargs -r docker stop
#docker rm $(docker ps -a -q)
docker ps -q | xargs -r docker rm
docker volume prune --force
docker volume prune --force
#cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/autopistas_g7
./universidades_g7/network.sh down

# Directorio base
BASE_DIR="./autopistas_g7"
sudo rm -R $BASE_DIR
cp -R ./universidades_g7 $BASE_DIR 

# Buscar y reemplazar recursivamente en archivos .yaml
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/cantabria.universidadesiebs.com/ruta78.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/iebs.universidadesiebs.com/mop.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/universidadesiebs.com/autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/universidadesiebs.com/autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/universidades_g7/autopistas_g7/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/cantabria.autopistasmop.com/ruta78.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/iebs.autopistasmop.com/mop.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/universidadeschannel/autopistaschannel/g' {} +
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/universidadeschannel/autopistaschannel/g' {} +
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/universidades_g7/autopistas_g7/g' {} +

find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/universidadesg7_network/autopistas_g7_network/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/universidadesg7_network/autopistas_g7_network/g' {} +

find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/orderer.example.com/orderer.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/peer0.org1.example.com/peer0.mop.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/peer0.org2.example.com/peer0.ruta78.autopistasmop.com/g' {} +

find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/orderer.example.com/orderer.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/peer0.org1.example.com/peer0.mop.autopistasmop.com/g' {} +
find $BASE_DIR -type f -name "*.yaml" -exec sed -i 's/peer0.org2.example.com/peer0.ruta78.autopistasmop.com/g' {} +

find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/docker-compose-universidades/docker-compose-autopistas/g' {} +

  
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/crypto-config-iebs/crypto-config-mop/g' {} +
find $BASE_DIR -type f -name "*.sh" -exec sed -i 's/crypto-config-cantabria/crypto-config-ruta78/g' {} +
  

echo "Reemplazo completado en todos los archivos .yaml y .sh dentro del directorio $BASE_DIR"

echo Buscar y renombrar archivos .sh y .yaml que contengan "iebs" en el nombre
find $BASE_DIR -type f \( -name '*iebs*.sh' -o -name '*iebs*.yaml' \) | while read -r file; do
    # Obtener el nuevo nombre reemplazando "iebs" por "mop"
    new_name=$(echo "$file" | sed 's/iebs/mop/g')
    # Renombrar el archivo
    mv "$file" "$new_name"
done

echo Buscar y renombrar archivos .sh y .yaml que contengan "cantabria" en el nombre
find $BASE_DIR -type f \( -name '*cantabria*.sh' -o -name '*cantabria*.yaml' \) | while read -r file; do
    # Obtener el nuevo nombre reemplazando "cantabria" por "ruta78"
    new_name=$(echo "$file" | sed 's/cantabria/ruta78/g')
    # Renombrar el archivo
    mv "$file" "$new_name"
done

echo Buscar y renombrar archivos .sh y .yaml que contengan "universidades" en el nombre
find $BASE_DIR -type f \( -name '*universidades*.sh' -o -name '*universidades*.yaml' \) | while read -r file; do
    # Obtener el nuevo nombre reemplazando "universidades" por "autopistas"
    new_name=$(echo "$file" | sed 's/universidades/autopistas/g')
    # Renombrar el archivo
    mv "$file" "$new_name"
done

echo "Renombrado completado."

