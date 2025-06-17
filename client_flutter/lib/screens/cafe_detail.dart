import 'package:flutter/material.dart';

class CafeDetailScreen extends StatelessWidget {
  const CafeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> cafe = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    const primaryBrown = Color(0xFF4B2E1E);
    const background = Color(0xFFF9F6F1);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: background,
      body:
          SizedBox(
            height: screenHeight, 
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Background image (bottom layer of the Stack)
                Image.network(
                  cafe['image'], 
                  width: double.infinity,
                  height: 0.25 * screenHeight,
                  fit: BoxFit.cover,
                ),

                // 2. Back button (positioned on top of the image)
                Positioned(
                  top: 0.05 * screenHeight,
                  left: 16,
                  child: _circleButton(
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                ),

                // 3. Share and Favorite buttons (positioned on top of the image)
                Positioned(
                  top: 0.16 * screenHeight,
                  right: 16,
                  child: Row(
                    children: [
                      _circleButton(Icons.share, () {
                        // TODO: Implement share functionality here
                      }),
                      const SizedBox(width: 8),
                      _circleButton(Icons.favorite_border, () {
                        // TODO: Implement add favorite functionality
                      }),
                    ],
                  ),
                ),

                // 4. Overlapping white card with scrollable content (main info layer)
                // Adjust the top value if the overall Stack height changes significantly
                Positioned(
                  top: 0.23 * screenHeight, // This value needs to be carefully chosen relative to the Stack's new height
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cafe['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryBrown,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  index < cafe['rating'] ? Icons.star : Icons.star_outline, // To-do: change to real cafe reviews
                                  size: 18,
                                  color: const Color(0xFF6F8371),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('(234 reviews)', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children:  [
                              Chip(
                                backgroundColor: const Color(0xFF6F8371) , //To-do: change to cafe is opened or not (ex: cafe?.isOpened ? const Color(0xFF6F8371) : const Color(0xFFE5E7EB))
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                label: Text(
                                      "Open Now", //To-do: change to cafe is opened or not (ex: cafe?.isOpened ? "Open Now" : "Closed Now")
                                      style: TextStyle(
                                        color: Colors.white, //To-do: change to cafe is opened or not (ex: cafe?.isOpened ? Colors.white : const Color(0xFFE5E7EB))
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              ),
                              SizedBox(width: 12),
                              Text('8:00 AM – 5:00 PM'), // To-do: change to real cafe opening hours
                            ],
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: cafe['tags'].map<Widget>((tag) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _TagChip(
                                  label: tag,
                                  icon: _getIconForTag(tag),
                                ),
                              )).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text('Location',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBrown,
                                  fontSize: 16)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.map, size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '123 Coffee Street, Brewtown, BT1 2CP', //To-do: change to cafe's location
                            style: TextStyle(fontSize: 14),
                          ),
                          const Text(
                            '0.3 miles away', //To-do: change to cafe's distance
                            style: TextStyle(color: Color(0xFF6F8371)),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Reviews',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryBrown,
                                      fontSize: 16)),
                              Text('See All', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 12), 
                          //To-do: add reviews.map 
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: const Text('Sarah Johnson'),
                            subtitle: const Text('March 15, 2025'),
                            trailing: Row( // reviews.star
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                (index) => const Icon(Icons.star, size: 18, color: Color(0xFF6F8371)),
                              ),
                            ),
                          ),
                          Text(
                              'Amazing coffee and atmosphere! The baristas are very knowledgeable and friendly. Perfect spot for working or meeting friends.',
                              style: TextStyle(fontSize: 14),
                            ),
                      
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- End of change ---
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white70,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  IconData _getIconForTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'free wi-fi':
        return Icons.wifi;
      case 'outdoor seating':
        return Icons.beach_access;
      case 'specialty coffee':
        return Icons.star_border;
      case 'pet friendly':
        return Icons.pets;
      case 'study spot':
        return Icons.school;
      case 'stable wi-fi':
        return Icons.wifi;
      default:
        return Icons.coffee;
    }
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TagChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Color(0xFF1F2937)),
      label: Text(label),
      shape: StadiumBorder(
        side: BorderSide(color: Color(0xFFF9F6F1)),
      ),
      backgroundColor: Color(0xFFF9F6F1),
    );
  }
}