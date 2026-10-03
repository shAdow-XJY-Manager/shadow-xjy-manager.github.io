// Historical page import remains available; live directory uses real project data.
import 'package:flutter/material.dart';
import '../../portal/projectCatalog.dart';

class IndexBook extends StatelessWidget {
  const IndexBook({super.key});
  @override
  Widget build(BuildContext context) => const ProjectCatalog(section: '工具');
}
