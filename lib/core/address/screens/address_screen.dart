import 'package:amazon_app/common/widgets/custom_textfield.dart';
import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/core/address/services/address_service.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address";
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressFormKey = GlobalKey<FormState>();
  final addressService = AddressService();
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  List<PaymentItem> paymentItems = [];

  String addressToBeUsed = "";

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
        amount: widget.totalAmount,
        label: "Total Amount",
        status: PaymentItemStatus.final_price));
  }

  void onGooglePayResult(res) {
    if (context.read<UserNotifier>().user.address.isEmpty) {
      addressService.saveUserAddress(
          context: context, address: addressToBeUsed);
    }

    addressService.orderProduct(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount));
  }

  void onApplePayResult(res) {
    if (context.read<UserNotifier>().user.address.isEmpty) {
      addressService.saveUserAddress(
          context: context, address: addressToBeUsed);
    }

    addressService.orderProduct(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount));
  }

  void payPressed(String addressFromProvider) {
    //reset preexisting values
    addressToBeUsed = "";
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}";
      } else {
        //the payment modal still shown, we dont want that, therefore we need to just throw an exception
        throw Exception("Please enter all the values!");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, "Error");
    }
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserNotifier>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("OR", style: TextStyle(fontSize: 18))
                ]),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              GooglePayButton(
                onPressed: () {
                  payPressed(address);
                },
                width: double.infinity,
                type: GooglePayButtonType.pay,
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString("gpay.json"),
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator:
                    const Center(child: CircularProgressIndicator.adaptive()),
                height: 50,
              ),
              const SizedBox(height: 10),
              ApplePayButton(
                width: double.infinity,
                style: ApplePayButtonStyle.whiteOutline,
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString("applepay.json"),
                onPaymentResult: onApplePayResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                height: 50,
                onPressed: () => payPressed(address),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
