local options = {}

local function setup()
	local surround = jaylib.loadpkg("nvim-surround")
	if surround == nil then
		return
	end

	surround.setup(options)
end

return { setup = setup }
