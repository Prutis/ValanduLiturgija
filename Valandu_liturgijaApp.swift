//
//  Valandu_liturgijaApp.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-02-09.
//

import SwiftUI
import UIKit

@main
struct Valandu_liturgijaApp: App {
    @AppStorage("naktis") var naktis:Bool = false
    @AppStorage("automode") var automode:Bool = false
    @AppStorage("darkas")  var darkas = false
    @AppStorage("bgcolor") var bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)

    //@Environment(\.colorScheme) var scheme
    let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
    init() {
        if(!automode) { darkas = naktis } else { darkas = (UIColor.myDarkas.accessibilityName == "dark red")}
         //   .environment(\.colorScheme, darkas ? .dark : .light)
      //  print("18V_D darkas,UIColor.myDarkas.accessibilityName",darkas, UIColor.myDarkas.accessibilityName)
    }
    var body: some Scene {
        WindowGroup {
    
            ContentView()
                .preferredColorScheme(darkas ? .dark : .light)
                .background(darkas ? Color.black : bgColor)
    
        }
}
}
extension UIColor {
    static var myDarkas: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                // Return one of two colors depending on light or dark mode
                //print("40V_D",traits.userInterfaceStyle == .dark)
                return traits.userInterfaceStyle == .dark ? UIColor.red : UIColor.green  }
        } else {
            // Same old color used for iOS 12 and earlier
            return UIColor.red}
    }
}


