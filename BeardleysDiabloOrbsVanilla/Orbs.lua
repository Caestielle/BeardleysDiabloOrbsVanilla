local counter = 0
local orb = CreateFrame('FRAME')
local timeElapsed = 0
orb:SetScript("OnUpdate", function()
	if UnitAffectingCombat("Player") then
		timeElapsed = timeElapsed + 1
		if timeElapsed > 1 then
			timeElapsed = 0
			BDOMod_RedOrb:SetTexture("Interface\\Addons\\BeardleysDiabloOrbsVanilla\\d3orbanimation\\d3_orb_ani_frame"..counter..".tga")
			counter = counter+1
			if counter > 24 then
				counter = 0
			end
		end
	end
end)