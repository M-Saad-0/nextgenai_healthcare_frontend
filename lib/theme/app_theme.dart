// import 'package:flutter/material.dart';

// class AppThemes {
//   static const Color primaryColor = Color.fromARGB(255, 91, 31, 170);

//   static final ThemeData lightTheme = ThemeData(
//       primaryTextTheme: TextTheme(
//         titleLarge: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//         bodyMedium: const TextStyle(
//           fontSize: 14,
//           color: Colors.black87,
//         ),
//         displaySmall: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[700],
//         ),
//         labelSmall: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[600],
//         ),
//       ),
//       colorScheme: ColorScheme(
//           surfaceContainerLow: const Color.fromARGB(255, 241, 235, 235),
//           brightness: Brightness.light,
//           primary: AppThemes.primaryColor,
//           secondary: const Color(0xFF42A5F5),
//           tertiary: Colors.white,
//           surface: Colors.white,
//           error: Colors.red.shade700,
//           onPrimary: Colors.white,
//           onSecondary: Colors.black,
//           onError: Colors.white,
//           onTertiary: Colors.black87,
//           onSurface: Colors.black54,
//           onSurfaceVariant: const Color.fromARGB(255, 223, 223, 223)),
//       brightness: Brightness.light,
//       primaryColor: primaryColor,
//       scaffoldBackgroundColor: Colors.white,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       tabBarTheme: const TabBarTheme(
//           indicatorColor: primaryColor,
//           labelColor: Color.fromARGB(135, 0, 0, 0)),
//       floatingActionButtonTheme: const FloatingActionButtonThemeData(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           fixedSize: const Size(200, 50),
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white,
//           textStyle: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
      
//       textTheme: const TextTheme(
//         bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
//         bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
//         bodySmall: TextStyle(fontSize: 14, color: Colors.black45),
//         headlineLarge: TextStyle(
//             fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
//         labelSmall: TextStyle(fontSize: 18, color: Colors.black54),
//       ),
//       inputDecorationTheme: const InputDecorationTheme(
//         filled: true,
//         fillColor: Color(0xFFF2F2F2),
//         labelStyle: TextStyle(color: Colors.grey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(4)),
//           borderSide: BorderSide(color: Color(0xFFD6D6D6)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: primaryColor),
//         ),
//       ),
//       cardTheme: const CardTheme(
//         color: Colors.white,
//         elevation: 4,
//         shadowColor: Colors.black26,
//       ),
//       iconTheme: const IconThemeData(color: Colors.black87),
//       switchTheme: const SwitchThemeData(
//           thumbColor: WidgetStatePropertyAll<Color>(primaryColor)),
//       progressIndicatorTheme:
//           const ProgressIndicatorThemeData(color: primaryColor),
// listTileTheme: const ListTileThemeData(
//   titleTextStyle: TextStyle(color: Color.fromARGB(255, 46, 46, 46), fontSize: 15, fontWeight: FontWeight.w500),
//     subtitleTextStyle: TextStyle(color:  Color.fromARGB(255, 105, 105, 105)),
//     iconColor:   Color.fromARGB(255, 105, 105, 105)
//   ),
  
//           );

//   static final ThemeData darkTheme = ThemeData(
//     listTileTheme: const ListTileThemeData(
//       titleTextStyle:TextStyle(color:Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
//     subtitleTextStyle: TextStyle(color:  Color.fromARGB(255, 185, 185, 185)),
//     iconColor:   Color.fromARGB(255, 185, 185, 185)
//   ),
//       primaryTextTheme: TextTheme(
//         titleLarge: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white70,
//         ),
//         bodyMedium: const TextStyle(
//           fontSize: 14,
//           color: Colors.white70,
//         ),
//         bodySmall: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[400],
//         ),
//         labelSmall: TextStyle(
//           fontSize: 12,
//           color: Colors.grey[500],
//         ),
//       ),
//       colorScheme: ColorScheme(
//           brightness: Brightness.dark,
//           surfaceContainerLow: Colors.grey[850],
//           primary: AppThemes.primaryColor,
//           secondary: const Color(0xFF90CAF9),
//           tertiary: const Color(0xFF121212),
//           surface: const Color(0xFF1E1E1E),
//           error: Colors.red.shade700,
//           onPrimary: Colors.black,
//           onSecondary: Colors.white,
//           onError: Colors.black,
//           onTertiary: Colors.white70,
//           onSurface: Colors.white60,
//           onSurfaceVariant: const Color.fromARGB(255, 77, 77, 77)),
//       brightness: Brightness.dark,
//       primaryColor: primaryColor,
//       scaffoldBackgroundColor: const Color(0xFF121212),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Color(0xFF1F1F1F),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       tabBarTheme: const TabBarTheme(
//           indicatorColor: primaryColor,
//           labelColor: Color.fromARGB(136, 255, 255, 255)),
//       floatingActionButtonTheme: const FloatingActionButtonThemeData(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.black,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           fixedSize: const Size(200, 50),
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.black,
//           textStyle:
//               const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//       ),
//       textTheme: const TextTheme(
//         bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
//         bodyMedium: TextStyle(fontSize: 16, color: Colors.white60),
//         bodySmall: TextStyle(fontSize: 14, color: Colors.white54),
//         headlineLarge: TextStyle(
//             fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
//         labelSmall: TextStyle(fontSize: 18, color: Colors.white60),
//       ),
//       inputDecorationTheme: const InputDecorationTheme(
//         filled: true,
//         fillColor: Color(0xFF1F1F1F),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(4)),
//           borderSide: BorderSide(color: Color(0xFF424242)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: primaryColor),
//         ),
//       ),
//       cardTheme: const CardTheme(
//         color: Color(0xFF1E1E1E),
//         elevation: 4,
//         shadowColor: Colors.black54,
//       ),
//       iconTheme: const IconThemeData(color: Colors.white70),
//       switchTheme: const SwitchThemeData(
//           thumbColor: WidgetStatePropertyAll<Color>(primaryColor),
//           trackColor: WidgetStatePropertyAll<Color>(Colors.black),
//           overlayColor: WidgetStatePropertyAll<Color>(Colors.black),
//           trackOutlineColor: WidgetStatePropertyAll<Color>(Colors.white60)),
//       progressIndicatorTheme:
//           const ProgressIndicatorThemeData(color: primaryColor));
// }



import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFF1DA1F2); // Old Twitter blue

  static final ThemeData lightTheme = ThemeData(
    primaryTextTheme: TextTheme(
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontSize: 12,
        color: Colors.grey[700],
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
      ),
    ),
    colorScheme: ColorScheme(
      surfaceContainerLow: const Color(0xFFF5F8FA), // Twitter's light gray background
      brightness: Brightness.light,
      primary: AppThemes.primaryColor,
      secondary: const Color(0xFF657786), // Twitter's secondary gray
      tertiary: Colors.white,
      surface: Colors.white,
      error: Colors.red.shade700,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
      onTertiary: Colors.black87,
      onSurface: Colors.black87,
      onSecondaryFixedVariant: const Color.fromARGB(255, 231, 231, 231),
      onSurfaceVariant: const Color(0xFFE1E8ED), // Light gray for dividers
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor
    ),
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 1, // Slight shadow for Twitter's app bar style
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: primaryColor,
      labelColor: Colors.black87,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Rounded buttons like old Twitter
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(fontSize: 18, color: Colors.black54),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF5F8FA), // Twitter's light gray input background
      labelStyle: TextStyle(color: Colors.grey),
       prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      hintStyle: TextStyle(color: Colors.grey),
      iconColor: Color.fromARGB(195, 146, 145, 145),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFE1E8ED)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll<Color>(primaryColor),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: TextStyle(color: Color(0xFF657786)),
      iconColor: Color(0xFF657786),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: TextStyle(color: Color(0xFF8899A6)),
      iconColor: Color(0xFF8899A6),
    ),
    primaryTextTheme: TextTheme(
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.grey[400],
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        color: Colors.grey[500],
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      surfaceContainerLow: const Color(0xFF192734), // Twitter's dark gray
      primary: AppThemes.primaryColor,
      secondary: const Color(0xFF8899A6), // Twitter's dark mode secondary
      tertiary: const Color(0xFF15202B),
      surface: const Color(0xFF15202B), // Twitter's dark background
      error: Colors.red.shade700,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onTertiary: Colors.white,
      onSurface: Colors.white,
            onSecondaryFixedVariant: const Color.fromARGB(255, 17, 27, 36),

      onSurfaceVariant: const Color(0xFF2F3B47), // Darker gray for dividers
    ),

    brightness: Brightness.dark,
    bottomNavigationBarTheme:const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF15202B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF15202B),
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: primaryColor,
      labelColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 14, color: Colors.white60),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelSmall: TextStyle(fontSize: 18, color: Colors.white70),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF253341), // Twitter's dark input background
      hintStyle: TextStyle(color: Color.fromARGB(155, 194, 192, 192)),
      labelStyle: TextStyle(color: Color.fromARGB(155, 194, 192, 192)),
      prefixIconColor: Color.fromARGB(155, 167, 165, 165),
      suffixIconColor: Color.fromARGB(155, 167, 165, 165),
      iconColor: Color.fromARGB(255, 167, 165, 165),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFF2F3B47)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF192734),
      elevation: 1,
      shadowColor: Colors.black26,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll<Color>(primaryColor),
      trackColor: WidgetStatePropertyAll<Color>(Color(0xFF2F3B47)),
      overlayColor: WidgetStatePropertyAll<Color>(Color(0xFF2F3B47)),
      trackOutlineColor: WidgetStatePropertyAll<Color>(Colors.white70),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
  );
}