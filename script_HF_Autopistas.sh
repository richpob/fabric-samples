# INSTALAR RED UNIVERSITARIA
#Paso 1: Borrar instancias de Dockers y redes
--> Borrar instalaciones previas
#docker stop $(docker ps -a -q)
docker ps -q | xargs -r docker stop
#docker rm $(docker ps -a -q)
docker ps -q | xargs -r docker rm
docker volume prune --force
docker volume prune --force
cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/autopistas_g7
./network.sh down
grep -r --include="*.yaml" "autopistasmop.com" .
grep -r --include="*.sh" "autopistas_g7"
grep -r --include="*.yaml" "autopistasruta78.com" .

#Paso 2: Clonar repo de base
#cd ~/Documents/GitHub/hyperledger-fabric/
#git clone https://gitlab.com/STorres17/soluciones-blockchain.git

#Paso 3: Instalar editor de json
cd ~/Documents/GitHub/hyperledger-fabric/fabric-samples/universidades_g7
#sudo apt install jq

#Paso 4: Borrar instancias de Dockers residuales
#docker stop $(docker ps -a -q)
docker ps -q | xargs -r docker stop
#docker rm $(docker ps -a -q)
docker ps -q | xargs -r docker rm
docker volume prune --force
docker network prune --force

#Paso 5: Borrar carpetas de certificados y artefactos
rm -rf organizations/peerOrganizations
rm -rf organizations/ordererOrganizations
rm -rf channel-artifacts/
mkdir channel-artifacts

#Paso 6: Crear certificados de las Org
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/../config
cryptogen generate --config=./organizations/cryptogen/crypto-config-iebs.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-cantabria.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

#Paso 7: arracanda la red con 1 orderer, 2 orgs y 2 couchdbs 
docker-compose -f docker/docker-compose-universidades.yaml up -d

#Paso 8: Crear los canales
export FABRIC_CFG_PATH=${PWD}/configtx
configtxgen -profile UniversidadesGenesis -outputBlock ./channel-artifacts/universidadeschannel.block -channelID universidadeschannel

export FABRIC_CFG_PATH=${PWD}/../config
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universidadesiebs.com/orderers/orderer.universidadesiebs.com/msp/tlscacerts/tlsca.universidadesiebs.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/universidadesiebs.com/orderers/orderer.universidadesiebs.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/universidadesiebs.com/orderers/orderer.universidadesiebs.com/tls/server.key
osnadmin channel join --channelID universidadeschannel --config-block ./channel-artifacts/universidadeschannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

#Paso 9: Adherir Org1 al Orderer
export CORE_PEER_TLS_ENABLED=true
export PEER0_IEBS_CA=${PWD}/organizations/peerOrganizations/iebs.universidadesiebs.com/peers/peer0.iebs.universidadesiebs.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="IebsMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_IEBS_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/iebs.universidadesiebs.com/users/Admin@iebs.universidadesiebs.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer channel join -b ./channel-artifacts/universidadeschannel.block

#Paso 10: Adherir Org2 al Orderer
export PEER0_CANTABRIA_CA=${PWD}/organizations/peerOrganizations/cantabria.universidadesiebs.com/peers/peer0.cantabria.universidadesiebs.com/tls/ca.crt
export CORE_PEER_LOCALMSPID="CantabriaMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CANTABRIA_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/cantabria.universidadesiebs.com/users/Admin@cantabria.universidadesiebs.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer channel join -b ./channel-artifacts/universidadeschannel.block