import 'package:agos/screens/merchant/map_page.dart';
import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 125,
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
                    height: 10,
                  ),
                  Center(
                    child: TextBold(
                      text: '3 minutes ago',
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                ],
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
                        Row(
                          children: [
                            TextBold(
                              text: 'Customer Name',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ButtonWidget(
                              radius: 100,
                              width: 65,
                              height: 30,
                              label: 'Done',
                              labelColor: Colors.white,
                              fontSize: 11,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 180,
                          child: TextRegular(
                            text:
                                'Location of the Station Location of the Station',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextRegular(
                          text: 'Total: ₱12.00',
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
                        TextRegular(
                          text: 'Size: Medium',
                          fontSize: 15,
                          color: primary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const MerchantMapScreen()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primary,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.directions_outlined,
                                      color: primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                TextRegular(
                                  text: 'Directions',
                                  fontSize: 12,
                                  color: primary,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          MaterialButton(
                            elevation: 2,
                            minWidth: 60,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            color: primary,
                            onPressed: (() async {}),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
