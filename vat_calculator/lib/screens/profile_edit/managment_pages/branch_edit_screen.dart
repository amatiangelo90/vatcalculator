import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditBranchScreen extends StatefulWidget {
  const EditBranchScreen({Key key, this.pkBranchId}) : super(key: key);

  final int pkBranchId;
  @override
  _EditBranchScreenState createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
