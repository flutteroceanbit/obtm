import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateCertificate(CertificateData data) async {
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
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                // crossAxisAlignment: pw.CrossAxisAlignment.s,
                // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.SizedBox(height: 60),

                          // Heading
                          pw.Center(
                            child: pw.Text(
                              "TO WHOM IT MAY CONCERN",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                          ),

                          pw.SizedBox(height: 30),

                          // // Body Text
                          // pw.Text(
                          //   "\t\t\t\t\t\t\t\t\t\t\t\tThis Certificate is presented to Ms. CHARMI SIROYA for the experience she gained in our organization. We hereby testify that this employee has worked in our company from 01/05/2025 to 01/11/2025 and has gained experience by working at the position of React JS Developer. During the mentioned tenure of her work here, Charmi Siroya remained involved in her work with determination and sincerity. We found her active and competent in executing all assigned tasks. She is professionally sound, hard working, and a devoted and motivated employee whose dedication in taking initiative and contribution for the realization of organizational goals and objectives has proven helpful in the advancement of our establishment repeatedly.",
                          //   textAlign: pw.TextAlign.justify,
                          //   style: pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
                          // ),
                          pw.RichText(
                            textAlign: pw.TextAlign.justify,
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 11.5,
                                lineSpacing: 3,
                              ),
                              children: [
                                pw.TextSpan(
                                  text:
                                      "\t\t\t\t\t\t\t\t\t\t\t\tThis Certificate is presented to ",
                                ),
                                pw.TextSpan(
                                  text:
                                      "Ms. ${data.firstName.toUpperCase()} ${data.lastName.toUpperCase()}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.TextSpan(
                                  text:
                                      " for the experience she gained in our organization. We hereby testify that this employee has worked in our company from ",
                                ),
                                pw.TextSpan(
                                  text: "${data.startDate} to ${data.endDate}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.TextSpan(
                                  text:
                                      " and has gained experience by working at the position of ",
                                ),
                                pw.TextSpan(
                                  text: "${data.position} Developer",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.TextSpan(
                                  text:
                                      ". During the mentioned tenure of her work here, ",
                                ),
                                pw.TextSpan(
                                  text: "${data.firstName} ${data.lastName}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.TextSpan(
                                  text:
                                      " remained involved in her work with determination and sincerity. We found her active and competent in executing all assigned tasks. She is professionally sound, hard working, and a devoted and motivated employee whose dedication in taking initiative and contribution for the realization of organizational goals and objectives has proven helpful in the advancement of our establishment repeatedly.",
                                ),
                              ],
                            ),
                          ),

                          pw.SizedBox(height: 20),

                          pw.RichText(
                            textAlign: pw.TextAlign.justify,
                            text: pw.TextSpan(
                              style: pw.TextStyle(
                                fontSize: 11.5,
                                lineSpacing: 3,
                              ),
                              children: [
                                pw.TextSpan(
                                  text: "\t\t\t\t\t\t\t\t\t\t\t\tMoreover, ",
                                ),
                                pw.TextSpan(text: "${data.firstName}'s"),
                                pw.TextSpan(
                                  text:
                                      " conduct during her stay with us is exemplary. During her service period, she has been found sincere, dependable, trustworthy, sociable, pleasant, and open to challenges. She has a genial temperament and can efficiently work in and lead a team. Her decision to terminate her services with us is solely her own and we wish her all the best in her future endeavors.",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,

                    children: [
                      pw.Text(
                        "Yours sincerely,",
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 180),

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
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                "Milin Patel",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 15),

                              pw.Text(
                                "Director",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 50),
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

class CertificateData {
  String firstName;
  String lastName;
  String startDate;
  String endDate;
  String position;

  CertificateData(
    this.firstName,
    this.lastName,
    this.startDate,
    this.endDate,
    this.position,
  );
}

typedef LayoutCallbackWithData =
    Future<Uint8List> Function(CertificateData data);

class CertificateExample {
  const CertificateExample(
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
