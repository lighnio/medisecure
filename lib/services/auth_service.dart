import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class AuthServices {
  
  final String _rpcUrl =  'http://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545';
  bool isLoading = true;

  final String _privatekey =
      '0x1537579196f7a700fb7433f151478caeee854d2eef270ef51d6524ca2f32a195';
  late Web3Client _web3client;

  AuthServices() {
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
        await rootBundle.loadString('build/contracts/UserContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'UserContract');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _registerUser;
  late ContractFunction _loginUser;
  late ContractFunction _checkLogged;
  late ContractFunction _logoutUser;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _registerUser = _deployedContract.function("registerUser");
    _loginUser = _deployedContract.function("loginUser");
    _checkLogged = _deployedContract.function("checkLogged");
    _logoutUser = _deployedContract.function("logoutUser");
  }

  // HERE START FUNCTIONS

  Future registerUser(
      String email, String username, String password, String role) async {
    BigInt cId = await _web3client.getChainId();
    var temp = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _registerUser,
          parameters: [email, username, password, role],
        ),
        chainId: cId.toInt());

    return temp.isNotEmpty;
  }

  Future loginUser(String email, String password) async {
    var temp = await _web3client
        .call(
            contract: _deployedContract,
            function: _loginUser,
            params: [email, password]);

    return temp[0];
  }
}
