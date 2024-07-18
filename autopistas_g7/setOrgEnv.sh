#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Mop
ORG=${1:-Mop}

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/autopistas_g7/organizations/ordererOrganizations/autopistasmop.com/tlsca/tlsca.autopistasmop.com-cert.pem
PEER0_ORG1_CA=${DIR}/autopistas_g7/organizations/peerOrganizations/mop.autopistasmop.com/tlsca/tlsca.mop.autopistasmop.com-cert.pem
PEER0_ORG2_CA=${DIR}/autopistas_g7/organizations/peerOrganizations/ruta78.autopistasmop.com/tlsca/tlsca.ruta78.autopistasmop.com-cert.pem
PEER0_ORG3_CA=${DIR}/autopistas_g7/organizations/peerOrganizations/org3.autopistasmop.com/tlsca/tlsca.org3.autopistasmop.com-cert.pem


if [[ ${ORG,,} == "org1" || ${ORG,,} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=MopMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/autopistas_g7/organizations/peerOrganizations/mop.autopistasmop.com/users/Admin@mop.autopistasmop.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/autopistas_g7/organizations/peerOrganizations/mop.autopistasmop.com/tlsca/tlsca.mop.autopistasmop.com-cert.pem

elif [[ ${ORG,,} == "ruta78" || ${ORG,,} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=Ruta78MSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/autopistas_g7/organizations/peerOrganizations/ruta78.autopistasmop.com/users/Admin@ruta78.autopistasmop.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/autopistas_g7/organizations/peerOrganizations/ruta78.autopistasmop.com/tlsca/tlsca.ruta78.autopistasmop.com-cert.pem

else
   echo "Unknown \"$ORG\", please choose Mop/Digibank or Ruta78/Magnetocorp"
   echo "For example to get the environment variables to set upa Ruta78 shell environment run:  ./setOrgEnv.sh Ruta78"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Ruta78 | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_ORG1_CA=${PEER0_ORG1_CA}"
echo "PEER0_ORG2_CA=${PEER0_ORG2_CA}"
echo "PEER0_ORG3_CA=${PEER0_ORG3_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"
