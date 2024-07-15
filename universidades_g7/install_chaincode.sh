go install golang.org/x/tools/gopls@latest
go mod init tollchaincode
go get github.com/hyperledger/fabric-contract-api-go/contractapi
go mod tidy
GO111MODULE=on go mod vendor
go build

go install golang.org/x/tools/gopls@latest 

  
  
  # Se empaqueta Chaincode
go list -json -mod=mod
cd ..
peer channel list

peer lifecycle chaincode package toll.tar.gz --path chaincodes/ --lang golang --label toll_1.0

  # Paso 9: Adherir Contrato a MOP
  export FABRIC_CFG_PATH=${PWD}/../config
  
  export CORE_PEER_TLS_ENABLED=true
  export PEER0_MOP_CA=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/peers/peer0.mop.autopistasmop.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID="MopMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MOP_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/mop.autopistasmop.com/users/Admin@mop.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode install tollchaincode.tar.gz 

    # Paso 10: Adherir Contrato  Ruta78MSP
  export FABRIC_CFG_PATH=${PWD}/../config
  export PEER0_RUTA78_CA=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/peers/peer0.ruta78.autopistasmop.com/tls/ca.crt
  export CORE_PEER_LOCALMSPID="Ruta78MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RUTA78_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ruta78.autopistasmop.com/users/Admin@ruta78.autopistasmop.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
  peer lifecycle chaincode package toll.tar.gz --path chaincode/ --lang golang --label toll_1.0 