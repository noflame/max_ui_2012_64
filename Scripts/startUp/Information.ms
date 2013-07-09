try(destroyDialog ::rlInfo)catch()
rollout rlInfo "Information"
(
	label lbColor "Display Color:" pos:[10,13]
	dropdownlist dlColor items:#("wirecolor","red", "green", "blue", "white", "black", "yellow", "orange") width:70 pos:[80,10]
	label lbType "Display Type:" pos:[10,45]
	dropdownlist dlType items:#("Selection","Scene") width:70 pos:[80,42]
	label lbHidden "Show Hidden:" pos:[10,75]	
	checkbox cbHidden "" pos:[80,75]
	groupbox gpParameters "Parameters" width:140 height:155 pos:[10,100]
 	checkbutton btnObjectName "Object Name" width:120 height:25 pos:[20,120]
	checkbutton btnObjectID "Object ID" width:120 height:25 pos:[20,145]
	checkbutton btnObjectParent "Parents Names" width:120 height:25 pos:[20,170]
	checkbutton btnParentConnections "Parent Connections" width:120 height:25 pos:[20,195]
	checkbutton btnPolyCount "Poly Count" width:120 height:25 pos:[20,220]

	fn fnDisClr o = (
		selColor = dlColor.items[(dlColor.selection)]
		if selColor == "wirecolor" do (return o.wirecolor)
		if selColor == "red" do return red
		if selColor == "green" do return green
		if selColor == "blue" do return blue
		if selColor == "white" do return white
		if selColor == "black" do return black
		if selColor == "yellow" do return yellow
		if selColor == "orange" do return orange
	)
	
	fn userNodes = (
		selType = dlType.items[(dlType.selection)]
		col = if selType == "Selection" then Selection else Objects
		_theNodes = if cbHidden.state then col else (for o in col where not o.isHiddenInVpt collect o)
		return _theNodes
	)
	
	fn showObjectNames = if (gw.wTransPoint [0,0,0]) != undefined do (
		gw.setTransform (Matrix3 1)
		
		for o in (userNodes()) do
		(
			pos = gw.wTransPoint o.pos
			pos.z = 0
			gw.wtext pos o.name color:(fnDisClr o)
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)
	fn showObjectID = if (gw.wTransPoint [0,0,0]) != undefined do (
		gw.setTransform (Matrix3 1)
		for o in (userNodes()) do
		(
			pos = gw.wTransPoint o.pos
			pos.z = 0
			gw.wtext pos (o.gbufferchannel as string) color:(fnDisClr o)
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)
	fn showObjectParent = if (gw.wTransPoint [0,0,0]) != undefined do (
		gw.setTransform (Matrix3 1)
		for o in (userNodes()) do
		(
			pos = gw.wTransPoint o.pos
			pos.z = 0
			info = if o.parent != undefined then o.parent.name else "!"
			clr = if o.parent != undefined then (fnDisClr o.parent) else (fnDisClr o)
			gw.wtext pos info color:clr
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)
	fn showParentConnections = if (gw.wTransPoint [0,0,0]) != undefined do (
		gw.setTransform (Matrix3 1)
		for o in (userNodes()) do
		(
			pos = gw.wTransPoint o.pos
			pos.z = 0
			if o.parent != undefined do (
				gw.setColor #line (o.parent.wirecolor)
				gw.Polyline #(o.pos,o.parent.pos) true
			)
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)
	fn showObjectPolyCount = if (gw.wTransPoint [0,0,0]) != undefined do (
		gw.setTransform (Matrix3 1)
		
		for o in (userNodes()) where superclassof o == GeometryClass do
		(
			polyCount = o.mesh.numfaces as string
			pos = gw.wTransPoint o.pos
			pos.z = 0
			gw.wtext pos polyCount color:(fnDisClr o)
		)
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)
	fn updateInfo = (
		if btnObjectName.state then (
			unRegisterRedrawViewsCallback showObjectNames
			forceCompleteRedraw()
			registerRedrawViewsCallback showObjectNames
			forceCompleteRedraw()
		)
		if btnObjectID.state then (
			unRegisterRedrawViewsCallback showObjectID
			forceCompleteRedraw()
			registerRedrawViewsCallback showObjectID
			forceCompleteRedraw()
		)
		if btnObjectParent.state then (
			unRegisterRedrawViewsCallback showObjectParent
			forceCompleteRedraw()
			registerRedrawViewsCallback showObjectParent
			forceCompleteRedraw()
		)
		if btnParentConnections.state then (
			unRegisterRedrawViewsCallback showParentConnections
			forceCompleteRedraw()
			registerRedrawViewsCallback showParentConnections
			forceCompleteRedraw()
		)
		if btnPolyCount.state then (
			unRegisterRedrawViewsCallback showObjectPolyCount
			forceCompleteRedraw()
			registerRedrawViewsCallback showObjectPolyCount
			forceCompleteRedraw()
		)
	)
	
	on btnObjectName changed state do (
		(if state then registerRedrawViewsCallback else unRegisterRedrawViewsCallback) showObjectNames
		forceCompleteRedraw()
	)
	on btnObjectID changed state do (
		(if state then registerRedrawViewsCallback else unRegisterRedrawViewsCallback) showObjectID
		forceCompleteRedraw()
	)
	on btnObjectParent changed state do (
		(if state then registerRedrawViewsCallback else unRegisterRedrawViewsCallback) showObjectParent
		forceCompleteRedraw()
	)
	on btnParentConnections changed state do (
		(if state then registerRedrawViewsCallback else unRegisterRedrawViewsCallback) showParentConnections
		forceCompleteRedraw()
	)
	on btnPolyCount changed state do (
		(if state then registerRedrawViewsCallback else unRegisterRedrawViewsCallback) showObjectPolyCount
		forceCompleteRedraw()
	)
	on cbHidden changed state do (updateInfo())
	on dlColor selected idx do (updateInfo())
	on dlType selected idx do (updateInfo())
	on rlIDTools close do (
		unRegisterRedrawViewsCallback showObjectNames
		unRegisterRedrawViewsCallback showObjectID
		unRegisterRedrawViewsCallback showObjectParent
		unRegisterRedrawViewsCallback showParentConnections
		unRegisterRedrawViewsCallback showObjectPolyCount
	)
)
createDialog rlInfo 160 265 style:#(#style_SysMenu, #style_ToolWindow)