--[[
	Random Appearance
	effect displaying characters or words at random time
	programmed by gcyong (gcyong@outlook.com)
]]

include("karaskel.lua");
include("unicode.lua");

--[[ information ]]
script_name			= "Random Appearance";
script_description	= "effect displaying characters or words at random time";
script_author		= "gcyong(gcyong.tistory.com)";
script_version		= "F";

gcyongRandomAppearance = {
	dialog = { },
	subtitles = nil, styles = nil, meta = nil, applied = nil, selected = false, word = false,
	dlimit = 100, ulimit = 1000
}

--[[ define dialog window ]]
gcyongRandomAppearance.dialog = {
	-- label (Appearance Unit)
	{
		class	= "label",
		x		= 0,
		y		= 0,
		width	= 10,
		height	= 1,
		label	= "Appearance Unit"
	},
	-- dropdown (Appearance Unit, character or word)
	{
		class	= "dropdown",
		x		= 0,
		y		= 1,
		width	= 10,
		height	= 1,
		items	= { "character", "word" },
		value	= "character",
		name	= "unit"
	},
	-- label (Applied lines)
	{
		class	= "label",
		x		= 0,
		y		= 2,
		width	= 10,
		height	= 1,
		label	= "Choose Applied Line(s)"
	},
	-- dropdown (Applied lines)
	{
		class	= "dropdown",
		x		= 0,
		y		= 3,
		width	= 10,
		height	= 1,
		items	= { "Selected Line(s)", "Active Line" },
		value	= "Selected Line(s)",
		name	= "applied"
	}
}

--[[
	SplitToWord function
	split received a string to word(s)
	[in] string
	[out] word(s). field 'n' is the number of words and 'm' is without delimiter.
]]
function gcyongRandomAppearance:SplitToWord(line)
	local words = { n = 1, m = 0 }
	local bnew = true

	-- split words
	for i = 1, string.len( line ) do
		local ch = string.sub( line, i, i )	-- each character
		if ch == '\\' then	-- '\n', '\N', or '\h'
			local rech = string.sub( line, i + 1, i + 1 )
			-- if special character
			if rech == 'n' or rech == 'N' or rech == 'h' then
				if words[ words.n ] ~= nil then
					words.n = words.n + 1
				end
				words[ words.n ] = ch .. rech
				words.n = words.n + 1
				bnew = true
			-- if not special character
			else
				words[ words.n ] = words[ words.n ] .. ch .. rech
			end
			i = i + 1
		elseif ch == ' ' then
			if words[ words.n ] ~= nil then
				words.n = words.n + 1
			end
			words[ words.n ] = ch
			words.n = words.n + 1
			bnew = true
		else
			if words[ words.n ] == nil then
				words[ words.n ] = ch
			else
				words[ words.n ] = words[ words.n ] .. ch
			end
			if bnew == true then
				bnew = false
				words.m = words.m + 1
			end
		end
	end

	return words
end

--[[
	SplitToChar function
	split received a string to character(s)
	[in] string
	[out] character(s). field 'n' is the number of words and 'm' is without delimiter.
]]
function gcyongRandomAppearance:SplitToChar(line)
	local chars = { n = 1, m = 0 }

	for ch in unicode.chars(line) do
		if ch == '\\' then
			local rech = string.sub( line, i + 1, i + 1 )
			if rech == 'n' or rech == 'N' or rech == 'h' then
				chars[ chars.n ] = ch .. rech
				chars.n = chars.n + 1
			else
				chars[ chars.n ] = ch
				chars[ chars.n + 1 ] = rech
				chars.n = chars.n + 2
				chars.m = chars.m + 2
			end
			i = i + 1
		elseif ch == ' ' then
			chars[ chars.n ] = ch
			chars.n = chars.n + 1
		else
			chars[ chars.n ] = ch
			chars.n = chars.n + 1
			chars.m = chars.m + 1
		end
	end
	chars.n = chars.n - 1

	return chars
end

function gcyongRandomAppearance:PrepareProcess(subtitles, applied, selected, word)
	self.subtitles = subtitles
	self.meta, self.styles = karaskel.collect_head( subtitles )
	self.selected = selected
	self.applied = applied
	self.word = word
end

function gcyongRandomAppearance:ProcessLine(line)
	local delay, appear = nil, nil
	local result = nil
	local units = nil

	if line.class == "dialogue" then
		-- get added information
		karaskel.preproc_line( self.subtitles, self.meta, self.styles, line )
		karaskel.preproc_line_text( self.meta, self.styles, line )
		karaskel.preproc_line_size( self.meta, self.styles, line )
		if self.word == true then
			units = self:SplitToWord( line.text )
		else
			units = self:SplitToChar( line.text )
		end
		for i = 1, units.n do
			if units[i] == '\\n' or units[i] == '\\N' or units[i] == '\\h' then
				result = result .. units[i]
			else
				-- get time information
				delay = math.random( self.dlimit, self.ulimit )
				appear = math.random( 0, line.end_time - line.start_time - self.ulimit )
				if result == nil then
					result = "{\\alpha&HFF&\\t(" .. appear .. ", " .. (appear + delay) .. ", \\alpha&H00&)}" .. units[i]
				else
					result = result .. "{\\alpha&HFF&\\t(" .. appear .. ", " .. (appear + delay) .. ", \\alpha&H00&)}" .. units[i]
				end
			end
		end
		line.text = result
	end

	return line
end

function gcyongRandomAppearance:Process()
	math.randomseed(os.time())
	if self.selected == true then
		for i = 1, #self.applied do
			self.subtitles[ self.applied[i] ] = self:ProcessLine( self.subtitles[ self.applied[i] ] )
		end
	else
		self.subtitles[ self.applied ] = self:ProcessLine( self.subtitles[ self.applied ] )
	end
end

function processing_function(subtitles, selected_lines, active_line)
	local ret, options = aegisub.dialog.display( gcyongRandomAppearance.dialog, {"Apply", "Cancel"} )

	if ret == "Apply" then
		local applied, selected, word = nil, false, false

		if options.applied == "Selected Line(s)" then
			applied = selected_lines
			selected = true
		else
			applied = active_line
			selected = false
		end
		if options.unit == "character" then
			word = false
		else
			word = true
		end
		gcyongRandomAppearance:PrepareProcess( subtitles, applied, selected, word )
		gcyongRandomAppearance:Process()
	end
end

aegisub.register_macro( "Random Appearance", "effect displaying characters or words at random time", processing_function )
