import 'package:agos/screens/tabs/recommended_tab.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageController = TextEditingController();

  String filter = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(),
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: TextRegular(
                      text: 'Refilling Stations',
                      fontSize: 24,
                      color: primary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 280,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: messageController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                color: primary,
                              ),
                              suffixIcon: filter != ''
                                  ? IconButton(
                                      onPressed: (() {
                                        setState(() {
                                          filter = '';
                                          messageController.clear();
                                        });
                                      }),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: primary,
                                      ),
                                    )
                                  : const SizedBox(),
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(width: 1, color: primary),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(width: 1, color: primary),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              hintText: 'Search a Station',
                              border: InputBorder.none,
                              hintStyle: const TextStyle(
                                fontFamily: 'QRegular',
                              )),
                          onChanged: (value) {
                            setState(() {
                              filter = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.my_library_books_outlined,
                          color: primary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 1,
                    labelStyle: TextStyle(
                      fontFamily: 'QRegular',
                      color: primary,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'QRegular',
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    labelColor: primary,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        text: 'Recommended',
                      ),
                      Tab(
                        text: 'Nearest',
                      ),
                      Tab(
                        text: 'Most rated',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Expanded(
              child: SizedBox(
                child: TabBarView(
                  children: [
                    RecommendedTab(),
                    SizedBox(),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
