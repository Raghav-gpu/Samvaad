import 'package:bot/services/chat_web_service.dart';
import 'package:bot/theme.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SourcesSection extends StatefulWidget {
  const SourcesSection({super.key});

  @override
  State<SourcesSection> createState() => _SourcesSectionState();
}

class _SourcesSectionState extends State<SourcesSection> {
  bool isLoading = true;
  bool isFetchingMore = false;
  List searchResults = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();

    // Add listener to the scroll controller for lazy loading
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isFetchingMore) {
        _fetchMoreData();
      }
    });
  }

  Future<void> _fetchInitialData() async {
    ChatWebService().searchResultStream.listen((data) {
      setState(() {
        searchResults = data['data'];
        isLoading = false;
      });
    });
  }

  Future<void> _fetchMoreData() async {
    setState(() {
      isFetchingMore = true;
    });

    // Simulating a network call delay
    await Future.delayed(const Duration(seconds: 2));
    final moreResults = [
      {
        'title': 'New Article 1',
        'url': 'https://example.com/new-article-1',
      },
      {
        'title': 'New Article 2',
        'url': 'https://example.com/new-article-2',
      },
    ];

    setState(() {
      searchResults.addAll(moreResults);
      isFetchingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            const Icon(
              Icons.source_outlined,
              color: Colors.white70,
            ),
            const SizedBox(width: 8),
            const Text(
              "Sources",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        // Skeletonizer with horizontal ListView
        Skeletonizer(
          enabled: isLoading,
          child: SizedBox(
            height: 120, // Fixed height for horizontal scrolling
            child: ListView.builder(
              controller: _scrollController, // Attach ScrollController
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              itemCount: searchResults.length + (isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Display a loading indicator at the end when fetching more
                if (index == searchResults.length) {
                  return Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }

                final result = searchResults[index];
                return Container(
                  width: 200, // Width of each card
                  margin:
                      const EdgeInsets.only(right: 16), // Spacing between cards
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result['url'],
                        style: const TextStyle(
                          color: Colors.pink,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (isFetchingMore)
          const SizedBox(height: 16), // Extra spacing for loader
      ],
    );
  }
}
