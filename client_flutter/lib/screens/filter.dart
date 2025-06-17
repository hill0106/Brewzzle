import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final Color primaryBrown = const Color(0xFF4B2E1E);
  final Color background = const Color(0xFFF9F6F1);

  final List<Map<String, dynamic>> seating = [
    {'label': 'Indoor', 'icon': Icons.chair},
    {'label': 'Outdoor', 'icon': Icons.beach_access},
    {'label': 'Lounge', 'icon': Icons.weekend},
    {'label': 'Work-friendly', 'icon': Icons.laptop_mac},
  ];

  final List<Map<String, dynamic>> coffee = [
    {'label': 'Espresso', 'icon': Icons.local_cafe},
    {'label': 'Cold Brew', 'icon': Icons.local_drink},
    {'label': 'Specialty', 'icon': Icons.star_outline},
    {'label': 'Hand-brewed', 'icon': Icons.filter_alt_outlined},
  ];

  final List<Map<String, dynamic>> essentials = [
    {'label': 'Quiet', 'icon': Icons.volume_off},
    {'label': 'Wi-Fi', 'icon': Icons.wifi},
    {'label': 'Outlets', 'icon': Icons.electrical_services},
    {'label': 'Group-friendly', 'icon': Icons.groups},
    {'label': 'Instagrammable', 'icon': Icons.photo_camera_outlined},
  ];

  final Map<String, bool> selectedTags = {};
  final List<Map<String, dynamic>> switches = [
    {'icon': Icons.access_time, 'name': 'Open Now', 'isSelected': false},
    {'icon': Icons.wb_sunny_outlined, 'name': 'Early Bird (Before 7AM)', 'isSelected': false},
    {'icon': Icons.nightlight_round, 'name': 'Late Night (After 8PM)', 'isSelected': false}
  ];

  Map<String, dynamic> _collectFilters() {
    // Collect selected seating options
    List<dynamic> selectedFilters = seating
        .where((item) => selectedTags[item['label']] ?? false)
        .map((item) => item['label'])
        .toList();

    // Collect selected coffee options
    selectedFilters += coffee
        .where((item) => selectedTags[item['label']] ?? false)
        .map((item) => item['label'])
        .toList();

    // Collect selected essentials
    selectedFilters += essentials
        .where((item) => selectedTags[item['label']] ?? false)
        .map((item) => item['label'])
        .toList();

    // Format hours filters as pipe-separated string
    List<String> hoursFilters = [];
    if (switches[0]['isSelected']) hoursFilters.add('openNow');
    if (switches[1]['isSelected']) hoursFilters.add('before7');
    if (switches[2]['isSelected']) hoursFilters.add('after8');
    String hoursString = hoursFilters.join('|');
    
    return {
      'filters': selectedFilters,
      'hours': hoursString,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B2E1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Filters',
            style: TextStyle(
              color: Color(0xFF4B2E1E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildSectionTitle('Seating Type'),
            _buildTagGroup(seating),

            _buildSectionTitle('Coffee Category'),
            _buildTagGroup(coffee),

            _buildSectionTitle('Open Hours'),
            ...switches.map((switchItem) => _buildSwitch(switchItem)),

            _buildSectionTitle('Your Essentials'),
            _buildTagGroup(essentials),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              final filters = _collectFilters();
              print('Selected Filters: ${filters['filters']}');
              print('Hours Filter: ${filters['hours']}');
              Navigator.pop(context, filters);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBrown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Apply Filters', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4B2E1E),
        ),
      ),
    );
  }

  Widget _buildTagGroup(List<Map<String, dynamic>> tags) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tags.map((tagData) {
        final String tag = tagData['label'];
        final IconData icon = tagData['icon'];
        final bool selected = selectedTags[tag] ?? false;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTags[tag] = !selected;
            });
          },
          child: Chip(
            backgroundColor: selected ? primaryBrown : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : const Color(0xFF4B5563),
                ),
                const SizedBox(width: 4),
                Text(
                  tag,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitch(Map<String, dynamic> switchItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.transparent)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(switchItem['icon'], size: 20, color: Color(0xFF6F8371)),
              const SizedBox(width: 10),
              Text(
                switchItem['name'],
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          FlutterSwitch(
            value: switchItem['isSelected'],
            onToggle: (val) {
              setState(() {
                switchItem['isSelected'] = val;
              });
            },
            width: 60,
            height: 30,
            // toggleSize: 22,
            activeColor: const Color(0xFF6F8371),
            inactiveColor: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }
}
