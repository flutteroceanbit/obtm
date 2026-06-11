import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateMarkSheet(MarkSheetData data) async {
  final pdf = pw.Document();
  final bgImage = pw.MemoryImage(
    (await rootBundle.load(
      'assets/images/Letterpad.jpeg',
    )).buffer.asUint8List(),
  );
  pw.EdgeInsetsGeometry tablePadding() {
    return pw.EdgeInsets.symmetric(vertical: 2, horizontal: 5);
  }

  pdf.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        margin: pw.EdgeInsets.zero,
        buildBackground: data.isBackground
            ? (context) => pw.Positioned.fill(
                child: pw.Image(bgImage, fit: pw.BoxFit.cover),
              )
            : null,
      ),
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 70, vertical: 100),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.SizedBox(height: 30),
              pw.Text(
                "Reference Number : ${data.reference}",
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "Internship Completion Certificate",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.RichText(
                textAlign: pw.TextAlign.justify,
                text: pw.TextSpan(
                  style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                  children: [
                    pw.TextSpan(
                      text:
                          "\t\t\t\t\t\t\t\t\t\t\t\tThis is to certify that ${data.gender}. ",
                    ),
                    pw.TextSpan(
                      text: data.name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: " D/o Mr. "),
                    pw.TextSpan(
                      text: data.fatherName,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(
                      text:
                          " has successfully completed the internship training course with a grade '",
                    ),
                    pw.TextSpan(
                      text: data.grade,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: "' and marks "),
                    pw.TextSpan(
                      text: data.marks,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: " out of 50 (SEE) for "),
                    pw.TextSpan(
                      text: data.technology,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: ", conducted by "),
                    pw.TextSpan(
                      text: "Oceanbit Solution Pvt.Ltd.",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: ". facilitated by "),
                    pw.TextSpan(
                      text: data.universityName,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: ", Surat from "),
                    pw.TextSpan(
                      text: "${data.startDate} to ${data.endDate}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(
                      text:
                          " at Oceanbit Solution Pvt.Ltd., Dabholi Gam, Surat.",
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Certified by:", style: pw.TextStyle(fontSize: 11)),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Oceanbit Solution Pvt.Ltd. (CIN : U72900GJ2021PTC126155)",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 100),
                  pw.Text(
                    "Director",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Grading for performance are as follows:",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(),

                    tableWidth: pw.TableWidth.min,
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text(
                              "Letter Grade",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text(
                              "Marks (In %)",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Row 1
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: tablePadding(),

                            child: pw.Text("O (Outstanding)"),
                          ),
                          pw.Padding(
                            padding: tablePadding(),

                            child: pw.Text("97.00 - 100"),
                          ),
                        ],
                      ),

                      /// Row 2
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text("E (Excellent)"),
                          ),
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text("87.00 - 96.99"),
                          ),
                        ],
                      ),

                      /// Row 3
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text("A+ (Very Good)"),
                          ),
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text("77.00 - 86.99"),
                          ),
                        ],
                      ),

                      /// Row 4
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text("B (Good)"),
                          ),
                          pw.Padding(
                            padding: tablePadding(),
                            child: pw.Text("67.00 - 76.99"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "* SEE: Semester End Evaluation",
                    style: pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}

class MarkSheetData {
  String name;
  String fatherName;
  String marks;
  String technology;
  String universityName;
  String startDate;
  String endDate;
  String grade;
  String gender;
  String reference;
  bool isBackground;

  MarkSheetData(
    this.name,
    this.fatherName,
    this.marks,
    this.technology,
    this.universityName,
    this.startDate,
    this.endDate,
    this.grade,
    this.gender,
    this.reference,
    this.isBackground,
  );
}

typedef LayoutCallbackWithMarkSheetData =
    Future<Uint8List> Function(MarkSheetData data);

class MarkSheetExample {
  const MarkSheetExample(
    this.name,
    this.file,
    this.builder, [
    this.needsData = false,
  ]);

  final String name;
  final String file;
  final LayoutCallbackWithMarkSheetData builder;
  final bool needsData;
}
