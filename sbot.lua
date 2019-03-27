script_name("Satiety-Bot")
script_author("James Hawk")
script_version("1.1")
script_dependencies("ML 0.26", "imgui", "encoding", "imgui_addons", "vkeys")

require "lib.moonloader"
require "vkeys"
local imgui = require "imgui"
local memory = require "memory"
local hook = require "lib.samp.events"
imgui.ToggleButton = require('imgui_addons').ToggleButton
local inicfg = require 'inicfg'
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
local imBool = imgui.ImBool(false)
local imBool1 = imgui.ImBool(false)
local imBool2 = imgui.ImBool(false)
local imBool3 = imgui.ImBool(false)
local imBool4 = imgui.ImBool(false)
local imBool5 = imgui.ImBool(false)	
local flag = false
local flag1 = false
local flag2 = false
local flag3 = false
local flag4 = false
local m_flag = false
local a_flag = false
local med_flag = imgui.ImBool(false)
local alcohol_flag = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer("/anims 32", 256)
local text_buffer1 = imgui.ImBuffer("2700", 256)
local cfg = inicfg.load(
	{
		config={
			command="/anims 32";
			wait_time=2700;
			med_for_home=0;
			alc_for_home=0;
		},
		"sbot-lua"
	}
)
------------MAIN------------------
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand("/isb", function()
		main_window_state.v = not main_window_state.v
		imgui.Process = main_window_state.v
	end)
	sampRegisterChatCommand("/isb_r", function()
		sampAddChatMessage(string.format("[%s]: RELOADING",thisScript().name), 0x0000FF)
		thisScript():reload()
	end)
	
	imgui.Process=false
	
	while true do
		wait(0)
		
		if main_window_state.v == false then
			imgui.Process = false
		end
		----------------------BOTS------------------------
		if flag or flag1 or flag2 or flag3 or flag4 then
			wait(cfg.config.wait_time*1000)
			if flag or flag1 or flag2 or flag3 or flag4 then
				sampAddChatMessage(string.format("[%s]: It's time to eat and heal!",thisScript().name), 0x2f7585)
				wait(250)
				setVirtualKeyState(13)
				wait(250)
				if flag or flag1 then
					sampSendChat("/house")
					wait(250)
					if sampIsDialogActive(174) then
						sampSendDialogResponse(174, 1, 1, -1)
						wait(250)
						if sampIsDialogActive(2431) then
							sampSendDialogResponse(2431, 1, 0, -1)
							wait(250)
							if sampIsDialogActive(185) then
								sampSendDialogResponse(185, 1, 6, -1)
								wait(250)
								local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
								local health = sampGetPlayerHealth(id)
								-------medkit----------
								if m_flag then
									if health < 50 then
										sampSendChat("/usemed")
										wait(4000)
										sampSendChat("/usemed")
									elseif health < 100 then
										sampSendChat("/usemed")
									end
								--------alcohol---------	
								elseif a_flag then
									if health <100 then
										sampSendChat("/house")
										wait(250)
										if sampIsDialogActive(174) then
											sampSendDialogResponse(174, 1, 1, -1)
											wait(250)
											if sampIsDialogActive(2431) then
												sampSendDialogResponse(2431, 1, 1, -1)
											end
										end
										wait(250)
										setVirtualKeyState(27)
										wait(250)
										if health < 50 and sampTextdrawIsExists(551) and sampTextdrawIsExists(548) then
											sampSendClickTextdraw(551)
											wait(450)
											sampSendClickTextdraw(551)
											wait(450)
											sampSendClickTextdraw(548)
										elseif health < 100 and sampTextdrawIsExists(551) and sampTextdrawIsExists(548) then
											sampSendClickTextdraw(551)
											wait(450)
											sampSendClickTextdraw(548)
										end
									end
								end
								---------------------
							end
						end
					end
					wait(250)
					if flag and not flag1 then
						setGameKeyState(21, 255)--alt
					elseif not flag and flag1 then
						sampSendChat(cfg.config.command)
					end
				--------------chips---------------
				elseif not flag and not flag1 and flag2 and not flag3 and not flag4 then
					sampSendChat("/eat")
					wait(250)
					if sampIsDialogActive(9965) then
						for i = 1, 4 do
							sampSendDialogResponse(9965, 1, 0, -1)
							wait(4000)
						end
						wait(150)
						local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
						local health = sampGetPlayerHealth(id)
						if health < 50 then
							sampSendChat("/usemed")
							wait(4000)
							sampSendChat("/usemed")
						elseif health < 100 then
							sampSendChat("/usemed")
						end
						sampSendChat(cfg.config.command)
					end
				--------------fish------------
				elseif not flag and not flag1 and not flag2 and flag3 and not flag4 then
					sampSendChat("/eat")
					wait(250)
					if sampIsDialogActive(9965) then
						for i = 1, 4 do
							sampSendDialogResponse(9965, 1, 1, -1)
							wait(4000)
						end
						wait(150)
						local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
						local health = sampGetPlayerHealth(id)
						if health < 50 then
							sampSendChat("/usemed")
							wait(4000)
							sampSendChat("/usemed")
						elseif health < 100 then
							sampSendChat("/usemed")
						end
						sampSendChat(cfg.config.command)
					end
				--------------fam------------
				end
			end
		end
		--------------------------------------------------
	end
end


function imgui.OnDrawFrame()
	imgui.ShowCursor = false
	if main_window_state.v then
		imgui.ShowCursor = true
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(350, 380), imgui.Cond.FirstUseEver)
		imgui.Begin("Satiety-Bot by JHawk", main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		imgui.SetCursorPos(imgui.ImVec2(100, 25), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if imgui.Button(u8'Перезагрузить скрипт') then
			lua_thread.create(function()
				sampAddChatMessage(string.format("[%s]: RELOADING",thisScript().name), 0x0000FF)
				sampProcessChatInput("//isb")
				wait(50)
				thisScript():reload()
			end)
		end
		imgui.Separator()
		if imgui.CollapsingHeader('Settings') then
			imgui.PushItemWidth(80)
			imgui.InputText(u8"Введите анимацию.", text_buffer)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Text(u8"Указано: \"".. text_buffer.v .."\".")
			imgui.PushItemWidth(11)
			imgui.PushItemWidth(80)
			imgui.InputText(u8"Введите задержку.", text_buffer1)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Text(u8"Указано: ".. text_buffer1.v ..".")
			imgui.PushItemWidth(11)
			if imgui.Button('Check cfg') then
				sampAddChatMessage(cfg.config.command,-1)
				sampAddChatMessage(cfg.config.wait_time,-1)
				sampAddChatMessage(tostring(cfg.config.med_for_home),-1)
				sampAddChatMessage(tostring(cfg.config.alc_for_home),-1)
			end
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.PushItemWidth(10)
			if imgui.Button('Save cfg') then
				cfg.config.command=text_buffer.v
				cfg.config.wait_time=text_buffer1.v
				cfg.config.med_for_home=med_flag.v
				cfg.config.alc_for_home=alcohol_flag.v
				printStringNow('Saved settings!', 1000)
			end
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Text(u8"Работа в свёрнутом режиме")
			imgui.SameLine()
			if imgui.ToggleButton("Test##1", imBool) then
				check = not check
				if check then
					sampAddChatMessage(string.format("[%s]: AntiAFK begin to work", thisScript().name), 0x00FF00)
					memory.setuint8(7634870, 1, false)
					memory.setuint8(7635034, 1, false)
					memory.fill(7623723, 144, 8, false)
					memory.fill(5499528, 144, 6, false)
				else
					sampAddChatMessage(string.format("[%s]: AntiAFK stop working", thisScript().name), 0xFF4040)
					memory.setuint8(7634870, 0, false)
					memory.setuint8(7635034, 0, false)
					memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
					memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
				end
			end
			imgui.Text(u8"Выберите хил для дома (alt-бот/anims-бот)")
			if imgui.Checkbox(u8"Аптечка", med_flag) then
				m_flag = not m_flag
			end
			imgui.SameLine()
			if imgui.Checkbox(u8"Алкоголь", alcohol_flag) then
				a_flag = not a_flag
			end
		end
		imgui.Separator()
		imgui.BeginGroup()
		imgui.SetCursorPos(imgui.ImVec2(50, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Выберите тип бота для начала работы.")
		imgui.SetCursorPos(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.TextQuestion(u8"Анимации нужны, чтобы вам засчитывало payday. Все боты хилятся только если ваше хп ниже 100 (дабы попросту не тратить ресурсы).")
		imgui.SetCursorPos(imgui.ImVec2(10, 230), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Alt-бот")
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(100, 230), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if (not flag1 and not flag2  and not flag3  and not flag4) then
			if imgui.ToggleButton("alt-bot", imBool1) then
				flag = not flag
				if flag then
					sampAddChatMessage(string.format("[%s]: started Alt-bot", thisScript().name), 0x00FF00)
				else
					sampAddChatMessage(string.format("[%s]: stopped Alt-bot", thisScript().name), 0xFF4040)
				end
			end
		end
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(150, 230), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.TextQuestion(u8"Alt-бот - перед включением поставить персонажа в любую alt-анимацию. Ест еду из холодильника (в доме).")
		
		imgui.SetCursorPos(imgui.ImVec2(10, 260), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Anims-бот")
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(100, 260), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if (not flag and not flag2  and not flag3 and not flag4) then
			if imgui.ToggleButton("anims-bot", imBool2) then
				flag1 = not flag1
				if flag1 then
					sampAddChatMessage(string.format("[%s]: started Anims-bot", thisScript().name), 0x00FF00)
				else
					sampAddChatMessage(string.format("[%s]: stopped Anims-bot", thisScript().name), 0xFF4040)
				end
			end
		end
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(150, 260), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.TextQuestion(u8"Anims-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест еду из холодильника (в доме).")
		
		imgui.SetCursorPos(imgui.ImVec2(10, 290), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Chips-бот")
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(100, 290), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if (not flag and not flag1  and not flag3  and not flag4) then
			if imgui.ToggleButton("chips-bot", imBool3) then
				flag2 = not flag2
				if flag2 then
					sampAddChatMessage(string.format("[%s]: started Chips-bot", thisScript().name), 0x00FF00)
				else
					sampAddChatMessage(string.format("[%s]: stopped Chips-bot", thisScript().name), 0xFF4040)
				end
			end
		end
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(150, 290), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.TextQuestion(u8"Chips-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест чипсы.")
		
		imgui.SetCursorPos(imgui.ImVec2(10, 320), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Fish-бот")
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(100, 320), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5,
		0.5))
		if (not flag and not flag1 and not flag2 and not flag4) then
			if imgui.ToggleButton("fish-bot", imBool4) then
				flag3 = not flag3
				if flag3 then
					sampAddChatMessage(string.format("[%s]: started Fish-bot", thisScript().name), 0x00FF00)
				else
					sampAddChatMessage(string.format("[%s]: stopped Fish-bot", thisScript().name), 0xFF4040)
				end
			end
		end
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(150, 320), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.TextQuestion(u8"Fish-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест рыбу.")
		
		imgui.SetCursorPos(imgui.ImVec2(10, 350), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Fam-бот")
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(100, 350), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if (not flag and not flag1 and not flag2 and not flag3) then
			if imgui.ToggleButton("fam-bot", imBool5) then
				-- flag4 = not flag4
				-- if flag4 then
					-- sampAddChatMessage(string.format("[%s]: started Fam-bot", thisScript().name), 0x00FF00)
				-- else
					-- sampAddChatMessage(string.format("[%s]: stopped Fam-bot", thisScript().name), 0xFF4040)
				-- end
			end
		end
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(150, 350), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.TextQuestion(u8"Fam-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест пищу из семейного холодильника (нужно стоять в семейной квартире; в семье должно быть улучшение \"Рыбный Цех\").")
		imgui.SameLine()
		imgui.SetCursorPos(imgui.ImVec2(180, 350), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text("Not working yet")
		imgui.EndGroup()
		imgui.End()
	end
end

function imgui.TextQuestion(txt)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(txt)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function setVirtualKeyState(key)
  lua_thread.create(function(key)
	  setVirtualKeyDown(key, true)
	  wait(150)
	  setVirtualKeyDown(key, false)
  end, key)
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		inicfg.save(cfg, "sbot-lua")
	end
end

function hook.onShowDialog(id, style, title, b1, b2, text)
	lua_thread.create(function()
		if flag or flag1 then
			if id == 185 and (flag or flag1) then --item in the bridge
				wait(250)
				sampCloseCurrentDialogWithButton(1)
			elseif id == 9965 and (flag2 or flag3) then --/eat
				wait(16500)
				sampCloseCurrentDialogWithButton(1)
			end
		end
	end)
end
