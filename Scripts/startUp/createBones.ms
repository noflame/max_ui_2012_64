plugin simpleObject createBones name:"Create bones" classID:#(145345,543211) category:"Standard Primitives" silentErrors:true
(
	local
		rm;
	
	tool create
	(
		local
			newPos,
			oldPos,
			previousBone,
			currentBone;
		
		on start do (
			newPos = undefined
			oldPos = undefined
			previousBone = undefined
			currentBone = undefined
			
			
			
			mySel = getCurrentSelection()
			if mySel.count > 0 then
			(
				rm = RayMeshGridIntersect()
				rm.Initialize 100
				for o in mySel do rm.addNode o
				rm.buildGrid()
			)
			else #abort
		)
		
		on mousePoint clickno do (
			if rm != undefined then
			(
				oldPos = newPos
				previousBone = currentBone
				
				pos = (Inverse (getViewTM())).pos
				dir = normalize (worldPoint - pos)
				
				if clickno != 1 then
				(
					theHitsCount = rm.intersectRay pos dir true
					if theHitsCount > 1 AND viewport.IsPerspView()  then
					(
						distances = for i=1 to theHitsCount collect (rm.getHitDist i)
						distancesSorted = sort distances
						index1 = findItem distances distancesSorted[1]
						index2 = findItem distances distancesSorted[2]
						dist1 = rm.getHitDist index1
						dist2 = rm.getHitDist index2
						pos1 = (pos+(dist1*dir))
						pos2 = (pos+(dist2*dir))
						newPos = (pos1+pos2)/2
					)
					else
					(
						newPos = worldPoint
					)
					if oldpos == undefined then oldPos = newPos
						
					newBone = BoneSys.createBone oldPos newPos [0,1,0]
					if currentBone != undefined then newBone.parent = currentBone
					currentBone = newBone
				)
			) else #abort
		)
		on mouseMove pos do (
			if rm != undefined then
			(
				pos = (Inverse (getViewTM())).pos
				dir = normalize (worldPoint - pos)
				theHitsCount = rm.intersectRay pos dir true
				if theHitsCount > 1 AND viewport.IsPerspView() then
				(
					distances = for i=1 to theHitsCount collect (rm.getHitDist i)
					distancesSorted = sort distances
					index1 = findItem distances distancesSorted[1]
					index2 = findItem distances distancesSorted[2]
					dist1 = rm.getHitDist index1
					dist2 = rm.getHitDist index2
					pos1 = (pos+(dist1*dir))
					pos2 = (pos+(dist2*dir))
					newPos = (pos1+pos2)/2
				)
				else ( newPos = worldPoint )
				
				if currentBone != undefined then
				(
					myTM = matrixFromNormal (normalize (newPos-oldPos))
					currentBone.dir = (normalize (newPos-oldPos))
					currentBone.transform = matrix3 myTM.row3 -myTM.row1 -myTM.row2 oldPos
					currentBone.length = distance newPos oldPos
				)
			) else #abort
		)
		on mouseAbort arg do (
			if currentBone != undefined AND previousBone != undefined then
			(
				currentBone.length = 4
				if previousBone != undefined then currentBone.dir = previousBone.dir
				in coordsys local rotate currentBone (eulerAngles 0 0 -90)
				delete $
				select currentBone
			)
			else ( delete $ )
		)
	)

)