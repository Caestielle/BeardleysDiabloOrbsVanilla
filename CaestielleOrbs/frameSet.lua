PlayerFrame:Hide()
local f = CreateFrame('FRAME')
f:RegisterAllEvents()
f:SetScript('OnEvent', function()
	if UnitExists("player") then
		if (UnitIsPVP("player")) then
			BDOMod_RedOrbGloss:SetTexture("Interface\\Addons\\BeardleysDiabloOrbsVanilla\\art\\orb_cracked.tga");
		else
			BDOMod_RedOrbGloss:SetTexture("Interface\\Addons\\BeardleysDiabloOrbsVanilla\\art\\orb_gloss.tga")
		end
	end
end)