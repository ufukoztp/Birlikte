import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/repo/remote_repo.dart';
import 'package:flutter/cupertino.dart';

class NameTakepProvider with ChangeNotifier{


  late SIGNTYPE _signType ;

  SIGNTYPE get signType => _signType;

  set signType(SIGNTYPE value) {
    _signType = value;
    notifyListeners();
  }

  late BuildContext _context;

  BuildContext get context => _context;

  late bool _nameState=false;


  bool get nameState => _nameState;

  set nameState(bool value) {
    _nameState = value;
    notifyListeners();
  }

  set context(BuildContext value) {
    _context = value;
  }

  late String _name;
  bool _nameIsLoading=false;

  bool get nameIsLoading => _nameIsLoading;

  set nameIsLoading(bool value) {
    _nameIsLoading = value;
    notifyListeners();
  }

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  Remote_Repo _remote_repo =Remote_Repo();

  Future getUserName(uid)async{


      name = (await _remote_repo.getUserName(uid).then((value) {
        nameIsLoading=true;

        if(signType==SIGNTYPE.GOOGLE){
          Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
        }else{
          if(value!=null){
            nameState=true;
            Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
          }else{
            print("geldi");
            nameState=true;
          }
        }


      }))!;




  }

  Future setUserName(uid)async{
    await _remote_repo.setUserName(uid,name).then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    });
    notifyListeners();
  }

}