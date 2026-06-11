import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateInternshipOfferLetter(InternshipData data) async {
  final pdf = pw.Document();
  final bgImage = pw.MemoryImage(
    (await rootBundle.load(
      'assets/images/Letterpad.jpeg',
    )).buffer.asUint8List(),
  );
  pdf.addPage(
    pw.Page(
      // pageFormat: PdfPageFormat.a4,
      pageTheme: pw.PageTheme(
        margin: pw.EdgeInsets.zero,
        buildBackground: (context) =>
            pw.Positioned.fill(child: pw.Image(bgImage, fit: pw.BoxFit.cover)),
      ),
      build: (context) {
        return pw.Stack(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 70,
                vertical: 100,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 20),

                  // Heading
                  pw.Center(
                    child: pw.Text(
                      "INTERNSHIP OFFER LETTER",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 30),
                  pw.RichText(
                    textAlign: pw.TextAlign.justify,
                    text: pw.TextSpan(
                      style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                      children: [
                        pw.TextSpan(text: "Dear "),
                        pw.TextSpan(
                          text:
                              "${data.firstName.toUpperCase()} ${data.lastName.toUpperCase()}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),
                  pw.RichText(
                    textAlign: pw.TextAlign.justify,
                    text: pw.TextSpan(
                      style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                      children: [
                        pw.TextSpan(
                          text:
                              "We are pleased to offer you an internship at our company in the ",
                        ),
                        pw.TextSpan(
                          text: "${data.position} Developer",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.TextSpan(text: " at our "),
                        pw.TextSpan(
                          text: "OCEANBIT SOLUTIONS PRIVATE LIMITED",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.TextSpan(
                          text:
                              ". Your internship shall commence. The terms and conditions of your internship with the Company are set forth below:",
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),
                  pw.Text(
                    "1. Subject to your acceptance of the terms and conditions contained herein, your project and responsibilities during the Term will be determined by the supervisor assigned to you for the duration of the internship.",
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "2. Your timings will be from Monday to Saturday. Please be sure to bring documents with you on your first day to complete your profile.",
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "3. You will sign a confidentiality agreement with the company before you commence your internship.",
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                  ),

                  pw.SizedBox(height: 10),
                  pw.Text(
                    "4. The internship cannot be construed as an employment or an offer of employment with OCEANBIT SOLUTIONS PRIVATE LIMITED",
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                  ),

                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Please, confirm your acceptance of the terms of this offer by failing which, we have the right to cancel the internship. We look forward to having you on our team! If you have any questions, please feel free to reach out to us.",
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                  ),
                  pw.SizedBox(height: 40),
                  //
                  // pw.Text(
                  //   "Yours sincerely,",
                  //   style: pw.TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: pw.FontWeight.bold,
                  //   ),
                  // ),
                  pw.SizedBox(height: 150),

                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "For \n\nOCEANBIT SOLUTIONS PRIVATE LIMITED",
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      // pw.SizedBox(height: 20),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Intern",
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 15),

                          pw.Text(
                            "${data.firstName.toUpperCase()} ${data.lastName.toUpperCase()}",
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

class InternshipData {
  String firstName;
  String lastName;
  String position;

  InternshipData(this.firstName, this.lastName, this.position);
}

typedef LayoutCallbackWithData =
    Future<Uint8List> Function(InternshipData data);

class InternshipExample {
  const InternshipExample(
    this.name,
    this.file,
    this.builder, [
    this.needsData = false,
  ]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
