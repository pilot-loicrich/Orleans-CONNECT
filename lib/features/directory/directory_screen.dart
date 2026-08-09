import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/business_repository.dart';
import '../../models/business.dart';
import '../../shared/widgets/async_view.dart';
import 'widgets/business_card.dart';

/// Annuaire des commerces et services de proximité, avec recherche et
/// filtre par catégorie.
class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  BusinessCategory? _category;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final repo = context.read<BusinessRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Annuaire')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Rechercher un commerce, un quartier…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip('Tout', null),
                for (final c in BusinessCategory.values) _chip(c.label, c),
              ],
            ),
          ),
          Expanded(
            child: AsyncView<List<Business>>(
              future: repo.fetchAll(category: _category, query: _query),
              isEmpty: (data) => data.isEmpty,
              emptyMessage: 'Aucun commerce ne correspond à votre recherche.',
              builder: (context, items) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => BusinessCard(
                  business: items[i],
                  onTap: () => context.push('/directory/${items[i].id}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, BusinessCategory? value) {
    final selected = _category == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _category = value),
      ),
    );
  }
}
