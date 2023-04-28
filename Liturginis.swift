//
//  Liturginis.swift
//  Valandu liturgija
//
//  Created by Rutenis Piksrys on 2021-05-21.
//

import SwiftUI

struct Liturginis {
    @AppStorage("pnr") var pnr: Int = 0 //pasirinkimas ka publikuoti
    @AppStorage("kal_md")  var kal_md: Int = 359
    @AppStorage("vel_md")  var vel_md: Int = 120
    @AppStorage("pas_md")  var pas_md: Int = 330
    @AppStorage("krk_md")  var krk_md: Int = 7
    @AppStorage("kra_md")  var kra_md: Int = 6
    @AppStorage("pel_md")  var pel_md: Int = 100
    @AppStorage("sav_diena")  var sav_diena: Int = 0
    @AppStorage("laikasV")  var laikasV: String = ""
    @AppStorage("lit_laikas") var lit_laikas: String = " Eilinis"
    @AppStorage("lit_laikas2") var lit_laikas2: String = ""
    @AppStorage("lit_color") var lit_color: String = "green"
    @AppStorage("lit_color_m") var lit_color_m: String = "green"
    @AppStorage("lit_colorx") var lit_colorx: String = "green"
    @AppStorage("lit_per_sp") var lit_per_sp: String = "green"
    @AppStorage("lit_per") var lit_per: String = "eil"
    @AppStorage("sv0") var sv0: String = ""
    @AppStorage("sv1") var sv1: String = ""
    @AppStorage("sv2") var sv2: String = ""
    @AppStorage("metur") var metur: String = "A"
    @AppStorage("sp0") var sp0: String = "gold"
    @AppStorage("sp1") var sp1: String = "gold"
    @AppStorage("sp2") var sp2: String = "gold"
    @AppStorage("colorV") var colorV: String = ""
    @AppStorage("ikkr") var ikkr: String = ""
    @AppStorage("iskk") var iskk: String = ""
    @AppStorage("MMdd")  var MMdd: String = "0101"
    @AppStorage("MMddr")  var MMddr: String = "0101"
    @AppStorage("krk")  var krk:String = "0106"
    @AppStorage("tipas") var tipas: String = ""
    @AppStorage("tipasp") var tipasp: String = ""
    @AppStorage("data_md")  var data_md: Int = 1
    @AppStorage("data2s")  var data2s: String = "210101"
    @AppStorage("metai") var metai: String = "2021"
    @AppStorage("savaite") var savaite: Int = 0
    @AppStorage("eil_sav") var eil_sav: Int = 0
    var lsk: Int = 0
    var sv_pavad = ["", "", ""]
    var sv_spalva = ["gold", "gold", "gold"]
    var pi: Bool = true
    @AppStorage("risk_pav") var risk_pav = ""
    @AppStorage("risk_sp") var risk_sp = ""
    var duomenys = Duomenys()
    func dtime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    init() {
        //print("Liturginis _D",sav_diena)
      //  print(56,"Liturginis_init_D",dtime())
        pnr = 0
        pel_md = 0
       // print(55,sv0)
        vel_md = 0
        var sek_md = 0

        lsk = 0
  //      sv_pavad = ["", "", ""]
        lit_laikas2 = ""
        laikasV = ""
        risk_pav = ""
        colorV = ""
        iskk = ""
        ikkr = ""
        risk_sp = ""
        tipas = ""
        tipasp = ""
        data_md = m_d(dd: data2s)
        let dict = duomenys.iskilmes
        let dspalva = duomenys.isk_spalva
        let pavad = duomenys.iskm_pav
        let isk_tipas = duomenys.isk_tipas
        //print("76_Lit _D",metai.suffix(2),MMddr)
        if let ikkrx = dict[metai.suffix(2) + MMddr] {
            ikkr = ikkrx
            if(isk_tipas[ikkrx] == "is" && ikkr != "pel") {
                risk_pav = pavad[ikkrx] ?? ""
                risk_sp = dspalva[ikkrx] ?? ""
            }
            //print("L92_D",ikkr,risk_pav)
        }
        //print("83_Lit _D",ikkr)
        var pel:String = "0202"
        var vel:String = "0404"
        var sek:String = "0601"
        var pas:String = "1128"
        var kra:String = "0106"
        var isk:Bool = false



        for (key, names) in dict {
            if(key.prefix(2) == metai.suffix(2)) {
                if(names == "kra") {kra = key
                   kra_md = m_d(dd: key)
                }
                if(names == "krk") {krk = key
                   krk_md = m_d(dd: key)
                }
                if(names == "pel") {pel = key
                    pel_md = m_d(dd: key)
                }
                if(names == "vel") {vel = key
                    vel_md = m_d(dd: key)
                }
                if(names == "sek") {sek = key
                    sek_md = m_d(dd: key)
                }
                if(names == "pas") {pas = key
                    pas_md = m_d(dd: key)
                }
                if(key == data2s) {isk = true
                    iskk = names
                }
            }
        }
        if(data2s <= krk){
            lit_laikas = "II Kalėdų savaitė"
            laikasV = "II Kalėdų savaitė"
            lit_color = "gold"
            lit_per_sp = "gold"
            lit_per = "kal"
        }
        if(data2s > krk){
            lit_laikas = "Eilinis"
            lit_color = "green"
            lit_per_sp = "green"
            lit_per = "eil"
            var pdsk: Int = 0;
            let krkm: String = String(krk.suffix(2))
            if (krkm == "0108" || krkm == "0109") { pdsk = 1 }
            var dsk: Int  = data_md;
            if(data_md > krk_md) { dsk = data_md - krk_md + pdsk}
            savaite = (dsk / 7) + 1;
            eil_sav = savaite
            lit_laikas = IntR(iss: savaite) + " eilinė savaitė ";
            if (sav_diena == 0) { lit_laikas = IntR(iss: savaite) + " EILINIS SEKMADIENIS"}
            if (sav_diena == 6) {
                let sx: Int = savaite + 1
                laikasV = IntR(iss: sx) + " EILINIS SEKMADIENIS"
                //print("142_D",laikasV,sx," : ",savaite)
            }
        }

        if(data2s >= pel){
            lit_laikas = "Gavėnia"
            lit_color = "purple"
            lit_per_sp = "purple"
            lit_per = "gav"
            if (data_md < pel_md + 4) { lit_laikas = "Dienos po Pelenės"
                //savaite=0
                if (sav_diena == 6) { laikasV = "I GAVĖNIOS SEKMADIENIS"}
            } else {
                let vdiena = data_md - pel_md - 4;
                savaite = (vdiena / 7) + 1;
                lit_laikas = IntR(iss: savaite) + " gavėnios savaitė ";
                if (sav_diena == 0) { lit_laikas = IntR(iss: savaite) + " GAVĖNIOS SEKMADIENIS" }
                if (sav_diena == 6) {laikasV = IntR(iss: (savaite+1)) + " GAVĖNIOS SEKMADIENIS"
                    colorV = lit_color }
                }
        }

        if(data_md == pel_md + 25) {lit_color = "rose"
            lit_per_sp = "rose"
        }
        if(data_md > vel_md-8 && data_md < vel_md-2) {
                   lit_per = "gad";
               }
        if(data_md > vel_md-3 && data_md <= vel_md) {
             lit_per = "ve3";
         }
        if (data_md == vel_md - 6) { lit_laikas = "Didysis pirmadienis" }
        if (data_md == vel_md - 5) { lit_laikas = "Didysis antradienis" }
        if (data_md == vel_md - 4) { lit_laikas = "Didysis trečiadienis" }
        if (data_md == vel_md - 3) { lit_laikas = "Didysis ketvirtadienis"
            lit_color = "gold"        }
        if (data_md == vel_md - 2) { lit_laikas = "Didysis penktadienis"
            lit_color = "red"        }
        if (data_md == vel_md - 1) { lit_laikas = "Didysis šeštadienis"
            lit_color = "purple"     }
        if(data2s >= vel){
            lit_color = "gold"
            lit_per_sp = "gold"
            lit_per = "vel"
            let vdiena: Int = data_md - vel_md-1
             savaite = (vdiena / 7) + 1
            lit_laikas = IntR(iss: savaite) + " Velykų savaitė "
            if (sav_diena == 0) { lit_laikas = IntR(iss: (savaite+1)) + " VELYKŲ SEKMADIENIS"}
             if (sav_diena == 6) { laikasV = IntR(iss: (savaite+1)) + " VELYKŲ SEKMADIENIS"
                colorV="gold"; }
        }
        if(data_md > vel_md && data_md <= vel_md+7) {
            lit_per = "ve8"
            lit_laikas = "Velykų aštuondienis"
            if (sav_diena == 0) { lit_laikas =  "II VELYKŲ SEKMADIENIS"
                lit_color="gold"
                lit_per_sp = "gold"
            }
            if (sav_diena == 6) { laikasV =  "II VELYKŲ SEKMADIENIS"
                lit_per_sp = "gold"}
        }
        if(data2s >= sek){
            lit_color = "green"
            lit_per_sp = "green"
            lit_per = "eil"
            var snr:Int = 6;
            if (sek > (metai.suffix(2) + "0514")) { snr = 7 }
            if (sek > (metai.suffix(2) + "0521")) { snr = 8 }
            if (sek > (metai.suffix(2) + "0528")) { snr = 9 }
            if (sek > (metai.suffix(2) + "0604")) { snr = 10 }
            if (sek > (metai.suffix(2) + "0611")) { snr = 11 }
            let dsk = data_md - sek_md
            savaite = (dsk / 7) + snr
            eil_sav = savaite
            lit_laikas = IntR(iss: savaite) + " eilinė savaitė "
            if (sav_diena == 0) { lit_laikas = IntR(iss: savaite) + " EILINIS SEKMADIENIS" }
            if (sav_diena == 6) { laikasV = IntR(iss: (savaite+1)) + " EILINIS SEKMADIENIS" }
        }
        if(data2s >= pas){
            lit_color = "purple"
            lit_per_sp = "purple"
            lit_per = "adv"
            let vdiena: Int = data_md - pas_md
            savaite = (vdiena / 7) + 1
            lit_laikas = IntR(iss: savaite) + " advento savaitė "
            if (sav_diena == 0) { lit_laikas = IntR(iss: savaite) + " ADVENTO SEKMADIENIS" }
            if (sav_diena == 6) { laikasV = IntR(iss: savaite+1) + " ADVENTO SEKMADIENIS" }

        }
        if(data2s == (metai.suffix(2) + "1102")){
            lit_laikas = "Vėlinės"
            lit_color = "purple"
            lit_per_sp = "purple"
        }
        kal_md = m_d(dd: metai.suffix(2) + "1225")
        let pr_kaledas_md: Int = m_d(dd: metai.suffix(2) + "1217")
        if(data_md < kal_md && data_md >= pr_kaledas_md ) {
             lit_laikas = "Šiokiadieniai prieš Kalėdas"
             lit_color = "purple"
            if (sav_diena == 0) { lit_laikas = "IV ADVENTO SEKMADIENIS" }
             lit_per = "ksp";
            if (sav_diena == 6) {laikasV = "IV ADVENTO SEKMADIENIS"
                colorV = lit_color }
         }
        if(data2s >= (metai.suffix(2) + "1225")){
            lit_laikas = "Kalėdų"
            lit_color = "gold"
            lit_per_sp = "gold"
            lit_per = "kal"
        }
        if (data_md > kal_md) {
            let sk: Int = data_md - kal_md + 1
            var kaldv:String = "";
            if (sk == 1) { kaldv = "pirmoji"}
            if (sk == 2) { kaldv = "antroji"}
            if (sk == 3) { kaldv = "trečioji"}
            if (sk == 4) { kaldv = "ketvirtoji"}
            if (sk == 5) { kaldv = "penktoji"}
            if (sk == 6) { kaldv = "šeštoji"}
            if (sk == 7) { kaldv = "septintoji" }
            lit_laikas = "Kalėdų " + kaldv + " diena"
            lit_per = "ka8"
        }
        if(lit_per == "kal" && sav_diena == 0 && !isk) { lit_laikas = "II KALĖDŲ SEKMADIENIS" }
        if(isk) {
            if let spalva = dspalva[iskk] { lit_color = spalva}
            if let pava = pavad[iskk] { lit_laikas = pava}
            sv0 = ""
            sv1 = ""
            sv2 = ""
            sv_pavad[0] = ""
            sv_pavad[1] = ""
            sv_pavad[2] = ""
        }
        if let itipas = isk_tipas[iskk] {
            if itipas == "is" {  lit_laikas2 = "Iškilmė"}
            if itipas == "sv" {  lit_laikas2 = "Šventė"}
            if itipas == "pr" {  lit_laikas2 = "Privalomas minėjimas"}
            if iskk == "pas" { lit_laikas2 = ""}
            if iskk == "ver" { lit_laikas2 = ""}
            
        }

        lsk = 0
        if(!isk) {
            sv0 = ""
            sv1 = ""
            sv2 = ""
            sv_pavad[0] = ""
            sv_pavad[1] = ""
            sv_pavad[2] = ""
            let minejimai = duomenys.minejimai
            let sventieji = duomenys.sventieji
            // 1. stabilios sventes bei privalomi
            // 2. laisvi minejimai
            var n = 0
            for (key, names) in minejimai {
                if(key == MMdd || sav_diena == 6) {
                    pi = true
                    if (lit_per == "isk" || lit_per == "gav" || lit_per == "gad" || lit_per == "ve3" || lit_per == "ve8" || sav_diena == 0 || lit_per == "ksp") { pi = false }
                    if(data_md == pel_md) { pi = false }
                    if(MMdd == "0202" || MMdd == "0806") { pi = true }
                    if(MMdd == "0222" && sav_diena != 0) { pi = true } //nepaisyti gavėnios
                    if(pi && key == MMdd ) {
                    if(names == "sv" || names == "pr"){
                        tipasp = names
                         tipas = names
                        lit_colorx = "gold"
                        lit_color = "gold"
                        if let sventasis = sventieji[key] {lit_laikas = sventasis
                           // if (laikas.indexOf("kankin") > 0) color = "red";
                            if sventasis.contains("kankin") { lit_color = "red" }
                            if(MMdd == "0503") { lit_color = "red" }
                            if sventasis.contains("apaštala") { lit_color = "red" }
                            if(MMdd == "1227") { lit_color = "gold" }
                            if(MMdd == "0914") { lit_color = "red" }
                            if(MMdd == "0425") { lit_color = "red" }
                        }
                        if(names == "sv") { lit_laikas2 = "Šventė"}
                        if(names == "pr") { lit_laikas2 = "Privalomas minėjimas"}
                    } else {
                        if let sventasis = sventieji[key] {
                            var array: [String] = []
                            array = sventasis.components(separatedBy: "@")
                            let lsk:Int = array.count
                            while n < lsk {
                                let ttt = array[n]
                                sv_pavad[n] = ttt
                                sv_spalva[n] = sv_pavad[n].contains("kankin") ? "red" : "gold"
                                n += 1
                            }
                           // print(311,sv_pavad[0],"_D")
                        }
                    }
                    } //pi
                }
            } //for
                    if(sav_diena == 6 && pi && lit_laikas2.isEmpty  && lit_per == "eil")
                    { sv_pavad[n] = "Švč. Marijos šeštadienis"
                        sv_spalva[n] = "gold"
                    }
        } //!isk
        lit_color_m = lit_color
        sv0 = sv_pavad[0]
        sv1 = sv_pavad[1]
        sv2 = sv_pavad[2]
        sp0 = sv_spalva[0]
        sp1 = sv_spalva[1]
        sp2 = sv_spalva[2]
        //print(540,sv0,"_D")
        if (data_md < pas_md) {    //metų raidės nustatymas
            if (Int(metai)! % 3 == 1) { metur = "A" }
            if (Int(metai)! % 3 == 0)  { metur = "C" }
            if (Int(metai)! % 3 == 2) { metur = "B" }
        } else {
            if (Int(metai)! % 3 == 1) { metur = "B" }
            if (Int(metai)! % 3 == 0) { metur = "A" }
            if (Int(metai)! % 3 == 2) { metur = "C" }
        }
 
    }
    func m_d(dd: String)  -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let date = dateFormatter.date(from: dd)
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .year, for: date!)
        return day!
    }
    func IntR(iss: Int) -> String {
        var integerValue:Int = iss
        var numeralString = ""
            let mappingList: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
            for i in mappingList {
                while (integerValue >= i.0) {
                    integerValue -= i.0
                    numeralString += i.1
                }
            }
            return numeralString
       
    }
}

