--- @since 26.9.1

local function config_home()
	local home = os.getenv("YAZI_CONFIG_HOME")
	if home and home ~= "" then
		return home
	end
	local appdata = os.getenv("APPDATA")
	if appdata and appdata ~= "" then
		return appdata .. "\\yazi\\config"
	end
	return nil
end

local function script_path()
	local home = config_home()
	if not home then
		return nil
	end
	return home .. "\\plugins\\ime-switch.yazi\\ime.ps1"
end

local function switch_ime(mode)
	local script = script_path()
	if not script then
		return
	end

	-- Fire-and-forget; IME switch must not block UI rendering.
	Command("powershell")
		:arg({
			"-NoProfile",
			"-NonInteractive",
			"-ExecutionPolicy",
			"Bypass",
			"-File",
			script,
			mode,
		})
		:stdin(Command.NULL)
		:stdout(Command.NULL)
		:stderr(Command.NULL)
		:spawn()
end

local function setup(st)
	if ya.target_family() ~= "windows" then
		return
	end

	-- nil = unknown, true = Chinese mode requested, false = English mode requested
	st.want_zh = nil

	Status:children_add(function()
		local want_zh = tostring(cx.layer) == "input"
		if st.want_zh == want_zh then
			return ""
		end
		st.want_zh = want_zh

		local mode = want_zh and "zh" or "en"
		ya.async(function()
			switch_ime(mode)
		end)

		return ""
	end, 1)
end

return { setup = setup }
