import 'package:flutter/material.dart';

class AutofillGroupDemo extends StatefulWidget {

  AutofillGroupDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AutofillGroupDemoState createState() => _AutofillGroupDemoState();
}

class _AutofillGroupDemoState extends State<AutofillGroupDemo> {

  bool isSameAddress = true;
  final shippingAddress1 = TextEditingController();
  final shippingAddress2 = TextEditingController();
  final billingAddress1 = TextEditingController();
  final billingAddress2 = TextEditingController();

  final creditCardNumber = TextEditingController();
  final creditCardSecurityCode = TextEditingController();

  final phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: buildListView(),
    );
  }


  @override
  Widget buildListView() {
    return ListView(
      children: <Widget>[
        const Text('Shipping address'),
        // The address fields are grouped together as some platforms are
        // capable of autofilling all of these fields in one go.
        AutofillGroup(
          child: Column(
            children: <Widget>[
              TextField(
                controller: shippingAddress1,
                autofillHints: const <String>[AutofillHints.streetAddressLine1],
              ),
              TextField(
                controller: shippingAddress2,
                autofillHints: const <String>[AutofillHints.streetAddressLine2],
              ),
            ],
          ),
        ),
        const Text('Billing address'),
        Checkbox(
          value: isSameAddress,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              setState(() {
                isSameAddress = newValue;
              });
            }
          },
        ),
        // Again the address fields are grouped together for the same reason.
        if (!isSameAddress)
          AutofillGroup(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: billingAddress1,
                  autofillHints: const <String>[
                    AutofillHints.streetAddressLine1,
                  ],
                ),
                TextField(
                  controller: billingAddress2,
                  autofillHints: const <String>[
                    AutofillHints.streetAddressLine2,
                  ],
                ),
              ],
            ),
          ),
        const Text('Credit Card Information'),
        // The credit card number and the security code are grouped together
        // as some platforms are capable of autofilling both fields.
        AutofillGroup(
          child: Column(
            children: <Widget>[
              TextField(
                controller: creditCardNumber,
                autofillHints: const <String>[AutofillHints.creditCardNumber],
              ),
              TextField(
                controller: creditCardSecurityCode,
                autofillHints: const <String>[
                  AutofillHints.creditCardSecurityCode,
                ],
              ),
            ],
          ),
        ),
        const Text('Contact Phone Number'),
        // The phone number field can still be autofilled despite lacking an
        // `AutofillScope`.
        TextField(
          controller: phoneNumber,
          autofillHints: const <String>[AutofillHints.telephoneNumber],
        ),
      ],
    );
  }


}