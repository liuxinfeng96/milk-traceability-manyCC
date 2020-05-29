#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users

starttime=$(date +%s)

# launch network; create channel and join peer to channel
cd ../app_network
./start.sh

# 安装链码
docker exec cli peer chaincode install -n sourcechaincode -v 1.0 -p github.com/source
docker exec cli peer chaincode install -n processchaincode -v 1.0 -p github.com/process
docker exec cli peer chaincode install -n logisticschaincode -v 1.0 -p github.com/logistics
docker exec cli peer chaincode install -n saleschaincode -v 1.0 -p github.com/sales
# 实例化链码
docker exec cli peer chaincode instantiate -o orderer.example.com:7050 -C firstchannel -n sourcechaincode -v 1.0 -c '{"Args":[""]}' -P "OR ('SourceMSP.member','ProcessMSP.member','LogisticsMSP.member','SalesMSP.member')"
sleep 5


docker exec -e  "CORE_PEER_LOCALMSPID=ProcessMSP" -e "CORE_PEER_ADDRESS=peer0.process.example.com:7051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/users/Admin@process.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/peers/peer0.process.example.com/tls/ca.crt" cli peer chaincode install -n sourcechaincode -v 1.0 -p github.com/source

docker exec -e  "CORE_PEER_LOCALMSPID=ProcessMSP" -e "CORE_PEER_ADDRESS=peer0.process.example.com:7051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/users/Admin@process.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/peers/peer0.process.example.com/tls/ca.crt" cli peer chaincode install -n processchaincode -v 1.0 -p github.com/process

docker exec -e  "CORE_PEER_LOCALMSPID=ProcessMSP" -e "CORE_PEER_ADDRESS=peer0.process.example.com:7051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/users/Admin@process.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/peers/peer0.process.example.com/tls/ca.crt" cli peer chaincode install -n logisticschaincode -v 1.0 -p github.com/logistics

docker exec -e  "CORE_PEER_LOCALMSPID=ProcessMSP" -e "CORE_PEER_ADDRESS=peer0.process.example.com:7051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/users/Admin@process.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/peers/peer0.process.example.com/tls/ca.crt" cli peer chaincode install -n saleschaincode -v 1.0 -p github.com/sales

docker exec -e  "CORE_PEER_LOCALMSPID=ProcessMSP" -e "CORE_PEER_ADDRESS=peer0.process.example.com:7051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/users/Admin@process.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/process.example.com/peers/peer0.process.example.com/tls/ca.crt" cli peer chaincode instantiate -o orderer.example.com:7050 -C firstchannel -n processchaincode -v 1.0 -c '{"Args":[""]}' -P "OR ('SourceMSP.member','ProcessMSP.member','LogisticsMSP.member','SalesMSP.member')"
sleep 5


docker exec -e "CORE_PEER_LOCALMSPID=LogisticsMSP" -e "CORE_PEER_ADDRESS=peer0.logistics.example.com:8051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/users/Admin@logistics.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/peers/peer0.logistics.example.com/tls/ca.crt" cli peer chaincode install -n sourcechaincode -v 1.0 -p github.com/source

docker exec -e "CORE_PEER_LOCALMSPID=LogisticsMSP" -e "CORE_PEER_ADDRESS=peer0.logistics.example.com:8051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/users/Admin@logistics.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/peers/peer0.logistics.example.com/tls/ca.crt" cli peer chaincode install -n processchaincode -v 1.0 -p github.com/process

docker exec -e "CORE_PEER_LOCALMSPID=LogisticsMSP" -e "CORE_PEER_ADDRESS=peer0.logistics.example.com:8051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/users/Admin@logistics.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/peers/peer0.logistics.example.com/tls/ca.crt" cli peer chaincode install -n logisticschaincode -v 1.0 -p github.com/logistics

docker exec -e "CORE_PEER_LOCALMSPID=LogisticsMSP" -e "CORE_PEER_ADDRESS=peer0.logistics.example.com:8051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/users/Admin@logistics.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/peers/peer0.logistics.example.com/tls/ca.crt" cli peer chaincode install -n saleschaincode -v 1.0 -p github.com/sales

docker exec -e "CORE_PEER_LOCALMSPID=LogisticsMSP" -e "CORE_PEER_ADDRESS=peer0.logistics.example.com:8051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/users/Admin@logistics.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/logistics.example.com/peers/peer0.logistics.example.com/tls/ca.crt" cli peer chaincode instantiate -o orderer.example.com:7050 -C firstchannel -n logisticschaincode -v 1.0 -c '{"Args":[""]}' -P "OR ('SourceMSP.member','ProcessMSP.member','LogisticsMSP.member','SalesMSP.member')"
sleep 5

docker exec -e "CORE_PEER_LOCALMSPID=SalesMSP" -e "CORE_PEER_ADDRESS=peer0.sales.example.com:9051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/users/Admin@sales.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/peers/peer0.sales.example.com/tls/ca.crt" cli peer chaincode install -n sourcechaincode -v 1.0 -p github.com/source

docker exec -e "CORE_PEER_LOCALMSPID=SalesMSP" -e "CORE_PEER_ADDRESS=peer0.sales.example.com:9051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/users/Admin@sales.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/peers/peer0.sales.example.com/tls/ca.crt" cli peer chaincode install -n processchaincode -v 1.0 -p github.com/process

docker exec -e "CORE_PEER_LOCALMSPID=SalesMSP" -e "CORE_PEER_ADDRESS=peer0.sales.example.com:9051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/users/Admin@sales.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/peers/peer0.sales.example.com/tls/ca.crt" cli peer chaincode install -n logisticschaincode -v 1.0 -p github.com/logistics

docker exec -e "CORE_PEER_LOCALMSPID=SalesMSP" -e "CORE_PEER_ADDRESS=peer0.sales.example.com:9051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/users/Admin@sales.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/peers/peer0.sales.example.com/tls/ca.crt" cli peer chaincode install -n saleschaincode -v 1.0 -p github.com/sales

docker exec -e "CORE_PEER_LOCALMSPID=SalesMSP" -e "CORE_PEER_ADDRESS=peer0.sales.example.com:9051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/users/Admin@sales.example.com/msp" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sales.example.com/peers/peer0.sales.example.com/tls/ca.crt" cli peer chaincode instantiate -o orderer.example.com:7050 -C firstchannel -n saleschaincode -v 1.0 -c '{"Args":[""]}' -P "OR ('SourceMSP.member','ProcessMSP.member','LogisticsMSP.member','SalesMSP.member')"
sleep 5


printf "\nTotal setup execution time : $(($(date +%s) - starttime)) secs ...\n\n\n"
printf "链码安装完成...\n"

