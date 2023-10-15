import "package:flutter/material.dart";
import "package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart";
import "package:provider/provider.dart";

import "../common/colors.dart";

class HomeViewTabScaffold extends StatefulWidget {
  const HomeViewTabScaffold({
    super.key,
    required this.tabs,
  });

  final List<HomeViewTabItem> tabs;

  @override
  State<HomeViewTabScaffold> createState() => _HomeViewTabScaffoldState();
}

class _HomeViewTabScaffoldState extends State<HomeViewTabScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor[100],
        elevation: 0,
        title: Text(
          widget.tabs[selectedIndex].name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.primaryColor,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Expanded(child: SizedBox()),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  context.read<AuthServiceProvider>().logout();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 48,
        width: 48,
        child: widget.tabs[selectedIndex].fabIcon != null &&
                widget.tabs[selectedIndex].fabOnPressed != null
            ? FloatingActionButton(
                onPressed: widget.tabs[selectedIndex].fabOnPressed,
                backgroundColor: AppColors.primaryColor[800],
                child: widget.tabs[selectedIndex].fabIcon!,
              )
            : null,
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.tabs.map((HomeViewTabItem tab) => tab.child).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        useLegacyColorScheme: false,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedLabelStyle: const TextStyle(
          color: AppColors.secondaryColor,
        ),
        items: widget.tabs.map((HomeViewTabItem tab) {
          final bool isSelectedTab = selectedIndex == widget.tabs.indexOf(tab);
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: 64,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelectedTab
                      ? AppColors.secondaryColorLight
                      : AppColors.primaryColor[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                    child: Theme(
                  data: ThemeData(
                    iconTheme: IconThemeData(
                      color: isSelectedTab
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                    ),
                  ),
                  child: isSelectedTab ? tab.activeIcon ?? tab.icon : tab.icon,
                )),
              ),
            ),
            label: tab.name,
          );
        }).toList(),
        onTap: (int index) {
          _tabController.animateTo(index);
        },
      ),
    );
  }
}

class HomeViewTabItem {
  const HomeViewTabItem({
    required this.name,
    required this.icon,
    this.activeIcon,
    required this.child,
    required this.fabIcon,
    required this.fabOnPressed,
  });
  final String name;
  final Widget icon;
  final Widget? fabIcon;
  final VoidCallback? fabOnPressed;
  final Widget? activeIcon;
  final Widget child;
}
