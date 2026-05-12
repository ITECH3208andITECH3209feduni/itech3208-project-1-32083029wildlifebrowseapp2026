import '../config/api_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../templates/drawer.dart';
import '../auth/auth.dart';

class LandownerRoute extends StatelessWidget {
  final User user;
  final List<String> browseFilter;
  final bool uploadSuccess;

  const LandownerRoute({
    super.key,
    required this.user,
    required this.browseFilter,
    this.uploadSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return LandholderHomePage(
      user: user,
      browseFilter: browseFilter,
      uploadSuccess: uploadSuccess,
    );
  }
}

class LandholderHomePage extends StatefulWidget {
  final User user;
  final List<String> browseFilter;
  final bool uploadSuccess;

  const LandholderHomePage({
    super.key,
    required this.user,
    required this.browseFilter,
    this.uploadSuccess = false,
  });

  @override
  State<LandholderHomePage> createState() => _LandholderHomePageState();
}

class _LandholderHomePageState extends State<LandholderHomePage> {
  late Future<List<dynamic>> futureLandholders;

  @override
  void initState() {
    super.initState();
    futureLandholders = fetchLandholders();
  }

  String getUserRole() {
    return widget.user.claims['custom:role']
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .trim()
            .toLowerCase() ??
        '';
  }

  String getUserEmailOrUsername() {
    return widget.user.claims['email']?.toString() ??
        widget.user.claims['username']?.toString() ??
        '';
  }

  bool isOwner(Map item) {
    final currentUserId = getUserEmailOrUsername();
    final createdBy = item['createdBy']?.toString() ?? '';
    return createdBy == currentUserId;
  }

  bool canCreateListing() {
    final role = getUserRole();
    return role == 'landholder';
  }

  Future<List<dynamic>> fetchLandholders() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/landholders'),
    );

    debugPrint('LANDHOLDER GET RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map && data['items'] is List) {
        return data['items'];
      }

      if (data is List) {
        return data;
      }

      return [];
    } else {
      throw Exception('Failed to load landholders: ${response.statusCode}');
    }
  }

  String getValue(Map item, String key) {
    final value = item[key];
    if (value == null) return '';
    return value.toString();
  }

  List getListValue(Map item, String key) {
    final value = item[key];
    if (value is List) return value;
    return [];
  }

  Future<void> deleteListing(Map item) async {
    if (!isOwner(item)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only delete listings you created.'),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text(
          'Are you sure you want to delete this listing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final id = item['_id'];

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/landholders/$id'),
    );

    debugPrint('DELETE RESPONSE: ${response.statusCode}');
    debugPrint(response.body);

    if (response.statusCode == 200 || response.statusCode == 204) {
      setState(() {
        futureLandholders = fetchLandholders();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing deleted successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete listing'),
        ),
      );
    }
  }

  void editListing(Map item) {
    if (!isOwner(item)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only edit listings you created.'),
        ),
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).pushNamed(
      '/landowner-registration',
      arguments: {
        'user': widget.user,
        'existingListing': item,
      },
    );
  }

  Widget landholderTile(Map item) {
    final name = getValue(item, 'landownerName').isNotEmpty
        ? getValue(item, 'landownerName')
        : getValue(item, 'landholderName');

    final address = getValue(item, 'address');
    final postcode = getValue(item, 'postcode');
    final phone = getValue(item, 'phone');
    final browseData = getListValue(item, 'browseData');

    final bool owner = isOwner(item);

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          name.isNotEmpty ? "$name's property" : 'Landholder property',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: $address'),
            Text('Postcode: $postcode'),
            Text('Phone: $phone'),
            if (browseData.isNotEmpty) Text('Browse: ${browseData.join(", ")}'),
            const SizedBox(height: 6),
            Text(
              owner
                  ? 'Your listing - tap to view or use buttons to edit/delete'
                  : 'Tap to view Landholder Profile',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: owner
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit listing',
                    onPressed: () {
                      editListing(item);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete listing',
                    onPressed: () {
                      deleteListing(item);
                    },
                  ),
                ],
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LandholderProfile(
                item: item,
                user: widget.user,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String username =
        widget.user.claims['given_name']?.toString() ?? 'User';

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Landholder Dashboard'),
        actions: [
          if (canCreateListing())
            TextButton(
              child: const Text('Create Listing'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  '/landowner-registration',
                  arguments: {'user': widget.user},
                );
              },
            ),
        ],
      ),
      drawer: UserDrawer(username: username, user: widget.user),
      body: FutureBuilder<List<dynamic>>(
        future: futureLandholders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No landholder listings found'),
            );
          }

          final landholders = snapshot.data!;

          return ListView.builder(
            itemCount: landholders.length,
            itemBuilder: (context, index) {
              return landholderTile(landholders[index]);
            },
          );
        },
      ),
    );
  }
}

class LandholderProfile extends StatelessWidget {
  final Map item;
  final User user;

  const LandholderProfile({
    super.key,
    required this.item,
    required this.user,
  });

  String getValue(String key) {
    final value = item[key];
    if (value == null) return '';
    return value.toString();
  }

  List getListValue(String key) {
    final value = item[key];
    if (value is List) return value;
    return [];
  }

  String getUserEmailOrUsername() {
    return user.claims['email']?.toString() ??
        user.claims['username']?.toString() ??
        '';
  }

  bool isOwner() {
    final currentUserId = getUserEmailOrUsername();
    final createdBy = item['createdBy']?.toString() ?? '';
    return createdBy == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final name = getValue('landownerName').isNotEmpty
        ? getValue('landownerName')
        : getValue('landholderName');

    final browseData = getListValue('browseData');
    final daysData = getListValue('daysData');
    final timesData = getListValue('timesData');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Landholder Profile'),
        actions: [
          if (isOwner())
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Edit listing',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  '/landowner-registration',
                  arguments: {
                    'user': user,
                    'existingListing': item,
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (isOwner())
              const Text(
                'This is your listing',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            const SizedBox(height: 8),
            Text('Name: $name'),
            Text('Phone: ${getValue('phone')}'),
            Text('Address: ${getValue('address')}'),
            Text('Postcode: ${getValue('postcode')}'),
            Text('Access details: ${getValue('accessDetails')}'),
            Text('Extra details: ${getValue('extraDetails')}'),
            Text('Browse: ${browseData.join(", ")}'),
            Text('Available days: ${daysData.join(", ")}'),
            Text('Available times: ${timesData.join(", ")}'),
          ],
        ),
      ),
    );
  }
}