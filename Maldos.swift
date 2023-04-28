//
//  Maldos.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-02-10.
//

import SwiftUI
import WebKit
//import SnapToScroll



struct Maldos: View {
    
    @AppStorage("param") var param:String = "<script>document.getElementsByTagName( 'body' )[0].style['font-size'] = '120.0%';document.getElementsByTagName( 'body' )[0].style['font-family']='Arial';zoom =120.0;document.getElementsByTagName( 'body' )[0].style['color']='#2F2D29';document.getElementsByTagName( 'body' )[0].style['background-color']='#FBF5E1'; tamsa=false;hbgColor ='#FBF5E1'; Naktis();  garbed(false);  antrasch(false,false);  scrollp(100.0,120.0);  fmygt(true,true,false,false,true,false,false); </script></html>"
    @AppStorage("mnr") var mnr:Int = 99
    @AppStorage("zoom") var zoom: Double = 100
    @AppStorage("greitis") var greitis: Double = 100
    @AppStorage("data3s")  var data3s: String = "2021/01/01"
    @AppStorage("sapkat") var sapkat: String = ""
    @AppStorage("sapkav") var sapkav: String = ""
    @AppStorage("sapkan") var sapkan: String = ""
    @AppStorage("selectedId") var selectedId:Int = 0
    @AppStorage("ausrin") var ausrin: String = ""
    @AppStorage("izang") var izang: String = ""
    @AppStorage("naktin") var naktin: String = ""
    @AppStorage("pavak") var pavak: String = ""
    @AppStorage("priesp") var priesp: String = ""
    @AppStorage("rytmet") var rytmet: String = ""
    @AppStorage("vakar") var vakar: String = ""
    @AppStorage("vidut") var vidut: String = ""
    @AppStorage("colorV") var colorV: String = ""
    @AppStorage("lit_colorx") var lit_colorx: String = "green"
    @AppStorage("selectedTab")  var selectedTab = 0
    @AppStorage("sav_diena")  var sav_diena: Int = 0
    @AppStorage("nakt_d") var nakt_d:String = "0"
    @AppStorage("lit_per") var lit_per: String = "eil"
    @AppStorage("MMdd")  var MMdd: String = "0101"
    @AppStorage("darkas")  var darkas = false
    @AppStorage("pilnas") var pilnas: Bool = false
    @AppStorage("lit_laikas2") var lit_laikas2: String = ""
    @AppStorage("bgcolor") var bgColor: Color = Color(.sRGB, red: Double(251)/255.0, green: Double(245)/255.0, blue: Double(225)/255.0)

    var duomenys = Duomenys()

    var misios: String = ""
    var mscript: String = ""
    var path = ""

    @State var slinkis: Bool = false
    @State var noti: Bool = true
    @State var js: String = ""
    //var CV = ContentView()

    var murl: URL = URL(string: "https://lk.katalikai.lt/")!

    var contents :String = ""
    var c3 :String = ""
    //@ObservedObject private var fetch = Fetch()
    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }

    init() {
      //  print( 63,"Maldos_init()_D",dtime(),self.selectedTab,mnr)
       // print("M80_D",sapkat)
    }

    var body: some View {

        ZStack {
            ScrollView(.horizontal, showsIndicators: false ) {
                        ScrollViewReader { proxy in
                        HStack(alignment: .center, spacing: 10) {

                            WebView(html: duomenys.prhtml+sapkat+izang+duomenys.pohtml+param,bgColor: (darkas ? .black : bgColor))
                    .frame(width: UIScreen.main.bounds.size.width)
                        .gesture(
                            TapGesture(count: 1)
                                                .onEnded { _ in
                                                    selectedId = 0
                                                            proxy.scrollTo(selectedId)
                                                })
                        .id(0) 
                    WebView(html: duomenys.prhtml+sapkat+ausrin+duomenys.pohtml+param,bgColor: (darkas ? .black : bgColor))
                    .frame(width: UIScreen.main.bounds.size.width)
                    .gesture(
                        TapGesture(count: 1)
                                            .onEnded { _ in
                                                selectedId = 1
                                                        proxy.scrollTo(selectedId)
                                            })
                        .id(1)
                    WebView(html: duomenys.prhtml+sapkat+rytmet+duomenys.pohtml+param,bgColor: (darkas ? .black : bgColor))
                    .frame(width: UIScreen.main.bounds.size.width)
                    .gesture(
                        TapGesture(count: 1)
                                            .onEnded { _ in
                                                selectedId = 2
                                                        proxy.scrollTo(selectedId)
                                            })
                    .id(2)
                    WebView(html: duomenys.prhtml+sapkat+priesp+duomenys.pohtml+param+duomenys.podprp,bgColor: (darkas ? .black : bgColor))
 
                    .frame(width: UIScreen.main.bounds.size.width)
                    .gesture(
                        TapGesture(count: 1)
                                            .onEnded { _ in
                                                selectedId = 3
                                                        proxy.scrollTo(selectedId)
                                            })
                    .id(3)
                    WebView(html: duomenys.prhtml+sapkat+vidut+duomenys.pohtml+param+duomenys.podvip,bgColor: (darkas ? .black : bgColor))
                    .frame(width: UIScreen.main.bounds.size.width)

                    .onTapGesture(count: 1) {  selectedId = 4
                        proxy.scrollTo(selectedId)
                        // print("_D",sapkat)
                    }
                        .id(4)
                    WebView(html: duomenys.prhtml+sapkat+pavak+duomenys.pohtml+param+duomenys.podpap,bgColor: (darkas ? .black : bgColor))
                    .frame(width: UIScreen.main.bounds.size.width)

                        .onTapGesture(count: 1) {  selectedId = 5
                            proxy.scrollTo(selectedId)
                        }
                        .id(5)
                            WebView(html: duomenys.prhtml+sapkav+vakar+duomenys.pohtml+param,bgColor: (darkas ? .black : bgColor))
                        .frame(width: UIScreen.main.bounds.size.width)
                        .gesture(
                            TapGesture(count: 1)
                                                .onEnded { _ in
                                                   // print("_D",duomenys.prhtml)
                                                   // print("_D",sapkav)
                                                    //print("_D",vakar)
                                                   // print("_D",duomenys.pohtml)
                                                    //print("_D",param)
                                                    
                                                    selectedId = 6
                                                            proxy.scrollTo(selectedId)
                                                })
                        .id(6)
                    WebView(html: duomenys.prhtml+sapkan+"<script> var puslp ='nakt'; var nakt_d='" + nakt_d + "'; var diena=" + String(sav_diena) + ";var lit_laikas2='" + lit_laikas2 + "'; var MMdd='" + MMdd + "';</script>" + naktin+duomenys.pohtml+param,bgColor: (darkas ? .black : bgColor))
                        .frame(width: UIScreen.main.bounds.size.width)

                        .onTapGesture(count: 1) {  selectedId = 7
                            proxy.scrollTo(selectedId)   }
                        .id(7)

                } //hstack
                        .padding(.horizontal, 2)
                        .edgesIgnoringSafeArea(.all)
                        .statusBar(hidden: pilnas)
                        .onAppear() {
                            //print("M139_D",param)
                            self.selectedTab = 0
                            proxy.scrollTo(selectedId)
                        }

                }
                //scrollviewreader
                   // .onPreferenceChange(wtop) { value in
                   //                 print(value)
                   //            }
  

                }
                    //.disabled(true) .horizontal
            // scrollview
                
        } //Zstack

    } //some view
    
    
    

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

struct Maldos_Previews: PreviewProvider {
    static var previews: some View {
        Maldos()
       
    }
}
