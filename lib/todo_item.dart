import 'package:bingyan_todo_list/components/checkbox.dart';
import 'package:bingyan_todo_list/model.dart';
import 'package:flutter/material.dart';

extension AdaptiveDuration on Duration {
  String get adaptiveString {
    if (inDays >= 1) {
      return "$inDays days";
    }
    if (inHours >= 1) {
      return "$inHours hours";
    }
    return "$inMinutes minutes";
  }
}

extension TimeUtil on DateTime {
  String get toDueTimeString {
    final diff = difference(DateTime.now());
    if (diff.isNegative) {
      return "已过期 ${(-diff).adaptiveString}";
    }
    return "剩余 ${diff.adaptiveString}";
  }
}

class ItemCard extends StatelessWidget {
  final Task task;
  const ItemCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: TodoCheckBox(
        priority: Priority.none,
        onChanged: (value) {},
      ),
      title: Text(task.title),
      subtitle: Text(task.description ?? "..."),
      trailing: Text(task.created?.toDueTimeString ?? ""),
      onTap: () {
        Navigator.pushNamed(context, "/detail", arguments: task.id);
      },
    );
    // InkWell(
    //   onTap: () async {
    //     await Navigator.pushNamed(context, '/detail', arguments: task.id);
    //   },
    //   child: Container(
    //       height: 100,
    //       margin: const EdgeInsets.symmetric(vertical: 8.0),
    //       clipBehavior: Clip.hardEdge,
    //       // color: task.due == null
    //       //     ? Colors.primaryLightValue
    //       //     : Colors.primaryValue,
    //       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Expanded(
    //                 flex: 0,
    //                 child: SizedBox(
    //                     width: 50,
    //                     child: TodoCheckBox(
    //                         priority: Priority.none, onChanged: (value) {})),
    //               ),
    //               Text(task.title,
    //                   overflow: TextOverflow.ellipsis,
    //                   maxLines: 1,
    //                   style: const TextStyle(
    //                       fontSize: 16,
    //                       color: Colors.white,
    //                       fontWeight: FontWeight.w600,
    //                       height: 1)),
    //               task.due == null
    //                   ? const SizedBox.shrink()
    //                   : const Icon(Icons.access_time_sharp,
    //                       color: Colors.white, size: 16)
    //             ],
    //           ),
    //           Expanded(
    //             flex: 1,
    //             child: Padding(
    //               padding: const EdgeInsets.only(top: 8, bottom: 16, right: 30),
    //               child: Text(task.description ?? "",
    //                   overflow: TextOverflow.ellipsis,
    //                   maxLines: 2,
    //                   softWrap: true,
    //                   style:
    //                       const TextStyle(color: Colors.white, fontSize: 14)),
    //             ),
    //           ),
    //           const Text(
    //             "Time",
    //             // "Created at ${DateFormat.yMMMMd('en_US').format(item.createTime)}",
    //             style: TextStyle(color: Colors.white, fontSize: 11, height: 1),
    //           )
    //         ],
    //       )),
    // );
  }
}
