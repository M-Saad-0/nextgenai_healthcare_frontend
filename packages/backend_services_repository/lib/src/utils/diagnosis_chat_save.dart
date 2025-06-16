import 'package:backend_services_repository/backend_service_repositoy.dart';

class DiagnosisChatSave{
  List<String> getSymtomsData(){
    Box box = Hive.box('settings');
    List<String> diagnosisChat = box.get("diagnosisChat")??[];
    return diagnosisChat.reversed.toList();
  }
  void saveSymptomsData(String symptoms){
    Box box = Hive.box('settings');
    List<String> diagnosisChat = box.get("diagnosisChat")??[];
    if(diagnosisChat.length>50){
      diagnosisChat = diagnosisChat.skip(20).toList();
    }
    diagnosisChat.add(symptoms);
    box.put('diagnosisChat', diagnosisChat);
  }
}