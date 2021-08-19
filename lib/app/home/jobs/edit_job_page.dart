import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_code_with_andrea/app/home/models/job.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_exception_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job}) : super(key: key);

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job:  job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _ratePerHourController = TextEditingController();

  final FocusNode _jobFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  bool _isLoading = false;

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.job != null){
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }
  void _jobEditingComplete() {
    final newFocus = _formKey.currentState.validate()
        ? _ratePerHourFocusNode
        : _jobFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    // TODO: Validate & saveForm
    // TODO: submit data to Firestore

    setState(() {
      _isLoading = true;
    });
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null){
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose a different job name',
              defaultActionText: 'OK');
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null?'New Job': 'Edit Job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        focusNode: _jobFocusNode,
        initialValue: _name,
        //controller: _jobController,
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        onEditingComplete: _jobEditingComplete,
        enabled: _isLoading == false,
      ),
      TextFormField(
        initialValue: _ratePerHour!= null ?'$_ratePerHour' :null,
       // controller: _ratePerHourController,
        focusNode: _ratePerHourFocusNode,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        enabled: _isLoading == false,
      ),
    ];
  }
}
