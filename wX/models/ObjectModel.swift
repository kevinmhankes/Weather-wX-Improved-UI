/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final public class ObjectModel {

    private var modelName = ""
    private var paramArr = [String]()
    var paramLabelArr = [String]()
    var sectorArr = [String]()
    var timeArr = [String]()
    private var runArr = [String]()
    var modelArr = [String]()
    var runTimeData = RunTimeData()
    private var activityName = ""
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
    private var sectorInt = 0
    private var prodIdx = 0
    private var sectorButton = ObjectToolbarIcon()
    private var runButton = ObjectToolbarIcon()
    var timeButton = ObjectToolbarIcon()
    private var prodButton = ObjectToolbarIcon()
    private var statusButton = ObjectToolbarIcon()
    private var modelButton = ObjectToolbarIcon()
    let productButtonTruncate = 18

    var time: String {
        return self.timeStr.split(" ")[0]
    }

    var timeIndex: Int {
        get {
            return self.timeIdx
        }
        set {
            self.timeIdx = newValue
        }
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
            modelArr = UtilityModelNsslWrfInterface.models
        case "ESRL":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "1ref_sfc"
            model = "HRRR"
            sector = "US"
            sectorInt = 0
            modelArr = UtilityModelEsrlInterface.models
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
            modelArr = UtilityModelNcepInterface.models
        case "WPCGEFS":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "capegt500"
            sector = "US"
            sectorInt = 0
            model = "WPCGEFS"
        case "SPCHRRR":
            prodIdx = 0
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "sfc_prec"
            model = "HRRR"
            sector = "US"
        case "SPCHREF":
            prodIdx = 0
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
            sectorInt = 0
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
        getPrefs()
    }

    func getPrefs() {
        model = Utility.readPref(prefModel, model)
        param = Utility.readPref(prefParam, param)
        sector = Utility.readPref(prefSector, sector)
        timeStr = Utility.readPref(prefRunPosn, timeStr)
        timeIdx = Utility.readPref(prefRunPosnIdx, timeIdx)
    }

    func setPrefs() {
        Utility.writePref(prefModel, model)
        Utility.writePref(prefParam, param)
        Utility.writePref(prefSector, sector)
        Utility.writePref(prefRunPosn, timeStr)
        Utility.writePref(prefRunPosnIdx, timeIdx)
    }

    func setButtons(
        _ prodButton: ObjectToolbarIcon,
        _ sectorButton: ObjectToolbarIcon,
        _ runButton: ObjectToolbarIcon,
        _ timeButton: ObjectToolbarIcon
    ) {
        self.prodButton = prodButton
        self.sectorButton = sectorButton
        self.runButton = runButton
        self.timeButton = timeButton
        sectorButton.title = sector
        runButton.title = run
        timeButton.title = timeStr
        prodButton.title = param.truncate(productButtonTruncate)
    }

    func setButtons(
        _ prodButton: ObjectToolbarIcon,
        _ sectorButton: ObjectToolbarIcon,
        _ runButton: ObjectToolbarIcon,
        _ timeButton: ObjectToolbarIcon,
        _ statusButton: ObjectToolbarIcon,
        _ modelButton: ObjectToolbarIcon
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
        self.modelToken = self.prefModel + ":" + modelName
        switch modelToken {
        case "NSSLWRF:WRF":
            paramArr = UtilityModelNsslWrfInterface.paramsNsslWrf
            paramLabelArr = UtilityModelNsslWrfInterface.labelsNsslWrf
            sectorArr = UtilityModelNsslWrfInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NSSLWRF:WRF_3KM":
            paramArr = UtilityModelNsslWrfInterface.paramsNsslWrf
            paramLabelArr = UtilityModelNsslWrfInterface.labelsNsslWrf
            sectorArr = UtilityModelNsslWrfInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NSSLWRF:FV3":
            paramArr = UtilityModelNsslWrfInterface.paramsNsslFv3
            paramLabelArr = UtilityModelNsslWrfInterface.labelsNsslFv3
            sectorArr = UtilityModelNsslWrfInterface.sectorsLong
            timeArr = []
            (1...60).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NSSLWRF:HRRRV3":
            paramArr = UtilityModelNsslWrfInterface.paramsNsslHrrrv3
            paramLabelArr = UtilityModelNsslWrfInterface.labelsNsslHrrrv3
            sectorArr = UtilityModelNsslWrfInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:HRRR":
            paramArr = UtilityModelEsrlInterface.modelHrrrParams
            paramLabelArr = UtilityModelEsrlInterface.modelHrrrLabels
            sectorArr = UtilityModelEsrlInterface.sectorsHrrr
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:HRRR_AK":
            paramArr = UtilityModelEsrlInterface.modelHrrrParams
            paramLabelArr = UtilityModelEsrlInterface.modelHrrrLabels
            sectorArr = UtilityModelEsrlInterface.sectorsHrrrAk
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:HRRR_NCEP":
            paramArr = UtilityModelEsrlInterface.modelHrrrParams
            paramLabelArr = UtilityModelEsrlInterface.modelHrrrLabels
            sectorArr = UtilityModelEsrlInterface.sectorsHrrr
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:RAP":
            paramArr = UtilityModelEsrlInterface.modelRapParams
            paramLabelArr = UtilityModelEsrlInterface.modelRapLabels
            sectorArr = UtilityModelEsrlInterface.sectorsRap
            timeArr = []
            (0...21).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:RAP_NCEP":
            paramArr = UtilityModelEsrlInterface.modelRapParams
            paramLabelArr = UtilityModelEsrlInterface.modelRapLabels
            sectorArr = UtilityModelEsrlInterface.sectorsRap
            timeArr = []
            (0...21).forEach {timeArr.append(String(format: "%02d", $0))}
        case "GLCFS:GLCFS":
            paramArr = UtilityModelGlcfsInterface.params
            paramLabelArr = UtilityModelGlcfsInterface.labels
            sectorArr = UtilityModelGlcfsInterface.sectors
            timeArr = []
            (1...13).forEach {timeArr.append(String(format: "%02d", $0))}
            stride(from: 15, to: 120, by: 3).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NCEP:GFS":
            paramArr = UtilityModelNcepInterface.modelGfsParams
            paramLabelArr = UtilityModelNcepInterface.modelGfsLabels
            sectorArr = UtilityModelNcepInterface.sectorsGfs
            timeArr = []
            stride(from: 0, to: 243, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            stride(from: 252, to: 396, by: 12).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:HRRR":
            paramArr = UtilityModelNcepInterface.modelHrrrParams
            paramLabelArr = UtilityModelNcepInterface.modelHrrrLabels
            sectorArr = UtilityModelNcepInterface.sectorsHrrr
            timeArr = []
            (0...18).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            (0...22).forEach {runArr.append(String(format: "%02d", $0)+"Z")}
            runTimeData.listRun=runArr
        case "NCEP:RAP":
            paramArr = UtilityModelNcepInterface.modelRapParams
            paramLabelArr = UtilityModelNcepInterface.modelRapLabels
            sectorArr = UtilityModelNcepInterface.sectorsRap
            timeArr = []
            (0...21).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            (0...22).forEach {runArr.append(String(format: "%02d", $0)+"Z")}
            runTimeData.listRun = runArr
        case "NCEP:NAM-HIRES":
            paramArr = UtilityModelNcepInterface.modelNam4kmParams
            paramLabelArr = UtilityModelNcepInterface.modelNam4kmLabels
            sectorArr = UtilityModelNcepInterface.sectorsNam4km
            timeArr = []
            stride(from: 1, to: 61, by: 1).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:NAM":
            paramArr = UtilityModelNcepInterface.modelNamParams
            paramLabelArr = UtilityModelNcepInterface.modelNamLabels
            sectorArr = UtilityModelNcepInterface.sectorsNam
            timeArr = []
            stride(from: 0, to: 85, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:HRW-NMMB":
            paramArr = UtilityModelNcepInterface.modelHrwNmmParams
            paramLabelArr = UtilityModelNcepInterface.modelHrwNmmLabels
            sectorArr = UtilityModelNcepInterface.sectorsHrwNmm
            timeArr = []
            (0...48).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("12Z")
            runTimeData.listRun = runArr
        case "NCEP:HRW-ARW":
            paramArr = UtilityModelNcepInterface.modelHrwNmmParams
            paramLabelArr = UtilityModelNcepInterface.modelHrwNmmLabels
            sectorArr = UtilityModelNcepInterface.sectorsHrwNmm
            timeArr = []
            (0...48).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("12Z")
            runTimeData.listRun = runArr
        case "NCEP:HRW-ARW2":
            paramArr = UtilityModelNcepInterface.paramsHrwArw2
            paramLabelArr = UtilityModelNcepInterface.labelsHrwArw2
            sectorArr = UtilityModelNcepInterface.sectorsHrwArw2
            timeArr = []
            (0...48).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("12Z")
            runTimeData.listRun = runArr
        case "NCEP:HREF":
            paramArr = UtilityModelNcepInterface.paramsHref
            paramLabelArr = UtilityModelNcepInterface.labelsHref
            sectorArr = UtilityModelNcepInterface.sectorsHref
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("06Z")
            runArr.append("12Z")
            runArr.append("18Z")
            runTimeData.listRun = runArr
        case "NCEP:NBM":
            paramArr = UtilityModelNcepInterface.paramsNbm
            paramLabelArr = UtilityModelNcepInterface.labelsNbm
            sectorArr = UtilityModelNcepInterface.sectorsNbm
            timeArr = []
            stride(from: 0, to: 264, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("06Z")
            runArr.append("12Z")
            runArr.append("18Z")
            runTimeData.listRun = runArr
        case "NCEP:GEFS-SPAG":
            paramArr = UtilityModelNcepInterface.modelGefsSpagParams
            paramLabelArr = UtilityModelNcepInterface.modelGefsSpagLabels
            sectorArr = UtilityModelNcepInterface.sectorsGefsSpag
            timeArr = []
            stride(from: 0, to: 180, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            stride(from: 192, to: 384, by: 12).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:GEFS-MEAN-SPRD":
            paramArr = UtilityModelNcepInterface.modelGefsMnsprdParams
            paramLabelArr = UtilityModelNcepInterface.modelGefsMnsprdLabels
            sectorArr = UtilityModelNcepInterface.sectorsGefsMnsprd
            timeArr = []
            stride(from: 0, to: 180, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            stride(from: 192, to: 384, by: 12).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:SREF":
            paramArr = UtilityModelNcepInterface.modelSrefParams
            paramLabelArr = UtilityModelNcepInterface.modelSrefLabels
            sectorArr = UtilityModelNcepInterface.sectorsSref
            timeArr = []
            stride(from: 0, to: 87, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ("03Z")
        case "NCEP:NAEFS":
            paramArr = UtilityModelNcepInterface.modelNaefsParams
            paramLabelArr = UtilityModelNcepInterface.modelNaefsLabels
            sectorArr = UtilityModelNcepInterface.sectorsNaefs
            timeArr = []
            stride(from: 0, to: 384, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:POLAR":
            paramArr = UtilityModelNcepInterface.modelPolarParams
            paramLabelArr = UtilityModelNcepInterface.modelPolarLabels
            sectorArr = UtilityModelNcepInterface.sectorsPolar
            timeArr = []
            stride(from: 0, to: 384, by: 24).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runTimeData.listRun=runArr
        case "NCEP:WW3":
            paramArr = UtilityModelNcepInterface.modelWw3Params
            paramLabelArr = UtilityModelNcepInterface.modelWw3Labels
            sectorArr = UtilityModelNcepInterface.sectorsWw3
            timeArr = []
            stride(from: 0, to: 126, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:WW3-ENP":
            paramArr = UtilityModelNcepInterface.modelWw3EnpParams
            paramLabelArr = UtilityModelNcepInterface.modelWw3EnpLabels
            sectorArr = UtilityModelNcepInterface.sectorsWw3Enp
            timeArr = []
            stride(from: 0, to: 126, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:WW3-WNA":
            paramArr = UtilityModelNcepInterface.modelWw3WnaParams
            paramLabelArr = UtilityModelNcepInterface.modelWw3WnaLabels
            sectorArr = UtilityModelNcepInterface.sectorsWw3Wna
            timeArr = []
            stride(from: 0, to: 126, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:ESTOFS":
            paramArr = UtilityModelNcepInterface.modelEstofsParams
            paramLabelArr = UtilityModelNcepInterface.modelEstofsLabels
            sectorArr = UtilityModelNcepInterface.sectorsEstofs
            timeArr = []
            stride(from: 0, to: 180, by: 1).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:FIREWX":
            paramArr = UtilityModelNcepInterface.modelFirewxParams
            paramLabelArr = UtilityModelNcepInterface.modelFirewxLabels
            sectorArr = UtilityModelNcepInterface.sectorsFirewx
            timeArr = []
            stride(from: 0, to: 37, by: 1).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "WPCGEFS:WPCGEFS":
            paramArr = UtilityModelWpcGefsInterface.params
            paramLabelArr = UtilityModelWpcGefsInterface.labels
            sectorArr = UtilityModelWpcGefsInterface.sectors
            timeArr = []
            stride(from: 0, to: 240, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = self.runTimeData.listRun
        case "SPCHRRR:HRRR":
            paramArr = UtilityModelSpcHrrrInterface.params
            paramLabelArr = UtilityModelSpcHrrrInterface.labels
            sectorArr = UtilityModelSpcHrrrInterface.sectors
            timeArr = []
            (2...15).forEach {timeArr.append(String(format: "%02d", $0))}
            runArr = self.runTimeData.listRun
        case "SPCHREF:HREF":
            paramArr = UtilityModelSpcHrefInterface.params
            paramLabelArr = UtilityModelSpcHrefInterface.labels
            sectorArr = UtilityModelSpcHrefInterface.sectorsLong
            timeArr = []
            (1...49).forEach {timeArr.append(String(format: "%02d", $0))}
            runArr = self.runTimeData.listRun
        case "SPCSREF:SREF":
            paramArr = UtilityModelSpcSrefInterface.params
            paramLabelArr = UtilityModelSpcSrefInterface.labels
            sectorArr = []
            timeArr = []
            stride(from: 0, to: 87, by: 3).forEach {timeArr.append(String(format: "%02d", $0))}
            runArr = self.runTimeData.listRun
        default: break
        }
        if sectorArr.count > 0 {
            if !self.sectorArr.contains(sector) {
                self.sector = self.sectorArr[0]
                self.sectorButton.title = self.sector
            }
        }
        if !self.paramArr.contains(param) {
            if self.paramArr.count > 0 {
                self.param = self.paramArr[0]
            }
            self.prodButton.title = self.param.truncate(productButtonTruncate)
        }
    }

    func setupListRunZ() {
        runArr = []
        runArr.append("00Z")
        runArr.append("06Z")
        runArr.append("12Z")
        runArr.append("18Z")
        runTimeData.listRun = runArr
    }

    func setupListRunZ(_ start: String) {
        runArr = []
        runArr.append("03Z")
        runArr.append("09Z")
        runArr.append("15Z")
        runArr.append("21Z")
        runTimeData.listRun = runArr
    }

    func getRunStatus() {
        switch prefModel {
        case "NSSLWRF":       runTimeData = UtilityModelNsslWrfInputOutput.getRunTime()
        case "ESRL":          runTimeData = UtilityModelEsrlInputOutput.getRunTime(self)
        case "GLCFS": break
        case "NCEP":
            runTimeData = UtilityModelNcepInputOutput.getRunTime(self)
            runTimeData.listRun = runArr
        case "WPCGEFS": runTimeData = UtilityModelWpcGefsInputOutput.getRunTime()
        case "SPCHRRR": runTimeData = UtilityModelSpcHrrrInputOutput.getRunTime()
        case "SPCHREF": runTimeData = UtilityModelSpcHrefInputOutput.getRunTime()
        case "SPCSREF": runTimeData = UtilityModelSpcSrefInputOutput.getRunTime()
        default: break
        }
    }

    func getImage() -> Bitmap {
        var bitmap = Bitmap()
        switch prefModel {
        case "NSSLWRF": bitmap = UtilityModelNsslWrfInputOutput.getImage(self)
        case "ESRL":    bitmap = UtilityModelEsrlInputOutput.getImage(self)
        case "GLCFS":   bitmap = UtilityModelGlcfsInputOutput.getImage(self)
        case "NCEP":
            if self.model == "NAM4KM" {
                self.model = "NAM-HIRES"
            }
            if self.model.contains("HRW") && self.model.contains("-AK") {
                self.model = self.model.replace("-AK", "")
            }
            if self.model.contains("HRW") && self.model.contains("-PR") {
                self.model = self.model.replace("-PR", "")
            }
            if self.model != "HRRR" {
                self.timeStr = self.timeStr.truncate(3)
            } else {
                self.timeStr = self.timeStr.truncate(3)
            }
            bitmap = UtilityModelNcepInputOutput.getImage(self)
        case "WPCGEFS": bitmap = UtilityModelWpcGefsInputOutput.getImage(self)
        case "SPCHRRR": bitmap = UtilityModelSpcHrrrInputOutput.getImage(self)
        case "SPCHREF": bitmap = UtilityModelSpcHrefInputOutput.getImage(self)
        case "SPCSREF": bitmap = UtilityModelSpcSrefInputOutput.getImage(self)
        default: break
        }
        return bitmap
    }

    func getAnimation() -> AnimationDrawable {
        var animDrawable = AnimationDrawable()
        switch prefModel {
        case "NSSLWRF": animDrawable = UtilityModels.getAnimation(self, UtilityModelNsslWrfInputOutput.getImage)
        case "ESRL":    animDrawable = UtilityModels.getAnimation(self, UtilityModelEsrlInputOutput.getImage)
        case "GLCFS":   animDrawable = UtilityModels.getAnimation(self, UtilityModelGlcfsInputOutput.getImage)
        case "NCEP":    animDrawable = UtilityModels.getAnimation(self, UtilityModelNcepInputOutput.getImage)
        case "WPCGEFS": animDrawable = UtilityModels.getAnimation(self, UtilityModelWpcGefsInputOutput.getImage)
        case "SPCHRRR": animDrawable = UtilityModels.getAnimation(self, UtilityModelSpcHrrrInputOutput.getImage)
        case "SPCHREF": animDrawable = UtilityModels.getAnimation(self, UtilityModelSpcHrefInputOutput.getImage)
        case "SPCSREF": animDrawable = UtilityModels.getAnimation(self, UtilityModelSpcSrefInputOutput.getImage)
        default: break
        }
        return animDrawable
    }

    func setModel(_ model: String) {
        self.model = model
        self.modelButton.title = model
    }

    func setRun(_ run: String) {
        self.run = run
        self.runButton.title = run
        self.statusButton.title = runTimeData.imageCompleteStr
    }

    func setSector(_ sector: String) {
        self.sector = sector
        self.sectorButton.title = sector
    }

    func setParam(_ paramIdx: Int) {
        self.param = paramArr[paramIdx]
        self.prodButton.title = param.truncate(productButtonTruncate)
        if self.modelName == "SSEO" {
            setModelVars(self.modelName)
        }
    }

    func setParam(_ param: String) {
        self.param = param
        self.prodButton.title = param.truncate(productButtonTruncate)
        if self.modelName == "SSEO" {
            setModelVars(self.modelName)
        }
    }

    func setTimeIdx(_ timeIdx: Int) {
        if timeIdx > -1 && timeIdx < timeArr.count {
            self.timeIdx = timeIdx
            self.timeStr = self.timeArr[timeIdx]
            self.timeButton.title = timeStr
        }
    }

    func timeIdxIncr() {
        self.timeIdx += 1
        self.timeStr = self.timeArr.safeGet(timeIdx)
        self.timeButton.title = timeStr
    }

    func timeIdxDecr() {
        self.timeIdx -= 1
        self.timeStr = self.timeArr.safeGet(timeIdx)
        self.timeButton.title = timeStr
    }

    func leftClick() {
        if timeIdx == 0 {
            setTimeIdx(timeArr.count - 1)
        } else {
            timeIdxDecr()
        }
    }

    func rightClick() {
        if timeIdx == timeArr.count - 1 {
            setTimeIdx(0)
        } else {
            timeIdxIncr()
        }
    }

    func setTimeArr(_ idx: Int, _ time: String) {
        self.timeArr[idx] = time
    }
}
