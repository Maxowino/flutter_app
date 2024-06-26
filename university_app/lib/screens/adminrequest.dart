import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRequest extends StatelessWidget {
  
  const DataRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('School Requests',style:TextStyle(color: Colors.white)),
        centerTitle:true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Resource-request').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          List<DataRow> dataRows = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            return DataRow(
              cells: [
                DataCell(Text(data['name'] ?? '')),
                DataCell(Text('${data['form1Textbooks'] ?? ''}')),
                DataCell(Text('${data['form2Textbooks'] ?? ''}')),
                DataCell(Text('${data['form3Textbooks'] ?? ''}')),
                DataCell(Text('${data['form4Textbooks'] ?? ''}')),
              ],
            );
          }).toList();

          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Form 1 Textbooks',style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Form 2 Textbooks',style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Form 3 Textbooks',style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text('Form 4 Textbooks',style: TextStyle(fontWeight: FontWeight.bold),)),
                ],
                rows: dataRows,
              ),
            ),
          );
        },
      ),
    );
  }
}
