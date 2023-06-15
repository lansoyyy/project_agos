import 'package:agos/widgets/appbar_widget.dart';
import 'package:agos/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../widgets/text_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final messageController = TextEditingController();

  String filter = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('MESSAGES'),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 275,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            child: TextFormField(
              style: const TextStyle(
                fontFamily: 'QBold',
                color: primary,
              ),
              textCapitalization: TextCapitalization.words,
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
                    borderSide: const BorderSide(width: 1, color: primary),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: primary),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: 'Search Messages',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    fontFamily: 'QRegular',
                    color: primary,
                    fontSize: 12,
                  )),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SizedBox(
              child: ListView.separated(
                itemCount: 50,
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: primary,
                  );
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/station.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            color: primary,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextBold(
                                    text: 'Name of the Station',
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: TextRegular(
                                      text: 'Latest message here',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 25,
                                    width: MediaQuery.of(context).size.width /
                                        1.55,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextBold(
                                          text: '3 minutes ago',
                                          fontSize: 16,
                                          color: primary,
                                        ),
                                        const Expanded(
                                          child: SizedBox(
                                            width: 30,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.delete,
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
