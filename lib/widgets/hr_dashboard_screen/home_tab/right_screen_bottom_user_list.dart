import 'package:flutter/material.dart';
import 'package:usms/screens/user_details_screen.dart';

class RightScreenBottomUserList extends StatelessWidget {
  final usersData;
  RightScreenBottomUserList({@required this.usersData});

  // final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white54,
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          child: ListView.builder(
            itemCount: usersData.data!.docs.length,
            itemBuilder: (context, i) {
              final singleUserData = usersData.data!.docs[i];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor.withOpacity(0.5),
                ),
                child: ListTile(
                  key: ValueKey(singleUserData['fullName']),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      singleUserData['profileImage'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(singleUserData['fullName']),
                  subtitle: Text(singleUserData['degreeType'] + ' - ' + singleUserData['speciality']),
                  trailing: Icon(Icons.arrow_forward_ios),
                  contentPadding: const EdgeInsets.all(3),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailsScreen(singleUserData))),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
