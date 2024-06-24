#!/bin/bash

# Configuración de CA para Universidad IEBS
fabric-ca-client enroll -u https://admin:adminpw@localhost:7054
fabric-ca-client register --id.name peer0 --id.secret peer0pw --id.type peer
fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 -M ./crypto-config/peerOrganizations/iebs.example.com/peers/peer0

# Configuración de CA para Universidad de Cantabria
fabric-ca-client enroll -u https://admin:adminpw@localhost:8054
fabric-ca-client register --id.name peer0 --id.secret peer0pw --id.type peer
fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 -M ./crypto-config/peerOrganizations/cantabria.example.com/peers/peer0
