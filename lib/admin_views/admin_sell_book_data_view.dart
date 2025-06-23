import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<Map<String, List<QueryDocumentSnapshot>>> fetchAllSchoolSellingRequests() async {
    Map<String, List<QueryDocumentSnapshot>> result = {};
    for (String school in CurrentUserData.schoolList) {
      final snapshot = await FirebaseFirestore.instance
          .collection(sellingRequestTableName)
          .doc(school)
          .collection("books")
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Sort each school's data by dateTime
        snapshot.docs.sort((a, b) {
          final modelA = BuyingSellingModel.fromMap(a.data());
          final modelB = BuyingSellingModel.fromMap(b.data());
          final dateA = DateTime.tryParse(modelA.dateTime) ?? DateTime(1970);
          final dateB = DateTime.tryParse(modelB.dateTime) ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });

        result[school] = snapshot.docs;
      }
    }
    return result;
  }

  bool _passesFilters(QueryDocumentSnapshot doc) {
    final model = BuyingSellingModel.fromMap(doc.data() as Map<String, dynamic>);
    final date = DateTime.tryParse(model.dateTime);
    if (date == null) return false;

    if (_selectedDate != null &&
        (date.year != _selectedDate!.year ||
            date.month != _selectedDate!.month ||
            date.day != _selectedDate!.day)) {
      return false;
    }

    if (_selectedTime != null &&
        (date.hour != _selectedTime!.hour ||
            date.minute != _selectedTime!.minute)) {
      return false;
    }

    return true;
  }

  Future<pw.Document> generatePdf(List<QueryDocumentSnapshot> docs) async {
    final pdf = pw.Document();

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
        margin: const pw.EdgeInsets.all(10),
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
        title: CustomText(text: "Sell Book Data", color: blackColor),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.picture_as_pdf),
          //   onPressed: () async {
          //     final dataMap = await fetchAllSchoolSellingRequests();
          //     final allDocs = dataMap.values.expand((docs) => docs).toList();
          //     final filtered = allDocs.where(_passesFilters).toList();
          //     if (filtered.isNotEmpty) {
          //       final pdfDoc = await generatePdf(filtered);
          //       await Printing.layoutPdf(onLayout: (format) => pdfDoc.save());
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No data to export")));
          //     }
          //   },
          // ),
          if (_selectedDate != null || _selectedTime != null)
            IconButton(
              icon: const Icon(Icons.cancel_presentation),
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                  _selectedTime = null;
                });
              },
            ),
        ],
      ),
      body: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
        future: fetchAllSchoolSellingRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final schoolDataMap = snapshot.data ?? {};

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Filters
                  Row(
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
                            setState(() => _selectedDate = picked);
                          }
                        },
                        height: 25,
                        color: blackColor,
                        borderRadius: 5,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomText(text: "Sort by Date", size: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomCard(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedTime = picked);
                          }
                        },
                        height: 25,
                        color: blackColor,
                        borderRadius: 5,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomText(text: "Sort by Time", size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Tables per school
                  for (var entry in schoolDataMap.entries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            CustomText(
                              text: entry.key,
                              fontWeight: FontWeight.bold,
                              size: 18,
                              color: Colors.blueAccent,
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () async {
                                  final filteredDocs = entry.value.where(_passesFilters).toList();
                                  if (filteredDocs.isNotEmpty) {
                                    final pdfDoc = await generatePdf(filteredDocs);
                                    await Printing.layoutPdf(onLayout: (format) => pdfDoc.save());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("No data to export for ${entry.key}")),
                                    );
                                  }
                                },
                                child: Icon(
                                    Icons.picture_as_pdf
                                )
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Table(
                          border: TableBorder.all(color: Colors.black, width: 1.0),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(2),
                            5: FlexColumnWidth(2),
                            6: FlexColumnWidth(2),
                            7: FlexColumnWidth(2),
                            8: FlexColumnWidth(2),
                            9: FlexColumnWidth(2),
                            10: FlexColumnWidth(2),
                            11: FlexColumnWidth(2),
                          },
                          children: [
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
                            for (var doc in entry.value)
                              if (_passesFilters(doc))
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
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
