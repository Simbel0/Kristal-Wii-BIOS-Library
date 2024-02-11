return {
    talk = function(cutscene, event)
        cutscene:text("* Hello![wait:5]\n* I'm " .. event.actor.data.name .. ",[wait:5] your Vii!")
        cutscene:text("* In other words,[wait:5] I'm your [style:GONER]Vessel Mii[style:dark].")
		
		local wii_data = love.filesystem.read("wii_settings.json")
		local wii_data_dc
		if wii_data then
			wii_data_dc = JSON.decode(wii_data)
		end
		
		if not Kristal.callEvent("madeVii") then
			cutscene:text("* ...Or rather,[wait:5] I would be,[wait:5] if you had created me in the Vii Channel.")
			cutscene:text("* But I'm not the type to hold a grudge.")
			cutscene:text("* Or am I?[wait:5]\n* I guess we'll never know! :)")
		end
		
		foods = {"sweet","soft","sour","salty","painful","cold"}
		
		bloods = {"A","AB","B","C","D"}
		
		colors = {"red","blue","green","cyan"}
		
		gifts = {"kindness","mind","ambition","bravery","voice"}
		
		feels = {"Love","Hope","Disgust","Fear"}
		
		cutscene:text("* Hm?[wait:5]\n* You want to know about me?")
		cutscene:text("* Well,[wait:5] I like to eat " .. foods[event.actor.data.food] .. " foods.")
		cutscene:text("* My blood type is " .. bloods[event.actor.data.blood] .. ".")
		cutscene:text("* The color I prefer the most is " .. colors[event.actor.data.color] .. ".")
		cutscene:text("* And I feel I have been given a gift of " .. gifts[event.actor.data.gift] .. ".")
		cutscene:text("* Well,[wait:5] that's about it![wait:5]\n* The rest is up to you!")
		
		if event.actor.data.feel == 1 then
			cutscene:text("* Wow,[wait:5] you look interested to learn more!")
			cutscene:text("* Sorry,[wait:5] but that's pretty much everything I know.")
		elseif event.actor.data.feel == 2 then
			cutscene:text("* Oh,[wait:5] and I can't wait to see what kinds of adventures I go on!")
			cutscene:text("* Judging by your look,[wait:5] I think you might be happy about that.")
		elseif event.actor.data.feel == 3 then
			cutscene:text("* Hey,[wait:5] you look like you ate something gross.")
			cutscene:text("* Are you feeling alright?")
		else
			cutscene:text("* You seem...[wait:5] Very disinterested in me.")
			cutscene:text("* Th-that's okay![wait:5]\n* We'll get there in due time!")
		end
    end
}
