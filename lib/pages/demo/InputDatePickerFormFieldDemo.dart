import 'package:flutter/material.dart';

class InputDatePickerFormFieldDemo extends StatefulWidget {

  const InputDatePickerFormFieldDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _InputDatePickerFormFieldDemoState createState() => _InputDatePickerFormFieldDemoState();
}

class _InputDatePickerFormFieldDemoState extends State<InputDatePickerFormFieldDemo> {

  DateTime firstDate = DateTime(2019);
  DateTime lastDate = DateTime(2030, 12, 12);
  DateTime selectedDate = DateTime.now().add(Duration(hours: 0, minutes: 0, seconds: 0));

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: buildBody()
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      slivers: [
        Container(
          height: 300,
          child: ListView(
            children: <Widget>[
              InputDatePickerFormField(
                firstDate: firstDate,
                lastDate: lastDate,
                initialDate: selectedDate,
                onDateSubmitted: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ],
          ),
        )
      ].map((e) => SliverToBoxAdapter(child: e,)).toList(),
    );
  }

}