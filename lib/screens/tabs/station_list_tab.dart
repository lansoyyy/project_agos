import 'package:agos/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class StationList extends StatelessWidget {
  const StationList({super.key});

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
                    width: 120,
                    height: 175,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/station.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      color: primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            Icon(
                              Icons.star_half,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextBold(
                          text: '4.5',
                          fontSize: 15,
                          color: primary,
                        ),
                      ],
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
                        SizedBox(
                          width: 180,
                          child: TextRegular(
                            text: 'Open from: 8am - 7pm',
                            fontSize: 14,
                            color: primary,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextRegular(
                          text: '₱12.00/gallon',
                          fontSize: 15,
                          color: primary,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextBold(
                          text: '2.5km away',
                          fontSize: 16,
                          color: primary,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
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
