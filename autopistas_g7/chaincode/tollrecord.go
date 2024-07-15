package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// TollRecord define la estructura del registro de tránsito
type TollRecord struct {
	NumContratoCliente string `json:"num_contrato_cliente"`
	PlacaMatricula     string `json:"placa_matricula"`
	FechaHoraTx        string `json:"fecha_hora_tx"`
	NumPortico         string `json:"num_portico"`
	PrecioCLP          int    `json:"precio_clp"`cd
}

// SmartContract proporciona funciones para gestionar el registro de peajes
type SmartContract struct {
	contractapi.Contract
}

// InitLedger agrega un conjunto de registros inicial al ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	tollRecords := []TollRecord{
		{"0xc83273f025ecEd0317f52DfE26d95C4638a10D7E", "HSGT59", "Tue Jul  9 18:18:58 -04 2024", "P001", 525},
		{"0xa83273f025ecEd0317f52DfE26d95C4638a10D7E", "HSGT60", "Tue Jul  9 18:19:58 -04 2024", "P002", 530},
		{"0xb83273f025ecEd0317f52DfE26d95C4638a10D7E", "HSGT61", "Tue Jul  9 18:20:58 -04 2024", "P003", 535},
		{"0xc83273f025ecEd0317f52DfE26d95C4638a10D7E", "HSGT62", "Tue Jul  9 18:21:58 -04 2024", "P004", 540},
		{"0xd83273f025ecEd0317f52DfE26d95C4638a10D7E", "HSGT63", "Tue Jul  9 18:22:58 -04 2024", "P005", 545},
		{"0xe83273f025ecEd0317f52DfE26d95C4638a10D7E", "HSGT64", "Tue Jul  9 18:23:58 -04 2024", "P006", 550},
	}

	for _, tollRecord := range tollRecords {
		tollRecordJSON, err := json.Marshal(tollRecord)
		if err != nil {
			return err
		}

		err = ctx.GetStub().PutState(tollRecord.NumContratoCliente, tollRecordJSON)
		if err != nil {
			return fmt.Errorf("failed to put to world state. %s", err.Error())
		}
	}

	return nil
}

// CreateTollRecord crea un nuevo registro de peaje
func (s *SmartContract) CreateTollRecord(ctx contractapi.TransactionContextInterface, numContratoCliente string, placaMatricula string, fechaHoraTx string, numPortico string, precioCLP int) error {
	tollRecord := TollRecord{
		NumContratoCliente: numContratoCliente,
		PlacaMatricula:     placaMatricula,
		FechaHoraTx:        fechaHoraTx,
		NumPortico:         numPortico,
		PrecioCLP:          precioCLP,
	}

	tollRecordJSON, err := json.Marshal(tollRecord)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(numContratoCliente, tollRecordJSON)
}

// QueryTollRecord consulta un registro de peaje por su número de contrato
func (s *SmartContract) QueryTollRecord(ctx contractapi.TransactionContextInterface, numContratoCliente string) (*TollRecord, error) {
	tollRecordJSON, err := ctx.GetStub().GetState(numContratoCliente)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state. %s", err.Error())
	}
	if tollRecordJSON == nil {
		return nil, fmt.Errorf("the record %s does not exist", numContratoCliente)
	}

	var tollRecord TollRecord
	err = json.Unmarshal(tollRecordJSON, &tollRecord)
	if err != nil {
		return nil, err
	}

	return &tollRecord, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error creating chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincode: %s", err.Error())
	}
}
