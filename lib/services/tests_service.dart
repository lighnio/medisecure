import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:medisecure/models/test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class TestServices extends ChangeNotifier {
  List<Test> tests = [];

  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  final String _wsUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  bool isLoading = true;

  final String _privatekey =
      '0x1537579196f7a700fb7433f151478caeee854d2eef270ef51d6524ca2f32a195';
  late Web3Client _web3client;

  TestServices() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/MedicalTestContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'MedicalTestContract');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createTest;
  late ContractFunction _deleteTest;
  late ContractFunction _tests;
  late ContractFunction _testsCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createTest = _deployedContract.function('createTest');
    _deleteTest = _deployedContract.function('deleteTest');
    _tests = _deployedContract.function('tests');
    _testsCount = _deployedContract.function('testCount');
    await fetchTests();
  }

  Future<void> fetchTests() async {
    List totalTaskList = await _web3client.call(
      contract: _deployedContract,
      function: _testsCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    tests.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3client.call(
          contract: _deployedContract,
          function: _tests,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        tests.add(
          Test(
            id: (temp[0] as BigInt).toInt(),
            title: temp[1],
            description: temp[2],
          ),
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTest(String title, String description)
   async {
    BigInt cId = await _web3client.getChainId();
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _createTest,
          parameters: [title, description],
        ),
        chainId: cId.toInt());
    isLoading = true;
    fetchTests();
  }

  Future<void> deleteTest(int id) async {
    BigInt cId = await _web3client.getChainId();
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _deleteTest,
          parameters: [BigInt.from(id)],
        ),
        chainId: cId.toInt());
    isLoading = true;
    notifyListeners();
    fetchTests();
  }
}
