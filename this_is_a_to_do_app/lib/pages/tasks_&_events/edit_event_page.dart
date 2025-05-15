import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../assets/colors.dart';
import '../../model/events/event.dart';
import '../../helper/utils.dart';
import '../../model/events/event_provider.dart';

class EditEventPage extends StatefulWidget {
  final Event? event;
  const EditEventPage({super.key, this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(Duration(minutes: 60));
    }
    else {
      final event = widget.event!;
      titleController.text = event.title;
      startDate = event.startDate;
      endDate = event.endDate;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // *-----*  MAIN CONTENT *--------------------------------------------------*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: CloseButton(color: Colors.white),
        actions: buildEditingActions(),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(titleController),
              SizedBox(height: 12),
              buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }
  // *------------------------------------------------------ end of MAIN -----*


  Widget buildTitle(dynamic titleController) => TextFormField(
    style: TextStyle(color: AppColors.white, fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: "Add Title",
      hintStyle: TextStyle(color: Colors.white60),
    ),
    onFieldSubmitted: (_) => saveForm(),
    validator:
        (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
    controller: titleController,
  );

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.secondaryBackground,
        shadowColor: AppColors.transparent,
      ),
      icon: Icon(Icons.done),
      label: Text("Save"),
      onPressed: saveForm,
    ),
  ];

  Widget buildDateTimePickers() => Column(
      children: [
        buildFrom(),
        buildTo()]
  );

  Widget buildFrom() => buildHeader(
    header: 'FROM',
    child: Row(
      children: [
        // * Start Date
        Expanded(
          flex: 1, // menu size
          child: buildDropdownField(
            text: Utils.toDate(startDate),
            onClicked: () => pickFromDateTime(pickDate: true),
          ),
        ),
        // * Start Time
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(startDate),
            onClicked: () => pickFromDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );

  Widget buildTo() => buildHeader(
    header: 'TO',
    child: Row(
      children: [
        // * End Date
        Expanded(
          flex: 1, // menu size
          child: buildDropdownField(
            text: Utils.toDate(endDate),
            onClicked: () => pickToDateTime(pickDate: true),
          ),
        ),
        // * End Time
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(endDate),
            onClicked: () => pickToDateTime(pickDate: false),
          ),
        ),
      ],
    ),
  );

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) => ListTile(
    title: Text(text, style: TextStyle(color: AppColors.white)),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({required String header, required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        header,
        style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold),
      ),
      child,
    ],
  );

  Future pickFromDateTime({required bool pickDate}) async {
    // this line prevents user to select a start date before today
    //final date = await pickDateTime(startDate, pickDate: pickDate, firstDate: pickDate ? startDate : null);

    final date = await pickDateTime(startDate, pickDate: pickDate);

    if (date == null) return;

    if (date.isAfter(endDate)) {
      endDate = DateTime(
        date.year,
        date.month,
        date.day,
        endDate.hour,
        endDate.minute,
      );
    }
    setState(() => startDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    // Waits for user to pick a date
    final date = await pickDateTime(endDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isBefore(startDate)) {
      startDate = DateTime(
        date.year,
        date.month,
        date.day,
        startDate.hour,
        startDate.minute,
      );
    }
    setState(() => endDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    // "if date was selected..."
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime(2000, 12),
        lastDate: DateTime(2100),
      );

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    }
    // "if time was selected..."
    else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final provider = Provider.of<EventProvider>(context, listen: false);
      final isEditing = widget.event != null;
      var timestamp = DateTime.now().millisecondsSinceEpoch;

      final event = Event(
        id: isEditing ? widget.event!.id : "event$timestamp",
        title: titleController.text,
        startDate: startDate,
        endDate: endDate,
      );

      if (isEditing) {
        provider.editEvent(event, widget.event!);
      } else {
        provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }

  // *--------------------------------------------------- end of WIDGETS -----*
}
