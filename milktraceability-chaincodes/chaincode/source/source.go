package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

//SourceChaincode 自定义链码
type SourceChaincode struct {
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
func (s *SourceChaincode) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

//Invoke 函数
func (s *SourceChaincode) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {
	function, args := APIstub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)
	if function == "addSourceInfo" {
		return s.addSourceInfo(APIstub, args)
	} else if function == "getSourceInfo" {
		return s.getSourceInfo(APIstub, args)
	}
	return shim.Error("Invalid Smart Contract function name.")
}

//添加原料信息
func (s *SourceChaincode) addSourceInfo(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	var err error
	var MilkInfos MilkInfo

	if len(args) != 4 {
		return shim.Error("Incorrect number of arguments.")
	}
	MilkInfos.MilkID = args[0]
	if MilkInfos.MilkID == "" {
		return shim.Error("MilkID can not be empty.")
	}
	MilkInfos.MilkSourceInfo.GrassState = args[1]
	MilkInfos.MilkSourceInfo.CowState = args[2]
	MilkInfos.MilkSourceInfo.MilkState = args[3]
	SourceInfoJSONasBytes, err := json.Marshal(MilkInfos)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = APIstub.PutState(MilkInfos.MilkID, SourceInfoJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

//获取原料信息
func (s *SourceChaincode) getSourceInfo(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}
	milkAsBytes, err := APIstub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(milkAsBytes)
}

func main() {
	err := shim.Start(new(SourceChaincode))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
