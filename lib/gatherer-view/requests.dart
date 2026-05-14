import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../templates/drawer.dart';
import '../templates/browseList.dart';
import '../auth/auth.dart';

import '../models/request.dart';
import '../models/response.dart';

import 'package:change_case/change_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class GathererRoute extends StatelessWidget {
  final User user;
  const GathererRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Requests',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
        useMaterial3: true,
      ),
      home: GathererHomePage(title: 'Request Board', user: user),
    );
  }
}

class GathererHomePage extends StatefulWidget {
  const GathererHomePage({
    super.key,
    required this.title,
    required this.user,
  });

  final String title;
  final User user;

  @override
  State<GathererHomePage> createState() => _RequestBoardState();
}

Future<List<Request>> fetchRequests() async {
  try {
    final response = await http.get(
  Uri.parse('${ApiConfig.requestsAPI}?refresh=${DateTime.now().millisecondsSinceEpoch}'),
);

    final Map<String, dynamic> responseData = json.decode(response.body);
    final Response requestResponse = Response.fromJson(responseData);

    if (response.statusCode == 200) {
      return requestResponse.items;
    } else {
      throw Exception('Failed to load requests: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<bool> deleteRequest(String requestId, int statusNum) async {
  try {
    final response = await http.delete(
      Uri.parse('${ApiConfig.requestsAPI}/$requestId/$statusNum'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      debugPrint('Request deleted successfully');
      return true;
    } else {
      debugPrint('Delete failed: ${response.statusCode}');
      debugPrint(response.body);
      return false;
    }
  } catch (e) {
    debugPrint('Error deleting request: $e');
    return false;
  }
}

bool isGatherer(User user) {
  final role = user.claims['custom:role']
      .toString()
      .toLowerCase()
      .replaceAll('[', '')
      .replaceAll(']', '')
      .trim();

  return role == 'gatherer';
}
bool isCaretaker(User user) {
  final role = user.claims['custom:role']
      .toString()
      .toLowerCase()
      .replaceAll('[', '')
      .replaceAll(']', '')
      .trim();

  return role == 'caretaker';
}
bool isLandholder(User user) {
  final role = user.claims['custom:role']
      .toString()
      .toLowerCase()
      .replaceAll('[', '')
      .replaceAll(']', '')
      .trim();

  return role == 'landholder';
}
class _RequestBoardState extends State<GathererHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  late Future<List<Request>> futureRequests;
List<Request> currentRequests = [];
  @override
  void initState() {
    super.initState();

  futureRequests = fetchRequests().then((requests) {
  currentRequests = requests;
  return requests;
});

    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  void _refreshRequests() async {
  await Future.delayed(const Duration(milliseconds: 300));

  if (!mounted) return;

  setState(() {
    futureRequests = fetchRequests();
  });
}

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Widget requestTile(Request request, User user, bool isWip) {
    Color tileColor;

    final currentUsername = user.claims['username'];
    final bool acceptedByMe = request.assigned_User_ID == currentUsername;

    final bool canDelete =
    (isGatherer(user) && request.status_Num == 2 && acceptedByMe) ||
    (isCaretaker(user) &&
        (request.requester_ID.toString() == currentUsername.toString()));

    if (request.requester_ID == currentUsername) {
      tileColor = const Color.fromARGB(255, 173, 216, 230);
    } else if (isWip) {
      tileColor = const Color.fromARGB(255, 255, 224, 156);
    } else {
      tileColor = const Color.fromARGB(255, 246, 251, 244);
    }

    return Hero(
      tag: request.request_ID,
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/${request.animal_ID.toLowerCase().split(" ").join("-")}.jpg',
            ),
            radius: 20,
          ),
          title: Text(request.animal_ID),
          subtitle: BrowseTileList(
            browses: request.getBrowseNames(),
            quantities: request.getBrowseQuantities(),
          ),
          trailing: SizedBox(
            width: canDelete ? 120 : 85,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${formatTimelapse(getTimelapse(request.timestamp))} ago",
                        style: isStale(getTimelapse(request.timestamp))
                            ? const TextStyle(color: Colors.red)
                            : const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Postcode: ${request.postcode}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (canDelete)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Request'),
                          content: const Text(
                            'Are you sure you want to delete this accepted request?',
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

                      if (confirm == true) {
                        final success = await deleteRequest(
                          request.request_ID.toString(),
                          request.status_Num,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Deleted successfully'
                                  : 'Delete failed',
                            ),
                          ),
                        );

 if (success) {
  setState(() {
    currentRequests.removeWhere(
      (item) => item.request_ID == request.request_ID,
    );

    futureRequests = Future.value(currentRequests);
  });
}
                      }
                    },
                  ),
              ],
            ),
          ),

          tileColor: tileColor,
          onTap: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute<bool>(
                builder: (BuildContext context) => DetailedRequest(
                  title: 'Request Details',
                  request: request,
                  user: user,
                ),
              ),
            );

            if (result == true) {
              _refreshRequests();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Requests';

    final String username =
        widget.user.claims['given_name'].toString().toCapitalCase();

    return MaterialApp(
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
        useMaterial3: true,
      ),
      title: appTitle,
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Make an order request',
                onPressed: () async {
                  final result =
                      await Navigator.of(context, rootNavigator: true).pushNamed(
                    '/caretaker',
                    arguments: {'user': widget.user},
                  );

                  if (result == true) {
                    _refreshRequests();
                  }
                },
              ),
              if (isLandholder(widget.user))
  IconButton(
    icon: const Icon(Icons.edit_location_outlined),
    tooltip: 'List/Register a listing',
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pushNamed(
        '/landholder-tutorial',
        arguments: {'user': widget.user},
      );
    },
  ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Explore browse',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed('/education');
                },
              ),
            ],
          ),
          drawer: UserDrawer(username: username, user: widget.user),
          body: FutureBuilder<List<Request>>(
            future: futureRequests,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Snapshot Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No requests found'));
              }

              currentRequests = snapshot.data!;
List<Request> allRequests = currentRequests;

              final filteredRequests = allRequests.where((request) {
                final isUserAssigned =
                    widget.user.claims['username'] == request.assigned_User_ID;

                return isActive(request.status_Num) ||
                    (!isActive(request.status_Num) && isUserAssigned);
              }).toList();

              int userLocation =
                  int.parse(widget.user.claims['custom:postcode']);

              filteredRequests.sort((a, b) {
                int c = max(a.postcode, userLocation) -
                    min(a.postcode, userLocation);
                int d = max(b.postcode, userLocation) -
                    min(b.postcode, userLocation);
                return c.compareTo(d);
              });

              filteredRequests.sort((a, b) {
                return b.status_Num.compareTo(a.status_Num);
              });

              return FadeTransition(
                opacity: _fadeAnimation,
                child: ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    final isWip = !isActive(request.status_Num);

                    return requestTile(request, widget.user, isWip);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DetailedRequest extends StatefulWidget {
  const DetailedRequest({
    super.key,
    required this.title,
    required this.request,
    required this.user,
  });

  final String title;
  final Request request;
  final User user;

  @override
  State<DetailedRequest> createState() => _DetailedRequestState();
}

class _DetailedRequestState extends State<DetailedRequest> {
  Future<void> _maybeShowOfflineNotice() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('offlineNoticeShown') ?? false;

    if (!shown) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Offline reminder'),
            content: const Text(
              'Please screenshot this request and the relevant landholder listings and browse pages. '
              'Some images may not load without mobile reception when gathering browse.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      await prefs.setBool('offlineNoticeShown', true);
    }
  }

  Future<void> _maybeShowEnvironmentalCareNotice() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('environmentalCareNoticeShown') ?? false;

    if (!shown) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Gather responsibly'),
            content: const Text(
              'Please respect the integrity of the plants by taking only what is necessary so the plant can regenerate. '
              'Clean and disinfect your tools and bags before and after gathering to avoid spreading plant diseases or pests.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      await prefs.setBool('environmentalCareNoticeShown', true);
    }
  }

  Widget header(Request request) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          height: 100,
          child: Image(
            image: AssetImage(
              'assets/images/${request.animal_ID.toLowerCase().split(" ").join("-")}.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Animal: ${request.animal_ID}',
                style: const TextStyle(
                  color: Color.fromARGB(235, 16, 17, 17),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Caretaker: ${request.caretakerName}',
                style: const TextStyle(
                  color: Color.fromARGB(235, 16, 17, 17),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget disclaimer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        label: const Text(
          'Legal Disclaimer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Important Legal Notice'),
                content: const Text(
                  'Gatherers are reminded that browse must only be collected '
                  'from private property with the owner’s permission. '
                  'Collecting from Crown land (public or state land) is illegal '
                  'and may result in legal action.\n\n'
                  'Always verify property ownership and obtain consent before gathering.',
                ),
                actions: [
                  TextButton(
                    child: const Text('I Understand'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget browsePanel(browses, quantities, types) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset.zero,
                blurRadius: 4,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                    color: Color.fromARGB(255, 230, 230, 230),
                  ),
                  child: Text(
                    "Browse Needed",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                BrowseQuantityList(
                  browses: browses,
                  quantities: quantities,
                  types: types,
                  fontColor: const Color.fromARGB(255, 230, 230, 230),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget requestDetails(details) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.call_to_action_outlined, size: 14),
              Text(
                "Request Details:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            details,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              inherit: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget deliveryAddress(address, postcode) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.place, size: 14),
              Text(
                "Delivery address:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          isShowAddress(widget.request, widget.user)
              ? SelectableText("$address, $postcode")
              : SelectableText("Postcode: $postcode"),
        ],
      ),
    );
  }

  Widget timelapse(request) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(child: Icon(Icons.timelapse, size: 14)),
            TextSpan(
              text:
                  " Submitted ${formatTimelapse(getTimelapse(request.timestamp))} ago",
              style: isStale(getTimelapse(request.timestamp))
                  ? const TextStyle(color: Colors.red)
                  : const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestButtons(Request request) {
    final bool canAccept = isGatherer(widget.user) &&
        widget.user.claims['username'] != request.requester_ID &&
        request.status_Num == 1;

    if (!canAccept) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(218, 166, 247, 146),
                minimumSize: const Size(101, 38),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              onPressed: () async {
                await _maybeShowOfflineNotice();
                await _maybeShowEnvironmentalCareNotice();

                setState(() {
                  request.assignGatherer = widget.user.claims['username'];
                  request.updateState = 2;
                });

                final success = await updateRequest(request);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Request accepted successfully'
                          : 'Failed to accept request',
                    ),
                  ),
                );

               if (success) {
  Navigator.pop(context, true);
}
              },
              child: const Text(
                'Accept',
                style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(218, 250, 250, 250),
                side: const BorderSide(color: Colors.black12),
                minimumSize: const Size(101, 38),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showListings(browseFilter) {
    final bool acceptedByMe =
        widget.request.assigned_User_ID == widget.user.claims['username'];

    final bool canSeeListings =
        isGatherer(widget.user) && widget.request.status_Num == 2 && acceptedByMe;

    if (!canSeeListings) {
      return Container();
    }

    return TextButton.icon(
      icon: const Icon(Icons.edit_location_outlined),
      label: const Text('See nearby browse'),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          '/landowner',
          arguments: {
            'user': widget.user,
            'browseFilter': browseFilter,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool acceptedByMe =
        widget.request.assigned_User_ID == widget.user.claims['username'];

    final bool canDelete = isGatherer(widget.user) &&
        widget.request.status_Num == 2 &&
        acceptedByMe;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: Text('${widget.request.animal_ID} request'),
        actions: [
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete accepted request',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Request'),
                    content: const Text(
                      'Are you sure you want to delete this accepted request?',
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

                if (confirm == true) {
                  final success = await deleteRequest(
                    widget.request.request_ID.toString(),
                    widget.request.status_Num,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Deleted successfully' : 'Delete failed',
                      ),
                    ),
                  );

                  if (success) {
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 30.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              header(widget.request),
              const SizedBox(height: 10.0),
              disclaimer(),
              const SizedBox(height: 10.0),
              browsePanel(
                widget.request.getBrowseNames(),
                widget.request.getBrowseQuantities(),
                widget.request.getBrowseTypes(),
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.bottomLeft,
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 234, 118),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: Offset.zero,
                          blurRadius: 4,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          deliveryAddress(
                            widget.request.address.toString().toCapitalCase(),
                            widget.request.postcode,
                          ),
                          const SizedBox(height: 10.0),
                          widget.request.requestDetails != null
                              ? requestDetails(widget.request.requestDetails)
                              : Container(),
                          const SizedBox(height: 10.0),
                          timelapse(widget.request),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              requestButtons(widget.request),
              showListings(widget.request.getBrowseNames()),
            ],
          ),
        ],
      ),
    );
  }
}

bool isActive(state) {
  return state == 1;
}

String getTimelapse(requestTime) {
  DateTime parsedDate = DateTime.parse(requestTime);
  Duration difference = DateTime.now().difference(parsedDate);
  int parsedDifference = difference.inSeconds;

  int daysElapsed = parsedDifference ~/ (24 * 3600);
  int hoursElapsed = (parsedDifference % (24 * 3600)) ~/ 3600;
  int minutesElapsed = (parsedDifference % 3600) ~/ 60;

  return '$daysElapsed:$hoursElapsed:$minutesElapsed';
}

String formatTimelapse(timelapse) {
  List<int> timeParts =
      timelapse.split(":").map<int>((str) => int.parse(str)).toList();

  int daysElapsed = timeParts[0];
  int hourElapsed = timeParts[1];
  int minElapsed = timeParts[2];

  if (daysElapsed != 0) {
    return '$daysElapsed days';
  } else if (hourElapsed != 0) {
    return '${hourElapsed}h ${minElapsed}m';
  } else {
    return '${minElapsed}m';
  }
}

bool isStale(timelapse) {
  List<int> timeParts =
      timelapse.split(":").map<int>((str) => int.parse(str)).toList();

  return timeParts[0] > 0 || timeParts[1] > 15;
}

Future<bool> updateRequest(Request updatedRequest) async {
  try {
    debugPrint(
      'PATCH URL: ${ApiConfig.requestsAPI}/${updatedRequest.request_ID}/2',
    );
    debugPrint('PATCH BODY: ${jsonEncode(updatedRequest.toJson())}');

    final response = await http.patch(
      Uri.parse('${ApiConfig.requestsAPI}/${updatedRequest.request_ID}/2'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedRequest.toJson()),
    );

    debugPrint('PATCH status: ${response.statusCode}');
    debugPrint('PATCH response: ${response.body}');

    if (response.statusCode == 200) {
      debugPrint('Update successfully saved');
      return true;
    } else {
      debugPrint('Server Error: ${response.statusCode}');
      debugPrint(response.body);
      return false;
    }
  } catch (e) {
    debugPrint('Failed to update request: $e');
    return false;
  }
}

bool isShowAddress(Request request, User user) {
  if (!isActive(request.status_Num) &&
      user.claims['username'] == request.assigned_User_ID) {
    return true;
  }

  if (user.claims['username'] == request.requester_ID) {
    return false;
  } else {
    return false;
  }
}