import 'package:flutter/material.dart';
import 'fridge_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Keeps track of the current page
  int _selectedIndex = 0;

  // Update the current selected page
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List events = ['Event 1', 'Event 2', 'secondpage'];

    // All the main pages we have
    final List pages = [
      // Homepage
      FridgeScreen(),
      
      // Eventpage

      // ChangeNotifierProvider(
      //   create: (context) => EventViewmodel(
      //     eventRepository: context.read<EventRepository>(),
      //   )..load(),
      //   child: EventsScreen(),
      // ),
      // EventsScreen(),
      // // Infopage
      // InfoPage(),

    ];


    return Scaffold(
      backgroundColor:const Color.fromRGBO(0, 29, 54, 100),
      appBar: AppBar(
        // title: Text("Event Compagnion"),
        backgroundColor: Colors.transparent,
        ),
      // drawer: Drawer(),

      body: pages[_selectedIndex],
      






      // body: Center(
      //   child: ElevatedButton(
      //     child: Text("Go to second page"),
      //     onPressed: () {
      //       // Navigate to second page
      //       // Navigator.push(
      //       //   context, 
      //       //   MaterialPageRoute(
      //       //     builder: (context) => SecondPage(),));
            
      //       // Navigator.pushNamed(context, '/secondpage');
      //       Navigator.pushNamed(context, '/'+events[2]);
      //     },
      //   ),
      // ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: EdgeInsets.all(0),
        
        decoration: BoxDecoration(
          color: Color.fromRGBO(245, 245, 245, 0.8),
          borderRadius: BorderRadius.circular(32),
        ),
        
        child: BottomNavigationBar(
          // Styling
          // selectedItemColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedLabelStyle: TextStyle(fontSize: 16, height: 0, color:Color.fromRGBO(207, 72, 72, 1)),
          unselectedLabelStyle: TextStyle(fontSize: 14, height: 0),

          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: [
            // Home
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Fridge',
            ),
        
            // // Events
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.event),
            //   label: 'Events',
            // ),
        
            // // Info
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.info_outline),
            //   label: 'Info',
            // ),
          ]
        ),
      ),
      

    );
  }
}