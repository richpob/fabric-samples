go install golang.org/x/tools/gopls@latest
go mod init tollchaincode
go get github.com/hyperledger/fabric-contract-api-go/contractapi
go mod tidy
GO111MODULE=on go mod vendor

go install golang.org/x/tools/gopls@latest 

  
  
  # Se empaqueta Chaincode
go list -json -mod=mod
peer lifecycle chaincode package toll.tar.gz --path chaincodes/ --lang golang --label toll_1.0

  # Paso 11: Adherir Contrato a MOP
  export FABRIC_CFG_PATH=${PWD}/../config
  export CORE_PEER_TLS_ENABLED=true
  export PEER0_MOP_CA=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/peers/peer0.mop.autopistasmop.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID="MopMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MOP_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/users/Admin@mop.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode install toll.tar.gz 

  

    # Paso 12: Adherir Contrato  Ruta78MSP
  export FABRIC_CFG_PATH=${PWD}/../config
  export PEER0_RUTA78_CA=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/peers/peer0.ruta78.autopistasmop.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID="Ruta78MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RUTA78_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/users/Admin@ruta78.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode install toll.tar.gz 

peer lifecycle chaincode queryinstalled
//copiar el ID del package, es una combinación del nombre del chaincode y el hash del contenido del código
export CC_PACKAGE_ID=toll2.0:5a333a60ba99e11d3ae6aa5dd9dc8e665485a1deb20a3bb0876a7f50f1678b3b
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.autopistasmop.com --channelID autopistaschannel --signature-policy "OR('MopMSP.member','Ruta78MSP.member')" --name tollchaincode --version 2.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem

  export CORE_PEER_LOCALMSPID="MopMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MOP_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/users/Admin@mop.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.autopistasmop.com --channelID autopistaschannel --signature-policy "OR('MopMSP.member','Ruta78MSP.member')" --name tollchaincode --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem

peer lifecycle chaincode checkcommitreadiness --channelID autopistaschannel --name tollchaincode --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem --output json

  export CORE_PEER_LOCALMSPID="Ruta78MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RUTA78_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/users/Admin@ruta78.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:9051

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.autopistasmop.com --channelID autopistaschannel --signature-policy "OR('MopMSP.member','Ruta78MSP.member')" --name tollchaincode --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem

peer lifecycle chaincode checkcommitreadiness --channelID autopistaschannel --name tollchaincode --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem --output json

export CORE_PEER_LOCALMSPID="MopMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MOP_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/users/Admin@mop.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.autopistasmop.com --signature-policy "OR('MopMSP.member','Ruta78MSP.member')" --channelID autopistaschannel --name tollchaincode --version 1.0 --sequence 1 --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/peers/peer0.mop.autopistasmop.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/peers/peer0.ruta78.autopistasmop.com/tls/ca.crt

peer lifecycle chaincode querycommitted --channelID autopistaschannel --name tollchaincode --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem

//probar el chaincode Toll 
  export CORE_PEER_LOCALMSPID="Ruta78MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RUTA78_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/users/Admin@ruta78.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.autopistasmop.com --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem -C autopistaschannel -n tollchaincode --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/peers/peer0.ruta78.autopistasmop.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'

peer chaincode query -C autopistaschannel -n tollchaincode -c '{"Args":["QueryTollRecord"]}'

peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.autopistasmop.com --tls --cafile ${PWD}/organizations/ordererOrganizations/autopistasmop.com/orderers/orderer.autopistasmop.com/msp/tlscacerts/tlsca.autopistasmop.com-cert.pem -C autopistaschannel -n tollchaincode --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/peers/peer0.ruta78.autopistasmop.com/tls/ca.crt -c '{"function":"CreateAsset","Args":["asset8","green","16","Sergio","750"]}'
peer chaincode query -C autopistaschannel -n tollchaincode -c '{"Args":["QueryTollRecord"]}'


