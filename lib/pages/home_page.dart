import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bot/pages/explore_page.dart';
import 'package:bot/pages/new_chat_page.dart';
import 'package:bot/theme.dart';
import 'package:bot/widgets/bottom_bar.dart';
import 'package:bot/widgets/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // The background image with fade effect
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_page_bg2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            // The rest of the content (UI) is not affected by the fade effect
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "Samvaad",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 14),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  // Wrap the animated text inside a SizedBox to fix the space it occupies
                  SizedBox(
                    height: 120, // Fixed height to prevent fluctuation
                    child: AnimatedTextKit(
                      repeatForever: false,
                      animatedTexts: [
                        for (var word in ['How may I help you today?'])
                          TypewriterAnimatedText(
                            word,
                            cursor: '?',
                            speed: Duration(milliseconds: 90),
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.08, // Scales with screen width
                                ),
                          )
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ChatPage()));
                          },
                          child: HomeCard(
                            text: "Start a Samvaad",
                            icon: Icons.chat_rounded,
                            color: Color(0xFF38EF7D),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Add spacing
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ExplorePage()));
                          },
                          child: HomeCard(
                            text: "Explore with Samvaad",
                            icon: Icons.map,
                            color: Color(0xFFD1A1E0),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingChatBox(
      //   onTap: () {
      //     Navigator.push(
      //         context, CupertinoPageRoute(builder: (context) => ChatPage()));
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
