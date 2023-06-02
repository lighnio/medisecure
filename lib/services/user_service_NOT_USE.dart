import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class UserService {
  final String rpcUrl = 'http://127.0.0.1:7545';
  late Web3Client _client;

  final String contractAddress = '0x1f3a857B6380A16a2158f9D04266a3927d361d19';
  late EthereumAddress _contractAddress;
  late DeployedContract _deployedContract;

  final String privateKey =
      '0xd1707e9c95c6915363d8785448ffceb5c6abcc4eb216b1b2b9efa04d0b3588e3';
  late EthPrivateKey _credentials;

  ContractFunction? _registerUserFunction;
  ContractFunction? _getUserFunction;

  UserService() {
    _client = Web3Client(rpcUrl, Client());
    _contractAddress = EthereumAddress.fromHex(contractAddress);
    _deployedContract = DeployedContract(_abiCode(), _contractAddress);
    init();
  }

  Future<void> init() async {
    _credentials = EthPrivateKey.fromHex(privateKey);
    await _getContractFunctions();
  }

  ContractAbi _abiCode() {
    // Define aquí el ABI de tu contrato de usuarios en formato JSON
    final jsonAbi = '''
      [
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "email",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "role",
          "type": "string"
        }
      ],
      "name": "UserRegistered",
      "type": "event"
    },
    {
      "constant": false,
      "inputs": [
        {
          "internalType": "string",
          "name": "_name",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_email",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_password",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_role",
          "type": "string"
        }
      ],
      "name": "registerUser",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        }
      ],
      "name": "getUser",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        },
        {
          "internalType": "string",
          "name": "password",
          "type": "string"
        }
      ],
      "name": "login",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ]
    ''';
    return ContractAbi.fromJson(jsonAbi, 'UserContract');
  }

  Future<void> _getContractFunctions() async {
    _registerUserFunction = _deployedContract.function('registerUser');
    _getUserFunction = _deployedContract.function('getUser');
  }

  Future<void> registerUser(
      String name, String email, String password, String role) async {
    // final credentials = await _client.credentialsFromPrivateKey(privateKey);
    print("$name $email $password $role");
    BigInt cId = await _client.getChainId();
    final credentials = EthPrivateKey.fromHex(privateKey);
    final transaction = Transaction.callContract(
      contract: _deployedContract,
      function: _registerUserFunction!,
      parameters: [
        name,
        email,
        password,
        role,
      ],
    );
    await _client.sendTransaction(credentials, transaction, chainId: cId.toInt());
  }

  Future<Map<String, dynamic>> getUser(String email) async {
    final result = await _client.call(
      contract: _deployedContract,
      function: _getUserFunction!,
      params: [
        email,
      ],
    );
    final userData = result[0].toString(); // Obtén los datos del usuario como desees
    // Parsea los datos y devuelve un mapa con la información del usuario
    print(userData);
    return {
      'name': 'Nombre del usuario',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'role': 'Rol del usuario',
    };
  }
}
