import 'package:flutter/material.dart';

import 'file:///D:/wac/wac/lib/model/contact.dart';

import 'database_helper.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;

  const ContactDetails({Key key, this.contact}) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState(contact);
}

class _ContactDetailsState extends State<ContactDetails> {
  final Contact contact;
  Company company;
  Address address;
  Geo geo;

  DatabaseHelper dbHelper;

  _ContactDetailsState(this.contact);

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<dynamic> list =
          await dbHelper.getRows(dbHelper.tableCompany, contact.id);
      company = Company.fromJson(list[0]);
      list = await dbHelper.getRows(dbHelper.tableAddress, contact.id);
      address = Address.fromJson(list[0]);
      list = await dbHelper.getRows(dbHelper.tableGeo, contact.id);
      geo = Geo.fromJson(list[0]);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contacts'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        children: [

          CircleAvatar(
            radius: 50,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              child:contact.profileImage == null?
              Image.asset('assets/ic_user.png',height: 100,width: 100,):
              Image.network(contact.profileImage,height: 100,width: 100,),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
              '${contact.name}',textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          Divider(
            height: 28,
          ),
          Text(
            'Email: ${contact.email}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Phone: ${contact.phone ?? ''}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Username: ${contact.username}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Website: ${contact.website ?? ''}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          address == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Address',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Suite: ${address.suite ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Street: ${address.street}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'City: ${address.city}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Zipcode: ${address.zipcode}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ]),
          company == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Company',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${company.name}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${company.catchPhrase}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${company.bs}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
          geo == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${geo.lat}${geo.lng}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ]),
        ],
      ),
    );
  }
}
