import '../../../domain/entities/institution.dart';
import '../../providers/institutions/institutions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InstitutionsScreen extends ConsumerStatefulWidget {
  static const name = 'institution-screen';

  const InstitutionsScreen({super.key});

  @override
  InstitutionsScreenState createState() => InstitutionsScreenState();
}

class InstitutionsScreenState extends ConsumerState<InstitutionsScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(getInstitutionsProvider.notifier).loadInstitutions();
    controller.addListener(() {
      if ((controller.position.pixels + 200) >=
          controller.position.maxScrollExtent) {
        ref.read(getInstitutionsProvider.notifier).loadInstitutions();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final institutions = ref.watch(getInstitutionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instituciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          institutions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(10),
                  itemCount: institutions.length,
                  itemBuilder: (context, index) {
                    final institution = institutions[index];
                    return _InstitutionCard(institution: institution);
                  },
                ),
              ),
    );
  }
}

class _InstitutionCard extends StatelessWidget {
  final Institution institution;

  const _InstitutionCard({required this.institution});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.school,
          color: institution.background.withValues(alpha: 0.5),
          size: 40,
        ),
        title: Text(
          institution.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${institution.location.city}, ${institution.location.state}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/institution-detail-screen/${institution.id}');
        },
      ),
    );
  }
}
