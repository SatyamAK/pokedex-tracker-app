import 'package:flutter/material.dart';

class AppBarWithsearch extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final PreferredSizeWidget? bottom;
  final Function(String value, BuildContext context) search;
  const AppBarWithsearch({super.key, required this.title, this.bottom, required this.search}) : 
    preferredSize = (bottom != null)?const Size.fromHeight(84):const Size.fromHeight(52);

  @override
  State<AppBarWithsearch> createState() => _AppBarWithsearchState();
  
  @override
  final Size preferredSize;
}

class _AppBarWithsearchState extends State<AppBarWithsearch> {
  bool _isSearching = false;
  final TextEditingController _textController = TextEditingController();

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title:  (_isSearching)?searchBox():widget.title,
      bottom: widget.bottom,
      actions: [
        IconButton(
          onPressed: ()=>{
            setState(() {
              _isSearching = !_isSearching;
            })
          },
          icon: Icon(
            (_isSearching)?Icons.cancel_outlined:Icons.search
          )
        )
      ],
    );
  }

  Widget searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
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
            hintText: 'Bulbasaur...',
            border: InputBorder.none,
          ),
          onChanged: (value) => widget.search(value, context),
          onSubmitted: (value) => widget.search(value, context),
        ),
      ),
    );
  }
}