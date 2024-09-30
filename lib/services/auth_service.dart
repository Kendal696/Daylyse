import 'package:daylyse/interfaces/auth_interface.dart';
import 'package:daylyse/interfaces/response_interface.dart';
import 'package:daylyse/models/user_model.dart';

class AuthService {
  late AuthInterface auth;

  AuthService({required this.auth});

  Future<Response<UserModel>> createAccount(String name, String email, String password)async{
    try {
      final user = await auth.createAccount(name, email, password);
      return Response(data: UserModel.fromJson(user!));
    } catch (e) {
        return Response(errorMessage: e.toString());
    }
  }
  
  Future<Response<UserModel>> signIn(String email, String password)async{
    try {
      final user = await auth.signIn(email, password);
      return Response(data: UserModel.fromJson(user!));
    } catch (e) {
        return Response(errorMessage: e.toString());
    }
  }
}