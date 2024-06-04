
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:zigzagbus/helper/makepdf.dart';

class PdfViewer extends StatelessWidget {
  final tickethistory;
  final currency;
  final netImage;

  const PdfViewer({super.key, this.tickethistory, this.currency, this.netImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(currency: currency,tickethistory: tickethistory, netImage: netImage),
      ),
    );
  }
}