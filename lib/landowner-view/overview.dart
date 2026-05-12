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

  Widget landholderTile(Map item) {
    final name = getValue(item, 'landownerName').isNotEmpty
        ? getValue(item, 'landownerName')
        : getValue(item, 'landholderName');

    final address = getValue(item, 'address');
    final postcode = getValue(item, 'postcode');
    final phone = getValue(item, 'phone');
    final browseData = getListValue(item, 'browseData');

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
            if (browseData.isNotEmpty)
              Text('Browse: ${browseData.join(", ")}'),
            const SizedBox(height: 6),
            const Text(
              'Tap to view Landholder Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
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
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LandholderProfile(item: item),
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

  const LandholderProfile({
    super.key,
    required this.item,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
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