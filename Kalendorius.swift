//
//  Calendar.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-02-26.
//

import SwiftUI

struct Kalendorius: View {

    @AppStorage("datas") var datas: String = "2021-01-24"
    @AppStorage("datasx") var datasx: String = "2021-01-24"
    @AppStorage("metai") var metai: String = "2021"
    @AppStorage("menuo") var menuo: Int = 1
    @AppStorage("menuop") var menuop: String = "Sausio"
    @AppStorage("mdiena") var mdiena: Int = 1
    @AppStorage("sdiena") var sdiena: Int = 1
    @AppStorage("sdienap") var sdienap: String = "Pirmadienis"
    @AppStorage("sapkat") var sapkat: String = ""
    @AppStorage("sapkav") var sapkav: String = ""
    @AppStorage("sapkan") var sapkan: String = ""
    @AppStorage("pnr") var pnr: Int = 0 //pasirinkimas ka publikuoti
    @AppStorage("eil_sav") var eil_sav: Int = 0
    @AppStorage("savaite") var savaite: Int = 0
    @AppStorage("selectedTab")  var selectedTab = 2

    @State  var data = Date()
    @AppStorage("data2s")  var data2s: String = "210101"
    @AppStorage("data3s")  var data3s: String = "2021/01/01"
    @AppStorage("data_md")  var data_md: Int = 1
    @AppStorage("kal_md")  var kal_md: Int = 359
    @AppStorage("vel_md")  var vel_md: Int = 120
    @AppStorage("pas_md")  var pas_md: Int = 330
    @AppStorage("krk_md")  var krk_md: Int = 7
    @AppStorage("kra_md")  var kra_md: Int = 6
    @AppStorage("lit_laikas") var lit_laikas: String = " Eilinis"
    @AppStorage("lit_laikas2") var lit_laikas2: String = ""
    @AppStorage("lit_color") var lit_color: String = "green"
    @AppStorage("lit_colorx") var lit_colorx: String = "green"
    @AppStorage("lit_color_m") var lit_color_m: String = "green"
    @AppStorage("lit_per_sp") var lit_per_sp: String = "green"
    @AppStorage("lit_per") var lit_per: String = "eil"
    @AppStorage("sv0") var sv0: String = ""
    @AppStorage("sv1") var sv1: String = ""
    @AppStorage("sv2") var sv2: String = ""
    @AppStorage("metur") var metur: String = "A"
    @AppStorage("sp0") var sp0: String = "gold"
    @AppStorage("sp1") var sp1: String = "gold"
    @AppStorage("sp2") var sp2: String = "gold"
    @AppStorage("ikkr") var ikkr: String = ""
    @AppStorage("iskk") var iskk: String = ""
    @AppStorage("MMdd")  var MMdd: String = "0101"
    @AppStorage("MMddr")  var MMddr: String = "0101"
    @AppStorage("krk")  var krk:String = "0106"
    @AppStorage("ausrin") var ausrin: String = ""
    @AppStorage("tipas") var tipas: String = ""
    @AppStorage("tipasp") var tipasp: String = ""
    @AppStorage("ratas") var ratas: Bool = false
    @AppStorage("mnr") var mnr:Int = 99
    @AppStorage("colorV") var colorV: String = ""
    
    @State  var lsk: Int = 0
    @State  var sv_pavad = ["", "", ""]
    @State  var sv_spalva = ["gold", "gold", "gold"]
    @State  var pi: Bool = true
    @AppStorage("sav_diena")  var sav_diena: Int = 0
    @AppStorage("laikasV")  var laikasV: String = ""
    @AppStorage("selectedId") var selectedId:Int = 0
    @AppStorage("risk_pav") var risk_pav = ""
    @AppStorage("risk_sp") var risk_sp = ""
    @State  var dataei = ""

    
    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }

    init() {
      //  print(83,"Kalendorius_init()_D",dtime(),self.selectedTab)
    }
    
    private var selectedDate: Binding<Date> {
      Binding<Date>(get: { self.data}, set : {
          self.data = $0
          self.setDateString()
        
      })
    }
    func setDateString() {
        //print(107,"Kalendorius_setDateString()_D",dtime(),mnr)
        lit_colorx = lit_color
        colorV = lit_color
        sv_pavad[0] = sv0
        sv_pavad[1] = sv1
        sv_pavad[2] = sv2
        sv_spalva[0] = sp0
        sv_spalva[1] = sp1
        sv_spalva[2] = sp2
        let formatter = DateFormatter()
        formatter.locale =  Locale(identifier: "lt_LT")
        formatter.dateFormat = "yyyy-MM-dd"
        self.datasx = formatter.string(from: data)
        self.dataei = formatter.string(from: Date())
    
        formatter.dateFormat = "yyyy"
        self.metai = formatter.string(from: data)
        formatter.dateFormat = "MMMM"
        self.menuop  = formatter.string(from: data)
        formatter.dateFormat = "EEEE"
        self.sdienap  = formatter.string(from: data)
        formatter.dateFormat = "dd"
        self.mdiena  = Int(formatter.string(from: data))!
        formatter.dateFormat = "MM"
        self.menuo  = Int(formatter.string(from: data))!
        formatter.dateFormat = "e"
        self.sdiena  = Int(formatter.string(from: data))!
        formatter.dateFormat = "yyMMdd"
        self.data2s  = formatter.string(from: data)
        formatter.dateFormat = "yyyy/MM/dd"
        self.data3s  = formatter.string(from: data)
        let ryt = Calendar.current.date(byAdding: .day, value: 1, to: data)
        formatter.dateFormat = "MMdd"
        self.MMdd  = formatter.string(from: data)
        self.MMddr  = formatter.string(from: ryt ?? data)
        sav_diena = Calendar.current.component(.weekday, from: data) - 1
        Liturginis()

}
    var body: some View {
        VStack() {
        Form {
            Section(header: Text("Pasirinkite Valandų liturgijos datą:")) {
                VStack {
                    if ratas {
                    DatePicker(
                        selection: selectedDate,
                        displayedComponents: .date,
                       label: { Text("") }
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .onAppear() {       let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm"
                        data = formatter.date(from: datasx + " 15:31") ?? Date() }
                    } else {
                        DatePicker(
                            selection: selectedDate,
                            displayedComponents: .date,
                           label: { Text("") }
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .onAppear() {       let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm"
                            data = formatter.date(from: datasx + " 15:31") ?? Date() }
                    }
                }

                HStack {
                    Spacer()
                Button("Šiandien"){data = Date()
                    setDateString()
                }
                .frame(width: 100, height: 22, alignment: .center)
                .background(Color(.white))
                .foregroundColor(.red)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                )
                .font(.footnote)
                    Spacer()
               }
  }

            Section(header: Text("Jūsų pasirinkimas paspaudimu:" )
                        .font(.footnote) ) {
                VStack {
                HStack { Text(metai + " m. " + menuop).font(.footnote)
                    Text(String(mdiena) + " d., " + sdienap).font(.footnote) }
                    Text(lit_laikas).font(.subheadline)
                    if(!lit_laikas2.isEmpty && iskk != "pel") {
                        Text(lit_laikas2).font(.footnote)
                            .foregroundColor(.red)
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width/1.2)
                .background(Color(lit_color_m))
                .foregroundColor(.white)
                .border(pnr == 1 ? Color(alter_c(cc: lit_color_m)) :Color(lit_color_m), width: 3)
                .cornerRadius(10)
                .contentShape(Rectangle())
                .onTapGesture {lit_colorx = lit_color_m
                    colorV = lit_colorx
                    tipas = tipasp
                    pnr = 1
                    sapka()
                }
                //laisvi minėjimai

                if(!sv0.isEmpty) {
                    Text(sv0)
                        .frame(width: UIScreen.main.bounds.width/1.2)
                        .background(Color(sp0))
                        .foregroundColor(.white)
                        .border(pnr == 2 ? Color(alter_c(cc: sp0)) :Color(sp0), width: 2)
                        .cornerRadius(10)
                        .font(.footnote)
                        .contentShape(Rectangle())
                        .onTapGesture { lit_colorx = sp0
                            colorV = lit_colorx
                            pnr = 2
                            tipas = "la"
                            sapka()
                            selectedTab = 0
                        }
                }
                if(!sv1.isEmpty) {

                    Text(sv1)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: 25)
                        .background(Color(sp1))
                        .foregroundColor(.white)
                        .border(pnr == 3 ? Color(alter_c(cc: sp1)) :Color(sp1), width: 2)
                        .cornerRadius(10)
                        .font(.footnote)
                        .contentShape(Rectangle())
                        .onTapGesture { lit_colorx = sp1
                            colorV = lit_colorx
                            pnr = 3
                            tipas = "la"
                            sapka()
                            selectedTab = 0
                        }
                }
                if(!sv2.isEmpty) {
                    Text(sv2)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: 25)
                        .background(Color(sp2))
                        .foregroundColor(.white)
                        .border(pnr == 4 ? Color(alter_c(cc: sp2)) :Color(sp2), width: 2)
                        .cornerRadius(10)
                        .font(.footnote)
                        .contentShape(Rectangle())
                        .onTapGesture { lit_colorx = sp2
                            colorV = lit_colorx
                            pnr = 4
                            tipas = "la"
                            sapka()
                            selectedTab = 0
                        }
                }
    //            }
            }
        }
        } //vst
        .animation(nil)
        .padding(.top, 1)

 
    }
    func alter_c(cc: String)  -> String {
        var ac:String = "green-a"
        if cc == "rose" {ac = "rose-a"}
        if cc == "red" {ac = "red-a"}
        if cc == "green" {ac = "green-a"}
        if cc == "gold" {ac = "gold-a"}
        if cc == "purple" {ac = "purple-a"}
        return ac
    }
        func m_d(dd: String)  -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let date = dateFormatter.date(from: dd)
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .year, for: date!)
        return day!
    }
    mutating func setcd() {
        var components = DateComponents()
        components.year = Int(metai)
        components.month = menuo
        components.day = mdiena
        components.hour = 15
        components.minute = 1
        components.timeZone = TimeZone(abbreviation: "EET")
        let date = Calendar.current.date(from: components) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        data = formatter.date(from: data3s + " 15:31") ?? date
        //print(521,data,datas,date)
    }
    func sapka() {
        let formatter = DateFormatter()
        formatter.locale =  Locale(identifier: "lt_LT")
        formatter.dateFormat = "yyyy-MM-dd"
        self.dataei = formatter.string(from: Date())
        //print("sapka()_D",dataei,datasx)
        if dataei != datasx { selectedId = 0 }
        datas = datasx
        sapkat = "<script> metur='" + metur + "'; "
        sapkat += " iskk ='" + iskk  +  "'; "
        sapkat += " var pdata ='" + MMdd  +  "'; "
        sapkat += " lit_per ='" + lit_per  +  "'; </script>"
        //print("299_D",iskk)
        if(pnr < 2) {
            sapkat += "<p class='" + lit_color_m + "'><small>"
            sapkat += metai + " m. " + menuop
            sapkat +=  " " + String(mdiena)
            sapkat += " d., " + sdienap +  "</small><br>"
            sapkat +=  lit_laikas
            if(!lit_laikas2.isEmpty && iskk != "pel") {
                sapkat += "<br><small><span style='color:red'>" + lit_laikas2 + "</span></small>" }
            sapkat +=  "</p>" }
        if(pnr == 2) {
            sapkat = "<p class='" + lit_colorx + "'><small>"
            sapkat += metai + " m. " + menuop
            sapkat +=  " " + String(mdiena)
            sapkat += " d., " + sdienap +  "</small><br>"
            sapkat +=  sv0
            sapkat +=  "</p>" }
        if(pnr == 3) {
            sapkat = "<p class='" + lit_colorx + "'><small>"
            sapkat += metai + " m. " + menuop
            sapkat +=  " " + String(mdiena)
            sapkat += " d., " + sdienap +  "</small><br>"
            sapkat +=  sv1
            sapkat +=  "</p>" }
        if(pnr == 4) {
            sapkat = "<p class='" + lit_colorx + "'><small>"
            sapkat += metai + " m. " + menuop
            sapkat +=  " " + String(mdiena)
            sapkat += " d., " + sdienap +  "</small><br>"
            sapkat +=  sv2
            sapkat +=  "</p>" }
        if(colorV.isEmpty) {colorV = lit_colorx}
        sapkav = sapkat
        sapkan = sapkat
  
        if(sav_diena == 6 && (iskk.isEmpty || lit_per == "gav")) {
            colorV = lit_per_sp
            //print("346_D",laikasV)
            sapkav = "<script> metur='" + metur + "'; "
            sapkav += " lit_per ='" + lit_per  +  "'; </script>"
            sapkav += "<p class='" + colorV + "'>"
            sapkav += laikasV + "</p>"
            sapkan = "<script> metur='" + metur + "'; "
            sapkan += " lit_per ='" + lit_per  +  "'; </script>"
            sapkan += "<p class='" + colorV + "'>"
            sapkan += laikasV + "</p>"
        }
        //ar ryt yra iškilmė
        if(!risk_pav.isEmpty) {
            colorV = risk_sp
            sapkav = "<script> metur='" + metur + "'; </script>"
            sapkav += "<p class='" + colorV + "'>"
            sapkav += risk_pav + "</p>"
            sapkav += "<script> lit_per ='" + lit_per  +  "'; </script>"
            sapkan = "<p class='" + colorV + "'>"
            sapkan += risk_pav + "</p>"
            sapkan += "<script> lit_per ='" + lit_per  +  "'; </script>"
        }
        var forma=Formavimas()
        forma.formavimas()
        //Formavimas().formavimas()
        mnr = 99
        self.selectedTab = 0
       // print("sapka() galas_D",dtime(),self.selectedTab)
    }

 
}

// Valandų liturgijos
struct Kalendorius_Previews: PreviewProvider {
    static var previews: some View {
        Kalendorius()
    }
}

