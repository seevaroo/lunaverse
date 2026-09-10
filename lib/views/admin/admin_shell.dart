import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/learning_repository.dart';
import '../../models/app_models.dart';
import '../../presentation/app_state.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int index = 0;
  @override Widget build(BuildContext context) {
    const titles = ['Overview', 'User management', 'Content management', 'Certificates'];
    final pages = [const AdminOverview(), const AdminUsersPage(), const AdminContentPage(), const AdminCertificatesPage()];
    return Scaffold(body: Row(children: [
      NavigationRail(extended: MediaQuery.sizeOf(context).width >= 1000, selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), leading: const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Icon(Icons.auto_awesome, color: Color(0xff3155d9), size: 30)), destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Overview')),
        NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Users')),
        NavigationRailDestination(icon: Icon(Icons.library_books_outlined), selectedIcon: Icon(Icons.library_books), label: Text('Content')),
        NavigationRailDestination(icon: Icon(Icons.workspace_premium_outlined), selectedIcon: Icon(Icons.workspace_premium), label: Text('Certificates')),
      ]),
      Expanded(child: Scaffold(appBar: AppBar(title: Text(titles[index]), actions: [IconButton(onPressed: context.read<AppState>().signOut, icon: const Icon(Icons.logout), tooltip: 'Keluar')]), body: pages[index])),
    ]));
  }
}

class AdminOverview extends StatelessWidget {
  const AdminOverview({super.key});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(28), children: [Text('Good morning, Admin', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Pantau kesehatan pembelajaran LunaVerse dari satu tempat.'), const SizedBox(height: 28), GridView.count(shrinkWrap: true, crossAxisCount: MediaQuery.sizeOf(context).width > 900 ? 4 : 2, children: const [_StatCard('Active users', '248', Icons.people), _StatCard('Quiz attempts', '1,294', Icons.quiz), _StatCard('Average score', '82%', Icons.trending_up), _StatCard('Certificates', '184', Icons.workspace_premium)]), const SizedBox(height: 28), const Card(child: ListTile(leading: Icon(Icons.insights), title: Text('Bahasa paling diminati'), subtitle: Text('English 42%  •  Japanese 27%  •  Spanish 16%')))]);
}
class _StatCard extends StatelessWidget { const _StatCard(this.label, this.value, this.icon); final String label; final String value; final IconData icon; @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: const Color(0xff3155d9)), Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), Text(label)]))); }

class AdminUsersPage extends StatelessWidget { const AdminUsersPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(28), children: [const _Toolbar('Registered users', 'Export'), DataTable(columns: const [DataColumn(label: Text('Name')), DataColumn(label: Text('Email')), DataColumn(label: Text('Status'))], rows: const [DataRow(cells: [DataCell(Text('Luna Learner')), DataCell(Text('user@lunaverse.app')), DataCell(Text('Active'))]), DataRow(cells: [DataCell(Text('Sakura Tan')), DataCell(Text('sakura@example.com')), DataCell(Text('Active'))]), DataRow(cells: [DataCell(Text('Diego Ramos')), DataCell(Text('diego@example.com')), DataCell(Text('Inactive'))])])]); }
class _Toolbar extends StatelessWidget { const _Toolbar(this.title, this.action); final String title; final String action; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: Text(action))])); }

class AdminContentPage extends StatefulWidget { const AdminContentPage({super.key}); @override State<AdminContentPage> createState() => _AdminContentPageState(); }
class _AdminContentPageState extends State<AdminContentPage> { final languages = List<Language>.from(DemoLearningRepository.languages); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(28), children: [const _Toolbar('Languages & lessons', 'Add content'), ...languages.map((language) => Card(child: ListTile(leading: Text(language.icon), title: Text(language.name), subtitle: Text('${language.lessons} lessons'), trailing: IconButton(onPressed: () => setState(() => languages.remove(language)), icon: const Icon(Icons.delete_outline)))))]); }

class AdminCertificatesPage extends StatelessWidget { const AdminCertificatesPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(28), children: [const _Toolbar('Certificate verification', 'Issue certificate'), Card(child: DataTable(columns: const [DataColumn(label: Text('Learner')), DataColumn(label: Text('Language')), DataColumn(label: Text('Score')), DataColumn(label: Text('Action'))], rows: const [DataRow(cells: [DataCell(Text('Luna Learner')), DataCell(Text('English')), DataCell(Text('92/100')), DataCell(Text('Issued'))]), DataRow(cells: [DataCell(Text('Sakura Tan')), DataCell(Text('Japanese')), DataCell(Text('88/100')), DataCell(Text('Verify'))])]))]); }