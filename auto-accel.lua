--[[
	auto-accel.lua
	programmed by gcyong(gcyong.tistory.com)
]]

include("karaskel.lua");
include('unicode.lua');

--[[ 가속 비중을 랜덤으로 설정할때 하한값과 상한값 ]]
ACCEL_RANDOM_MIN	= 1
ACCEL_RANDOM_MAX	= 100

--[[ information of manager ]]
script_name			= "가속 기능";
script_description	= "자막의 가속을 오토메이션으로 구현합니다.";
script_author		= "gcyong(gcyong.tistory.com)";
script_version		= "0.1";

--[[ accelerated unit ]]
ACCEL_UNIT_LINE		= 0
ACCEL_UNIT_WORD		= 1
ACCEL_UNIT_CHAR		= 2

--[[ class processing acceleration ]]
gcyong_accel={q={}, c={}}

gcyong_accel.subtitles			= nil
gcyong_accel.meta				= nil
gcyong_accel.styles				= nil
gcyong_accel.actors				= {}

gcyong_accel.q.selected_actor	= nil
gcyong_accel.q.start_pos		= {x=nil, y=nil}
gcyong_accel.q.end_pos			= {x=nil, y=nil}
gcyong_accel.q.random_accel		= nil
gcyong_accel.q.acceleration		= nil
gcyong_accel.q.accel_unit		= nil
gcyong_accel.q.ignore_end_pos	= nil

gcyong_accel.c.direction		= {x=nil, y=nil}
gcyong_accel.c.applied_lines	= {}

gcyong_accel.dialog={
	{
		class	= "label",
		x		= 0,
		y		= 0,
		width	= 13,
		height	= 1,
		label	= "옵션(각 옵션에 대한 설명은 마우스로 입력창을 가리키면 나옵니다.)"
	},
	{
		class	= "label",
		x		= 0,
		y		= 1,
		width	= 1,
		height	= 1,
		label	= "가속되는 엑터"
	},
	{
		class	= "dropdown",
		x		= 1,
		y		= 1,
		width	= 12,
		height	= 1,
		name	= "accel_actor",
		hint	= "가속하고자 하는 자막의 엑터를 설정합니다.",
		items	= {},
		value	= ""
	},
	{
		class	= "label",
		x		= 0,
		y		= 2,
		width	= 1,
		height	= 1,
		label	= "시작 위치"
	},
	{
		class	= "label",
		x		= 2,
		y		= 2,
		width	= 1,
		height	= 1,
		label	= "x"
	},
	{
		class	= "intedit",
		x		= 3,
		y		= 2,
		width	= 4,
		height	= 1,
		name	= "start_pos_x",
		hint	= "시작 좌표의 x값을 입력합니다.",
		value	= 0
	},
	{
		class	= "label",
		x		= 8,
		y		= 2,
		width	= 1,
		height	= 1,
		label	= "y"
	},
	{
		class	= "intedit",
		x		= 9,
		y		= 2,
		width	= 4,
		height	= 1,
		name	= "start_pos_y",
		hint	= "시작 좌표의 y값을 입력합니다.",
		value	= 0
	},
	{
		class	= "label",
		x		= 0,
		y		= 3,
		width	= 1,
		height	= 1,
		label	= "종료 위치"
	},
	{
		class	= "label",
		x		= 2,
		y		= 3,
		width	= 1,
		height	= 1,
		label	= "x"
	},
	{
		class	= "intedit",
		x		= 3,
		y		= 3,
		width	= 4,
		height	= 1,
		name	= "end_pos_x",
		hint	= "종료 좌표의 x값을 입력합니다.",
		value	= 0
	},
	{
		class	= "label",
		x		= 8,
		y		= 3,
		width	= 1,
		height	= 1,
		label	= "y"
	},
	{
		class	= "intedit",
		x		= 9,
		y		= 3,
		width	= 4,
		height	= 1,
		name	= "end_pos_y",
		hint	= "종료 좌표의 y값을 입력합니다.",
		value	= 0
	},
	{
		class	= "label",
		x		= 0,
		y		= 4,
		width	= 1,
		height	= 1,
		label	= "가속되는 단위"
	},
	{
		class	= "dropdown",
		x		= 1,
		y		= 4,
		width	= 12,
		height	= 1,
		name	= "accel_unit",
		hint	= "가속의 단위를 적습니다. 해당 줄 자체를 가속하려면 'line'을, 단어별로 분리해서 가속하려면 'word'를, 글자별로 분리해서 가속하려면 'character'를 선택합니다.",
		items	= {"line", "word", "character"},
		value	= "line"
	},
	{
		class	= "label",
		x		= 0,
		y		= 5,
		width	= 1,
		height	= 1,
		label	= "가속 비중(0 ~ 100)"
	},
	{
		class	= "intedit",
		x		= 1,
		y		= 5,
		width	= 12,
		height	= 1,
		name	= "acceleration",
		hint	= "한 프레임 별로 가속되는 비중을 적습니다. 1이면 등속이고, 0이면 랜덤입니다.",
		min		= 0,
		max		= 100,
		value	= 0
	},
	{
		class	= "label",
		x		= 0,
		y		= 6,
		width	= 1,
		height	= 1,
		label	= "종료 위치를 무시합니다."
	},
	{
		class	= "dropdown",
		x		= 1,
		y		= 6,
		width	= 12,
		height	= 1,
		name	= "ignore_end_pos",
		hint	= "종료 위치를 무시하고 시작 위치에서 정해진 시간동안 가속합니다. 만일 종료 위치를 무시하더라도 종료 위치는 반드시 입력해야 합니다. 방향을 계산해야 하기 때문입니다. 만일 종료 위치를 무시한다면 정확히 위치를 입력할 필요 없이, 방향에만 맞게 입력해도 됩니다. 가령, (0, 0)에서 우하단으로 이동할 때, 방향을 무시한다면 (10, 10)이던, (1, 1)이던 동일하게 작동합니다.",
		items	= {"yes", "no"},
		value	= "yes"
	}
}

--[[ gcyong_accel의 멤버 함수 ]]

function gcyong_accel:init_accel(subtitles, selected_lines, active_line)
	self.subtitles = nil
	self.meta = nil
	self.styles = nil
	self.actors = {}

	self.q.selected_actor = nil
	self.q.start_pos = {x=nil, y=nil}
	self.q.end_pos = {x=nil, y=nil}
	self.q.random_accel = nil
	self.q.acceleration = nil
	self.q.accel_unit = nil
	self.q.ignore_end_pos = nil

	self.c.direction = {x=nil, y=nil}
	self.c.applied_lines = {}
	
	self.subtitles = subtitles
	self.meta, self.styles = karaskel.collect_head(subtitles)
end

function gcyong_accel:find_actor(act)
	local actors = self.actors
	if actors == nil then
		return false
	else
		local cnt = #actors
		for i = 0, cnt do
			if actors[i] == act then
				return true
			end
		end
	end
	
	return false
end

function gcyong_accel:get_line_info(idx)
	if idx < 1 then
		return nil
	end
	if idx > #self.subtitles then
		return nil
	end
	local line = self.subtitles[idx]
	if line.class == "dialogue" then
		karaskel.preproc_line(self.subtitles, self.meta, self.styles, line)
		karaskel.preproc_line_text(self.meta, self.styles, line)
		karaskel.preproc_line_size(self.meta, self.styles, line)
		return line
	end
	
	return nil
end
	
function gcyong_accel:init_dialog()
	local subtitles=self.subtitles
	self.dialog[3].items = {}
	for i = 1, #subtitles do
		local line = self:get_line_info(i)
		if line ~= nil and self:find_actor(line.actor) == false then
			table.insert(self.dialog[3].items, line.actor)
			self.actors[#self.actors + 1] = line.actor
		end
	end
end

function gcyong_accel:delete_pre_actor()
	local subtitles = self.subtitles
	local i = 1
	while i <= #subtitles do
		local line = subtitles[i]
		if line ~= nil and line.effect == (self.q.selected_actor .. "-accel-result") then
			subtitles.delete(i)
			i = i - 1
		end
		i = i + 1
	end
end		

function gcyong_accel:setting_options(options)
	--[[ 전달받은 옵션을 저장 ]]
	self.q.selected_actor = options.accel_actor;
	self.q.start_pos.x = options.start_pos_x;
	self.q.start_pos.y = options.start_pos_y;
	self.q.end_pos.x = options.end_pos_x;
	self.q.end_pos.y = options.end_pos_y;
	local unit = options.accel_unit;
	if unit == "line" then
		self.q.accel_unit = ACCEL_UNIT_LINE
	elseif unit == "word" then
		self.q.accel_unit = ACCEL_UNIT_WORD
	elseif unit == "character" then
		self.q.accel_unit = ACCEL_UNIT_CHAR
	end
	self.q.acceleration = options.acceleration
	if options.acceleration == 0 then
		self.q.random_accel = true
	else
		self.q.random_accel = false
	end
	if options.ignore_end_pos == "yes" then
		self.q.ignore_end_pos = true
	else
		self.q.ignore_end_pos = false
	end
end

function gcyong_accel:calc_attr()
	--[[ 적용할 자막의 인덱스를 저장 ]]
	local subtitles = self.subtitles
	local selected_actor = self.q.selected_actor
	for i = 1, #subtitles do
		local line = self:get_line_info(i)
		if line ~= nil and line.actor == selected_actor then
			table.insert(self.c.applied_lines, i)
		end
	end
	--[[ 방향 계산 ]]
	local dx, dy = 0, 0
	dx = self.q.end_pos.x - self.q.start_pos.x
	dy = self.q.end_pos.y - self.q.start_pos.y
	self.c.direction.x = dx
	self.c.direction.y = dy
end

function gcyong_accel:setting_accel_line()
	local line_num = #self.c.applied_lines
	for i = 1, line_num do
		if self.q.random_accel == true then
			self.q.acceleration = math.random(ACCEL_RANDOM_MIN, ACCEL_RANDOM_MAX)
		end
		local line = self:get_line_info(self.c.applied_lines[i])
		local start_time, end_time = line.start_time, line.end_time
		local start_frame, end_frame = aegisub.frame_from_ms(start_time), aegisub.frame_from_ms(end_time)
		local dur_frame = end_frame - start_frame + 1
		local one_frame_ms = aegisub.ms_from_frame(1) * 2
		local accel = self.q.acceleration
		--[[ 프레임당 방향 증분 계산 ]]
		local dx, dy = self.c.direction.x / dur_frame, self.c.direction.y / dur_frame
		--[[ line_copy를 dur_frame동안 반복하면서 라인 추가 ]]
		local nx, ny = 0, 0
		for f = 0, dur_frame - 1 do
			local line_copy = table.copy(line)
			line_copy.start_time = start_time + aegisub.ms_from_frame(f + start_frame)
			line_copy.end_time = start_time + aegisub.ms_from_frame(f + start_frame + 1)
			line_copy.duration = line_copy.end_time - line_copy.start_time
			if f == 0 then
				nx = self.q.start_pos.x
				ny = self.q.start_pos.y
			else
				if accel == 1 then
					nx = nx + dx
					ny = ny + dy
				else
					nx = nx + dx * (accel * line_copy.start_time / 1000)^2
					ny = ny + dy * (accel * line_copy.start_time / 1000)^2
				end
				if self.q.ignore_end_pos == false then
					if nx > self.q.end_pos.x or ny > self.q.end_pos.y then
						nx = self.q.end_pos.x
						ny = self.q.end_pos.y
					end
				end
			end
			line_copy.comment = false
			local line_text = "{\\pos(" .. nx .. ", " .. ny .. ")}" .. line_copy.text
			line_copy.text = line_text
			line_copy.effect = line_copy.actor .. "-accel-result"
			line_copy.actor = ""
			self.subtitles.append(line_copy)
		end
		line.comment = true
		line.effect = "accelerated line"
		self.subtitles[self.c.applied_lines[i]] = line
	end
end

function gcyong_accel:setting_accel_word()
	local line_num = #self.c.applied_lines
	local split_words = {}
	local applied_lines = {}
	local split_words_count = nil
	local process_line = nil
	local display, shadow = "{\\alpha&H00&}", "{\\alpha&HFF&}"
	
	-- 모든 라인에 대해 반복
	for i = 1, line_num do
		-- 한 라인에 대해 단어를 쪼갬
		process_line = self:get_line_info(self.c.applied_lines[i])
		split_words = {}
		split_words_count = 1
		local start_pos = 1
		for j = 1, string.len(process_line) do
			sub_str = string.sub(process_line, j, j + 1)
			if sub_str == " " then
				-- start_pos부터 j-1까지 잘라서 split_words에 넣음
				split_words[split_words_count] = string.sub(process_line, start_pos, j-1)
				split_words_count = split_words_count + 1
				start_pos = j + 1
			end
		end
		-- 넣었으면 각 묶음에 대해 다시 전체 라인을 만듦
		for j = 1, #split_words do
			if j == 1 then
				applied_lines[1] = display .. split_words[1] .. " " .. shadow
				for k = 2, #split_words do
					applied_lines[1] = applied_lines[1] .. " " .. split_words[k]
				end
			elseif j == #split_words then
				applied_lines[j] = shadow
				for k = 1, j-1 do
					applied_lines[j] = applied_lines[j] .. " " .. split_words[k]
				end
				applied_lines[j] = applied_lines[j] .. " " .. display .. split_words[j]
			else
				applied_lines[j] = shadow
				for k = 1, j-1 do
					applied_lines[j] = applied_lines[j] .. " " .. split_words[k]
				end
				applied_lines[j] = applied_lines[j] .. " " .. display .. split_words[j] .. " " .. shadow
				for k = j+1, #split_words do
					applied_lines[j] = applied_lines[j] .. " " .. split_words[k]
				end
			end
			aegisub.debug.out(applied_lines[j] .. "\n")
		end
	end
end

function gcyong_accel:process()
	local accel_unit = self.q.accel_unit
	if accel_unit == ACCEL_UNIT_LINE then
		self:setting_accel_line()
		return true
	elseif accel_unit == ACCEL_UNIT_WORD then
		self:setting_accel_word()
		return true
	elseif accel_unit == ACCEL_UNIT_CHAR then
		-- 글자별 처리함수
		return true
	end
	return false
end

function processing_function(subtitles, selected_lines, active_line)
	local ok_button, options = nil, nil
	math.randomseed(os.time())
	gcyong_accel:init_accel(subtitles, selected_lines, active_line)
	gcyong_accel:init_dialog()
	aegisub.debug.out("가속을 구현하기 전에 먼저 설정합니다.")
	ok_button, options = aegisub.dialog.display(gcyong_accel.dialog)
	if ok_button == true then
		aegisub.debug.out(" ... OK.\n")
		aegisub.debug.out("옵션을 입력합니다.")
		gcyong_accel:setting_options(options)
		gcyong_accel:calc_attr()
		aegisub.debug.out(" ... OK.\n")
		aegisub.debug.out("이전에 적용했던 자막을 지웁니다.")
		gcyong_accel:delete_pre_actor()
		aegisub.debug.out(" ... OK.\n")
		aegisub.debug.out("가속 자막을 처리합니다.")
		local success = gcyong_accel:process()
		aegisub.progress.set(99)
		aegisub.set_undo_point("가속 자막 처리하기")
		if success == true then
			aegisub.progress.set(100)
			aegisub.debug.out(" ... OK.\n")
			aegisub.progress.task("가속 자막을 모두 처리했습니다.")
		else
			aegisub.debug.out(" ... Failed.\n")
			aegisub.progress.task("가속 자막을 처리하는 도중 오류가 발생했습니다.")
		end
	else
		aegisub.debug.out("\n가속 적용을 취소합니다.")
	end
end

aegisub.register_macro("가속 기능", "자막의 가속기능을 제공합니다.", processing_function)