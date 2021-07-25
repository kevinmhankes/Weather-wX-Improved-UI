/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final public class ObjectModel {

    private var modelName = ""
    private var params = [String]()
    var paramLabels = [String]()
    var sectors = [String]()
    var times = [String]()
    private var runs = [String]()
    var models = [String]()
    var runTimeData = RunTimeData()
    private var modelToken = ""
    private var prefModel = ""
    private var prefSector = ""
    private var prefParam = ""
    private var prefRunPosn = ""
    private var prefRunPosnIdx = ""
    var model = ""
    var run = ""
    var timeStr = ""
    var timeIdx = 0
    var param = ""
    var sector = ""
    private var sectorButton = ToolbarIcon()
    private var runButton = ToolbarIcon()
    var timeButton = ToolbarIcon()
    private var prodButton = ToolbarIcon()
    private var statusButton = ToolbarIcon()
    private var modelButton = ToolbarIcon()
    let productButtonTruncate = 18

    var time: String { timeStr.split(" ")[0] }

    var timeIndex: Int {
        get { timeIdx }
        set { timeIdx = newValue }
    }

    convenience init(_ prefModel: String) {
        self.init()
        self.prefModel = prefModel
        prefSector = "MODEL_" + prefModel + "_SECTOR_LAST_USED"
        prefParam = "MODEL_" + prefModel + "_PARAM_LAST_USED"
        prefRunPosn = prefModel + "_RUN_POSN"
        prefRunPosnIdx = prefModel + "_RUN_POSN" + "IDX"
        switch prefModel {
        case "NCAR_ENSEMBLE":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "t2_mean"
            sector = "CONUS"
            model = "NCAR_ENSEMBLE"
        case "NSSLWRF":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "sfct"
            sector = "CONUS"
            model = "WRF"
            models = UtilityModelNsslWrfInterface.models
        case "ESRL":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "1ref_sfc"
            model = "HRRR_NCEP"
            sector = "US"
            models = UtilityModelEsrlInterface.models
        case "GLCFS":
            run = "00Z"
            timeStr = "01"
            timeIdx = 0
            param = "wv"
            model = "GLCFS"
            sector = "All Lakes"
        case "NCEP":
            run = "00Z"
            timeStr = "003"
            timeIdx = 1
            param = "500_vort_ht"
            model = "GFS"
            sector = "NAMER"
            models = UtilityModelNcepInterface.models
        case "WPCGEFS":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "capegt500"
            sector = "US"
            model = "WPCGEFS"
        case "SPCHRRR":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "sfc_prec"
            model = "HRRR"
            sector = "US"
        case "SPCHREF":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "500w_mean,500h_mean"
            model = "HREF"
            sector = "CONUS"
        case "SPCSSEO":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "sfc_prec"
            model = "SSEO"
            sector = "US"
        case "SPCSREF":
            run = "00Z"
            timeStr = "03"
            timeIdx = 1
            param = "SREF_H5__"
            model = "SREF"
            sector = "US"
        case "AURORAL_FORECAST":
            run = "00Z"
            timeStr = "03"
            timeIdx = 1
            param = "KP_INDEX"
            model = "AURORAL"
            sector = "north"
        default: break
        }
        getPreferences()
    }

    private func getPreferences() {
        model = Utility.readPref(prefModel, model)
        param = Utility.readPref(prefParam, param)
        sector = Utility.readPref(prefSector, sector)
        timeStr = Utility.readPref(prefRunPosn, timeStr)
        timeIdx = Utility.readPref(prefRunPosnIdx, timeIdx)
    }

    func setPreferences() {
        Utility.writePref(prefModel, model)
        Utility.writePref(prefParam, param)
        Utility.writePref(prefSector, sector)
        Utility.writePref(prefRunPosn, timeStr)
        Utility.writePref(prefRunPosnIdx, timeIdx)
    }

    func setButtons(
        _ prodButton: ToolbarIcon,
        _ sectorButton: ToolbarIcon,
        _ runButton: ToolbarIcon,
        _ timeButton: ToolbarIcon,
        _ statusButton: ToolbarIcon,
        _ modelButton: ToolbarIcon
    ) {
        self.prodButton = prodButton
        self.sectorButton = sectorButton
        self.runButton = runButton
        self.timeButton = timeButton
        self.statusButton = statusButton
        self.modelButton = modelButton
        sectorButton.title = sector
        runButton.title = run
        timeButton.title = timeStr
        prodButton.title = param.truncate(productButtonTruncate)
        modelButton.title = model
    }

    func setModelVars(_ modelName: String) {
        self.modelName = modelName
        modelToken = prefModel + ":" + modelName
        switch modelToken {
        case "NSSLWRF:WRF":
            params = UtilityModelNsslWrfInterface.paramsNsslWrf
            paramLabels = UtilityModelNsslWrfInterface.labelsNsslWrf
            sectors = UtilityModelNsslWrfInterface.sectorsLong
            times.removeAll()
            (1...36).forEach { times.append(String(format: "%02d", $0)) }
        case "NSSLWRF:WRF_3KM":
            params = UtilityModelNsslWrfInterface.paramsNsslWrf
            paramLabels = UtilityModelNsslWrfInterface.labelsNsslWrf
            sectors = UtilityModelNsslWrfInterface.sectorsLong
            times.removeAll()
            (1...36).forEach { times.append(String(format: "%02d", $0)) }
        case "NSSLWRF:FV3":
            params = UtilityModelNsslWrfInterface.paramsNsslFv3
            paramLabels = UtilityModelNsslWrfInterface.labelsNsslFv3
            sectors = UtilityModelNsslWrfInterface.sectorsLong
            times.removeAll()
            (1...60).forEach { times.append(String(format: "%02d", $0)) }
        case "NSSLWRF:HRRRV3":
            params = UtilityModelNsslWrfInterface.paramsNsslHrrrv3
            paramLabels = UtilityModelNsslWrfInterface.labelsNsslHrrrv3
            sectors = UtilityModelNsslWrfInterface.sectorsLong
            times.removeAll()
            (1...36).forEach { times.append(String(format: "%02d", $0)) }
        case "ESRL:HRRR":
            params = UtilityModelEsrlInterface.modelHrrrParams
            paramLabels = UtilityModelEsrlInterface.modelHrrrLabels
            sectors = UtilityModelEsrlInterface.sectorsHrrr
            times.removeAll()
            (0...36).forEach { times.append(String(format: "%02d", $0)) }
        case "ESRL:HRRR_AK":
            params = UtilityModelEsrlInterface.modelHrrrParams
            paramLabels = UtilityModelEsrlInterface.modelHrrrLabels
            sectors = UtilityModelEsrlInterface.sectorsHrrrAk
            times.removeAll()
            (0...36).forEach { times.append(String(format: "%02d", $0)) }
        case "ESRL:HRRR_NCEP":
            params = UtilityModelEsrlInterface.modelHrrrParams
            paramLabels = UtilityModelEsrlInterface.modelHrrrLabels
            sectors = UtilityModelEsrlInterface.sectorsHrrr
            times.removeAll()
            (0...36).forEach { times.append(String(format: "%02d", $0)) }
        case "ESRL:RAP":
            params = UtilityModelEsrlInterface.modelRapParams
            paramLabels = UtilityModelEsrlInterface.modelRapLabels
            sectors = UtilityModelEsrlInterface.sectorsRap
            times.removeAll()
            (0...21).forEach { times.append(String(format: "%02d", $0)) }
        case "ESRL:RAP_NCEP":
            params = UtilityModelEsrlInterface.modelRapParams
            paramLabels = UtilityModelEsrlInterface.modelRapLabels
            sectors = UtilityModelEsrlInterface.sectorsRap
            times.removeAll()
            (0...21).forEach { times.append(String(format: "%02d", $0)) }
        case "GLCFS:GLCFS":
            params = UtilityModelGlcfsInterface.params
            paramLabels = UtilityModelGlcfsInterface.labels
            sectors = UtilityModelGlcfsInterface.sectors
            times.removeAll()
            (1...13).forEach { times.append(String(format: "%02d", $0)) }
            stride(from: 15, to: 120, by: 3).forEach { times.append(String(format: "%02d", $0)) }
        case "NCEP:GFS":
            params = UtilityModelNcepInterface.modelGfsParams
            paramLabels = UtilityModelNcepInterface.modelGfsLabels
            sectors = UtilityModelNcepInterface.sectorsGfs
            times.removeAll()
            stride(from: 0, to: 243, by: 3).forEach { times.append(String(format: "%03d", $0)) }
            stride(from: 252, to: 396, by: 12).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:HRRR":
            params = UtilityModelNcepInterface.modelHrrrParams
            paramLabels = UtilityModelNcepInterface.modelHrrrLabels
            sectors = UtilityModelNcepInterface.sectorsHrrr
            times.removeAll()
            (0...18).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            (0...22).forEach { runs.append(String(format: "%02d", $0)+"Z") }
            runTimeData.listRun = runs
        case "NCEP:RAP":
            params = UtilityModelNcepInterface.modelRapParams
            paramLabels = UtilityModelNcepInterface.modelRapLabels
            sectors = UtilityModelNcepInterface.sectorsRap
            times.removeAll()
            (0...21).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            (0...22).forEach { runs.append(String(format: "%02d", $0)+"Z") }
            runTimeData.listRun = runs
        case "NCEP:NAM-HIRES":
            params = UtilityModelNcepInterface.modelNam4kmParams
            paramLabels = UtilityModelNcepInterface.modelNam4kmLabels
            sectors = UtilityModelNcepInterface.sectorsNam4km
            times.removeAll()
            stride(from: 1, to: 61, by: 1).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:NAM":
            params = UtilityModelNcepInterface.modelNamParams
            paramLabels = UtilityModelNcepInterface.modelNamLabels
            sectors = UtilityModelNcepInterface.sectorsNam
            times.removeAll()
            stride(from: 0, to: 85, by: 3).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:HRW-FV3":
            params = UtilityModelNcepInterface.modelHrwFv3Params
            paramLabels = UtilityModelNcepInterface.modelHrwFv3Labels
            sectors = UtilityModelNcepInterface.sectorsHrwNmm
            times.removeAll()
            (1...48).forEach { times.append(String(format: "%03d", $0)) }
            stride(from: 51, to: 61, by: 3).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            runs.append("00Z")
            runs.append("12Z")
            runTimeData.listRun = runs
        case "NCEP:HRW-ARW":
            params = UtilityModelNcepInterface.modelHrwNmmParams
            paramLabels = UtilityModelNcepInterface.modelHrwNmmLabels
            sectors = UtilityModelNcepInterface.sectorsHrwNmm
            times.removeAll()
            (1...48).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            runs.append("00Z")
            runs.append("12Z")
            runTimeData.listRun = runs
        case "NCEP:HRW-ARW2":
            params = UtilityModelNcepInterface.paramsHrwArw2
            paramLabels = UtilityModelNcepInterface.labelsHrwArw2
            sectors = UtilityModelNcepInterface.sectorsHrwArw2
            times.removeAll()
            (1...48).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            runs.append("00Z")
            runs.append("12Z")
            runTimeData.listRun = runs
        case "NCEP:HREF":
            params = UtilityModelNcepInterface.paramsHref
            paramLabels = UtilityModelNcepInterface.labelsHref
            sectors = UtilityModelNcepInterface.sectorsHref
            times.removeAll()
            (0...36).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            runs.append("00Z")
            runs.append("06Z")
            runs.append("12Z")
            runs.append("18Z")
            runTimeData.listRun = runs
        case "NCEP:NBM":
            params = UtilityModelNcepInterface.paramsNbm
            paramLabels = UtilityModelNcepInterface.labelsNbm
            sectors = UtilityModelNcepInterface.sectorsNbm
            times.removeAll()
            stride(from: 0, to: 264, by: 3).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            runs.append("00Z")
            runs.append("06Z")
            runs.append("12Z")
            runs.append("18Z")
            runTimeData.listRun = runs
        case "NCEP:GEFS-SPAG":
            params = UtilityModelNcepInterface.modelGefsSpagParams
            paramLabels = UtilityModelNcepInterface.modelGefsSpagLabels
            sectors = UtilityModelNcepInterface.sectorsGefsSpag
            times.removeAll()
            stride(from: 0, to: 180, by: 6).forEach { times.append(String(format: "%03d", $0)) }
            stride(from: 192, to: 384, by: 12).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:GEFS-MEAN-SPRD":
            params = UtilityModelNcepInterface.modelGefsMnsprdParams
            paramLabels = UtilityModelNcepInterface.modelGefsMnsprdLabels
            sectors = UtilityModelNcepInterface.sectorsGefsMnsprd
            times.removeAll()
            stride(from: 0, to: 180, by: 6).forEach { times.append(String(format: "%03d", $0)) }
            stride(from: 192, to: 384, by: 12).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:SREF":
            params = UtilityModelNcepInterface.modelSrefParams
            paramLabels = UtilityModelNcepInterface.modelSrefLabels
            sectors = UtilityModelNcepInterface.sectorsSref
            times.removeAll()
            stride(from: 0, to: 87, by: 3).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ("03Z")
        case "NCEP:NAEFS":
            params = UtilityModelNcepInterface.modelNaefsParams
            paramLabels = UtilityModelNcepInterface.modelNaefsLabels
            sectors = UtilityModelNcepInterface.sectorsNaefs
            times.removeAll()
            stride(from: 0, to: 384, by: 6).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:POLAR":
            params = UtilityModelNcepInterface.modelPolarParams
            paramLabels = UtilityModelNcepInterface.modelPolarLabels
            sectors = UtilityModelNcepInterface.sectorsPolar
            times.removeAll()
            stride(from: 0, to: 384, by: 24).forEach { times.append(String(format: "%03d", $0)) }
            runs.removeAll()
            runs.append("00Z")
            runTimeData.listRun = runs
        case "NCEP:WW3":
            params = UtilityModelNcepInterface.modelWw3Params
            paramLabels = UtilityModelNcepInterface.modelWw3Labels
            sectors = UtilityModelNcepInterface.sectorsWw3
            times.removeAll()
            stride(from: 0, to: 126, by: 6).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:ESTOFS":
            params = UtilityModelNcepInterface.modelEstofsParams
            paramLabels = UtilityModelNcepInterface.modelEstofsLabels
            sectors = UtilityModelNcepInterface.sectorsEstofs
            times.removeAll()
            stride(from: 0, to: 180, by: 1).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "NCEP:FIREWX":
            params = UtilityModelNcepInterface.modelFirewxParams
            paramLabels = UtilityModelNcepInterface.modelFirewxLabels
            sectors = UtilityModelNcepInterface.sectorsFirewx
            times.removeAll()
            stride(from: 0, to: 37, by: 1).forEach { times.append(String(format: "%03d", $0)) }
            setupListRunZ()
        case "WPCGEFS:WPCGEFS":
            params = UtilityModelWpcGefsInterface.params
            paramLabels = UtilityModelWpcGefsInterface.labels
            sectors = UtilityModelWpcGefsInterface.sectors
            times.removeAll()
            stride(from: 0, to: 240, by: 6).forEach { times.append(String(format: "%03d", $0)) }
            runs = runTimeData.listRun
        case "SPCHRRR:HRRR":
            params = UtilityModelSpcHrrrInterface.params
            paramLabels = UtilityModelSpcHrrrInterface.labels
            sectors = UtilityModelSpcHrrrInterface.sectors
            times.removeAll()
            (2...15).forEach { times.append(String(format: "%02d", $0)) }
            runs = runTimeData.listRun
        case "SPCHREF:HREF":
            params = UtilityModelSpcHrefInterface.params
            paramLabels = UtilityModelSpcHrefInterface.labels
            sectors = UtilityModelSpcHrefInterface.sectorsLong
            times.removeAll()
            (1...49).forEach { times.append(String(format: "%02d", $0)) }
            runs = runTimeData.listRun
        case "SPCSREF:SREF":
            params = UtilityModelSpcSrefInterface.params
            paramLabels = UtilityModelSpcSrefInterface.labels
            sectors = []
            times.removeAll()
            stride(from: 0, to: 87, by: 3).forEach { times.append(String(format: "%02d", $0)) }
            runs = runTimeData.listRun
        default: break
        }
        if sectors.count > 0 {
            if !sectors.contains(sector) {
                sector = sectors[0]
                sectorButton.title = sector
            }
        }
        if !params.contains(param) {
            if params.count > 0 {
                param = params[0]
            }
            prodButton.title = param.truncate(productButtonTruncate)
        }
    }

    func setupListRunZ() {
        runs.removeAll()
        runs.append("00Z")
        runs.append("06Z")
        runs.append("12Z")
        runs.append("18Z")
        runTimeData.listRun = runs
    }

    // TODO fix unused arg
    func setupListRunZ(_ start: String) {
        runs.removeAll()
        runs.append("03Z")
        runs.append("09Z")
        runs.append("15Z")
        runs.append("21Z")
        runTimeData.listRun = runs
    }

    func getRunStatus() {
        switch prefModel {
        case "NSSLWRF":
            runTimeData = UtilityModelNsslWrfInputOutput.getRunTime()
        case "ESRL":
            runTimeData = UtilityModelEsrlInputOutput.getRunTime(self)
        case "GLCFS":
            break
        case "NCEP":
            runTimeData = UtilityModelNcepInputOutput.getRunTime(self)
            runTimeData.listRun = runs
        case "WPCGEFS":
            runTimeData = UtilityModelWpcGefsInputOutput.getRunTime()
        case "SPCHRRR":
            runTimeData = UtilityModelSpcHrrrInputOutput.getRunTime()
        case "SPCHREF":
            runTimeData = UtilityModelSpcHrefInputOutput.getRunTime()
        case "SPCSREF":
            runTimeData = UtilityModelSpcSrefInputOutput.getRunTime()
        default:
            break
        }
    }

    func getImage() -> Bitmap {
        switch prefModel {
        case "NSSLWRF":
            return UtilityModelNsslWrfInputOutput.getImage(self)
        case "ESRL":
            return UtilityModelEsrlInputOutput.getImage(self)
        case "GLCFS":
            return UtilityModelGlcfsInputOutput.getImage(self)
        case "NCEP":
            if model == "NAM4KM" {
                model = "NAM-HIRES"
            }
            if model.contains("HRW") && model.contains("-AK") {
                model = model.replace("-AK", "")
            }
            if model.contains("HRW") && model.contains("-PR") {
                model = model.replace("-PR", "")
            }
            if model != "HRRR" {
                timeStr = timeStr.truncate(3)
            } else {
                timeStr = timeStr.truncate(3)
            }
            return UtilityModelNcepInputOutput.getImage(self)
        case "WPCGEFS":
            return UtilityModelWpcGefsInputOutput.getImage(self)
        case "SPCHRRR":
            return UtilityModelSpcHrrrInputOutput.getImage(self)
        case "SPCHREF":
            return UtilityModelSpcHrefInputOutput.getImage(self)
        case "SPCSREF":
            return UtilityModelSpcSrefInputOutput.getImage(self)
        default:
            return Bitmap()
        }
    }

    func getAnimation() -> AnimationDrawable {
        switch prefModel {
        case "NSSLWRF":
            return UtilityModels.getAnimation(self, UtilityModelNsslWrfInputOutput.getImage)
        case "ESRL":
            return UtilityModels.getAnimation(self, UtilityModelEsrlInputOutput.getImage)
        case "GLCFS":
            return UtilityModels.getAnimation(self, UtilityModelGlcfsInputOutput.getImage)
        case "NCEP":
            return UtilityModels.getAnimation(self, UtilityModelNcepInputOutput.getImage)
        case "WPCGEFS":
            return UtilityModels.getAnimation(self, UtilityModelWpcGefsInputOutput.getImage)
        case "SPCHRRR":
            return UtilityModels.getAnimation(self, UtilityModelSpcHrrrInputOutput.getImage)
        case "SPCHREF":
            return UtilityModels.getAnimation(self, UtilityModelSpcHrefInputOutput.getImage)
        case "SPCSREF":
            return UtilityModels.getAnimation(self, UtilityModelSpcSrefInputOutput.getImage)
        default:
            return AnimationDrawable()
        }
    }

    func setModel(_ model: String) {
        self.model = model
        modelButton.title = model
    }

    func setRun(_ run: String) {
        self.run = run
        runButton.title = run
        statusButton.title = runTimeData.imageCompleteStr
    }

    func setSector(_ sector: String) {
        self.sector = sector
        sectorButton.title = sector
    }

    func setParam(_ paramIdx: Int) {
        param = params[paramIdx]
        prodButton.title = param.truncate(productButtonTruncate)
        if modelName == "SSEO" {
            setModelVars(modelName)
        }
    }

    func setTimeIdx(_ timeIdx: Int) {
        if timeIdx > -1 && timeIdx < times.count {
            self.timeIdx = timeIdx
            timeStr = times[timeIdx]
            timeButton.title = timeStr
        }
    }

    // TODO make private below 2
    func timeIdxIncr() {
        timeIdx += 1
        timeStr = times.safeGet(timeIdx)
        timeButton.title = timeStr
    }

    func timeIdxDecr() {
        timeIdx -= 1
        timeStr = times.safeGet(timeIdx)
        timeButton.title = timeStr
    }

    func leftClick() {
        if timeIdx == 0 {
            setTimeIdx(times.count - 1)
        } else {
            timeIdxDecr()
        }
    }

    func rightClick() {
        if timeIdx == times.count - 1 {
            setTimeIdx(0)
        } else {
            timeIdxIncr()
        }
    }

    func setTimeArr(_ idx: Int, _ time: String) {
        times[idx] = time
    }
}
