#FIN.......................

INSTALAR RED UNIVERSITARIA

--> Borrar instalaciones previas
cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/universidades_g7
./network.sh down

cd ~/Documents/GitHub/hyperledger-fabric/

#git clone https://gitlab.com/STorres17/soluciones-blockchain.git

cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/universidades_g7

#sudo apt install jq

#docker stop $(docker ps -a -q)
docker ps -q | xargs -r docker stop
#docker rm $(docker ps -a -q)
docker ps -q | xargs -r docker rm

docker volume prune 
docker network prune

rm -rf organizations/peerOrganizations
rm -rf organizations/ordererOrganizations
rm -rf channel-artifacts/
mkdir channel-artifacts

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
cryptogen generate --config=./organizations/cryptogen/crypto-config-iebs.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-cantabria.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

docker-compose -f docker/docker-compose-universidades.yaml up -d

//ya tenemos arracanda la red con 1 orderer, 2 orgs y 2 couchdbs 
//habrá que crear los canales

export FABRIC_CFG_PATH=${PWD}/configtx
configtxgen -profile UniversidadesGenesis -outputBlock ./channel-artifacts/universidadeschannel.block -channelID universidadeschannel
export FABRIC_CFG_PATH=${PWD}/../config
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universidadesg7.com/orderers/orderer.universidadesg7.com/msp/tlscacerts/tlsca.universidadesg7.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/universidadesg7.com/orderers/orderer.universidadesg7.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/universidadesg7.com/orderers/orderer.universidadesg7.com/tls/server.key

osnadmin channel join --channelID universidadeschannel --config-block ./channel-artifacts/universidadeschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

export CORE_PEER_TLS_ENABLED=true
export PEER0_IEBS_CA=${PWD}/organizations/peerOrganizations/iebs.universidadesg7.com/peers/peer0.iebs.universidadesg7.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="IebsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_IEBS_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/iebs.universidadesg7.com/users/Admin@iebs.universidadesg7.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer channel join -b ./channel-artifacts/universidadeschannel.block

export PEER0_CANTABRIA_CA=${PWD}/organizations/peerOrganizations/cantabria.universidadesg7.com/peers/peer0.cantabria.universidadesg7.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="CantabriaMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CANTABRIA_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/cantabria.universidadesg7.com/users/Admin@cantabria.universidadesg7.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer channel join -b ./channel-artifacts/universidadeschannel.block



# INSTALAR RED UNIVERSITARIA
# --> Borrar instalaciones previas
cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/universidades_g7
./network.sh down  # Apaga y limpia la red de prueba existente
cd ~/Documents/GitHub/hyperledger-fabric/
# Clonar el repositorio de soluciones blockchain
#git clone https://gitlab.com/STorres17/soluciones-blockchain.git
# Navegar al directorio de universidades
cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/universidades_g7
# Instalar jq, una herramienta para procesar JSON
#sudo apt install jq
# Detener y eliminar todos los contenedores Docker
docker ps -a -q
# docker stop $(docker ps -q)
docker ps -q | xargs -r docker stop
# Eliminar todos los volúmenes y redes no utilizadas
docker volume prune
docker network prune
# Eliminar las organizaciones y artefactos del canal anteriores
rm -rf organizations/peerOrganizations
rm -rf organizations/ordererOrganizations
rm -rf channel-artifacts/
mkdir channel-artifacts  # Crear un directorio para los nuevos artefactos del canal
# Configurar las variables de entorno necesarias para Hyperledger Fabric
echo $PATH
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
# Generar certificados criptográficos para las organizaciones
cryptogen generate --config=./organizations/cryptogen/crypto-config-iebs.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-cantabria.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"
# Levantar la red Docker con el archivo de configuración
docker-compose -f docker/docker-compose-universidades.yaml up -d
#docker-compose -f docker/docker-compose.yaml up -d
# La red ya está arrancada con 1 orderer, 2 organizaciones y 2 CouchDBs
# Crear los canales
# Configurar la variable de entorno para la generación de artefactos de configuración
#export FABRIC_CFG_PATH=${PWD}/configtx
# Generar el bloque génesis para el canal
#export FABRIC_CFG_PATH=$PWD
#configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
#configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/universidadeschannel.tx -channelID universidadeschannel
#peer channel create -o orderer.example.com:7050 -c universidadeschannel -f ./channel-artifacts/universidadeschannel.tx
configtxgen -profile UniversidadesGenesis -outputBlock ./channel-artifacts/universidadeschannel.block -channelID universidadeschannel

# Configurar las variables de entorno necesarias para el ordenamiento
export FABRIC_CFG_PATH=${PWD}/../config
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.key

# Unir el canal al ordenamiento
osnadmin channel join --channelID universidadeschannel --config-block ./channel-artifacts/universidadeschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# Listar los canales del ordenamiento
osnadmin channel list -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

# Configurar las variables de entorno para los peers de IEBS y CANTABRIA
export CORE_PEER_TLS_ENABLED=true
export PEER0_MADRID_CA=${PWD}/organizations/peerOrganizations/iebs.universidades.com/peers/peer0.madrid.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="IEBSMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_IEBS_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/iebs.universidades.com/users/Admin@madrid.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:7051
# Unir el peer de Iebs al canal
peer channel join -b ./channel-artifacts/universidadeschannel.block
# Configurar las variables de entorno para el peer de Bogotá
export PEER0_BOGOTA_CA=${PWD}/organizations/peerOrganizations/bogota.universidades.com/peers/peer0.bogota.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="BogotaMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BOGOTA_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/bogota.universidades.com/users/Admin@bogota.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:9051
# Unir el peer de Bogotá al canal
peer channel join -b ./channel-artifacts/universidadeschannel.block
# --> REVISAR DOCKERS Y SUS LOGS


--> REVISAR DOCKERS Y SUS LOGS
# ------------------ ADICIÓN DE UNA ORGANIZACIÓN A LA RED UNIVERSITARIA ------------------
# Configurar las variables de entorno necesarias
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
# Generar certificados criptográficos para la organización de Berlín
cryptogen generate --config=./organizations/cryptogen/crypto-config-berlin.yaml --output="organizations"
cd berlin/
export FABRIC_CFG_PATH=$PWD
# Generar la configuración para la organización de Berlín
../../bin/configtxgen -printOrg BerlinMSP > ../organizations/peerOrganizations/berlin.universidades.com/berlin.json
cd ..
# Levantar la red Docker para Berlín
docker-compose -f docker/docker-compose-berlin.yaml up -d
# Configurar las variables de entorno necesarias
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
export CORE_PEER_TLS_ENABLED=true
export PEER0_MADRID_CA=${PWD}/organizations/peerOrganizations/madrid.universidades.com/peers/peer0.madrid.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="MadridMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MADRID_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/madrid.universidades.com/users/Admin@madrid.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:7051
# Obtener el bloque de configuración del canal
peer channel fetch config channel-artifacts/config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.universidades.com -c universidadeschannel --tls --cafile ${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem
cd channel-artifacts
# Decodificar el bloque de configuración a JSON
configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
# Extraer la configuración del canal
jq .data.data[0].payload.data.config config_block.json > config.json
# Modificar la configuración para incluir a Berlín
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"BerlinMSP":.[1]}}}}}' config.json ../organizations/peerOrganizations/berlin.universidades.com/berlin.json > modified_config.json
# Codificar la configuración original y modificada
configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
# Calcular la actualización de configuración
configtxlator compute_update --channel_id universidadeschannel --original config.pb --updated modified_config.pb --output berlin_update.pb
# Decodificar la actualización a JSON
configtxlator proto_decode --input berlin_update.pb --type common.ConfigUpdate --output berlin_update.json
# Crear un envoltorio para la actualización de configuración
echo '{"payload":{"header":{"channel_header":{"channel_id":"'universidadeschannel'", "type":2}},"data":{"config_update":'$(cat berlin_update.json)'}}}' | jq . > berlin_update_in_envelope.json

# Codificar la actualización en el envoltorio
configtxlator proto_encode --input berlin_update_in_envelope.json --type common.Envelope --output berlin_update_in_envelope.pb
cd ..
# Firmar la actualización del canal
peer channel signconfigtx -f channel-artifacts/berlin_update_in_envelope.pb
# Configurar las variables de entorno necesarias para Bogotá
export PEER0_BOGOTA_CA=${PWD}/organizations/peerOrganizations/bogota.universidades.com/peers/peer0.bogota.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="BogotaMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BOGOTA_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/bogota.universidades.com/users/Admin@bogota.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:9051
# Actualizar el canal para incluir a Berlín
peer channel update -f channel-artifacts/berlin_update_in_envelope.pb -c universidadeschannel -o localhost:7050 --ordererTLSHostnameOverride orderer.universidades.com --tls --cafile ${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem
# Configurar las variables de entorno necesarias para el peer de Berlín
export PEER0_BERLIN_CA=${PWD}/organizations/peerOrganizations/berlin.universidades.com/peers/peer0.berlin.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="BerlinMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BERLIN_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/berlin.universidades.com/users/Admin@berlin.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:2051
# Obtener el bloque del canal para Berlín
peer channel fetch 0 channel-artifacts/universidadeschannel.block -o localhost:7050 --ordererTLSHostnameOverride orderer.universidades.com -c universidadeschannel --tls --cafile ${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem
# Unir el peer de Berlín al canal
peer channel join -b channel-artifacts/universidadeschannel.block
# ------------------ Administración y configuración de un canal de Hyperledger Fabric ------------------
# --> Revisar configtx.yaml
# --> Extraer info de un canal
# --> https://hyperledger-fabric.readthedocs.io/en/release-2.3/commands/peerchannel.html
# --> https://hyperledger-fabric.readthedocs.io/en/release-2.3/commands/osnadminchannel.html
# ------------------ Creación de certificados en base a la configuración de la red ------------------
# --> De cryptogen a la CA
# Detener y eliminar todos los contenedores Docker
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
# Eliminar todos los volúmenes y redes no utilizadas
docker volume prune
docker network prune
# Eliminar las organizaciones y artefactos del canal anteriores
rm -rf organizations/peerOrganizations
rm -rf organizations/ordererOrganizations
sudo rm -rf organizations/fabric-ca/madrid/
sudo rm -rf organizations/fabric-ca/bogota/
sudo rm -rf organizations/fabric-ca/ordererOrg/
rm -rf channel-artifacts/
mkdir channel-artifacts  # Crear un directorio para los nuevos artefactos del canal
# Levantar la red Docker para las autoridades certificadoras
docker-compose -f docker/docker-compose-ca.yaml up -d
# Registrar y enrolar las organizaciones usando la CA
. ./organizations/fabric-ca/registerEnroll.sh && createMadrid
. ./organizations/fabric-ca/registerEnroll.sh && createBogota
. ./organizations/fabric-ca/registerEnroll.sh && createOrderer
# Levantar la red Docker para la red universitaria
docker-compose -f docker/docker-compose-universidades.yaml up -d
# Configurar las variables de entorno necesarias para la generación de artefactos de configuración
export FABRIC_CFG_PATH=${PWD}/configtx
# Generar el bloque génesis para el canal
configtxgen -profile UniversidadesGenesis -outputBlock ./channel-artifacts/universidadeschannel.block -channelID universidadeschannel
# Configurar las variables de entorno necesarias para el ordenamiento
export FABRIC_CFG_PATH=${PWD}/../config
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.key
# Unir el canal al ordenamiento
osnadmin channel join --channelID universidadeschannel --config-block ./channel-artifacts/universidadeschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
# Listar los canales del ordenamiento
osnadmin channel list -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
# Configurar las variables de entorno necesarias para los peers de Madrid y Bogotá
export CORE_PEER_TLS_ENABLED=true
export PEER0_MADRID_CA=${PWD}/organizations/peerOrganizations/madrid.universidades.com/peers/peer0.madrid.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="MadridMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MADRID_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/madrid.universidades.com/users/Admin@madrid.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:7051
# Unir el peer de Madrid al canal
peer channel join -b ./channel-artifacts/universidadeschannel.block
# Configurar las variables de entorno para el peer de Bogotá
export PEER0_BOGOTA_CA=${PWD}/organizations/peerOrganizations/bogota.universidades.com/peers/peer0.bogota.universidades.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="BogotaMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BOGOTA_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/bogota.universidades.com/users/Admin@bogota.universidades.com/msp
export CORE_PEER_ADDRESS=localhost:9051
# Unir el peer de Bogotá al canal
peer channel join -b ./channel-artifacts/universidadeschannel.block
# ------------------ Administración de una Autoridad Certificadora (CA) ------------------
# --> Leer despliegue de la CA
# --> Opcionales al despliegue
# --> Logs de CA
# --> HSM en CA
# https://hyperledger-fabric-ca.readthedocs.io/en/v1.5.2/
