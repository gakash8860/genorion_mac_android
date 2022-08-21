// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

void main() => runApp(MaterialApp(
      home: TotalUsageBill(),
    ));

class TotalUsageBill extends StatefulWidget {
  String? totalEnergy;
  String? chooseValueMinute;
  double? totalAmountInRs;
  String? totalDays;
  Map<String, double>? deviceId;

  TotalUsageBill(
      {Key? key,
      this.chooseValueMinute,
      this.deviceId,
      this.totalAmountInRs,
      this.totalDays,
      this.totalEnergy})
      : super(key: key);

  @override
  _TotalUsageBillState createState() => _TotalUsageBillState();
}

class _TotalUsageBillState extends State<TotalUsageBill> {
  Map<String, double> dataMap = {};
  double totalAMount = 0.0;
  @override
  void initState() {
    super.initState();

    setState(() {
      dataMap = widget.deviceId!;

      totalAMount = widget.totalAmountInRs!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 28,
              right: 18,
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                Row(
                  children: [
                    InkWell(
                      child: const Text("Total Usage",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      onTap: () {},
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(360),
                  onTap: () {},
                  child: const SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                        // child: Icon(
                        //   Icons.notifications,
                        //   color: Colors.white,
                        // ),
                        ),
                  ),
                ),
              ],
            ),
          ),
       
          Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Power Usage Chart Month Wise',
                  style: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
                 Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 8,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    // _chartType=!_chartType;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: PieChart(

                                      dataMap: dataMap,
                                      animationDuration: const Duration(milliseconds: 2200),
                                      chartType:ChartType.disc
                                    // _chartType ? ChartType.disc : ChartType.ring,
                                  ),
                                ),
                              ),
                            ),
                    
              Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  createCard('📆 Total Days : ', '${widget.totalDays} days'),
                  createCard('📊 Total Power : ', '${widget.totalEnergy} Kwh'),
                  createCard('⏰  Total Time : ', "${widget.chooseValueMinute}"),
                  createCard('💰 Total Amount :  ',
                      '${totalAMount.toStringAsFixed(2).toString()} ₹'),
                ],
              ),
            ],
          )
      
        ],
      )),
    );
  }

  Widget createCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            children: <TextSpan>[
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
