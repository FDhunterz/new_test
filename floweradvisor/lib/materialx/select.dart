import 'dart:async';

import 'package:floweradvisor/materialx/base_widget.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:floweradvisor/materialx/form.dart';
import 'package:flutter/material.dart';


SelectData? _selectedData;
MultiSelectData? _multiSelectedData;

class Select {
  static Future<SelectData?> single({List<SelectData>? data, String? selectedId, required title, required context, SelectStyle? style, bool? withSearch = false, bool onlySelect = false, double? fontSize, bool isFull = false, bool fullScreen = true}) async {
    style ??= SelectStyle();
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    await Future.delayed(Duration.zero, () async {
      return showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) => SelectBase(
          fontSize: fontSize,
          withSearch: withSearch,
          data: data ?? [],
          selectedid: selectedId,
          title: title,
          style: style!,
          isFull: isFull,
          onlySelect: onlySelect,
          fullScreen: fullScreen,
        ),
      );
    });
    return _selectedData;
  }

  static Future<MultiSelectData?> multi({List<SelectData>? data, List<String>? selectedId, required title, required context, SelectStyle? style}) async {
    style ??= SelectStyle();
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    await Future.delayed(Duration.zero, () async {
      return showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) => MultiSelectBase(
          data: data ?? [],
          selectedid: selectedId,
          title: title,
          style: style!,
        ),
      );
    });
    return _multiSelectedData;
  }
}

class SelectBase extends StatefulWidget {
  final List<SelectData>? data;
  final String? selectedid;
  final String title;
  final SelectStyle style;
  final bool? withSearch;
  final bool onlySelect;
  final double? fontSize;
  final bool isFull;
  final bool fullScreen;
  const SelectBase({
    Key? key,
    this.data,
    this.selectedid,
    required this.title,
    required this.style,
    this.withSearch = true,
    this.onlySelect = false,
    this.fontSize,
    this.isFull = false,
    this.fullScreen = true,
  }) : super(key: key);

  static getSelectedData() {
    return _selectedData;
  }

  @override
  _SelectBase createState() => _SelectBase();
}

class _SelectBase extends State<SelectBase> {
  final _searching = MaterialXFormController(
      prefix: const Padding(
    padding: EdgeInsets.only(right: 6),
    child: Icon(Icons.search),
  ));

  selected(SelectData selectedData) {
    _selectedData = selectedData;
    Navigator.pop(context);
  }

  current(id) {
    _selectedData = null;
    if (id != null && id != '') {
      for (SelectData i in widget.data ?? []) {
        if (i.id == id) {
          _selectedData = i;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    current(widget.selectedid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.isFull ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(color: widget.style.backgroundColor ?? theme.colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: widget.fullScreen ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.35,
                    endIndent: MediaQuery.of(context).size.width * 0.35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Text(
                      '${widget.title} ',
                      style: TextStyle(
                        fontSize: widget.fontSize ?? 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  widget.withSearch!
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: MaterialXForm(
                                controller: _searching,
                                hintText: 'Pencarian...',
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                      : const SizedBox(),
                  widget.fullScreen
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: widget.data!.isEmpty
                                  ? []
                                  : widget.data!
                                      .where((SelectData value) => value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()))
                                      .map(
                                        (value) => ListTile(
                                          tileColor: widget.selectedid == value.id ? widget.style.selectedBackgroundTextColor ?? Colors.transparent : Colors.transparent,
                                          leading: widget.onlySelect
                                              ? null
                                              : Icon(
                                                  Icons.check,
                                                  color: widget.selectedid == value.id! ? widget.style.selectedTextColor ?? (theme.textTheme.bodyMedium != null ? theme.textTheme.bodyMedium!.color : Colors.green) : Colors.transparent,
                                                ),
                                          title: Text(value.title!, style: TextStyle(color: widget.selectedid == value.id ? widget.style.selectedTextColor ?? (theme.textTheme.bodyMedium != null ? theme.textTheme.bodyMedium!.color : Colors.green) : theme.textTheme.bodyMedium!.color)),
                                          onTap: () {
                                            selected(value);
                                          },
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: widget.data!.isEmpty
                                ? []
                                : widget.data!
                                    .where((SelectData value) => value.title!.toUpperCase().contains(_searching.controller!.text.toUpperCase()))
                                    .map(
                                      (value) => ListTile(
                                        tileColor: widget.selectedid == value.id ? widget.style.selectedBackgroundTextColor ?? Colors.transparent : Colors.transparent,
                                        leading: widget.onlySelect
                                            ? null
                                            : Icon(
                                                Icons.check,
                                                color: widget.selectedid == value.id! ? widget.style.selectedTextColor ?? (theme.textTheme.bodyMedium != null ? theme.textTheme.bodyMedium!.color : Colors.green) : Colors.transparent,
                                              ),
                                        title: Text(value.title!, style: TextStyle(color: widget.selectedid == value.id ? widget.style.selectedTextColor ?? (theme.textTheme.bodyMedium != null ? theme.textTheme.bodyMedium!.color : Colors.green) : theme.textTheme.bodyMedium!.color)),
                                        onTap: () {
                                          selected(value);
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectBase extends StatefulWidget {
  final List<SelectData>? data;
  final List<String>? selectedid;
  final String title;
  final SelectStyle style;
  const MultiSelectBase({
    Key? key,
    this.data,
    this.selectedid,
    required this.title,
    required this.style,
  }) : super(key: key);

  static getSelectedData() {
    return _selectedData;
  }

  @override
  _MultiSelectBase createState() => _MultiSelectBase();
}

class _MultiSelectBase extends State<MultiSelectBase> {
  List<ModelMultiSelect> _parseList = [];
  final List<String> _id = [], _name = [];
  List<ModelMultiSelect> _filterList = [];
  Timer? delay;

  selected(name, id, active) {
    bool _activated = false;
    if (!active) {
      _id.add(id);
      _name.add(name);
      _activated = true;
    } else {
      _id.remove(id);
      _name.remove(name);
      _activated = false;
    }

    for (var i in _parseList) {
      if (i.id == id) {
        i.active = _activated;
      }
    }

    setState(() {});
  }

  parse() {
    List<String> selectedId = widget.selectedid ?? [];
    _parseList = [];

    if (widget.data != null) {
      if (widget.data is List) {
        for (SelectData i in widget.data ?? []) {
          bool _havevalue = false;
          for (String j in selectedId) {
            if (i.id == j) {
              _id.add(i.id!);
              _name.add(i.title!);
              _havevalue = true;
              break;
            }
          }
          _parseList.add(ModelMultiSelect(
            active: _havevalue,
            id: i.id,
            name: i.title,
          ));
        }
        _filterList = _parseList;
      }
    }
  }

  @override
  void initState() {
    _multiSelectedData = null;
    _parseList.clear();
    _id.clear();
    _name.clear();
    super.initState();
    parse();
  }

  @override
  Widget build(BuildContext context) {
    return InitControl(
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    color: const Color(0xff00A2E9).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xff828282),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        '${widget.title} ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: MaterialXForm(
                        controller: MaterialXFormController(),
                        hintText: 'Pencarian...',
                        onChanged: (val) {
                          if (delay != null) {
                            delay!.cancel();
                          }
                          delay = Timer(
                            const Duration(milliseconds: 400),
                            () {
                              _parseList = _filterList.where((e) => e.name!.toUpperCase().contains(val.toUpperCase())).toList();
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _parseList.length,
                        itemBuilder: (context, index) {
                          var value = _parseList[index];
                          return ListTile(
                            leading: Icon(
                              Icons.check,
                              color: value.active == true ? Colors.blue : Colors.transparent,
                            ),
                            title: Text(value.name ?? '', style: TextStyle(color: value.active == true ? Colors.blue : Theme.of(context).textTheme.bodyMedium?.color)),
                            onTap: () {
                              selected(value.name ?? '', value.id, value.active);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: MaterialXButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        title: 'Pilih',
                        onTap: () {
                          _multiSelectedData = MultiSelectData(
                            id: _id,
                            title: _name,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectResult {
  final TextEditingController name = TextEditingController();
  String? id;
}

class SelectData {
  final Map<String, dynamic>? objectData;
  final List? listData;
  final String? title;
  final String? id;
  final dynamic data;

  parse<T>() {
    return data as T;
  }

  SelectData({this.id, this.listData, this.objectData, this.title, this.data});
}

class SelectStyle {
  Color? backgroundColor,

      /// default Theme.of(context).textTheme.caption || Colors.green
      selectedTextColor,
      // default Colors.Transparent
      selectedBackgroundTextColor;
  SelectStyle({this.backgroundColor, this.selectedBackgroundTextColor, this.selectedTextColor});
}

class MultiSelectData {
  List<String>? title;
  List<String>? id;
  List<Map<String, dynamic>>? objectData;
  List<List>? listData;

  MultiSelectData({this.id, this.listData, this.objectData, this.title});
}

class ModelMultiSelect {
  String? id, name;
  bool? active;

  ModelMultiSelect({this.id, this.name, this.active});
}
