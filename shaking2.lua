--[[
    shaking2.lua
	programmed by gcyong (gcyong@outlook.com)
]]

include("karaskel.lua");
include("unicode.lua");

--[[ 여러가지 설정 값 ]]
gcyongShaking = {
	--[[ 정렬 기준과 좌표 값 ]]
	stPoint = { al = nil, x = nil, y = nil },
	--[[ 흔드는 범위 ]]
	stRange = { Left = { x = nil, y = nil }, Right = { x = nil, y = nil } },
	--[[ 흔드는 시간 ]]
	uShakingTime = nil,
	--[[ 적용되는 자막 ]]
	stAppliedLine = { uType = nil, pLine = nil },
	--[[ 자막 종류 ]]
	APPLINETYPE_ALL = 0,
	APPLINETYPE_SEL = 1,
	APPLINETYPE_ACT = 2,
	--[[ 다이얼로그 ]]
	stDialog = { }
}

--[[ 다이얼로그 ]]
gcyongShaking.stDialog = {
	--[[ 적용되는 자막 선택 ]]
	{
		class	= "label",
		x		= 0,
		y		= 0,
		width	= 10,
		height	= 1,
		label	= "적용하려는 자막을 선택합니다."
	},
	{
		class	= "dropdown",
		x		= 0,
		y		= 1,
		width	= 10,
		height	= 1,
		name	= "AppliedLine",
		items	= { "모든 자막(All Lines)", "선택한 자막(Selected Lines)", "현재 작업중인 자막(Active Line)" },
		value	= "모든 자막(All Lines)"
	},
	--[[ 정렬 기준 선택 ]]
	{
		class	= "label",
		x		= 0,
		y		= 2,
		width	= 10,
		height	= 1,
		label	= "정렬 기준(Alignment)을 선택합니다."
	},
	{
		class	= "dropdown",
		x		= 0,
		y		= 3,
		width	= 10,
		height	= 1,
		name	= "Alignment",
		items	= { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
		value	= 1
	},
	--[[ 자막을 위치할 좌표 입력 ]]
	{
		class	= "label",
		x		= 0,
		y		= 4,
		width	= 10,
		height	= 1,
		label	= "자막을 위치할 좌표를 입력합니다."
	},
	{
		class	= "label",
		x		= 0,
		y		= 5,
		width	= 1,
		height	= 1,
		label	= "x"
	},
	{
		class	= "intedit",
		x		= 1,
		y		= 5,
		width	= 4,
		height	= 1,
		name	= "xPoint",
		value	= 0
	},
	{
		class	= "label",
		x		= 5,
		y		= 5,
		width	= 1,
		height	= 1,
		label	= "y"
	},
	{
		class	= "intedit",
		x		= 6,
		y		= 5,
		width	= 4,
		height	= 1,
		name	= "yPoint",
		value	= 0
	},
	--[[ 흔드는 범위 입력 ]]
	{
		class	= "label",
		x		= 0,
		y		= 6,
		width	= 10,
		height	= 1,
		label	= "흔들 범위를 입력합니다. (좌상단, 우하단)"
	},
		--[[ 좌상단 ]]
	{
		class	= "label",
		x		= 0,
		y		= 7,
		width	= 1,
		height	= 1,
		label	= "lx"
	},
	{
		class	= "intedit",
		x		= 1,
		y		= 7,
		width	= 4,
		height	= 1,
		name	= "xLeftPoint",
		value	= 0
	},
	{
		class	= "label",
		x		= 5,
		y		= 7,
		width	= 1,
		height	= 1,
		label	= "ly"
	},
	{
		class	= "intedit",
		x		= 6,
		y		= 7,
		width	= 4,
		height	= 1,
		name	= "yLeftPoint",
		value	= 0
	},
		--[[ 우하단 ]]
	{
		class	= "label",
		x		= 0,
		y		= 8,
		width	= 1,
		height	= 1,
		label	= "rx"
	},
	{
		class	= "intedit",
		x		= 1,
		y		= 8,
		width	= 4,
		height	= 1,
		name	= "xRightPoint",
		value	= 0
	},
	{
		class	= "label",
		x		= 5,
		y		= 8,
		width	= 1,
		height	= 1,
		label	= "ry"
	},
	{
		class	= "intedit",
		x		= 6,
		y		= 8,
		width	= 4,
		height	= 1,
		name	= "yRightPoint",
		value	= 0
	},
	--[[ 적용되는 시간 입력 ]]
	{
		class	= "label",
		x		= 0,
		y		= 9,
		width	= 10,
		height	= 1,
		label	= "적용되는 시간을 밀리초 단위로 입력합니다."
	},
	{
		class	= "intedit",
		x		= 0,
		y		= 10,
		width	= 8,
		height	= 1,
		name	= "AppliedTime",
		min		= 0
	},
	{
		class	= "label",
		x		= 8,
		y		= 10,
		width	= 1,
		height	= 1,
		label	= "ms"
	}	
}

function WorkProc( subtitles, selectedLines, activeLine )

	bBtn, stOptions = aegisub.dialog.display( gcyongShaking.stDialog )
	mata, styles = karaskel.collect_head(subtitles)
	lines = { }
	
	if bBtn then
		-- 옵선을 지정함
		
		
		
		-- 적용되는 자막
		if options.AppliedLine == "현재 작업중인 자막(Active Line)" then
			gcyongShaking.stAppliedLine.uType = gcyongShaking.APPLINETYPE_ACT 
			gcyongShaking.stAppliedLine.pLine = activeLine
			if activeLine.class == "dialog" then
				line = activeLine
				karaskel.preproc_line(subtitles, meta, styles, line)
				karaskel.preproc_line_text(meta, styles, line)
				karaskel.preproc_line_size(meta, styles, line)
				lines[1] = line
			end
		else if options.AppliedLine == "모든 자막(All Lines)" then
			gcyongShaking.stAppliedLine.uType = gcyongShaking.APPLINETYPE_ALL
			gcyongShaking.stAppliedLine.pLine = subtitles
			cnt = 1
			for i = 1, #subtitles do
				line = subtitles[i]
				if line.class == "dialog" then
					karaskel.preproc_line(subtitles, meta, styles, line)
					karaskel.preproc_line_text(meta, styles, line)
					karaskel.preproc_line_size(meta, styles, line)
					lines[cnt] = line
					cnt = cnt + 1
				end
			end
		else if options.AppliedLine == "선택한 자막(Selected Lines)" then
			gcyongShaking.stAppliedLine.uType = gcyongShaking.APPLINETYPE_SEL
			gcyongShaking.stAppliedLine.pLinw = selectedLines
			cnt = 1
			for i = 1, #selectedLines do
				line = selectedLines[i]
				if line.class == "dialog" then
					karaskel.preproc_line(subtitles, meta, styles, line)
					karaskel.preproc_line_text(meta, styles, line)
					karaskel.preproc_line_size(meta, styles, line)
					lines[cnt] = line
					cnt = cnt + 1
				end
			end
		else
			aegisub.cancel()
		end
		-- 흔드는 시간
		gcyongShaking.uShakingTime = options.AppliedTime
		-- 흔드는 범위
		if options.xLeftPoint > options.xRightPoint then
			tmp = options.xRightPoint
			options.xRightPoint = options.xLeftPoint
			options.xLeftPoint = tmp
		end
		if options.yLeftPoint > options.yRightPoint then
			tmp = options.yRightPoint
			options.yRightPoint = options.yLeftPoint
			options.yLeftPoint = tmp
		end
		gcyongShaking.stRange.Left.x = options.xLeftPoint
		gcyongShaking.stRange.Left.y = options.yLeftPoint
		gcyongShaking.stRange.Right.x = options.xRightPoint
		gcyongShaking.stRange.Right.y = options.yRightPoint
		-- 정렬 기준과 좌표 값
		gcyongShaking.stPoint.x = options.xPoint
		gcyongShaking.stPoint.y = options.yPoint
		gcyongShaking.stPoint.al = options.Alignment
		
		
	else
		aegisub.debug.out( "흔들 효과를 취소합니다." )
	end
end

aegisub.register_macro("가속 기능", "자막의 가속기능을 제공합니다.", WorkProc)