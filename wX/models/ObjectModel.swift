/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
            modelArr = UtilityModelNSSLWRFInterface.models
        case "ESRL":
            run = "00Z"
            timeStr = "01"
            timeIdx = 1
            param = "1ref_sfc"
            model = "HRRR"
            sector = "US"
            sectorInt = 0
            modelArr = UtilityModelESRLInterface.models
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
            modelArr = UtilityModelNCEPInterface.models
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
            paramArr = UtilityModelNSSLWRFInterface.paramsNsslWrf
            paramLabelArr = UtilityModelNSSLWRFInterface.labelsNsslWrf
            sectorArr = UtilityModelNSSLWRFInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NSSLWRF:WRF_3KM":
            paramArr = UtilityModelNSSLWRFInterface.paramsNsslWrf
            paramLabelArr = UtilityModelNSSLWRFInterface.labelsNsslWrf
            sectorArr = UtilityModelNSSLWRFInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NSSLWRF:FV3":
            paramArr = UtilityModelNSSLWRFInterface.paramsNsslFv3
            paramLabelArr = UtilityModelNSSLWRFInterface.labelsNsslFv3
            sectorArr = UtilityModelNSSLWRFInterface.sectorsLong
            timeArr = []
            (1...60).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NSSLWRF:HRRRV3":
            paramArr = UtilityModelNSSLWRFInterface.paramsNsslHrrrv3
            paramLabelArr = UtilityModelNSSLWRFInterface.labelsNsslHrrrv3
            sectorArr = UtilityModelNSSLWRFInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:HRRR":
            paramArr = UtilityModelESRLInterface.modelHrrrParams
            paramLabelArr = UtilityModelESRLInterface.modelHrrrLabels
            sectorArr = UtilityModelESRLInterface.sectorsHrrr
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:HRRR_AK":
            paramArr = UtilityModelESRLInterface.modelHrrrParams
            paramLabelArr = UtilityModelESRLInterface.modelHrrrLabels
            sectorArr = UtilityModelESRLInterface.sectorsHrrrAk
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:HRRR_NCEP":
            paramArr = UtilityModelESRLInterface.modelHrrrParams
            paramLabelArr = UtilityModelESRLInterface.modelHrrrLabels
            sectorArr = UtilityModelESRLInterface.sectorsHrrr
            timeArr = []
            (0...36).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:RAP":
            paramArr = UtilityModelESRLInterface.modelRapParams
            paramLabelArr = UtilityModelESRLInterface.modelRapLabels
            sectorArr = UtilityModelESRLInterface.sectorsRap
            timeArr = []
            (0...21).forEach {timeArr.append(String(format: "%02d", $0))}
        case "ESRL:RAP_NCEP":
            paramArr = UtilityModelESRLInterface.modelRapParams
            paramLabelArr = UtilityModelESRLInterface.modelRapLabels
            sectorArr = UtilityModelESRLInterface.sectorsRap
            timeArr = []
            (0...21).forEach {timeArr.append(String(format: "%02d", $0))}
        case "GLCFS:GLCFS":
            paramArr = UtilityModelGLCFSInterface.params
            paramLabelArr = UtilityModelGLCFSInterface.labels
            sectorArr = UtilityModelGLCFSInterface.sectors
            timeArr = []
            (1...13).forEach {timeArr.append(String(format: "%02d", $0))}
            stride(from: 15, to: 120, by: 3).forEach {timeArr.append(String(format: "%02d", $0))}
        case "NCEP:GFS":
            paramArr = UtilityModelNCEPInterface.modelGfsParams
            paramLabelArr = UtilityModelNCEPInterface.modelGfsLabels
            sectorArr = UtilityModelNCEPInterface.sectorsGfs
            timeArr = []
            stride(from: 0, to: 243, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            stride(from: 252, to: 396, by: 12).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:HRRR":
            paramArr = UtilityModelNCEPInterface.modelHrrrParams
            paramLabelArr = UtilityModelNCEPInterface.modelHrrrLabels
            sectorArr = UtilityModelNCEPInterface.sectorsHrrr
            timeArr = []
            (0...18).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            (0...22).forEach {runArr.append(String(format: "%02d", $0)+"Z")}
            runTimeData.listRun=runArr
        case "NCEP:RAP":
            paramArr = UtilityModelNCEPInterface.modelRapParams
            paramLabelArr = UtilityModelNCEPInterface.modelRapLabels
            sectorArr = UtilityModelNCEPInterface.sectorsRap
            timeArr = []
            (0...21).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            (0...22).forEach {runArr.append(String(format: "%02d", $0)+"Z")}
            runTimeData.listRun = runArr
        case "NCEP:NAM-HIRES":
            paramArr = UtilityModelNCEPInterface.modelNam4kmParams
            paramLabelArr = UtilityModelNCEPInterface.modelNam4kmLabels
            sectorArr = UtilityModelNCEPInterface.sectorsNam4km
            timeArr = []
            stride(from: 0, to: 61, by: 1).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:NAM":
            paramArr = UtilityModelNCEPInterface.modelNamParams
            paramLabelArr = UtilityModelNCEPInterface.modelNamLabels
            sectorArr = UtilityModelNCEPInterface.sectorsNam
            timeArr = []
            stride(from: 0, to: 85, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:HRW-NMMB":
            paramArr = UtilityModelNCEPInterface.modelHrwNmmParams
            paramLabelArr = UtilityModelNCEPInterface.modelHrwNmmLabels
            sectorArr = UtilityModelNCEPInterface.sectorsHrwNmm
            timeArr = []
            (0...48).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("12Z")
            runTimeData.listRun = runArr
        case "NCEP:HRW-ARW":
            paramArr = UtilityModelNCEPInterface.modelHrwNmmParams
            paramLabelArr = UtilityModelNCEPInterface.modelHrwNmmLabels
            sectorArr = UtilityModelNCEPInterface.sectorsHrwNmm
            timeArr = []
            (0...48).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runArr.append("12Z")
            runTimeData.listRun = runArr
        case "NCEP:GEFS-SPAG":
            paramArr = UtilityModelNCEPInterface.modelGefsSpagParams
            paramLabelArr = UtilityModelNCEPInterface.modelGefsSpagLabels
            sectorArr = UtilityModelNCEPInterface.sectorsGefsSpag
            timeArr = []
            stride(from: 0, to: 180, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            stride(from: 192, to: 384, by: 12).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:GEFS-MEAN-SPRD":
            paramArr = UtilityModelNCEPInterface.modelGefsMnsprdParams
            paramLabelArr = UtilityModelNCEPInterface.modelGefsMnsprdLabels
            sectorArr = UtilityModelNCEPInterface.sectorsGefsMnsprd
            timeArr = []
            stride(from: 0, to: 180, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            stride(from: 192, to: 384, by: 12).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:SREF":
            paramArr = UtilityModelNCEPInterface.modelSrefParams
            paramLabelArr = UtilityModelNCEPInterface.modelSrefLabels
            sectorArr = UtilityModelNCEPInterface.sectorsSref
            timeArr = []
            stride(from: 0, to: 87, by: 3).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ("03Z")
        case "NCEP:NAEFS":
            paramArr = UtilityModelNCEPInterface.modelNaefsParams
            paramLabelArr = UtilityModelNCEPInterface.modelNaefsLabels
            sectorArr = UtilityModelNCEPInterface.sectorsNaefs
            timeArr = []
            stride(from: 0, to: 384, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:POLAR":
            paramArr = UtilityModelNCEPInterface.modelPolarParams
            paramLabelArr = UtilityModelNCEPInterface.modelPolarLabels
            sectorArr = UtilityModelNCEPInterface.sectorsPolar
            timeArr = []
            stride(from: 0, to: 384, by: 24).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = []
            runArr.append("00Z")
            runTimeData.listRun=runArr
        case "NCEP:WW3":
            paramArr = UtilityModelNCEPInterface.modelWw3Params
            paramLabelArr = UtilityModelNCEPInterface.modelWw3Labels
            sectorArr = UtilityModelNCEPInterface.sectorsWw3
            timeArr = []
            stride(from: 0, to: 126, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:WW3-ENP":
            paramArr = UtilityModelNCEPInterface.modelWw3EnpParams
            paramLabelArr = UtilityModelNCEPInterface.modelWw3EnpLabels
            sectorArr = UtilityModelNCEPInterface.sectorsWw3Enp
            timeArr = []
            stride(from: 0, to: 126, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:WW3-WNA":
            paramArr = UtilityModelNCEPInterface.modelWw3WnaParams
            paramLabelArr = UtilityModelNCEPInterface.modelWw3WnaLabels
            sectorArr = UtilityModelNCEPInterface.sectorsWw3Wna
            timeArr = []
            stride(from: 0, to: 126, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:ESTOFS":
            paramArr = UtilityModelNCEPInterface.modelEstofsParams
            paramLabelArr = UtilityModelNCEPInterface.modelEstofsLabels
            sectorArr = UtilityModelNCEPInterface.sectorsEstofs
            timeArr = []
            stride(from: 0, to: 180, by: 1).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "NCEP:FIREWX":
            paramArr = UtilityModelNCEPInterface.modelFirewxParams
            paramLabelArr = UtilityModelNCEPInterface.modelFirewxLabels
            sectorArr = UtilityModelNCEPInterface.sectorsFirewx
            timeArr = []
            stride(from: 0, to: 37, by: 1).forEach {timeArr.append(String(format: "%03d", $0))}
            setupListRunZ()
        case "WPCGEFS:WPCGEFS":
            paramArr = UtilityModelWPCGEFSInterface.params
            paramLabelArr = UtilityModelWPCGEFSInterface.labels
            sectorArr = UtilityModelWPCGEFSInterface.sectors
            timeArr = []
            stride(from: 0, to: 240, by: 6).forEach {timeArr.append(String(format: "%03d", $0))}
            runArr = self.runTimeData.listRun
        case "SPCHRRR:HRRR":
            paramArr = UtilityModelSPCHRRRInterface.params
            paramLabelArr = UtilityModelSPCHRRRInterface.labels
            sectorArr = UtilityModelSPCHRRRInterface.sectors
            timeArr = []
            (2...15).forEach {timeArr.append(String(format: "%02d", $0))}
            runArr = self.runTimeData.listRun
        case "SPCHREF:HREF":
            paramArr = UtilityModelSPCHREFInterface.params
            paramLabelArr = UtilityModelSPCHREFInterface.labels
            sectorArr = UtilityModelSPCHREFInterface.sectorsLong
            timeArr = []
            (1...36).forEach {timeArr.append(String(format: "%02d", $0))}
            runArr = self.runTimeData.listRun
        case "SPCSREF:SREF":
            paramArr = UtilityModelsSPCSREFInterface.params
            paramLabelArr = UtilityModelsSPCSREFInterface.labels
            sectorArr = []
            timeArr = []
            stride(from: 0, to: 90, by: 3).forEach {timeArr.append(String(format: "%02d", $0))}
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
        case "NSSLWRF":       runTimeData = UtilityModelNSSLWRFInputOutput.getRunTime()
        case "ESRL":          runTimeData = UtilityModelESRLInputOutput.getRunTime(self)
        case "GLCFS": break
        case "NCEP":
            runTimeData = UtilityModelNCEPInputOutput.getRunTime(self)
            runTimeData.listRun = runArr
        case "WPCGEFS": runTimeData = UtilityModelWPCGEFSInputOutput.getRunTime()
        case "SPCHRRR": runTimeData = UtilityModelSPCHRRRInputOutput.getRunTime()
        case "SPCHREF": runTimeData = UtilityModelSPCHREFInputOutput.getRunTime()
        case "SPCSREF": runTimeData = UtilityModelsSPCSREFInputOutput.getRunTime()
        default: break
        }
    }

    func getImage() -> Bitmap {
        var bitmap = Bitmap()
        switch prefModel {
        case "NSSLWRF": bitmap = UtilityModelNSSLWRFInputOutput.getImage(self)
        case "ESRL":    bitmap = UtilityModelESRLInputOutput.getImage(self)
        case "GLCFS":   bitmap = UtilityModelGLCFSInputOutput.getImage(self)
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
            bitmap = UtilityModelNCEPInputOutput.getImage(self)
        case "WPCGEFS": bitmap = UtilityModelWPCGEFSInputOutput.getImage(self)
        case "SPCHRRR": bitmap = UtilityModelSPCHRRRInputOutput.getImage(self)
        case "SPCHREF": bitmap = UtilityModelSPCHREFInputOutput.getImage(self)
        case "SPCSREF": bitmap = UtilityModelsSPCSREFInputOutput.getImage(self)
        default: break
        }
        return bitmap
    }

    func getAnimation() -> AnimationDrawable {
        var animDrawable = AnimationDrawable()
        switch prefModel {
        case "NSSLWRF": animDrawable = UtilityModels.getAnimation(self, UtilityModelNSSLWRFInputOutput.getImage)
        case "ESRL":    animDrawable = UtilityModels.getAnimation(self, UtilityModelESRLInputOutput.getImage)
        case "GLCFS":   animDrawable = UtilityModels.getAnimation(self, UtilityModelGLCFSInputOutput.getImage)
        case "NCEP":    animDrawable = UtilityModels.getAnimation(self, UtilityModelNCEPInputOutput.getImage)
        case "WPCGEFS": animDrawable = UtilityModels.getAnimation(self, UtilityModelWPCGEFSInputOutput.getImage)
        case "SPCHRRR": animDrawable = UtilityModels.getAnimation(self, UtilityModelSPCHRRRInputOutput.getImage)
        case "SPCHREF": animDrawable = UtilityModels.getAnimation(self, UtilityModelSPCHREFInputOutput.getImage)
        case "SPCSREF": animDrawable = UtilityModels.getAnimation(self, UtilityModelsSPCSREFInputOutput.getImage)
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
