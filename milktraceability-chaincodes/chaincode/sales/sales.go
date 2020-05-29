package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

//SalesChaincode 自定义链码
type SalesChaincode struct {
}

//SourceInfo 原料信息
type SourceInfo struct {
	GrassState string `json:"grassState"` //牧草指标
	CowState   string `json:"cowState"`   //奶牛状态指标
	MilkState  string `json:"milkState"`  //生牛乳指标
}

//ProcessInfo 加工信息
type ProcessInfo struct {
	ProteinContent string `json:"proteinContent"` //蛋白质含量
	SterilizeTime  string `json:"sterilizeTime"`  //杀菌时间
	StorageTime    string `json:"storageTime"`    //存储时间
}

//LogInfo 配送信息
type LogInfo struct {
	LogCopName     string `json:"logCopName"`     //物流公司名称
	LogDepartureTm string `json:"logDepartureTm"` //出发时间
	LogArrivalTm   string `json:"logArrivalTm"`   //到达时间
	LogDeparturePl string `json:"logDeparturePl"` //出发地
	LogDest        string `json:"logDest"`        //目的地
	LogMOT         string `json:"logMOT"`         //运送方式
	TempAvg        string `json:"tempAvg"`        //平均温度
}

//MilkInfo 牛奶产品
type MilkInfo struct {
	MilkID          string      `json:"milkID"`          //牛奶ID
	MilkSourceInfo  SourceInfo  `json:"milkSourceInfo"`  //原料信息
	MilkProcessInfo ProcessInfo `json:"milkProcessInfo"` //加工信息
	MilkLogInfo     LogInfo     `json:"milkLogInfo"`     //配送信息
}

//Init 函数
func (s *SalesChaincode) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

//Invoke 函数
func (s *SalesChaincode) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {
	function, args := APIstub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)
	if function == "queryMilk" {
		return s.queryMilk(APIstub, args)
	}
	return shim.Error("Invalid Smart Contract function name.")
}

//查询产品
func (s *SalesChaincode) queryMilk(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}
	var milkInfo MilkInfo
	var resultMilkInfo MilkInfo
	var err error
	sourceInfo := APIstub.InvokeChaincode("sourcechaincode", [][]byte{[]byte("getSourceInfo"), []byte(args[0])}, "firstchannel")
	processInfo := APIstub.InvokeChaincode("processchaincode", [][]byte{[]byte("getProcessInfo"), []byte(args[0])}, "firstchannel")
	logInfo := APIstub.InvokeChaincode("logisticschaincode", [][]byte{[]byte("getLogInfo"), []byte(args[0])}, "firstchannel")
	resultMilkInfo.MilkID = args[0]
	if sourceInfo.Payload != nil {
		err = json.Unmarshal(sourceInfo.Payload, &milkInfo)
		if err != nil {
			return shim.Error("反序列化失败")
		}
		resultMilkInfo.MilkSourceInfo = milkInfo.MilkSourceInfo
	}
	if processInfo.Payload != nil {
		err = json.Unmarshal(processInfo.Payload, &milkInfo)
		if err != nil {
			return shim.Error("反序列化失败")
		}
		resultMilkInfo.MilkProcessInfo = milkInfo.MilkProcessInfo
	}

	if logInfo.Payload != nil {

		err = json.Unmarshal(logInfo.Payload, &milkInfo)
		if err != nil {
			return shim.Error("反序列化失败")
		}
		resultMilkInfo.MilkLogInfo = milkInfo.MilkLogInfo
	}
	resultJSONasBytes, _ := json.Marshal(resultMilkInfo)
	return shim.Success([]byte(resultJSONasBytes))
}

func main() {
	err := shim.Start(new(SalesChaincode))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
