import 'package:flutter/material.dart';
import 'package:simplyserve/screen/location/change_location_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
        
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                 
                
                  const SizedBox(width: 12),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  // Settings icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),

            // Avatar + name + email
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12,
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=580',
                    ), // replace with AssetImage if you have local avatar
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    'Praveen Kumar',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Email
                  Text(
                    'praveen.kumar@example.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2)),

            // Options list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _ProfileTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.location_on_outlined,
                    title: 'Manage Addresses',
                    onTap: () {
                   Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ChangeLocationPage()),
);

                    },
                  ),
                  _ProfileTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.favorite_border,
                    title: 'Favorites',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Order History',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.star_border,
                    title: 'Loyalty Rewards',
                    onTap: () {},
                  ),

                  // Extra spacing at bottom so last item isn't too close to edge
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
          child: Row(
            children: [
              // Icon with subtle circular background like screenshot
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 26, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
