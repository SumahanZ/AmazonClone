import 'package:amazon_app/common/widgets/custom_button.dart';
import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/core/admin/services/admin_services.dart';
import 'package:amazon_app/core/search/screens/search_screen.dart';
import 'package:amazon_app/models/order.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = "/order-details";
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final adminServices = AdminServices();
  int currentStep = 0;
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  //ONLY FOR ADMIN
  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(context: context, status: status + 1, order: widget.order, onSuccess: () {
      setState(() {
        //rebuilds the widget makes our app change
        currentStep += 1;
      });
    }); 
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserNotifier>().user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        onFieldSubmitted: (value) =>
                            navigateToSearchScreen(value),
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.search,
                                      color: Colors.black, size: 23)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1)),
                            hintText: "Search Amazon.in",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17)),
                      )),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("View order details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black12,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Order Date:        ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}"),
                      Text("Order ID:          ${widget.order.id}"),
                      Text("Order Total:     \$${widget.order.totalPrice}"),
                    ],
                  )),
              const SizedBox(height: 10),
              const Text("Purchase Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black12,
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Row(
                        children: [
                          Image.network(
                            widget.order.products[i].imagesUrl[0],
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(widget.order.products[i].name,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                  'Qty: ${widget.order.quantity[i].toString()}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text("Tracking",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black12,
                )),
                child: Stepper(
                  currentStep: currentStep,
                  controlsBuilder: (context, details) {
                    if(user.type == "admin") {
                      return CustomButton(text: "Done", onTap: () {
                          changeOrderStatus(details.currentStep);
                      });
                    }
                    return const SizedBox();
                  },
                  steps: [
                    Step(
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: currentStep > 0,
                        title: const Text("Pending"),
                        content:
                            const Text("Your order is yet to be delivered")),
                    Step(
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: currentStep > 1,
                        title: const Text("Completed"),
                        content: const Text(
                            "Your order has been delivered, you are yet to sign.")),
                    Step(
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: currentStep > 2,
                        title: const Text("Received"),
                        content: const Text(
                            "Your order has been delivered and signed by you")),
                    Step(
                        state: currentStep >= 3
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: currentStep >= 3,
                        title: const Text("Delivered"),
                        content: const Text(
                            "Your order has been delivered and signed by you!")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
