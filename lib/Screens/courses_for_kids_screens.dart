import 'package:flutter/material.dart';

class CoursesForKidsScreen extends StatelessWidget {
  const CoursesForKidsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.blue.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Farm Explorers",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Fun agricultural adventures for curious young minds!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              
              // Introduction Text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Join our exciting workshops and learn about farming, plants, and nature in a fun way!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              
              // Course Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildCourseCard(
                      context,
                      title: "Seed to Plant Adventure",
                      description: "Watch seeds grow into plants and learn about the magic of germination through fun experiments!",
                      duration: "4 weeks",
                      ageGroup: "Ages 5-8",
                      imageAsset: "assets/images/seed_to_plant.png",
                      backgroundColor: Colors.green.shade100,
                      iconColor: Colors.green,
                    ),
                    SizedBox(height: 16),
                    _buildCourseCard(
                      context,
                      title: "Smart Irrigation Heroes",
                      description: "Discover how technology helps plants get the right amount of water and build a mini irrigation system!",
                      duration: "3 weeks",
                      ageGroup: "Ages 7-10",
                      imageAsset: "assets/images/smart_irrigation.png",
                      backgroundColor: Colors.blue.shade100,
                      iconColor: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    _buildCourseCard(
                      context,
                      title: "Weather Watchers",
                      description: "Learn how weather affects plants and create your own weather station to track conditions!",
                      duration: "5 weeks",
                      ageGroup: "Ages 6-9",
                      imageAsset: "assets/images/weather_watchers.png",
                      backgroundColor: Colors.orange.shade100,
                      iconColor: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required String title,
    required String description,
    required String duration,
    required String ageGroup,
    required String imageAsset,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with rounded corners at the top
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade200, // Placeholder color
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getIconForTitle(title),
                      size: 80,
                      color: iconColor.withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ageGroup,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Start Learning"),
                    style: ElevatedButton.styleFrom(
                      primary: iconColor,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.contains("Seed")) return Icons.spa;
    if (title.contains("Irrigation")) return Icons.water_drop;
    if (title.contains("Weather")) return Icons.wb_sunny;
    return Icons.nature;
  }
}