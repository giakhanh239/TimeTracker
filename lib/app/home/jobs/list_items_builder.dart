
import 'package:flutter/material.dart';
import 'package:time_tracker_code_with_andrea/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final ItemWidgetBuilder<T> itemBuilder;
  final AsyncSnapshot<List<T>> snapshot;

  const ListItemsBuilder({Key key, @required this.itemBuilder, @required this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5,),
      itemBuilder: (context, index) {
        if(index == 0 || index == items.length +1){
          return Container();
        }
        return itemBuilder(context, items[index-1]);
      });
  }
}
