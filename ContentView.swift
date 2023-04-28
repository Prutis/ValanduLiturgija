//
//  ContentView.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-02-09.
//

import SwiftUI


struct ContentView: View {

  //  @AppStorage("bgcolor") var bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)
  //  @AppStorage("naktis") var naktis:Bool = false
    @AppStorage("selectedTab")  var selectedTab = 0
    @AppStorage("datas") var datas: String = "2021-01-24"
    @AppStorage("lit_color") var lit_color: String = "green"
    @AppStorage("lit_colorx") var lit_colorx: String = "green"
    @AppStorage("colorV") var colorV: String = ""

    @AppStorage("selectedId") var selectedId:Int = 0
    @AppStorage("mnr") var mnr:Int = 99
    @AppStorage("pirmas") var pirmas:Int = 0
    @AppStorage("automode") var automode:Bool = false
    @AppStorage("darkas")  var darkas = false
    @AppStorage("naktis") var naktis:Bool = false
    @AppStorage("pilnas") var pilnas: Bool = false
    let tabBar = UITabBar.appearance()
    @State var tabColor:Color = .red
    var datasx: String = "2021-01-24"
    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    init () {
     
        lit_colorx = lit_color
        colorV = lit_color
        mnr = 99
        selectedId = 0 //izanga
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if (hour >= 21) {selectedId = 7} //naktine
        if (hour < 21 && hour >= 18 ) {selectedId = 6} //vakarine
        if (hour < 18 && hour >= 15 ) {selectedId = 5} //pavakario
        if (hour < 15 && hour >= 12 ) {selectedId = 4}  //vidudienio
        if (hour < 12  && hour >= 9 ) {selectedId = 3} //priespiecio;
        if (hour < 9 && hour >= 6 ) {selectedId = 2} //rytmetine;
        if (hour < 6) {selectedId = 1} //ausrine";
        let formatter = DateFormatter()
        formatter.locale =  Locale(identifier: "lt_LT")
        formatter.dateFormat = "yyyy-MM-dd"
        self.datasx = formatter.string(from: date)
        pilnas = false
        var nust = Nustatymai()
        nust.paramf2()
        if datasx != datas {
         //   Kraunas()
            //print(50,"ContentView_init_2_D",dtime(),datas,datasx)
            Kalendorius().data = Date()
            Kalendorius().setDateString()
            Kalendorius().sapka()
            lit_colorx = lit_color
            selectedId = 0
        }
        
        self.selectedTab = pirmas
        
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.barTintColor = UIColor(Color(lit_colorx ))
        UITabBar.appearance().backgroundColor = UIColor(Color(lit_colorx))
        if lit_colorx == "rose" {tabColor = Color("rose-a")}
        if lit_colorx == "red" {tabColor = Color("red-a")}
        if lit_colorx == "green" {tabColor = Color("green-a")}
        if lit_colorx == "gold" {tabColor = Color("gold-a")}
        if lit_colorx == "purple" {tabColor = Color("purple-a")}

    }
    
    var body: some View {

        TabView(selection: $selectedTab) {
            Maldos()
                .fullScreenCover(isPresented: $pilnas, content: Maldos.init)
                .tabItem {
                    Image(systemName: "book")

                    Text("Malda") }
                .tag(0)
                .onAppear(){
                        mnr = 99
                        self.selectedTab = 0 }
            Menu()
                .tabItem {
                    Image(systemName: "filemenu.and.cursorarrow")
                    Text("Valandos")
                }
                .tag(1)

                .onAppear() {
                  //      mnr = 99
                        self.selectedTab = 1 }
            Kalendorius()
                .tabItem {
                    Image(systemName: "calendar")
                    Text(datas) }
                .tag(2)
                .onAppear() {
                        self.selectedTab = 2
                   }
            Nustatymai()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Nustatymai") }
                .tag(3)
                .onAppear() {
                        self.selectedTab = 3
                   }
        }
        .accentColor(tabColor)
        .onAppear() {
            setTabViewBackground()
                
        }
        .id(selectedTab)
        
    }
       
        
    func setTabViewBackground() {
        tabBar.barTintColor = UIColor(Color((selectedId < 6) ? lit_colorx : colorV))
        //print("setTabViewBackground _D",lit_colorx,colorV,selectedId, dtime())
        if selectedId < 6 {
            if lit_colorx == "rose" {tabColor = Color("rose-a")}
            if lit_colorx == "red" {tabColor = Color("red-a")}
            if lit_colorx == "green" {tabColor = Color("green-a")}
            if lit_colorx == "gold" {tabColor = Color("gold-a")}
            if lit_colorx == "purple" {tabColor = Color("purple-a")}
            UITabBar.appearance().backgroundColor = UIColor(Color(lit_colorx))
        } else {
            if colorV == "rose" {tabColor = Color("rose-a")}
            if colorV == "red" {tabColor = Color("red-a")}
            if colorV == "green" {tabColor = Color("green-a")}
            if colorV == "gold" {tabColor = Color("gold-a")}
            if colorV == "purple" {tabColor = Color("purple-a")}
            UITabBar.appearance().backgroundColor = UIColor(Color(colorV))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Kraunas  : View {
    var body: some View {
            Text("Formuojasi šios dienos maldos..")
        }
}
