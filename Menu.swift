//
//  Menu.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-02-18.
//

import SwiftUI

struct Menu: View {
    @AppStorage("selectedTab")  var selectedTab = 1
    @AppStorage("param") var param:String = "<script>document.getElementsByTagName( 'body' )[0].style['font-size'] = '120.0%';document.getElementsByTagName( 'body' )[0].style['font-family']='Arial';zoom =120.0;document.getElementsByTagName( 'body' )[0].style['color']='#2F2D29';document.getElementsByTagName( 'body' )[0].style['background-color']='#FBF5E1'; tamsa=false;hbgColor ='#FBF5E1'; Naktis();  garbed(false);  antrasch(false,false);  scrollp(100.0,120.0);  fmygt(true,true,false,false,true,false,false); </script></html>"
    @AppStorage("mnr") var mnr:Int = 99
    @AppStorage("selectedId") var selectedId:Int = 0
    @AppStorage("sapkat") var sapkat: String = ""
    @AppStorage("zoom") var zoom: Double = 100
    @AppStorage("data3s")  var data3s: String = "2021/01/01"
    @AppStorage("naktis") var naktis:Bool = false
    @AppStorage("automode") var automode:Bool = false
    @AppStorage("darkas")  var darkas = false
    @State var murl: URL = URL(string: "https://lk.katalikai.lt/")!
    @State private var isPresented = true
    var contents :String = ""
    var c3 :String = ""
    var pohtml: String = ""
    var prhtml: String = ""
    var apie: String = ""
    var path = ""

    static var appVersion: String? {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        }
    static var appVersion2: String? {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        }
    var appv = Menu.appVersion! + " (" + Menu.appVersion2! + ")"
    var duomenys = Duomenys()
    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    init() {
        mnr = 99
    }

    var body: some View {
        if mnr == 99 {
            
        ScrollView(.vertical){
 
            VStack {
            Text("PASIRINKITE VALANDĄ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Divider()
                    Group{
                        HStack {
                    Image(systemName: "rectangle.righthalf.inset.fill.arrow.right")
                        Text("Įžanga")
                        }
                    .foregroundColor(selectedId == 0 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 0
                        self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accentColor(selectedId == 0 ? .red : .black)
                    .padding(.horizontal)
                        Divider()
                        HStack {
                    Image(systemName: "book")
                    Text("Aušrinė") }
                    .foregroundColor(selectedId == 1 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 1
                        self.selectedTab = 0
                        //print("Menu_ausrine_D",dtime())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                        Divider()
                    HStack {
                    Image(systemName: "sunrise")
                    Text("Rytmetinė") }
                    .foregroundColor(selectedId == 2 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 2
                    self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                        Divider()
                        HStack {
                    Image(systemName: "sun.max")
                    Text("Priešpiečio") }
                    .foregroundColor(selectedId == 3 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 3
                    self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                        Divider()
                HStack {
                    Image(systemName: "sun.max")
                    Text("Vidudienio") }
                    .foregroundColor(selectedId == 4 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 4
                        self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                        Divider()
                    }
            Group {
                HStack {
                    Image(systemName: "sun.max")
                    Text("Pavakario") }
                    .foregroundColor(selectedId == 5 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 5
                        self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                        Divider()
                HStack {
                    Image(systemName: "sunset")
                    Text("Vakarinė") }
                    .foregroundColor(selectedId == 6 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 6
                        self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                        Divider()
                HStack {
                    Image(systemName: "moon")
                    Text("Naktinė") }
                    .foregroundColor(selectedId == 7 ? Color.red : Color.primary)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mnr = 99
                        selectedId = 7
                        self.selectedTab = 0
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    }

        
            Group {
            Divider()
            HStack {
                        Image(systemName: "book.circle")
                        Text("Mišių skaitiniai") }
                .foregroundColor(selectedId == 9 ? Color.red : Color.primary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            var contents :String = ""
                            var c3 :String = ""
                            contents = readlk(d3s: data3s)
                            if let range = contents.range(of: "/_dls/") {
                               let c2 = contents[range.lowerBound...]
                            if let range2 = c2.range(of: ".html") {
                                c3 =  c2[..<range2.lowerBound] + ".html"
                                let katalikai:URL = URL(string: "https://lk.katalikai.lt"+c3)!
                                var components = URLComponents()
                                components.scheme = "https"
                                components.host = "lk.katalikai.lt"
                                components.path =  c3
                                murl = components.url ?? katalikai
                            }}
                            mnr = 9
                            selectedId = 9
                        self.selectedTab = 1
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
            Divider()
                    HStack {
                        Image(systemName: "calendar")
                        Text("Liturginis kalendorius") }
                        .foregroundColor(selectedId == 10 ? Color.red : Color.primary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            mnr = 10
                            selectedId = 10
                            self.selectedTab = 1
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
            Divider()
        }
            Group {
        
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Apie šią programėlę  Ver: " + appv ) }
                        .foregroundColor(selectedId == 8 ? Color.red : Color.primary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                             mnr = 8
                             selectedId = 8
                                self.selectedTab = 1
                           // Apie()
                        }
                        }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

    }
            .padding(.top, 1) //VStack pabaiga
        }
        .padding(5)
        } else {                 //mnr ! 99
                ZStack {

                    if mnr == 8 {
                        VStack {
                            HStack {
                                Image(systemName: "filemenu.and.cursorarrow")
                                Text("Sugrįžti į menu...") }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                     mnr = 99
                                     selectedId = 8
                                        self.selectedTab = 1
                                }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        WebView(html: duomenys.prhtml+duomenys.apie+duomenys.pohtml+param)
                    .frame(maxWidth: .infinity)
                        } //Vstack
                } //mnr=8
                    if mnr == 9 {
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "filemenu.and.cursorarrow")
                                Text("Sugrįžti į menu...") }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                     mnr = 99
                                     selectedId = 9
                                        self.selectedTab = 1
                                }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                           
                        WebView2(url: murl, zoom: zoom)
                                .frame(maxWidth: .infinity)
 
                            
                        }
                    }
                    
                if(mnr == 10) {
                    VStack {
                        HStack {
                            Image(systemName: "filemenu.and.cursorarrow")
                            Text("Sugrįžti į menu...") }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                 mnr = 99
                                 selectedId = 10
                                    self.selectedTab = 1
                            }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    WebView3(url: URL(string: "https://lk.katalikai.lt/")!)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        
                }
                } //10
                } //Zstack
                .padding(.top, 1)
               
            
        } //else
    }        //some view
    
       
    
    
    
    func readlk(d3s: String) -> String {
        var contents : String = ""
        if let url = URL(string: "https://lk.katalikai.lt/" + d3s) {
            
            do {
                contents = try String(contentsOf: url)
                
            } catch {
             //   misios = "<h2>Nepavyko prisijungti prie https://lk.katalikai.lt/" + data3s + "</h2>"
            }
        }
        return contents
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}

