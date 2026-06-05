import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({super.key, required this.paymentUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) async {
            setState(() => _isLoading = false);

            try {
              // 1. Get the raw text from the page body
              var rawHtml = await controller.runJavaScriptReturningResult(
                  "document.body.innerText");

              // 2. Clean the string (Android/iOS often return wrapped quotes like ""{...}"")
              String cleanJson = rawHtml.toString();
              if (cleanJson.startsWith('"') && cleanJson.endsWith('"')) {
                cleanJson = cleanJson.substring(1, cleanJson.length - 1);
              }
              // Unescape quotes if necessary
              cleanJson = cleanJson.replaceAll('\\"', '"');

              debugPrint("Cleaned JSON: $cleanJson");

              // 3. Check if this is the intermediate redirect JSON
              if (cleanJson.contains("redirectUrl")) {
                final decoded = jsonDecode(cleanJson);
                String redirectUrl = decoded["redirectUrl"];
                controller.loadRequest(Uri.parse(redirectUrl));
              }

              // 4. Check if this is the final success JSON (from your screenshot)
              else if (cleanJson.contains("Fee collected successfully")) {
                final decoded = jsonDecode(cleanJson);
                String message = decoded["message"] ?? "Payment Successful";

                // Return the message back to _handleSave
                if (mounted) {
                  Navigator.pop(context, message);
                }
              }
            } catch (e) {
              debugPrint("Error parsing WebView content: $e");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}