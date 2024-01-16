import 'package:amazon_app/core/admin/models/sales_chart.dart';
import 'package:amazon_app/core/admin/services/admin_services.dart';
import 'package:amazon_app/core/admin/widgets/category_products_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {

  final adminServices = AdminServices();
  int? totalSales;
  List<SalesChart>? earnings;

  void getEarnings() async {
    var earningData = await adminServices.getAnalytics(context: context);
    totalSales = earningData["totalEarnings"];
    earnings = earningData["sales"] as List<SalesChart>;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return earnings  == null || totalSales == null ? const Center(child: CircularProgressIndicator.adaptive()) : Column(
      children: [
        Text("\$$totalSales", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 250,
          child: CategoryProductsChart(seriesList: [
            charts.Series(id: "Sales", data: earnings!, domainFn: (sales, _) => sales.label, measureFn: (sales, _) => sales.earning)
          ]),
        )
      ]
    );
  }
}