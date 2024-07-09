#!/bin/bash
clear
read -p "¿Deseas ejecutar el Paso 1 (Borrar instancias de Dockers y redes)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 1: Borrar instancias de Dockers y redes
  #docker stop $(docker ps -a -q)
  docker ps -q | xargs -r docker stop
  #docker rm $(docker ps -a -q)
  docker ps -q | xargs -r docker rm
  docker volume prune --force
  docker volume prune --force
  cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/autopistas_g7
  ./network.sh down
fi

read -p "¿Deseas ejecutar el Paso 2 (Clonar repo de base)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 2: Clonar repo de base
  cd ~/Documents/GitHub/hyperledger-fabric/
  git clone https://gitlab.com/STorres17/soluciones-blockchain.git
fi

read -p "¿Deseas ejecutar el Paso 3 (Instalar editor de json)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 3: Instalar editor de json
  cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/autopistas_g7
  sudo apt install jq
fi

read -p "¿Deseas ejecutar el Paso 4 (Borrar instancias de Dockers residuales)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 4: Borrar instancias de Dockers residuales
  docker ps -q | xargs -r docker stop
  docker ps -q | xargs -r docker rm
  docker volume prune -f
  docker network prune -f
fi

read -p "¿Deseas ejecutar el Paso 5 (Borrar carpetas de certificados y artefactos)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 5: Borrar carpetas de certificados y artefactos
  cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/autopistas_g7
  rm -rf organizations/peerOrganizations
  rm -rf organizations/ordererOrganizations
  rm -rf channel-artifacts/
  mkdir channel-artifacts
fi

read -p "¿Deseas ejecutar el Paso 6 (Crear certificados de las Org)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 6: Crear certificados de las Org
  export PATH=${PWD}/../bin:${PWD}:$PATH
  export FABRIC_CFG_PATH=${PWD}/../config
  cryptogen generate --config=./organizations/cryptogen/crypto-config-iebs.yaml --output="organizations"
  cryptogen generate --config=./organizations/cryptogen/crypto-config-cantabria.yaml --output="organizations"
  cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"
fi

read -p "¿Deseas ejecutar el Paso 7 (Arrancar la red con 1 orderer, 2 orgs y 2 couchdbs)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 7: Arrancar la red con 1 orderer, 2 orgs y 2 couchdbs
  docker-compose -f docker/docker-compose-autopistas.yaml up -d
fi

read -p "¿Deseas ejecutar el Paso 8 (Crear los canales)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 8: Crear los canales
  export FABRIC_CFG_PATH=${PWD}/configtx
  configtxgen -profile UniversidadesGenesis -outputBlock ./channel-artifacts/autopistaschannel.block -channelID autopistaschannel

  export FABRIC_CFG_PATH=${PWD}/../config
  export ORDERER_CA=${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem
  export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/tls/server.crt
  export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/tls/server.key
  osnadmin channel join --channelID autopistaschannel --config-block ./channel-artifacts/autopistaschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
  osnadmin channel list -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
fi

read -p "¿Deseas ejecutar el Paso 9 (Adherir Org1 al Orderer)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 9: Adherir Org1 al Orderer
  export CORE_PEER_TLS_ENABLED=true
  export PEER0_IEBS_CA=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/peers/peer0.mop.autopistasmop.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID="IebsMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_IEBS_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/users/Admin@mop.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
  peer channel join -b ./channel-artifacts/autopistaschannel.block
fi

read -p "¿Deseas ejecutar el Paso 10 (Adherir Org2 al Orderer)? (s/n): " ejecutar
if [[ $ejecutar == "s" ]]; then
  # Paso 10: Adherir Org2 al Orderer
  export PEER0_CANTABRIA_CA=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/peers/peer0.ruta78.autopistasmop.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID="CantabriaMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CANTABRIA_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/users/Admin@ruta78.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
  peer channel join -b ./channel-artifacts/autopistaschannel.block
  export FABRIC_CFG_PATH=$PWD/../config/
  peer channel list

fi

