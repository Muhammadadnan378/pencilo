import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/consts/colors.dart';
import '../data/custom_widget/custom_card.dart';
import '../data/custom_widget/custom_text_widget.dart';
import '../db_helper/model_name.dart';
import '../model/buying_selling_model.dart';

class AdminSellBookDataView extends StatefulWidget {
  const AdminSellBookDataView({super.key});

  @override
  State<AdminSellBookDataView> createState() => _AdminSellBookDataViewState();
}

class _AdminSellBookDataViewState extends State<AdminSellBookDataView> {

  List<QueryDocumentSnapshot>? _docs;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<QueryDocumentSnapshot>? _filteredDocs;


  Future<pw.Document> generatePdf(List<QueryDocumentSnapshot> docs) async {
    final pdf = pw.Document();

    // Table headers
    final headers = [
      'Buyer Name',
      'Buyer Contact',
      'Buyer Address',
      'Book Name',
      'Amount',
      'Seller Name',
      'Seller Contact',
      'Seller Address',
      'Book Name',
      'Date',
      'Time',
    ];

    // Table rows
    final dataRows = docs.map((doc) {
      final model = BuyingSellingModel.fromMap(doc.data() as Map<String, dynamic>);
      return [
        model.buyerUserName,
        model.buyerUserContact,
        model.buyerCurrentLocation,
        model.bookName,
        model.buyerUserAmount,
        model.sellerUserName,
        model.sellerUserContact,
        model.sellerCurrentLocation,
        model.bookName,
        formatOnlyDate(model.dateTime),
        formatOnlyTime(model.dateTime),
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(10), // tighter margins
        build: (context) => [
          pw.Text("Buy/Sell Report", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: dataRows,
            cellStyle: const pw.TextStyle(fontSize: 8),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(2),
              7: const pw.FlexColumnWidth(3),
              8: const pw.FlexColumnWidth(2),
              9: const pw.FlexColumnWidth(1.5),
              10: const pw.FlexColumnWidth(1.5),
            },
          ),
        ],
      ),
    );


    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: CustomText(text: "Sell Book Data",color: blackColor,),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              if (_filteredDocs != null) {
                final pdfDoc = await generatePdf(_filteredDocs!);
                await Printing.layoutPdf(onLayout: (format) => pdfDoc.save());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No data to export")),
                );
              }
            },
          ),
          if(_selectedDate != null || _selectedTime != null)
            IconButton(
              icon: Icon(Icons.cancel_presentation),
              onPressed: () async {
                _selectedDate = null;
                _selectedTime = null;
                _filteredDocs = _docs;
                setState(() {

                });
              },
            ),
        ]
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(sellingRequestTableName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          _docs = snapshot.data!.docs;

          // Sort the list by parsed DateTime
          _docs!.sort((a, b) {
            final modelA = BuyingSellingModel.fromMap(a.data() as Map<String, dynamic>);
            final modelB = BuyingSellingModel.fromMap(b.data() as Map<String, dynamic>);

            final dateA = DateTime.tryParse(modelA.dateTime) ?? DateTime(1970);
            final dateB = DateTime.tryParse(modelB.dateTime) ?? DateTime(1970);

            return dateB.compareTo(dateA); // For newest first. Use dateA.compareTo(dateB) for oldest first
          });

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomCard(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                            _filteredDocs = _docs?.where((doc) {
                              final model = BuyingSellingModel.fromMap(doc.data() as Map<String, dynamic>);
                              final date = DateTime.tryParse(model.dateTime);
                              return date != null &&
                                  date.year == picked.year &&
                                  date.month == picked.month &&
                                  date.day == picked.day;
                            }).toList();
                          });
                        }
                      },

                      height: 25,
                      color: blackColor,
                      borderRadius: 5,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: CustomText(text: "Sort by Date",size: 16,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(width: 10,),
                    CustomCard(
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked != null) {
                          setState(() {
                            _selectedTime = picked;
                            _filteredDocs = _docs?.where((doc) {
                              final model = BuyingSellingModel.fromMap(doc.data() as Map<String, dynamic>);
                              final date = DateTime.tryParse(model.dateTime);
                              return date != null &&
                                  date.hour == picked.hour &&
                                  date.minute == picked.minute;
                            }).toList();
                          });
                        }
                      },

                      height: 25,
                      color: blackColor,
                      borderRadius: 5,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: CustomText(text: "Sort by Time",size: 16,),
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(height: 10,),
                Table(
                  border: TableBorder.all(color: Colors.black, width: 1.0),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(3),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      children: [
                        tableHeader('Buyer Name'),
                        tableHeader('Buyer Contact'),
                        tableHeader('Buyer Address'),
                        tableHeader('Book Name'),
                        tableHeader('Amount'),
                        tableHeader('Seller Name'),
                        tableHeader('Seller Contact'),
                        tableHeader('Seller Address'),
                        tableHeader('Book Name'),
                        tableHeader('Amount'),
                        tableHeader('Date'),
                        tableHeader('Time'),
                      ],
                    ),

                    // Data Rows
                    for (var doc in (_filteredDocs ?? _docs)!)
                          () {
                        final model = BuyingSellingModel.fromMap(doc.data() as Map<String, dynamic>);
                        return TableRow(
                          children: [
                            tableCell(model.buyerUserName),
                            tableCell(model.buyerUserContact),
                            tableCell(model.buyerCurrentLocation),
                            tableCell(model.bookName),
                            tableCell(model.buyerUserAmount),
                            tableCell(model.sellerUserName),
                            tableCell(model.sellerUserContact),
                            tableCell(model.sellerCurrentLocation),
                            tableCell(model.bookName),
                            tableCell(model.sellerUserAmount),
                            tableCell(formatOnlyDate(model.dateTime)),
                            tableCell(formatOnlyTime(model.dateTime)),
                          ],
                        );
                      }(),
                  ],
                ),

                const SizedBox(height: 20),

                // You can add another table or section here to show additional data like amount, payment method, dateTime etc.
              ],
            ),
          );
        },
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0,bottom: 4,left: 3,right: 3),
      child: CustomText(
        text: text,
        fontWeight: FontWeight.bold,
        size: 13,
        maxLines: 1,
        color: bgColor,
      ),
    );
  }

  Widget tableCell(String? text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomText(
        text: text ?? '',
        color: Colors.black,
        maxLines: 1,
      ),
    );
  }

  String formatOnlyDate(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String formatOnlyTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
