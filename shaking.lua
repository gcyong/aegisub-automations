--[[
    shaking.lua
	programmed by gcyong (gcyong@outlook.com)
]]

include("karaskel.lua")

dx = { -1, 1 }
dy = { -1, 1 }
pt = { x = 0, y = 0 }

-- Script info. global variables
script_name        = "Shaking a line"
script_description = "effect shaking a line"
script_version     = "0.5v"
script_author      = "gcyong"

-- dialogue
dialog = {
	-- setting frame
	{class = "label", x = 0, y = 0, width = 4, height = 1, label = "프레임"},
	{class = "intedit", x = 5, y = 0, width = 4, height = 1, min = 0, value = 1, name = "frame",
	hint = "넘기는 프레임을 입력합니다. 기본이 1프레임이고, 0프레임이면 1프레임에서 5프레임 사이에서 랜덤 설정됩니다. 너무 큰 값을 입력하는 것은 권장하지 않습니다."},
	{class = "label", x = 9, y = 0, width = 3, height = 1, label = "frame(s)"},
	-- position
	{class = "label", x = 0, y = 1, width = 4, height = 1, label = "위치"},
	{class = "label", x = 4, y = 1, width = 1, height = 1, label = "x"},
	{class = "intedit", x = 5, y = 1, width = 3, height = 1, value = 0, name = "xpos", hint = "위치하는 좌표의 x값을 입력합니다."},
	{class = "label", x = 8, y = 1, width = 1, height = 1, label = "y"},
	{class = "intedit", x = 9, y = 1, width = 3, height = 1, value = 0, name = "ypos", hint = "위치하는 좌표의 y값을 입력합니다."},
	{class = "checkbox", x = 0, y = 2, width = 12, height = 1, label = "스타일에서 정한 위치를 사용합니다.", name = "defpos"},
	-- range
	{class = "label", x = 0, y = 3, width = 3, height = 1, label = "범위"},
	{class = "label", x = 3, y = 3, width = 1, height = 1, label = "x"},
	{class = "label", x = 5, y = 3, width = 1, height = 1, label = "-"},
	{class = "intedit", x = 6, y = 3, width = 2, height = 1, value = 1, min = 0, name = "xlim", hint = "프레임이 기준 위치에서 움직일 x좌표의 값을 하한선으로 설정합니다."},
	{class = "label", x = 8, y = 3, width = 1, height = 1, label = "~"},
	{class = "label", x = 9, y = 3, width = 1, height = 1, label = "+"},
	{class = "intedit", x = 10, y = 3, width = 2, height = 1, value = 1, min = 0, name = "limx", hint = "프레임이 기준 위치에서 움직일 x좌표의 값을 상한선으로 설정합니다."};
	{class = "label", x = 3, y = 4, width = 1, height = 1, label = "y"},
	{class = "label", x = 5, y = 4, width = 1, height = 1, label = "-"},
	{class = "intedit", x = 6, y = 4, width = 2, height = 1, value = 1, min = 0, name = "ylim", hint = "프레임이 기준 위치에서 움직일 y좌표의 값을 하한선으로 설정합니다."},
	{class = "label", x = 8, y = 4, width = 1, height = 1, label = "~"},
	{class = "label", x = 9, y = 4, width = 1, height = 1, label = "+"},
	{class = "intedit", x = 10, y = 4, width = 2, height = 1, value = 1, min = 0, name = "limy", hint = "프레임이 기준 위치에서 움직일 y좌표의 값을 상한선으로 설정합니다."},
	-- applied lines
	{class = "label", x = 0, y = 5, width = 4, height = 1, label = "적용할 자막"},
	{class = "dropdown", x = 4, y = 5, width = 8, hegiht = 1, items = {"현재 편집중인 자막", "선택된 자막(들)", "모든 자막"}, value = "현재 편집중인 자막", name = "subt"}
}

function line_proc(idx, subtitles, defpos, skip)
	line = subtitles[idx]
	
	meta, styles = karaskel.collect_head(subtitles, false)
	karaskel.preproc_line(subtitles, meta, styles, line)
	karaskel.preproc_line_text(meta, styles, line)
	karaskel.preproc_line_size(meta, styles, line)
	karaskel.preproc_line_pos(meta, styles, line)
	if defpos then
		pt.x = line.x
		pt.y = line.y
	end
	if line.class == "dialogue" then
		if line.comment then
			return
		end
		line.comment = true
		subtitles[idx] = line
		line.comment = false
		stime = line.start_time
		etime = line.end_time
		sframe = aegisub.frame_from_ms(stime)
		eframe = aegisub.frame_from_ms(etime)
		dframe = eframe - sframe - 1
		nx = pt.x
		ny = pt.y
		fs = 0
		while fs < dframe do
			lncopy = table.copy(line)
			lncopy.start_time = aegisub.ms_from_frame(fs + sframe)
			lncopy.end_time = aegisub.ms_from_frame(fs + skip + sframe)
			lncopy.duration = lncopy.end_time - lncopy.start_time
			lncopy.text = "{\\pos(" .. nx .. ", " .. ny .. ")}" .. lncopy.text
			subtitles[0] = lncopy 
			nx = math.random() * dx[math.random(2)] + pt.x
			ny = math.random() * dy[math.random(2)] + pt.y
			fs = fs + skip
		end
	end
end

function process_func(subtitles, selected_lines, active_line)
	math.randomseed(os.time())
	button, options = aegisub.dialog.display(dialog)
	
	if button then
		dx[1] = options.xlim
		dx[2] = options.limx
		dy[1] = options.ylim
		dy[2] = options.limy
		defpos = false
		if options.defpos then
			defpos = true
		else
			pt.x = options.xpos
			pt.y = options.ypos
		end
		skip = 0
		if options.frame == 0 then
			skip = math.random(1, 5)
		else
			skip = options.frame
		end
		if options.subt == "현재 편집중인 자막" then
			line_proc(active_line, subtitles, defpos, skip)
		elseif options.subt == "선택된 자막(들)" then
			for i = 1, #selected_lines do
				line_proc(selected_lines[i], subtitles, defpos, skip)
			end
		else
			n = #subtitles
			for i = 1, n do
				line_proc(i, subtitles, defpos, skip)
			end
		end
	end
end

aegisub.register_macro(script_name, script_description, process_func)