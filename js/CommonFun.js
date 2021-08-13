// 使用JS的方式获取工作路径
function getWorkPath() {
    var exePath = Qt.application.arguments[0]
    var appPath = ""

    if ( Qt.platform.os === "windows" || Qt.platform.os === "winrt" ) {
        appPath = exePath.substring(0, exePath.lastIndexOf('\\'))
    } else {
        appPath = exePath.substring(0, exePath.lastIndexOf('/'))
    }

    return appPath
}

// 根据数据报表对象返回已选中的数据类型
function getResultItem(result) {
    var obj = []

    if ( result.pv === 1 ) { obj.push("PV") }
    if ( result.pvx === 1 ) { obj.push("PV(x)") }
    if ( result.pvy === 1 ) { obj.push("PV(y)") }
    if ( result.pvxy === 1 ) { obj.push("PV(xy)") }
    if ( result.pvr === 1 ) { obj.push("PVr") }
    if ( result.pvres === 1 ) { obj.push("PV(res)") }

    if ( result.rms === 1 ) { obj.push("RMS") }
    if ( result.rmsx === 1 ) { obj.push("RMS(x)") }
    if ( result.rmsy === 1 ) { obj.push("RMS(y)") }
    if ( result.rmsxy === 1 ) { obj.push("RMS(xy)") }
    if ( result.rmsres === 1 ) { obj.push("RMS(res)") }

    if ( result.zernikeTilt === 1 ) { obj.push("Zernike_Tilt") }
    if ( result.zernikePower === 1 ) { obj.push("Power") }
    if ( result.zernikePowerX === 1 ) { obj.push("Power_X") }
    if ( result.zernikePowerY === 1 ) { obj.push("Power_Y") }
    if ( result.zernikeAst === 1 ) { obj.push("Zernike_Ast") }
    if ( result.zernikeComa === 1 ) { obj.push("Zernike_Coma") }
    if ( result.zernikeSpherical === 1 ) { obj.push("Zernike_SA") }

    if ( result.seidelTilt === 1 ) { obj.push("Seidel_Tilt") }
    if ( result.seidelFocus === 1 ) { obj.push("Seidel_Focus") }
    if ( result.seidelAst === 1 ) { obj.push("Seidel_Ast") }
    if ( result.seidelComa === 1 ) { obj.push("Seidel_Coma") }
    if ( result.seidelSpherical === 1 ) { obj.push("Seidel_SA") }
    if ( result.seidelTiltClock === 1 ) { obj.push("Seidel_Tilt_Clock") }
    if ( result.seidelAstClock === 1 ) { obj.push("Seidel_Ast_Clock") }
    if ( result.seidelComaClock === 1 ) { obj.push("Seidel_Coma_Clock") }

    if ( result.rmsPower === 1 ) { obj.push("RMS(Power)") }
    if ( result.rmsAst === 1 ) { obj.push("RMS(Ast)") }
    if ( result.rmsComa === 1 ) { obj.push("RMS(Coma)") }
    if ( result.rmsSa === 1 ) { obj.push("RMS(SA)") }

    if ( result.sag === 1 ) { obj.push("SAG") }
    if ( result.irr === 1 ) { obj.push("IRR") }
    if ( result.rsi === 1 ) { obj.push("RSI") }
    if ( result.rmst === 1 ) { obj.push("RMSt") }
    if ( result.rmsa === 1 ) { obj.push("RMSa") }
    if ( result.rmsi === 1 ) { obj.push("RMSi") }

    if ( result.ttv === 1 ) { obj.push("TTV") }
    if ( result.fringes === 1 ) { obj.push("Fringes") }
    if ( result.strehl === 1 ) { obj.push("Strehl_Ratio") }
    if ( result.parallelTheta === 1 ) { obj.push("Parallel_Theta") }
    if ( result.aperture === 1 ) { obj.push("Aperture") }
    if ( result.sizeX === 1 ) { obj.push("SizeX") }
    if ( result.sizeY === 1 ) { obj.push("SizeY") }
    if ( result.grms === 1 ) { obj.push("GRMS") }
    if ( result.concavity === 1 ) { obj.push("Concavity") }
    if ( result.curvatureRadius === 1 ) { obj.push("Curvature_Radius") }

    if ( result.z1 === 1 ) { obj.push("Z1") }
    if ( result.z2 === 1 ) { obj.push("Z2") }
    if ( result.z3 === 1 ) { obj.push("Z3") }
    if ( result.z4 === 1 ) { obj.push("Z4") }
    if ( result.z5 === 1 ) { obj.push("Z5") }
    if ( result.z6 === 1 ) { obj.push("Z6") }
    if ( result.z7 === 1 ) { obj.push("Z7") }
    if ( result.z8 === 1 ) { obj.push("Z8") }
    if ( result.z9 === 1 ) { obj.push("Z9") }

    return obj
}

// 根据数据报表对象返回已选中的数据类型以及上下限
function getResultItemAndLimit(result) {
    // 没有上下限的都使用空字符串代替
    var obj = []

    if ( result.pv === 1 ) {
        obj.push("PV")
        obj.push(result.pv_min)
        obj.push(result.pv_max)
    }
    if ( result.pvx === 1 ) {
        obj.push("PV(x)")
        obj.push(result.pvx_min)
        obj.push(result.pvx_max)
    }
    if ( result.pvy === 1 ) {
        obj.push("PV(y)")
        obj.push(result.pvy_min)
        obj.push(result.pvy_max)
    }
    if ( result.pvxy === 1 ) {
        obj.push("PV(xy)")
        obj.push(result.pvxy_min)
        obj.push(result.pvxy_max)
    }
    if ( result.pvr === 1 ) {
        obj.push("PVr")
        obj.push(result.pvr_min)
        obj.push(result.pvr_max)
    }
    if ( result.pvres === 1 ) {
        obj.push("PV(res)")
        obj.push(result.pvres_min)
        obj.push(result.pvres_max)
    }

    if ( result.rms === 1 ) {
        obj.push("RMS")
        obj.push(result.rms_min)
        obj.push(result.rms_max)
    }
    if ( result.rmsx === 1 ) {
        obj.push("RMS(x)")
        obj.push(result.rmsx_min)
        obj.push(result.rmsx_max)
    }
    if ( result.rmsy === 1 ) {
        obj.push("RMS(y)")
        obj.push(result.rmsy_min)
        obj.push(result.rmsy_max)
    }
    if ( result.rmsxy === 1 ) {
        obj.push("RMS(xy)")
        obj.push(result.rmsxy_min)
        obj.push(result.rmsxy_max)
    }
    if ( result.rmsres === 1 ) {
        obj.push("RMS(res)")
        obj.push(result.rmsres_min)
        obj.push(result.rmsres_max)
    }

    if ( result.zernikeTilt === 1 ) {
        obj.push("Zernike_Tilt")
        obj.push(result.zernikeTilt_min)
        obj.push(result.zernikeTilt_max)
    }
    if ( result.zernikePower === 1 ) {
        obj.push("Power")
        obj.push(result.zernikePower_min)
        obj.push(result.zernikePower_max)
    }
    if ( result.zernikePowerX === 1 ) {
        obj.push("Power_X")
        obj.push(result.zernikePowerX_min)
        obj.push(result.zernikePowerX_max)
    }
    if ( result.zernikePowerY === 1 ) {
        obj.push("Power_Y")
        obj.push(result.zernikePowerY_min)
        obj.push(result.zernikePowerY_max)
    }
    if ( result.zernikeAst === 1 ) {
        obj.push("Zernike_Ast")
        obj.push(result.zernikeAst_min)
        obj.push(result.zernikeAst_max)
    }
    if ( result.zernikeComa === 1 ) {
        obj.push("Zernike_Coma")
        obj.push(result.zernikeComa_min)
        obj.push(result.zernikeComa_max)
    }
    if ( result.zernikeSpherical === 1 ) {
        obj.push("Zernike_SA")
        obj.push(result.zernikeSpherical_min)
        obj.push(result.zernikeSpherical_max)
    }

    if ( result.seidelTilt === 1 ) {
        obj.push("Seidel_Tilt")
        obj.push(result.seidelTilt_min)
        obj.push(result.seidelTilt_max)
    }
    if ( result.seidelFocus === 1 ) {
        obj.push("Seidel_Focus")
        obj.push(result.seidelFocus_min)
        obj.push(result.seidelFocus_max)
    }
    if ( result.seidelAst === 1 ) {
        obj.push("Seidel_Ast")
        obj.push(result.seidelAst_min)
        obj.push(result.seidelAst_max)
    }
    if ( result.seidelComa === 1 ) {
        obj.push("Seidel_Coma")
        obj.push(result.seidelComa_min)
        obj.push(result.seidelComa_max)
    }
    if ( result.seidelSpherical === 1 ) {
        obj.push("Seidel_SA")
        obj.push(result.seidelSpherical_min)
        obj.push(result.seidelSpherical_max)
    }
    if ( result.seidelTiltClock === 1 ) {
        obj.push("Seidel_Tilt_Clock")
        obj.push(result.seidelTiltClock_min)
        obj.push(result.seidelTiltClock_max)
    }
    if ( result.seidelAstClock === 1 ) {
        obj.push("Seidel_Ast_Clock")
        obj.push(result.seidelAstClock_min)
        obj.push(result.seidelAstClock_max)
    }
    if ( result.seidelComaClock === 1 ) {
        obj.push("Seidel_Coma_Clock")
        obj.push(result.seidelComaClock_min)
        obj.push(result.seidelComaClock_max)
    }

    if ( result.rmsPower === 1 ) {
        obj.push("RMS(Power)")
        obj.push(result.rmsPower_min)
        obj.push(result.rmsPower_max)
    }
    if ( result.rmsAst === 1 ) {
        obj.push("RMS(Ast)")
        obj.push(result.rmsAst_min)
        obj.push(result.rmsAst_max)
    }
    if ( result.rmsComa === 1 ) {
        obj.push("RMS(Coma)")
        obj.push(result.rmsComa_min)
        obj.push(result.rmsComa_max)
    }
    if ( result.rmsSa === 1 ) {
        obj.push("RMS(SA)")
        obj.push(result.rmsSa_min)
        obj.push(result.rmsSa_max)
    }

    if ( result.sag === 1 ) {
        obj.push("SAG")
        obj.push(result.sag_min)
        obj.push(result.sag_max)
    }
    if ( result.irr === 1 ) {
        obj.push("IRR")
        obj.push(result.irr_min)
        obj.push(result.irr_max)
    }
    if ( result.rsi === 1 ) {
        obj.push("RSI")
        obj.push(result.rsi_min)
        obj.push(result.rsi_max)
    }
    if ( result.rmst === 1 ) {
        obj.push("RMSt")
        obj.push(result.rmst_min)
        obj.push(result.rmst_max)
    }
    if ( result.rmsa === 1 ) {
        obj.push("RMSa")
        obj.push(result.rmsa_min)
        obj.push(result.rmsa_max)
    }
    if ( result.rmsi === 1 ) {
        obj.push("RMSi")
        obj.push(result.rmsi_min)
        obj.push(result.rmsi_max)
    }

    if ( result.ttv === 1 ) {
        obj.push("TTV")
        obj.push(result.ttv_min)
        obj.push(result.ttv_max)
    }
    if ( result.fringes === 1 ) {
        obj.push("Fringes")
        obj.push(result.fringes_min)
        obj.push(result.fringes_max)
    }
    if ( result.strehl === 1 ) {
        obj.push("Strehl_Ratio")
        obj.push(result.strehl_min)
        obj.push(result.strehl_max)
    }
    if ( result.parallelTheta === 1 ) {
        obj.push("Parallel_Theta")
        obj.push(result.parallelTheta_min)
        obj.push(result.parallelTheta_max)
    }
    if ( result.aperture === 1 ) {
        obj.push("Aperture")
        obj.push("")
        obj.push("")
    }
    if ( result.sizeX === 1 ) {
        obj.push("SizeX")
        obj.push("")
        obj.push("")
    }
    if ( result.sizeY === 1 ) {
        obj.push("SizeY")
        obj.push("")
        obj.push("")
    }
    if ( result.grms === 1 ) {
        obj.push("GRMS")
        obj.push(result.grms_min)
        obj.push(result.grms_max)
    }
    if ( result.concavity === 1 ) {
        obj.push("Concavity")
        obj.push("")
        obj.push("")
    }
    if ( result.curvatureRadius === 1 ) {
        obj.push("Curvature_Radius")
        obj.push("")
        obj.push("")
    }

    if ( result.z1 === 1 ) {
        obj.push("Z1")
        obj.push("")
        obj.push("")
    }
    if ( result.z2 === 1 ) {
        obj.push("Z2")
        obj.push("")
        obj.push("")
    }
    if ( result.z3 === 1 ) {
        obj.push("Z3")
        obj.push("")
        obj.push("")
    }
    if ( result.z4 === 1 ) {
        obj.push("Z4")
        obj.push("")
        obj.push("")
    }
    if ( result.z5 === 1 ) {
        obj.push("Z5")
        obj.push("")
        obj.push("")
    }
    if ( result.z6 === 1 ) {
        obj.push("Z6")
        obj.push("")
        obj.push("")
    }
    if ( result.z7 === 1 ) {
        obj.push("Z7")
        obj.push("")
        obj.push("")
    }
    if ( result.z8 === 1 ) {
        obj.push("Z8")
        obj.push("")
        obj.push("")
    }
    if ( result.z9 === 1 ) {
        obj.push("Z9")
        obj.push("")
        obj.push("")
    }

    return obj
}

// 根据类别获取泽尼克数据类型
function getZernikeItem(type) {
    var zernike = ["Piston Or Bias", "Tilt X", "Tilt Y", "Power", "Astigmatism X", "Astigmatism Y",
                   "Coma X", "Coma Y", "Primary Spherical", "Trefoil X", "Trefoil Y",
                   "Secondary Astigmatism X", "Secondary Astigmaitsm Y", "Secondary Coma X", "Secondary Coma Y",
                   "Secondary Spherical", "Tetrafoil X", "Tetrafoil Y", "Secondary Trefoil X", "Secondary Trefoil Y",
                   "Tertiary Astigmatism X", "Tertiary Astigmatism Y", "Tertiary Coma X", "Tertiary Coma Y",
                   "Tertiary Spherical", "Pentafoil X", "Pentafoil Y", "Secondary Tetrafoil X", "Secondary Tetrafoil Y",
                   "Tertiary Trefoil X", "Tertiary Trefoil Y", "Quatenary Astigmatism X", "Quatenary Astigmatism Y",
                   "Quatenary Coma X", "Quatenary Coma Y", "Quatenary Spherical", "Quinary Spherical"]

    var obj = []

    for ( var i = 0; i < type; ++i )
    {
        obj.push(zernike[i])
    }

    return obj
}

// 获取单位
function getUnit(type) {
    var unit = ""

    switch ( type )
    {
    case 0: unit = "λ"; break
    case 1: unit = "Fr"; break
    case 2: unit = "nm"; break
    case 3: unit = "μm"; break
    case 4: unit = "mm"; break
    }

    return unit
}

// 获取数据报表中的单位
function getUnitInResult(type, isoWL, result) {
    var unit = getUnit(type)
    var obj = []

    for ( var i = 0; i < result.length; ++i )
    {
        if ( result[i] === "PV" ) { obj.push(unit) }
        if ( result[i] === "PV(x)" ) { obj.push(unit) }
        if ( result[i] === "PV(y)" ) { obj.push(unit) }
        if ( result[i] === "PV(xy)" ) { obj.push(unit) }
        if ( result[i] === "PVr" ) { obj.push(unit) }
        if ( result[i] === "PV(res)" ) { obj.push(unit) }

        if ( result[i] === "RMS" ) { obj.push(unit) }
        if ( result[i] === "RMS(x)" ) { obj.push(unit) }
        if ( result[i] === "RMS(y)" ) { obj.push(unit) }
        if ( result[i] === "RMS(xy)" ) { obj.push(unit) }
        if ( result[i] === "RMS(res)" ) { obj.push(unit) }

        if ( result[i] === "Zernike_Tilt" ) { obj.push(unit) }
        if ( result[i] === "Power") { obj.push(unit) }
        if ( result[i] === "Power_X" ) { obj.push(unit) }
        if ( result[i] === "Power_Y" ) { obj.push(unit) }
        if ( result[i] === "Zernike_Ast" ) { obj.push(unit) }
        if ( result[i] === "Zernike_Coma" ) { obj.push(unit) }
        if ( result[i] === "Zernike_SA" ) { obj.push(unit) }

        if ( result[i] === "Seidel_Tilt" ) { obj.push(unit) }
        if ( result[i] === "Seidel_Focus" ) { obj.push(unit) }
        if ( result[i] === "Seidel_Ast" ) { obj.push(unit) }
        if ( result[i] === "Seidel_Coma" ) { obj.push(unit) }
        if ( result[i] === "Seidel_SA" ) { obj.push(unit) }
        if ( result[i] === "Seidel_Tilt_Clock" ) { obj.push("deg") }
        if ( result[i] === "Seidel_Ast_Clock" ) { obj.push("deg") }
        if ( result[i] === "Seidel_Coma_Clock" ) { obj.push("deg") }

        if ( result[i] === "RMS(Power)" ) { obj.push(unit) }
        if ( result[i] === "RMS(Ast)" ) { obj.push(unit) }
        if ( result[i] === "RMS(Coma)" ) { obj.push(unit) }
        if ( result[i] === "RMS(SA)" ) { obj.push(unit) }

        if ( result[i] === "SAG" ) { obj.push("fr@" + isoWL) }
        if ( result[i] === "IRR" ) { obj.push("fr@" + isoWL) }
        if ( result[i] === "RSI" ) { obj.push("fr@" + isoWL) }
        if ( result[i] === "RMSt" ) { obj.push("fr@" + isoWL) }
        if ( result[i] === "RMSa" ) { obj.push("fr@" + isoWL) }
        if ( result[i] === "RMSi" ) { obj.push("fr@" + isoWL) }

        if ( result[i] === "TTV" ) { obj.push(unit) }
        if ( result[i] === "Fringes" ) { obj.push("fr") }
        if ( result[i] === "Strehl_Ratio" ) { obj.push("/") }
        if ( result[i] === "Parallel_Theta" ) { obj.push("sec") }
        if ( result[i] === "Aperture" ) { obj.push("mm") }
        if ( result[i] === "SizeX" ) { obj.push("mm") }
        if ( result[i] === "SizeY" ) { obj.push("mm") }
        if ( result[i] === "GRMS" ) { obj.push(unit + "/mm") }
        if ( result[i] === "Concavity" ) { obj.push("/") }
        if ( result[i] === "Curvature_Radius" ) { obj.push("mm") }

        if ( result[i] === "Z1" ) { obj.push(unit) }
        if ( result[i] === "Z2" ) { obj.push(unit) }
        if ( result[i] === "Z3" ) { obj.push(unit) }
        if ( result[i] === "Z4" ) { obj.push(unit) }
        if ( result[i] === "Z5" ) { obj.push(unit) }
        if ( result[i] === "Z6" ) { obj.push(unit) }
        if ( result[i] === "Z7" ) { obj.push(unit) }
        if ( result[i] === "Z8" ) { obj.push(unit) }
        if ( result[i] === "Z9" ) { obj.push(unit) }
    }

    return obj
}

// 设置QC的上下限
function setResultLimit(oriList, limitList) {
    var obj = oriList
    var number = 0

    if ( oriList.pv === 1 ) {
        obj.pv_min = limitList.get(number).qcmin
        obj.pv_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.pvx === 1 ) {
        obj.pvx_min = limitList.get(number).qcmin
        obj.pvx_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.pvy === 1 ) {
        obj.pvy_min = limitList.get(number).qcmin
        obj.pvy_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.pvxy === 1 ) {
        obj.pvxy_min = limitList.get(number).qcmin
        obj.pvxy_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.pvr === 1 ) {
        obj.pvr_min = limitList.get(number).qcmin
        obj.pvr_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.pvres === 1 ) {
        obj.pvres_min = limitList.get(number).qcmin
        obj.pvres_max = limitList.get(number).qcmax
        number += 1
    }

    if ( oriList.rms === 1 ) {
        obj.rms_min = limitList.get(number).qcmin
        obj.rms_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsx === 1 ) {
        obj.rmsx_min = limitList.get(number).qcmin
        obj.rmsx_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsy === 1 ) {
        obj.rmsy_min = limitList.get(number).qcmin
        obj.rmsy_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsxy === 1 ) {
        obj.rmsxy_min = limitList.get(number).qcmin
        obj.rmsxy_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsres === 1 ) {
        obj.rmsres_min = limitList.get(number).qcmin
        obj.rmsres_max = limitList.get(number).qcmax
        number += 1
    }

    if ( oriList.zernikeTilt === 1 ) {
        obj.zernikeTilt_min = limitList.get(number).qcmin
        obj.zernikeTilt_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.zernikePower === 1 ) {
        obj.zernikePower_min = limitList.get(number).qcmin
        obj.zernikePower_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.zernikePowerX === 1 ) {
        obj.zernikePowerX_min = limitList.get(number).qcmin
        obj.zernikePowerX_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.zernikePowerY === 1 ) {
        obj.zernikePowerY_min = limitList.get(number).qcmin
        obj.zernikePowerY_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.zernikeAst === 1 ) {
        obj.zernikeAst_min = limitList.get(number).qcmin
        obj.zernikeAst_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.zernikeComa === 1 ) {
        obj.zernikeComa_min = limitList.get(number).qcmin
        obj.zernikeComa_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.zernikeSpherical === 1 ) {
        obj.zernikeSpherical_min = limitList.get(number).qcmin
        obj.zernikeSpherical_max = limitList.get(number).qcmax
        number += 1
    }

    if ( oriList.seidelTilt === 1 ) {
        obj.seidelTilt_min = limitList.get(number).qcmin
        obj.seidelTilt_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelFocus === 1 ) {
        obj.seidelFocus_min = limitList.get(number).qcmin
        obj.seidelFocus_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelAst === 1 ) {
        obj.seidelAst_min = limitList.get(number).qcmin
        obj.seidelAst_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelComa === 1 ) {
        obj.seidelComa_min = limitList.get(number).qcmin
        obj.seidelComa_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelSpherical === 1 ) {
        obj.seidelSpherical_min = limitList.get(number).qcmin
        obj.seidelSpherical_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelTiltClock === 1 ) {
        obj.seidelTiltClock_min = limitList.get(number).qcmin
        obj.seidelTiltClock_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelAstClock === 1 ) {
        obj.seidelAstClock_min = limitList.get(number).qcmin
        obj.seidelAstClock_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.seidelComaClock === 1 ) {
        obj.seidelComaClock_min = limitList.get(number).qcmin
        obj.seidelComaClock_max = limitList.get(number).qcmax
        number += 1
    }

    if ( oriList.rmsPower === 1 ) {
        obj.rmsPower_min = limitList.get(number).qcmin
        obj.rmsPower_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsAst === 1 ) {
        obj.rmsAst_min = limitList.get(number).qcmin
        obj.rmsAst_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsComa === 1 ) {
        obj.rmsComa_min = limitList.get(number).qcmin
        obj.rmsComa_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsSa === 1 ) {
        obj.rmsSa_min = limitList.get(number).qcmin
        obj.rmsSa_max = limitList.get(number).qcmax
        number += 1
    }

    if ( oriList.sag === 1 ) {
        obj.sag_min = limitList.get(number).qcmin
        obj.sag_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.irr === 1 ) {
        obj.irr_min = limitList.get(number).qcmin
        obj.irr_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rsi === 1 ) {
        obj.rsi_min = limitList.get(number).qcmin
        obj.rsi_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmst === 1 ) {
        obj.rmst_min = limitList.get(number).qcmin
        obj.rmst_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsa === 1 ) {
        obj.rmsa_min = limitList.get(number).qcmin
        obj.rmsa_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.rmsi === 1 ) {
        obj.rmsi_min = limitList.get(number).qcmin
        obj.rmsi_max = limitList.get(number).qcmax
        number += 1
    }

    if ( oriList.ttv === 1 ) {
        obj.ttv_min = limitList.get(number).qcmin
        obj.ttv_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.fringes === 1 ) {
        obj.fringes_min = limitList.get(number).qcmin
        obj.fringes_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.strehl === 1 ) {
        obj.strehl_min = limitList.get(number).qcmin
        obj.strehl_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.parallelTheta === 1 ) {
        obj.parallelTheta_min = limitList.get(number).qcmin
        obj.parallelTheta_max = limitList.get(number).qcmax
        number += 1
    }
    if ( oriList.grms === 1 ) {
        obj.grms_min = limitList.get(number).qcmin
        obj.grms_max = limitList.get(number).qcmax
    }

    return obj
}

//------------------------------------------------------------------------------

// 往数据报表中添加空的数据
function pushNanData(qc, result, path) {
    var data = getResultItem(result)
    var array = [""]    // 首个为 ProductID

    for ( var i = 0; i < data.length; ++i )
    {
        array.push("nan")
    }

    array.push(qc)
    array.push(globalFun.getCurrentTime(4))

    dataTableModel.push_backRow(array)

    // 自动保存数据
    autoSaveData(array, result, path)
}

// 自动保存数据
function autoSaveData(array, result, path) {
    var horizontalHeaderData = getResultItem(result)
    horizontalHeaderData.unshift("ProductID")
    horizontalHeaderData.push("QC")
    horizontalHeaderData.push("Data")

    algorithmCtl.autoSaveData(path, array, horizontalHeaderData)
}
