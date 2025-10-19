import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class UserPoolAuthService {
  late CognitoUserPool _userPool;
  CognitoUser? _cognitoUser;
  
  UserPoolAuthService(String userPoolId, String clientId) {
    _userPool = CognitoUserPool(userPoolId, clientId);
  }
  
  Future<CognitoUser?> getCurrentUser() async {
    _cognitoUser ?? {
      _cognitoUser = await _userPool.getCurrentUser()
    };
    return _cognitoUser;
  }
  
  Future<bool> reauthenticateUser(String password) async {
    final user = await getCurrentUser();
    if (user == null) return false;
    
    try {
      final authDetails = AuthenticationDetails(
        username: user.username,
        password: password,
      );
      
      final session = await user.authenticateUser(authDetails);
      return session!.isValid();
    } catch (e) {
      print('Reauthentication error: $e');
      return false;
    }
  }
  
  Future<bool> updateUserAttributes(
    Map<String, String> attributes, 
    String password
  ) async {
    // User needs to reauthenticate
    final reauthSuccess = await reauthenticateUser(password);
    if (!reauthSuccess) {
      throw Exception('Reauthentication failed');
    }
    
    final user = await getCurrentUser();
    if (user == null) throw Exception('No user found');
    
    final attributeList = attributes.entries.map((entry) {
      return CognitoUserAttribute(name: entry.key, value: entry.value);
    }).toList();
    
    await user.updateAttributes(attributeList);
    return true;
  }
}