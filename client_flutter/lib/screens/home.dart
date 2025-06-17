import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; 
import 'filter.dart';
import 'map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryBrown = const Color(0xFF4B2E1E);
  final Color mutedGreen = const Color(0xFF7B8B7B);
  final Color background = const Color(0xFFF9F6F1);

  final List<Map<String, dynamic>> cafes = [
    {
      "name": "The Coffee House",
      "image": "https://images.unsplash.com/photo-1567880905822-56f8e06fe630?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "rating": 4,
      "tags": ["Free Wi-Fi", "Specialty Coffee"]
    },
    {
      "name": "Brew & Co",
      "image": "https://images.unsplash.com/photo-1567880905822-56f8e06fe630?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "rating": 5,
      "tags": ["Outdoor Seating", "Pet Friendly"]
    },
    {
      "name": "Urban Grind",
      "image": "https://images.unsplash.com/photo-1567880905822-56f8e06fe630?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "rating": 3,
      "tags": ["Stable Wi-Fi", "Study Spot", "Outdoor Seating"]
    },
  ];

  final List<Map<String, dynamic>> tags = [
    {"icon": Icons.wifi, "name": "Wi-Fi", "selected": true},
    {"icon": Icons.beach_access, "name": "Outdoor Seating", "selected": true},
    {"icon": Icons.camera_alt, "name": "Instagrammable", "selected": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Brewzzle",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF4B2E1E),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar & Filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search coffee shops...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF6F8371)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FilterScreen()),
                        );
                      },
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),

              // Tags
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 8,
                  children: tags.map((tag) => _buildTag(tag)).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Nearby Cafes Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Nearby Cafes for You",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF4B2E1E),
                      )),
                  Text("See All", style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 12),

              // Cafe List
              ...cafes.map((cafe) => _buildCafeCard(cafe)),

              const SizedBox(height: 24),

              const Text(
                "Brewwzled Picks",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF4B2E1E),
                ),
              ),

              const SizedBox(height: 16),

              // Horizontal cafe images (optional carousel)
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFeaturedCard(
                      imagePath: 'https://images.unsplash.com/photo-1567880905822-56f8e06fe630?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      title: 'Newly Opened: 10 Cafes in Westwood',
                      location: 'Westwood, LA',
                    ),
                    _buildFeaturedCard(
                      imagePath: 'https://images.unsplash.com/photo-1567880905822-56f8e06fe630?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      title: 'Cozy Spots in Koreatown, LA',
                      location: 'Koreatown, LA',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(Map<String, dynamic> tag) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tag["selected"] = !tag["selected"];
        });
        // To-do: send tag filter to backend
        print(tag['name']);
      },
      child: Chip(
        backgroundColor: tag["selected"] ? const Color(0xFF452D23) : const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tag["icon"],
              size: 16,
              color: tag["selected"] ? Colors.white : const Color(0xFF4B5563),
            ),
            const SizedBox(width: 4),
            Text(
              tag["name"],
              style: TextStyle(
                color: tag["selected"] ? Colors.white : const Color(0xFF4B5563),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );
  }

  Widget _buildCafeCard(Map<String, dynamic> cafe) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/cafe-detail',
          arguments: cafe,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                child: SizedBox(
                  width: 100,
                  child: Image.network(
                    cafe["image"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cafe["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < cafe["rating"] ? Icons.star : Icons.star_outline,
                                  size: 20,
                                  color: Color(0xFF6F8371)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: cafe["tags"]
                            .map<Widget>((tag) => Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  label: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFF6F8371),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 140,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFeaturedCard({
  required String imagePath,
  required String title,
  required String location,
}) {
  return Container(
    margin: const EdgeInsets.only(right: 12),
    width: 220,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(
        image: NetworkImage(imagePath),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.35),
          BlendMode.darken,
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}
