script_name("Satiety-Bot")
script_author("James Hawk")
script_version("2.3")

local key = require "vkeys"
local memory = require "memory"
local sampev = require "lib.samp.events"


local imgui = require "imgui"
local main_window_state = imgui.ImBool(false)

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	
	
	imgui.Process=false
	
	while true do
		wait(0)
		
		if main_window_state.v == false then
			imgui.Process = false
		end
		
end
