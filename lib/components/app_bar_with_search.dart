import 'package:flutter/material.dart';
import 'package:pokedex_tracker/constants/color.dart';

class AppBarWithsearch extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final PreferredSizeWidget? bottom;
  final Function(String value, BuildContext context) search;
  const AppBarWithsearch({super.key, required this.title, this.bottom, required this.search}) : 
    preferredSize = const Size.fromHeight(112);

  @override
  State<AppBarWithsearch> createState() => _AppBarWithsearchState();
  
  @override
  final Size preferredSize;
}

class _AppBarWithsearchState extends State<AppBarWithsearch> {
  final TextEditingController _textController = TextEditingController();

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title:  widget.title,
      bottom: searchBox(),
    );
  }

  PreferredSizeWidget searchBox() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(32),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: appBarTextColor,
          borderRadius: BorderRadius.circular(24)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => FocusScope.of(context).unfocus(),
              ),
              hintText: 'Search',
              border: InputBorder.none,
            ),
            onChanged: (value) => widget.search(value, context),
            onSubmitted: (value) => widget.search(value, context),
          ),
        ),
      ),
    );
  }
}