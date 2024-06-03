import 'package:arspace/util/all_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../backend/helper/app_router.dart';
import '../backend/models/tickets_model.dart';
import '../backend/parser/view_ticket_parser.dart';

class ViewTicketController extends GetxController{

  final ViewTicketParser parser;
  TicketsModel ticketResponse = TicketsModel();


  ViewTicketController({required this.parser});


  bool isTicketPurchased = false;
  bool isTicketLoading = false;


  Future<void> getTickets() async {

    Response response = await parser.getTickes();

    print("ticketResponse body--->${response.body}");
    print("ticketResponse body string--->${response.body.toString()}");

    if (response.statusCode == 200) {
      isTicketLoading = false;

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      ticketResponse = TicketsModel.fromJson(myMap);

      print("ticketResponse ---->${ticketResponse.toString()}");

      update();
    }
    else if (response.statusCode == 401) {
      isTicketLoading = false;
      parser.ClearPrafrence();
      Get.toNamed(AppRouter.getLoginRoute(), preventDuplicates: false);

      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      if (myMap['auth'] == false) {
        showToast(myMap['error']);
      } else {
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Token Expire');
        }
      }
      update();
    }
    else {
      isTicketLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }
}

