export FABRIC_CFG_PATH=$PWD
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/universidadeschannel.tx -channelID universidadeschannel
peer channel create -o orderer.example.com:7050 -c universidadeschannel -f ./channel-artifacts/universidadeschannel.tx
