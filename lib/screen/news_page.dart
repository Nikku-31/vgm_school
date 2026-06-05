import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../AppManager/ViewModel/NoificationVM/news_view_model.dart';
import '../core/constants/app_colors.dart';
import 'widgets/news_shimmer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch news when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().getAllNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("News",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary
          ),
        ),
      ),
      body: Consumer<NewsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const NewsShimmer();
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          if (viewModel.newsList.isEmpty) {
            return const Center(child: Text("No news available at the moment."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: viewModel.newsList.length,
            itemBuilder: (context, index) {
              final news = viewModel.newsList[index];
              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              news.title,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.new_releases, color: Colors.blueAccent),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        news.description,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy').format(news.date),
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}