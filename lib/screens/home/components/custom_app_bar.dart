import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSelectionMode;
  final int selectedCount;
  final Function onSearchChanged;
  final Function onSortPressed;
  final Function onCloseSelection;
  final Function onDeleteSelected;

  CustomAppBar({
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onSearchChanged,
    required this.onSortPressed,
    required this.onCloseSelection,
    required this.onDeleteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return isSelectionMode
        ? AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => onCloseSelection(),
            ),
            title: Text('$selectedCount seleccionadas'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: selectedCount == 0 ? null : () => onDeleteSelected(),
              ),
            ],
          )
        : AppBar(
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (query) => onSearchChanged(query),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () => onSortPressed(),
              ),
            ],
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
