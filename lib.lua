local Lib = {}

function Lib:init()
	local load_string = "Deactivated"
	self.wii_data = false
	if Kristal.load_wii then
		load_string = "Activated"
		if love.filesystem.getInfo("wii_settings.json") then
			self.wii_data = JSON.decode(love.filesystem.read("wii_settings.json"))
		else
			error("[Wii BIOS] Mod said we were in Wii mode, but wii_settings.json doesn't exist.")
		end
	end
	print("[Wii BIOS] Wii BIOS Library loaded. Wii mode: " .. load_string)
end

function Lib:messageBoard(message, title)
	if Kristal.load_wii then
		if not message then
			error("[Wii BIOS] Tried to send a message, but none existed.")
			return
		end
		
		local fm = {
			["title"] = title or Mod.info.name,
			["message"] = message,
			["mod"] = Mod.info.id,
			["opened"] = false,
			["date"] = os.date("%m/%d/%Y")
		}
		
		local size = 1
		for _ in pairs(self.wii_data["messages"])	do
			size = size + 1
		end
		
		self.wii_data["messages"][size] = fm
		love.filesystem.write("wii_settings.json", JSON.encode(self.wii_data))
	end
end

function Lib:getVii()
	if not Kristal.load_wii then
		Kristal.Console:warn("[Wii BIOS] Kristal is not currently in Wii Mode.")
	end
	
	local wii_data = love.filesystem.read("wii_settings.json")
	local wii_data_dc
	if wii_data then
		wii_data_dc = JSON.decode(wii_data)
	end
	
	if wii_data_dc then
		if wii_data_dc["vii"] then
			return wii_data_dc["vii"]
		end
	end
	Kristal.Console:warn("[Wii BIOS] Player has not made a Vii.")
	return {
		head = 1,
		body = 1,
		legs_left = true,
		skin_color = {195/255, 195/255, 195/255},
		hair_color = {61/255, 18/255, 14/255},
		shirt_color_1 = {127/255, 127/255, 127/255},
		shirt_color_2 = {1, 1, 1},
		name = "VESSEL",
		food = 1,
		blood = 1,
		color = 1,
		gift = 1,
		feel = 1
	}
end

function Lib:madeVii()
	if not Kristal.load_wii then
		Kristal.Console:warn("[Wii BIOS] Kristal is not currently in Wii Mode.")
	end
	
	local wii_data = love.filesystem.read("wii_settings.json")
	local wii_data_dc
	if wii_data then
		wii_data_dc = JSON.decode(wii_data)
	else
		return false
	end
	
	if wii_data_dc then
		if wii_data_dc["vii"] then
			return true
		end
	end
	return false
end

return Lib
