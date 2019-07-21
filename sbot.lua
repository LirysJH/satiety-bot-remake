script_name("Satiety-Bot")
script_author("James Hawk")
script_version("025")

local key = require "vkeys"
local memory = require "memory"
local sampev = require "lib.samp.events"
local inicfg = require 'inicfg'
local cfg = inicfg.load(
	{
		config={
			command="/anims 32";
			animation=false;
			wait_time=2700;
			med_for_home=false;
			alc_for_home=false;
			med_for_outd=false;
			drg_for_outd=false;
			loop_type=false;
			scrText_type=false;
			spr_home=false;
			spr_out=false;
			beer_home=false;
			beer_out=false;
			satiety=false;
			--adrenaline=false;
		}
	},"..\\config\\sbot-lua.ini"
)

local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8

local dlstatus = require('moonloader').download_status
local new = 0

local flag = false
local flag1 = false
local flag2 = false
local flag3 = false
local flag4 = false
local sat_flag = false
local sat_full = false
local f_scrText_state = false

local imgui = require "imgui"
imgui.ToggleButton = require('imgui_addons').ToggleButton
local main_window_state = imgui.ImBool(false)
local imBool = imgui.ImBool(false)
local imBool1 = imgui.ImBool(false)
local imBool2 = imgui.ImBool(false)
local imBool3 = imgui.ImBool(false)
local imBool4 = imgui.ImBool(false)
local imBool5 = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer("/anims 32", 256)
local text_buffer1 = imgui.ImBuffer("2700", 256)
local f_alc = imgui.ImBool(cfg.config.alc_for_home)
local f_anim = imgui.ImBool(cfg.config.animation)
local f_med = imgui.ImBool(cfg.config.med_for_home)
local f_med1 = imgui.ImBool(cfg.config.med_for_outd)
local f_drg = imgui.ImBool(cfg.config.drg_for_outd)
local f_loop = imgui.ImBool(cfg.config.loop_type)
local f_spr = imgui.ImBool(cfg.config.spr_home)
local f_spr1 = imgui.ImBool(cfg.config.spr_out)
local f_beer = imgui.ImBool(cfg.config.beer_home)
local f_beer1 = imgui.ImBool(cfg.config.beer_out)
--local f_adren = imgui.ImBool(cfg.config.adrenaline)
local f_scrText = imgui.ImBool(cfg.config.scrText_type)
local f_satiety = imgui.ImBool(cfg.config.satiety)

local sat = 0
local textdraw = { numb = 549.5, del = 54.5, {549.5, 60, -1436898180}, {547.5, 58, -16777216}, {549.5, 60, 1622575210} }

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
		if isPlayerPlaying(PLAYER_HANDLE) then
			----------------------BOTS------------------------
			if (flag or flag1 or flag2 or flag3 or flag4) and (f_loop.v or f_scrText.v or f_satiety.v) then
				wait(50)
				if f_loop.v then
					wait(cfg.config.wait_time*1000)
				elseif f_scrText_state or sat_flag then
					wait(50)
				end
				if (flag or flag1 or flag2 or flag3 or flag4) and (f_loop.v or f_scrText_state or sat_flag) then
					sampAddChatMessage(string.format("[%s]: It's time to eat and heal!",thisScript().name), 0xFFE4B5)
					wait(250)
					if f_anim.v then
						setVirtualKeyState(13)
						wait(250)
					end
					nopHook("onShowDialog", true)
					if flag or flag1 then
						sampSendChat("/house")
						wait(250)
						sampSendDialogResponse(174, 1, 1, -1)
						wait(250)
						sampSendDialogResponse(2431, 1, 0, -1)
						wait(250)
						sampSendDialogResponse(185, 1, 6, -1)
						wait(250)
						local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
						local health = sampGetPlayerHealth(id)
						if f_med.v then
							if health < 100 then
								while health < 100 do
									sampSendChat("/usemed")
									wait(4000)
									health = sampGetPlayerHealth(id)
								end
							end	
						elseif f_alc.v then
							if health <100 then
								sampSendChat("/house")
								wait(250)
								sampSendDialogResponse(174, 1, 1, -1)
								wait(250)
								sampSendDialogResponse(2431, 1, 1, -1)
								wait(450)
								if health < 100 and sampTextdrawIsExists(593) and sampTextdrawIsExists(590) then
									while health < 100 do
										sampSendClickTextdraw(593)
										wait(450)
										health = sampGetPlayerHealth(id)
									end
									sampSendClickTextdraw(590)
								end
								wait(450)
								-- setVirtualKeyState(27)
								-- wait(450)
								-- setVirtualKeyState(13)
							end
						elseif f_spr.v then
							if health < 100 then
								while health < 100 do
									sampSendChat("/sprunk")
									wait(4000)
									health = sampGetPlayerHealth(id)
								end
							end
						elseif f_beer.v then
							if health < 100 then
								while health < 100 do
									sampSendChat("/beer")
									wait(4000)
									health = sampGetPlayerHealth(id)
								end
							end
						end
						wait(250)
					elseif flag2 or flag3 or flag4 then
						sampSendChat("/eat")
						wait(250)
						if flag2 then
							while not sat_full do
							-- for i = 1, 15 do
								sampSendDialogResponse(9965, 1, 0, -1)
								wait(4000)
							end
						elseif flag3 then
							while not sat_full do
							-- for i = 1, 4 do
								sampSendDialogResponse(9965, 1, 1, -1)
								wait(4000)
							end
						elseif flag4 then
							while not sat_full do
								sampSendDialogResponse(9965, 1, 2, -1)
								wait(4000)
							end
						end
						wait(150)
						local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
						local health = sampGetPlayerHealth(id)
						if f_med1.v then
							if health < 100 then
								while health < 100 do
									sampSendChat("/usemed")
									wait(4000)
									health = sampGetPlayerHealth(id)
								end
							end
						elseif f_drg.v then
							if health < 20 then
								sampSendChat("/usedrugs 3")
								wait(4000)
								sampSendChat("/usedrugs 2")
							elseif health < 40 then
								sampSendChat("/usedrugs 3")
								wait(4000)
								sampSendChat("/usedrugs 1")
							elseif health < 60 then
								sampSendChat("/usedrugs 3")
							elseif health < 80 then
								sampSendChat("/usedrugs 2")
							elseif health < 100 then
								sampSendChat("/usedrugs 1")
							end
						elseif f_spr1.v then
							if health < 100 then
								while health < 100 do
									sampSendChat("/sprunk")
									wait(4000)
									health = sampGetPlayerHealth(id)
								end
							end
						elseif f_beer1.v then
							if health < 100 then
								while health < 100 do
									sampSendChat("/beer")
									wait(4000)
									health = sampGetPlayerHealth(id)
								end
							end
						end
					end
					if f_anim.v then
						if flag then
							setGameKeyState(21, 255)--alt
						elseif flag1 or flag2 or flag3 then
							sampSendChat(cfg.config.command)
						end
					end
					nopHook("onShowDialog", false)
				end
			end
			--------------------------------------------------
		end
	end
end

function imgui.OnDrawFrame()
	imgui.ShowCursor = main_window_state.v
	if main_window_state.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(400, 670), imgui.Cond.FirstUseEver)
		imgui.Begin("Satiety-Bot by JHawk", main_window_state, imgui.WindowFlags.NoResize)-- + imgui.WindowFlags.NoMove)
		-- imgui.Separator()
		imgui.Text(u8"Выберите тип работы скрипта:")
		imgui.SameLine()
		imgui.TextQuestion(u8"Циклический - срабатывание через указанную задержку. You are hungry - срабатывает, когда на экране появляется красная надпись \"You are hungry!\" или \"You are very hungry!\". Голод - срабатывает когда значение сытости достигает ниже 20 единиц.")
		imgui.BeginChild("##trigger", imgui.ImVec2(370, 50), true, imgui.WindowFlags.NoScrollbar)
			imgui.Checkbox(u8"Циклический##loop", f_loop)
			imgui.SameLine()
			imgui.Checkbox("You are hungry##hook_text", f_scrText)
			imgui.SameLine()
			imgui.Checkbox(u8"Голод##sat", f_satiety)
		imgui.EndChild()
		imgui.Text(u8"Выберите анимации и задержку:")
		imgui.SameLine()
		imgui.TextQuestion(u8"Анимация выбирается в том случае, если вы хотите, чтобы персонаж использовал какие-либо анимации после приёма пищи и хила. Задержка используется для \"циклического\" типа работы скрипта.")
		-- imgui.Separator()
		imgui.BeginChild("##anims_and_delay", imgui.ImVec2(370, 90), true, imgui.WindowFlags.NoScrollbar)
			imgui.PushItemWidth(80)
			imgui.InputText(u8"Вид анимации", text_buffer)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Checkbox(u8"Юзать анимации##animation", f_anim)
			imgui.PushItemWidth(80)
			imgui.InputText(u8"Задержка в сек.", text_buffer1)
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Text(u8"Сейчас: "..cfg.config.wait_time)
		imgui.EndChild()		
		-- imgui.Separator()
		imgui.Text(u8"Выберите хил в доме:")
		imgui.SameLine()
		imgui.TextQuestion(u8"Эти виды хила используются в alt/anims ботах.")
		imgui.BeginChild("##heal_home", imgui.ImVec2(370, 50), true, imgui.WindowFlags.NoScrollbar)
			imgui.Checkbox(u8"Аптечка##med", f_med)
			imgui.SameLine()
			imgui.Checkbox(u8"Алкоголь##alc", f_alc)
			imgui.SameLine()
			imgui.Checkbox(u8"Спранк##spr", f_spr)
			imgui.SameLine()
			imgui.Checkbox(u8"Пиво##beer", f_beer)
		imgui.EndChild()		
		-- imgui.Separator()
		imgui.Text(u8"Выберите хил на улице:")
		imgui.SameLine()
		imgui.TextQuestion(u8"Эти виды хила используются в chips/fish/venison ботах.")
		imgui.BeginChild("##heal_outside", imgui.ImVec2(370, 50), true, imgui.WindowFlags.NoScrollbar)
			imgui.Checkbox(u8"Аптечка##med1", f_med1)
			imgui.SameLine()
			imgui.Checkbox(u8"Наркотики##drg", f_drg)
			imgui.SameLine()
			imgui.Checkbox(u8"Спранк##spr1", f_spr1)
			imgui.SameLine()
			imgui.Checkbox(u8"Пиво##beer1", f_beer1)
		imgui.EndChild()		
		-- imgui.Separator()
		-- imgui.SetCursorPos(imgui.ImVec2(50, 280), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Text(u8"Выберите тип бота для начала работы:")
		imgui.SameLine()
		imgui.TextQuestion(u8"Анимации нужны, чтобы вам засчитывало payday. Все боты хилятся только если ваше хп ниже 100 (дабы попросту не тратить ресурсы).")
			
			imgui.BeginChild("##bots_home", imgui.ImVec2(160, 140), true, imgui.WindowFlags.NoScrollbar)
				imgui.SetCursorPos(imgui.ImVec2(30, 10))
				imgui.Text(u8"Боты для дома")
				imgui.SetCursorPos(imgui.ImVec2(10, 50))
				imgui.Text(u8"Alt-бот")
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(90, 50))
				if (not flag1 and not flag2 and not flag3 and not flag4) then
					if imgui.ToggleButton("##alt-bot", imBool1) then
						flag = not flag
						if flag then
							sampAddChatMessage(string.format("[%s]: begin Alt-bot", thisScript().name), 0x00FF00)
						else
							sampAddChatMessage(string.format("[%s]: end Alt-bot", thisScript().name), 0xFF4040)
						end
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(140, 50))
				imgui.TextQuestion(u8"Alt-бот - перед включением поставить персонажа в любую alt-анимацию. Ест еду из холодильника в доме.")
				
				imgui.SetCursorPos(imgui.ImVec2(10, 80))
				imgui.Text(u8"Anims-бот")
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(90, 80))
				if (not flag and not flag2 and not flag3 and not flag4) then
					if imgui.ToggleButton("anims-bot", imBool2) then
						flag1 = not flag1
						if flag1 then
							sampAddChatMessage(string.format("[%s]: begin Anims-bot", thisScript().name), 0x00FF00)
						else
							sampAddChatMessage(string.format("[%s]: end Anims-bot", thisScript().name), 0xFF4040)
						end
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(140, 80))
				imgui.TextQuestion(u8"Anims-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест еду из холодильника в доме.")	
			imgui.EndChild()
			
			imgui.SameLine()
			imgui.BeginChild("##bots_outside", imgui.ImVec2(195, 140), true, imgui.WindowFlags.NoScrollbar)
				imgui.SetCursorPos(imgui.ImVec2(50, 10))
				imgui.Text(u8"Боты для улицы")
				imgui.SetCursorPos(imgui.ImVec2(10, 50))
				imgui.Text(u8"Chips-бот")
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(110, 50))
				if (not flag and not flag1 and not flag3 and not flag4) then
					if imgui.ToggleButton("chips-bot", imBool3) then
						flag2 = not flag2
						if flag2 then
							sampAddChatMessage(string.format("[%s]: begin Chips-bot", thisScript().name), 0x00FF00)
						else
							sampAddChatMessage(string.format("[%s]: end Chips-bot", thisScript().name), 0xFF4040)
						end
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(160, 50))
				imgui.TextQuestion(u8"Chips-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест чипсы.")
				
				imgui.SetCursorPos(imgui.ImVec2(10, 80))
				imgui.Text(u8"Fish-бот")
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(110, 80))
				if (not flag and not flag1 and not flag2 and not flag4) then
					if imgui.ToggleButton("fish-bot", imBool4) then
						flag3 = not flag3
						if flag3 then
							sampAddChatMessage(string.format("[%s]: begin Fish-bot", thisScript().name), 0x00FF00)
						else
							sampAddChatMessage(string.format("[%s]: end Fish-bot", thisScript().name), 0xFF4040)
						end
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(160, 80))
				imgui.TextQuestion(u8"Fish-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест рыбу.")		
			
				imgui.SetCursorPos(imgui.ImVec2(10, 110))
				imgui.Text(u8"Venison-бот")
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(110, 110))
				if (not flag and not flag1 and not flag2 and not flag3) then
					if imgui.ToggleButton("venison-bot", imBool5) then
						flag4 = not flag4
						if flag4 then
							sampAddChatMessage(string.format("[%s]: begin Venison-bot", thisScript().name), 0x00FF00)
						else
							sampAddChatMessage(string.format("[%s]: end Venison-bot", thisScript().name), 0xFF4040)
						end
					end
				end
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(160, 110))
				imgui.TextQuestion(u8"Venison-бот - перед включением поставить персонажа в любую anims-анимацию (из /anims). Ест оленину.")		
			imgui.EndChild()
			
		-- imgui.Separator()
		imgui.PushItemWidth(11)
		if imgui.Button(u8'Check cfg') then
			sampAddChatMessage("command - "..cfg.config.command,-1)
			sampAddChatMessage("loop_time - "..cfg.config.wait_time,-1)
			sampAddChatMessage("use animation - "..tostring(cfg.config.animation),-1)
			sampAddChatMessage("medkit_home - "..tostring(cfg.config.med_for_home),-1)
			sampAddChatMessage("medkit_outdoors - "..tostring(cfg.config.med_for_outd),-1)
			sampAddChatMessage("alcohol_home - "..tostring(cfg.config.alc_for_home),-1)
			sampAddChatMessage("sprunk_home - "..tostring(cfg.config.spr_home),-1)
			sampAddChatMessage("sprunk_outdoors - "..tostring(cfg.config.spr_out),-1)
			sampAddChatMessage("beer_home - "..tostring(cfg.config.beer_home),-1)
			sampAddChatMessage("beer_outdoors - "..tostring(cfg.config.beer_out),-1)
			sampAddChatMessage("drugs_outdoors - "..tostring(cfg.config.drg_for_outd),-1)
			sampAddChatMessage("loop - "..tostring(cfg.config.loop_type),-1)
			sampAddChatMessage("hook_text - "..tostring(cfg.config.scrText_type),-1)
			sampAddChatMessage("satiety - "..tostring(cfg.config.satiety),-1)
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.PushItemWidth(10)
		if imgui.Button('Save cfg') then
			cfg.config.command=text_buffer.v
			cfg.config.wait_time=text_buffer1.v
			cfg.config.med_for_home=f_med.v
			cfg.config.alc_for_home=f_alc.v
			cfg.config.med_for_outd=f_med1.v
			cfg.config.drg_for_outd=f_drg.v
			cfg.config.loop_type=f_loop.v
			cfg.config.scrText_type=f_scrText.v
			cfg.config.animation=f_anim.v
			cfg.config.spr_home=f_spr.v
			cfg.config.spr_out=f_spr1.v
			cfg.config.beer_home=f_beer.v
			cfg.config.beer_out=f_beer1.v
			cfg.config.satiety=f_satiety.v
			inicfg.save(cfg, '..\\config\\sbot-lua.ini')
			printStringNow('Saved settings!', 1000)
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.Text(u8"Работа в свёрнутом режиме")
		imgui.SameLine()
		if imgui.ToggleButton("AAFK##1", imBool) then
			--check = not check
			if imBool.v then
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
		-- imgui.SetCursorPos(imgui.ImVec2(10, 430), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if imgui.Button(u8'Проверить обновления##check_update') then
			local fpath = os.getenv('TEMP') .. '\\satiety-bot.json'
			downloadUrlToFile('https://gist.github.com/LirysJH/1bd8ec49521ef3071f60975920737421/raw', fpath, function(id, status, p1, p2)
			    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					local f = io.open(fpath, 'r')
					if f then
						local info = decodeJson(f:read('*a'))
						updatelink = info.updateurl
						if info and info.latest then
							version = tonumber(info.latest)
							ver = tonumber(info.ver)
							if version > tonumber(thisScript().version) then
								new = 1
								sampAddChatMessage(('[Satiety-Bot]: {FFFFFF}Доступно обновление!'), 0xF1CB09)
							else
								update = false
								sampAddChatMessage(('[Satiety-Bot]: {FFFFFF}У вас установлена последния версия!'), 0xF1CB09)
							end
						end
					end
				end
			end)
		end
		if new == 1 then
			imgui.SameLine()
			if imgui.Button(u8'Обновить##update') then
				lua_thread.create(function()
					sampAddChatMessage(('[Satiety-Bot]: Обновляюсь...'), 0xF1CB09)
					wait(300)
					downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
						if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
							sampAddChatMessage(('[Satiety-Bot]: Обновление завершено!'), 0xF1CB09)
							thisScript():reload()
						end
					end)
				end)
			end
		end
		imgui.SetCursorPos(imgui.ImVec2(125, 635), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		if imgui.Button(u8'Сбросить настройки') then
			lua_thread.create(function()
				sampAddChatMessage(string.format("[%s]: RELOADING",thisScript().name), 0x0000FF)
				sampProcessChatInput("//isb")
				wait(50)
				cfg.config.command="/anims 32"
				cfg.config.animation=false
				cfg.config.wait_time=2700
				cfg.config.med_for_home=false
				cfg.config.alc_for_home=false
				cfg.config.med_for_outd=false
				cfg.config.drg_for_outd=false
				cfg.config.loop_type=false
				cfg.config.scrText_type=false
				cfg.config.spr_home=false
				cfg.config.spr_out=false
				cfg.config.beer_home=false
				cfg.config.beer_out=false
				cfg.config.satiety=false
				thisScript():reload()
			end)
		end
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

function sampev.onDisplayGameText(style, time, text)
    if f_scrText.v and (flag or flag1 or flag2 or flag3 or flag4) then
        if text:find("You are hungry!") or text:find("You are very hungry!") then
			f_scrText_state = true
		end
	end
end

function sampev.onServerMessage(color,text)
	if f_scrText_state and (flag or flag1 or flag2 or flag3 or flag4) then
		if string.find(text,"Вы взяли комплексный обед. Посмотреть состояние голода можно") then
			f_scrText_state=false
		end
	end
end

function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if wparam == key.VK_ESCAPE and main_window_state.v then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
				main_window_state.v = false
			end
        end
    end
end

function onReceiveRpc(id, bs)
    if id == 134 then
		local td = readBitstream(bs)
		if td.x == textdraw[1][1] and td.y == textdraw[1][2] and td.color == textdraw[1][3] then
			sat = td.hun
			--print(sat)
			--print(math.floor((sat/textdraw.del)*100))
			--print(tostring(sat_flag))
			local tmp = math.floor((sat/textdraw.del)*100)
			if f_satiety.v then
				if tmp < 20 then
					sat_flag = true
					--print(tostring(sat_flag))
				else
					sat_flag = false
				end
			end
			if tmp > 99 then sat_full = true else sat_full = false end
		end
    end
end

function readBitstream(bs)
	local data = {}
	data.id = raknetBitStreamReadInt16(bs)
	raknetBitStreamIgnoreBits(bs, 104)
	data.hun = raknetBitStreamReadFloat(bs) - textdraw.numb
	raknetBitStreamIgnoreBits(bs, 32)
	data.color = raknetBitStreamReadInt32(bs)
	raknetBitStreamIgnoreBits(bs, 64)
	data.x = raknetBitStreamReadFloat(bs)
	data.y = raknetBitStreamReadFloat(bs)
	return data
end

function nopHook(name, bool)
    local samp = require 'samp.events'
    samp[name] = function()
        if bool then return false end
    end
end

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()
