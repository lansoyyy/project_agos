import 'package:agos/widgets/appbar_widget.dart';
import 'package:agos/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppbarWidget('RECENT ORDERS'),
      body: ListView.separated(
        itemCount: 50,
        separatorBuilder: (context, index) {
          return const Divider(
            color: primary,
          );
        },
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 150,
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
                              text:
                                  'Location of the Station Location of the Station Location of the Station Location of the Station',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextRegular(
                            text: 'Paid: ₱12.00',
                            fontSize: 15,
                            color: primary,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextRegular(
                            text: 'Quantity: 1pcs',
                            fontSize: 15,
                            color: primary,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 25,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextBold(
                                  text: 'September 01, 2023',
                                  fontSize: 16,
                                  color: primary,
                                ),
                                const SizedBox(
                                  width: 30,
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
    );
  }
}
