import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'file:///D:/wac/wac/lib/model/contact.dart';

import 'contact_details_page.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper dbHelper;
  List<Contact> contactList = List();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      dbHelper = DatabaseHelper.instance;
      List list = await dbHelper.getAllRows(dbHelper.tableContact);

      if (list.length == 0) {
        bool b = await getContacts();
        if (b) {
          List list = await dbHelper.getAllRows(dbHelper.tableContact);
          list.forEach((v) {
            contactList.add(Contact.fromJson(v));
          });
          setState(() {});
        }
      } else {
        contactList.clear();
        list.forEach((v) {
          contactList.add(Contact.fromJson(v));
        });
        debugPrint("len:${contactList.length}");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contacts"),
      ),
      body: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            Contact contact = contactList[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: contact.profileImage == null
                    ? AssetImage('assets/ic_user.png')
                    : NetworkImage(contact.profileImage),
              ),
              title: Text('${contact.name}'),
              subtitle: FutureBuilder<String>(
                future: companyName(contact.id), // async work
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('');
                    default:
                      if (snapshot.hasError)
                        return Text('');
                      else
                        return Text('${snapshot.data}');
                  }
                },
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContactDetails(contact: contact)));
              },
            );
          }),
    );
  }

  Future<String> companyName(int id) async {
    String s = await dbHelper.getCompanyName(id) ?? '';
    return s;
  }

  Future<bool> getContacts() async {
    String url = "http://www.mocky.io/v2/5d565297300000680030a986";

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      debugPrint(response.body);

      List<dynamic> list = jsonDecode(response.body);

      dbHelper.getAllRows(dbHelper.tableContact);
      dbHelper.getAllRows(dbHelper.tableCompany);
      dbHelper.getAllRows(dbHelper.tableAddress);
      dbHelper.getAllRows(dbHelper.tableGeo);
      list.forEach((element) {
        Contact contact = Contact.fromJson(element);

        dbHelper.insert(dbHelper.tableContact, contact.toJson());

        if (contact.company != null)
          dbHelper.insert(
              dbHelper.tableCompany, contact.company.toJson(contact.id));
        if (contact.address != null) {
          dbHelper.insert(
              dbHelper.tableAddress, contact.address.toJson(contact.id));
          if (contact.address.geo != null)
            dbHelper.insert(
                dbHelper.tableGeo, contact.address.geo.toJson(contact.id));
        }
      });
      return true;
    } else {
      return false;
    }
  }
}
