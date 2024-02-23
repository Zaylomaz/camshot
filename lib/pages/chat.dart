import 'package:flutter/material.dart';
import 'package:cometchat_sdk/cometchat_sdk.dart';

String region = "EU";
String appId = "253197607857cb2b";
AppSettings appSettings= (AppSettingsBuilder()
  ..subscriptionType = CometChatSubscriptionType.allUsers
  ..region= region
  ..adminHost = "" //optional
  ..clientHost = "" //optional
  ..autoEstablishSocketConnection =  true
).build();
class Chat extends StatelessWidget {

  const Chat ({super.key});



  @override
  Widget build(BuildContext context) => Scaffold();
  //   appBar: StreamChannelHeader(),
  //   body: Column(
  //     children: const <Widget>[
  //       Expanded(child: StreamMessageListView()),
  //       StreamMessageInput(),
  //     ],

}
// _ChannelListPage({required StreamChatClient client}) {
// }
//   class ChannelListPage extends StatelessWidget {
//   ChannelListPage({required this.client});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamChannelListView
//         sort: const [SortOption('last_message_at')],
//         filter: Filter.in_('members', [client.state.currentUser!.id]),
//         itemBuilder: (context, channels, index, tile) {
//           return tile;
//         },
//       ),
//
//   }
// }

// class ChannelPage extends StatelessWidget {

// }