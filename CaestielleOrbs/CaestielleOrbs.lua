----------------------------
----------------------------
-- Beardley's Diablo Orbs --
-- (c)2019 Kulturnilpferd -- 
----------------------------
--        Settings        --
----------------------------
scaleFactor = 1.25 -- With this value you can scale the whole UI. Menu with settings is comming soon...
----------------------------
----------------------------


local images = "Interface\\AddOns\\CaestielleOrbs\\art\\"
function BDOMod_OnLoad()
	this:RegisterEvent("UNIT_HEALTH")
	this:RegisterEvent("UNIT_MAXHEALTH")
	this:RegisterEvent("UNIT_RAGE")
	this:RegisterEvent("UNIT_ENERGY")
	this:RegisterEvent("UNIT_MANA")
	this:RegisterEvent("UNIT_RUNIC_POWER")
	this:RegisterEvent("UNIT_DISPLAYPOWER")
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
	this:RegisterEvent("ACTIONBAR_SHOWGRID")
	this:RegisterEvent("LOOT_CLOSED")
	this:RegisterEvent("PET_BAR_UPDATE")
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown")
end

function PlayerStuff(button)
	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("player");
		elseif ( CursorHasItem() ) then
			AutoEquipCursorItem();
		else
			TargetUnit("player");
		end
	else
		ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "cursor", 3, -3);
		return;
	end
end

local function addArtworkFrame(frameName,parentFrame,file,FrameStrata,offsetX,offsetY,height,width)
	local artworkFrame = CreateFrame("Frame",frameName,parentFrame)
	artworkFrame:SetPoint("BOTTOM",offsetX,offsetY)
	artworkFrame:SetFrameStrata(FrameStrata)
	artworkFrame:SetHeight(height)
	artworkFrame:SetWidth(width)
	artworkFrame.texture = artworkFrame:CreateTexture(nil,"OVERLAY")
	artworkFrame.texture:SetTexture(file)
	artworkFrame.texture:SetAllPoints(artworkFrame)
	return artworkFrame
end

local function createArtwork()
	actionbarBackground = addArtworkFrame(nil,UIParent,images.."bar3.tga","LOW",1,-4,127,491)
	leftArtwork = addArtworkFrame(nil,UIParent,images.."leftArtwork.tga","HIGH",-390,0,200,200)
	rightArtwork = addArtworkFrame(nil,UIParent,images.."rightArtwork.tga","HIGH",390,0,200,200)
end

local function changeActionBar()
	if GetBonusBarOffset() == 0 then
		ActionButton1:Show()
		ActionButton2:Show()
		ActionButton3:Show()
		ActionButton4:Show()
		ActionButton5:Show()
		ActionButton6:Show()
		ActionButton7:Show()
		ActionButton8:Show()
		ActionButton9:Show()
		ActionButton10:Show()
		ActionButton11:Show()
		ActionButton12:Show()
	else
		ActionButton1:Hide()
		ActionButton2:Hide()
		ActionButton3:Hide()
		ActionButton4:Hide()
		ActionButton5:Hide()
		ActionButton6:Hide()
		ActionButton7:Hide()
		ActionButton8:Hide()
		ActionButton9:Hide()
		ActionButton10:Hide()
		ActionButton11:Hide()
		ActionButton12:Hide()
	end
end

local function updateHealthOrb()
	local healthColor = {
		[1] = {15, 1.0, 0, 0},
		[2] = {35, 1.0, 0.27, 0},
		[3] = {55, 1.0, 0.65, 0},
		[4] = {75, 1.0, 1.0, 0},
		[5] = {90, 0.5, 0.8, 0},
		[6] = {100, 0, 1.0, 0}
	}
	local healthPercent = (UnitHealth("player")/UnitHealthMax("player"))
	local hp = healthPercent*100
	BDOMod_HealthPercentage:SetText(floor(healthPercent * 100))
	BDOMod_HealthText:SetText(UnitHealth("player").." / ".. UnitHealthMax("player"))
	BDOMod_RedOrb:SetHeight(healthPercent * 185)
	BDOMod_RedOrb:SetTexCoord(0, 1, 1-healthPercent, 1)
	for k, v in healthColor do
		if hp <= healthColor[k][1] then
			BDOMod_RedOrb:SetVertexColor(v[2],v[3],v[4]) break
		end
	end
end

local function updateManaOrb()
	local manaPercent = (UnitMana("player")/UnitManaMax("player"))
	BDOMod_ManaPercentage:SetText(floor(manaPercent * 100))
	BDOMod_ManaText:SetText(UnitMana("player").." / ".. UnitManaMax("player"))
	BDOMod_BlueOrb:SetHeight(manaPercent * 185)
	BDOMod_DruidLeft:SetHeight(manaPercent * 185)
	BDOMod_BlueOrb:SetTexCoord(0, 1, 1-manaPercent, 1)
	BDOMod_DruidLeft:SetTexCoord(0, 0.5, 1-manaPercent, 1)
end

local function updateDruidMana()
	local lib = AceLibrary("DruidManaLib-1.0")
	local DruidMana = AceLibrary("DruidManaLib-1.0"):GetMana()
	lib:MaxManaScript()
	local _, DruidMaxMana = AceLibrary("DruidManaLib-1.0"):GetMana()
	local DruidPercent = (DruidMana/DruidMaxMana)
	BDOMod_DruidRight:SetHeight(DruidPercent * 185)
	BDOMod_DruidRight:SetTexCoord(0.5, 1, 1-DruidPercent, 1)
end

local function handlePetActionBar()
	if HasPetUI() then
		PetActionBarFrame:Show()
		PetActionButton1:Show()
		PetActionButton2:Show()
		PetActionButton3:Show()
		PetActionButton4:Show()
		PetActionButton5:Show()
		PetActionButton6:Show()
		PetActionButton7:Show()
		PetActionButton8:Show()
		PetActionButton9:Show()
		PetActionButton10:Show()
	else
		PetActionBarFrame:Hide()
		PetActionButton1:Hide()
		PetActionButton2:Hide()
		PetActionButton3:Hide()
		PetActionButton4:Hide()
		PetActionButton5:Hide()
		PetActionButton6:Hide()
		PetActionButton7:Hide()
		PetActionButton8:Hide()
		PetActionButton9:Hide()
		PetActionButton10:Hide()
	end
end

local function reconfigUI()
	MainMenuBar:SetScale(.01)
	MainMenuBar.ignoreFramePositionManager = true

	BDOMod_HealthOrb:SetScale(scaleFactor*53/100)
	BDOMod_ManaOrb:SetScale(scaleFactor*53/100)

	actionbarBackground:SetScale(scaleFactor*90/100)

	leftArtwork:SetScale(scaleFactor*75/100)
	rightArtwork:SetScale(scaleFactor*75/100)	

	--Setup Action Bar
	ActionButton1:ClearAllPoints()
	ActionButton2:ClearAllPoints()
	ActionButton3:ClearAllPoints()
	ActionButton4:ClearAllPoints()
	ActionButton5:ClearAllPoints()
	ActionButton6:ClearAllPoints()
	ActionButton7:ClearAllPoints()
	ActionButton8:ClearAllPoints()
	ActionButton9:ClearAllPoints()
	ActionButton10:ClearAllPoints()
	ActionButton11:ClearAllPoints()
	ActionButton12:ClearAllPoints()

	ActionButton1:SetScale(scaleFactor*60)
	ActionButton2:SetScale(scaleFactor*60)
	ActionButton3:SetScale(scaleFactor*60)
	ActionButton4:SetScale(scaleFactor*60)
	ActionButton5:SetScale(scaleFactor*60)
	ActionButton6:SetScale(scaleFactor*60)
	ActionButton7:SetScale(scaleFactor*60)
	ActionButton8:SetScale(scaleFactor*60)
	ActionButton9:SetScale(scaleFactor*60)
	ActionButton10:SetScale(scaleFactor*60)
	ActionButton11:SetScale(scaleFactor*60)
	ActionButton12:SetScale(scaleFactor*60)

	ActionButton1:SetPoint("BOTTOM", UIParent, "BOTTOM",-246,29)
	ActionButton2:SetPoint("BOTTOM", UIParent, "BOTTOM",-201,29)
	ActionButton3:SetPoint("BOTTOM", UIParent, "BOTTOM",-156,29)
	ActionButton4:SetPoint("BOTTOM", UIParent, "BOTTOM",-111,29)
	ActionButton5:SetPoint("BOTTOM", UIParent, "BOTTOM",-66,29)
	ActionButton6:SetPoint("BOTTOM", UIParent, "BOTTOM",-21,29)
	ActionButton7:SetPoint("BOTTOM", UIParent, "BOTTOM",21,29)
	ActionButton8:SetPoint("BOTTOM", UIParent, "BOTTOM",66,29)
	ActionButton9:SetPoint("BOTTOM", UIParent, "BOTTOM",111,29)
	ActionButton10:SetPoint("BOTTOM", UIParent, "BOTTOM",156,29)
	ActionButton11:SetPoint("BOTTOM", UIParent, "BOTTOM",201,29)
	ActionButton12:SetPoint("BOTTOM", UIParent, "BOTTOM",246,29)

	ActionButton1.ignoreFramePositionManager = true
	ActionButton2.ignoreFramePositionManager = true
	ActionButton3.ignoreFramePositionManager = true
	ActionButton4.ignoreFramePositionManager = true
	ActionButton5.ignoreFramePositionManager = true
	ActionButton6.ignoreFramePositionManager = true
	ActionButton7.ignoreFramePositionManager = true
	ActionButton8.ignoreFramePositionManager = true
	ActionButton9.ignoreFramePositionManager = true
	ActionButton10.ignoreFramePositionManager = true
	ActionButton11.ignoreFramePositionManager = true
	ActionButton12.ignoreFramePositionManager = true

	BonusActionButton1:ClearAllPoints()
	BonusActionButton2:ClearAllPoints()
	BonusActionButton3:ClearAllPoints()
	BonusActionButton4:ClearAllPoints()
	BonusActionButton5:ClearAllPoints()
	BonusActionButton6:ClearAllPoints()
	BonusActionButton7:ClearAllPoints()
	BonusActionButton8:ClearAllPoints()
	BonusActionButton9:ClearAllPoints()
	BonusActionButton10:ClearAllPoints()
	BonusActionButton11:ClearAllPoints()
	BonusActionButton12:ClearAllPoints()

	BonusActionButton1:SetScale(scaleFactor*60)
	BonusActionButton2:SetScale(scaleFactor*60)
	BonusActionButton3:SetScale(scaleFactor*60)
	BonusActionButton4:SetScale(scaleFactor*60)
	BonusActionButton5:SetScale(scaleFactor*60)
	BonusActionButton6:SetScale(scaleFactor*60)
	BonusActionButton7:SetScale(scaleFactor*60)
	BonusActionButton8:SetScale(scaleFactor*60)
	BonusActionButton9:SetScale(scaleFactor*60)
	BonusActionButton10:SetScale(scaleFactor*60)
	BonusActionButton11:SetScale(scaleFactor*60)
	BonusActionButton12:SetScale(scaleFactor*60)	

	BonusActionButton1:SetPoint("BOTTOM", UIParent, "BOTTOM",-246,29)
	BonusActionButton2:SetPoint("BOTTOM", UIParent, "BOTTOM",-201,29)
	BonusActionButton3:SetPoint("BOTTOM", UIParent, "BOTTOM",-156,29)
	BonusActionButton4:SetPoint("BOTTOM", UIParent, "BOTTOM",-111,29)
	BonusActionButton5:SetPoint("BOTTOM", UIParent, "BOTTOM",-66,29)
	BonusActionButton6:SetPoint("BOTTOM", UIParent, "BOTTOM",-21,29)
	BonusActionButton7:SetPoint("BOTTOM", UIParent, "BOTTOM",21,29)
	BonusActionButton8:SetPoint("BOTTOM", UIParent, "BOTTOM",66,29)
	BonusActionButton9:SetPoint("BOTTOM", UIParent, "BOTTOM",111,29)
	BonusActionButton10:SetPoint("BOTTOM", UIParent, "BOTTOM",156,29)
	BonusActionButton11:SetPoint("BOTTOM", UIParent, "BOTTOM",201,29)
	BonusActionButton12:SetPoint("BOTTOM", UIParent, "BOTTOM",246,29)	

	BonusActionButton1.ignoreFramePositionManager = true
	BonusActionButton2.ignoreFramePositionManager = true
	BonusActionButton3.ignoreFramePositionManager = true
	BonusActionButton4.ignoreFramePositionManager = true
	BonusActionButton5.ignoreFramePositionManager = true
	BonusActionButton6.ignoreFramePositionManager = true
	BonusActionButton7.ignoreFramePositionManager = true
	BonusActionButton8.ignoreFramePositionManager = true
	BonusActionButton9.ignoreFramePositionManager = true
	BonusActionButton10.ignoreFramePositionManager = true
	BonusActionButton11.ignoreFramePositionManager = true
	BonusActionButton12.ignoreFramePositionManager = true

	--Setup Left Multibar
	MultiBarBottomLeftButton1:ClearAllPoints()
	MultiBarBottomLeftButton2:ClearAllPoints()
	MultiBarBottomLeftButton3:ClearAllPoints()
	MultiBarBottomLeftButton4:ClearAllPoints()
	MultiBarBottomLeftButton5:ClearAllPoints()
	MultiBarBottomLeftButton6:ClearAllPoints()
	MultiBarBottomLeftButton7:ClearAllPoints()
	MultiBarBottomLeftButton8:ClearAllPoints()
	MultiBarBottomLeftButton9:ClearAllPoints()
	MultiBarBottomLeftButton10:ClearAllPoints()
	MultiBarBottomLeftButton11:ClearAllPoints()
	MultiBarBottomLeftButton12:ClearAllPoints()

	MultiBarBottomLeftButton1:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton2:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton3:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton4:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton5:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton6:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton7:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton8:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton9:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton10:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton11:SetScale(scaleFactor*60/100)
	MultiBarBottomLeftButton12:SetScale(scaleFactor*60/100)

	MultiBarBottomLeftButton1:SetPoint("BOTTOM", UIParent, "BOTTOM",-246,75)
	MultiBarBottomLeftButton2:SetPoint("BOTTOM", UIParent, "BOTTOM",-201,75)
	MultiBarBottomLeftButton3:SetPoint("BOTTOM", UIParent, "BOTTOM",-156,75)
	MultiBarBottomLeftButton4:SetPoint("BOTTOM", UIParent, "BOTTOM",-111,75)
	MultiBarBottomLeftButton5:SetPoint("BOTTOM", UIParent, "BOTTOM",-66,75)
	MultiBarBottomLeftButton6:SetPoint("BOTTOM", UIParent, "BOTTOM",-21,75)
	MultiBarBottomLeftButton7:SetPoint("BOTTOM", UIParent, "BOTTOM",21,75)
	MultiBarBottomLeftButton8:SetPoint("BOTTOM", UIParent, "BOTTOM",66,75)
	MultiBarBottomLeftButton9:SetPoint("BOTTOM", UIParent, "BOTTOM",111,75)
	MultiBarBottomLeftButton10:SetPoint("BOTTOM", UIParent, "BOTTOM",156,75)
	MultiBarBottomLeftButton11:SetPoint("BOTTOM", UIParent, "BOTTOM",201,75)
	MultiBarBottomLeftButton12:SetPoint("BOTTOM", UIParent, "BOTTOM",246,75)

	MultiBarBottomLeftButton1.ignoreFramePositionManager = true
	MultiBarBottomLeftButton2.ignoreFramePositionManager = true
	MultiBarBottomLeftButton3.ignoreFramePositionManager = true
	MultiBarBottomLeftButton4.ignoreFramePositionManager = true
	MultiBarBottomLeftButton5.ignoreFramePositionManager = true
	MultiBarBottomLeftButton6.ignoreFramePositionManager = true
	MultiBarBottomLeftButton7.ignoreFramePositionManager = true
	MultiBarBottomLeftButton8.ignoreFramePositionManager = true
	MultiBarBottomLeftButton9.ignoreFramePositionManager = true
	MultiBarBottomLeftButton10.ignoreFramePositionManager = true
	MultiBarBottomLeftButton11.ignoreFramePositionManager = true
	MultiBarBottomLeftButton12.ignoreFramePositionManager = true

	--Setup Right Multibar
	MultiBarBottomRightButton1:ClearAllPoints()
	MultiBarBottomRightButton2:ClearAllPoints()
	MultiBarBottomRightButton3:ClearAllPoints()
	MultiBarBottomRightButton4:ClearAllPoints()
	MultiBarBottomRightButton5:ClearAllPoints()
	MultiBarBottomRightButton6:ClearAllPoints()
	MultiBarBottomRightButton7:ClearAllPoints()
	MultiBarBottomRightButton8:ClearAllPoints()
	MultiBarBottomRightButton9:ClearAllPoints()
	MultiBarBottomRightButton10:ClearAllPoints()
	MultiBarBottomRightButton11:ClearAllPoints()
	MultiBarBottomRightButton12:ClearAllPoints()

	MultiBarBottomRightButton1:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton2:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton3:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton4:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton5:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton6:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton7:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton8:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton9:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton10:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton11:SetScale(scaleFactor*60/100)
	MultiBarBottomRightButton12:SetScale(scaleFactor*60/100)

	MultiBarBottomRightButton1:SetPoint("BOTTOM", UIParent, "BOTTOM",-246,132)
	MultiBarBottomRightButton2:SetPoint("BOTTOM", UIParent, "BOTTOM",-201,132)
	MultiBarBottomRightButton3:SetPoint("BOTTOM", UIParent, "BOTTOM",-156,132)
	MultiBarBottomRightButton4:SetPoint("BOTTOM", UIParent, "BOTTOM",-111,132)
	MultiBarBottomRightButton5:SetPoint("BOTTOM", UIParent, "BOTTOM",-66,132)
	MultiBarBottomRightButton6:SetPoint("BOTTOM", UIParent, "BOTTOM",-21,132)
	MultiBarBottomRightButton7:SetPoint("BOTTOM", UIParent, "BOTTOM",21,132)
	MultiBarBottomRightButton8:SetPoint("BOTTOM", UIParent, "BOTTOM",66,132)
	MultiBarBottomRightButton9:SetPoint("BOTTOM", UIParent, "BOTTOM",111,132)
	MultiBarBottomRightButton10:SetPoint("BOTTOM", UIParent, "BOTTOM",156,132)
	MultiBarBottomRightButton11:SetPoint("BOTTOM", UIParent, "BOTTOM",201,132)
	MultiBarBottomRightButton12:SetPoint("BOTTOM", UIParent, "BOTTOM",246,132)

	MultiBarBottomRightButton1.ignoreFramePositionManager = true
	MultiBarBottomRightButton2.ignoreFramePositionManager = true
	MultiBarBottomRightButton3.ignoreFramePositionManager = true
	MultiBarBottomRightButton4.ignoreFramePositionManager = true
	MultiBarBottomRightButton5.ignoreFramePositionManager = true
	MultiBarBottomRightButton6.ignoreFramePositionManager = true
	MultiBarBottomRightButton7.ignoreFramePositionManager = true
	MultiBarBottomRightButton8.ignoreFramePositionManager = true
	MultiBarBottomRightButton9.ignoreFramePositionManager = true
	MultiBarBottomRightButton10.ignoreFramePositionManager = true
	MultiBarBottomRightButton11.ignoreFramePositionManager = true
	MultiBarBottomRightButton12.ignoreFramePositionManager = true

	MultiBarLeft:SetScale(scaleFactor*60/100)	
	MultiBarLeftButton1:ClearAllPoints()
	MultiBarLeftButton1:SetPoint("RIGHT",UIParent,"RIGHT",-45,185)

	MultiBarRight:SetScale(scaleFactor*60/100)
	MultiBarRightButton1:ClearAllPoints()
	MultiBarRightButton1:SetPoint("RIGHT",UIParent,"RIGHT",-3,185)

	CastingBarFrame:ClearAllPoints()
	CastingBarFrame:SetScale(scaleFactor*70/100)
	CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM",0,175)
	CastingBarFrame.SetPoint = function() end
	--CastingBarFrame:ClearAllPoints()
	--CastingBarFrame:SetScale(scaleFactor*70/100)
	--CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM",0,160)	
	--CastingBarFrame.ignoreFramePositionManager = true
	
	--Setup Chatframes
	ChatFrame1:SetFrameStrata("HIGH")
	ChatFrame1:SetFrameLevel(9)

	ChatFrame2:SetFrameStrata("HIGH")
	ChatFrame1:SetFrameLevel(9)

	ChatFrame3:SetFrameStrata("HIGH")
	ChatFrame1:SetFrameLevel(9)

	ChatFrame4:SetFrameStrata("HIGH")
	ChatFrame1:SetFrameLevel(9)

	ChatFrame5:SetFrameStrata("HIGH")
	ChatFrame1:SetFrameLevel(9)

	ChatFrame6:SetFrameStrata("HIGH")	
	ChatFrame1:SetFrameLevel(9)

	ChatFrame7:SetFrameStrata("HIGH")
	ChatFrame1:SetFrameLevel(9)

	--PetActionBarFrame:ClearAllPoints()
	--PetActionBarFrame:SetScale(scaleFactor*60/100)
	--PetActionBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM",-77,194)
	--PetActionBarFrame.ignoreFramePositionManager = true

	PetActionButton1:ClearAllPoints()
	PetActionButton2:ClearAllPoints()
	PetActionButton3:ClearAllPoints()
	PetActionButton4:ClearAllPoints()
	PetActionButton5:ClearAllPoints()
	PetActionButton6:ClearAllPoints()
	PetActionButton7:ClearAllPoints()
	PetActionButton8:ClearAllPoints()
	PetActionButton9:ClearAllPoints()
	PetActionButton10:ClearAllPoints()

	
	PetActionButton1:SetScale(scaleFactor*50)
	PetActionButton2:SetScale(scaleFactor*50)
	PetActionButton3:SetScale(scaleFactor*50)
	PetActionButton4:SetScale(scaleFactor*50)
	PetActionButton5:SetScale(scaleFactor*50)
	PetActionButton6:SetScale(scaleFactor*50)
	PetActionButton7:SetScale(scaleFactor*50)
	PetActionButton8:SetScale(scaleFactor*50)
	PetActionButton9:SetScale(scaleFactor*50)
	PetActionButton10:SetScale(scaleFactor*50)

	PetActionButton1:SetPoint("BOTTOM", UIParent, "BOTTOM",-304,209)
	PetActionButton2:SetPoint("BOTTOM", UIParent, "BOTTOM",-271,209)
	PetActionButton3:SetPoint("BOTTOM", UIParent, "BOTTOM",-238,209)
	PetActionButton4:SetPoint("BOTTOM", UIParent, "BOTTOM",-205,209)
	PetActionButton5:SetPoint("BOTTOM", UIParent, "BOTTOM",-172,209)
	PetActionButton6:SetPoint("BOTTOM", UIParent, "BOTTOM",-139,209)
	PetActionButton7:SetPoint("BOTTOM", UIParent, "BOTTOM",-106,209)
	PetActionButton8:SetPoint("BOTTOM", UIParent, "BOTTOM",-73,209)
	PetActionButton9:SetPoint("BOTTOM", UIParent, "BOTTOM",-40,209)
	PetActionButton10:SetPoint("BOTTOM", UIParent, "BOTTOM",-7,209)
	


	--REP Bar (Positioning doesnt work...)
	--ReputationWatchBar:ClearAllPoints()
	--ReputationWatchBar:SetPoint("BOTTOM", UIParent, "BOTTOM",0,230)
	--ReputationWatchBar:SetScale(scaleFactor*34.6)
	--ReputationWatchBar.ignoreFramePositionManager = true

	--Micro Buttons	
	CharacterMicroButton:ClearAllPoints()
	SpellbookMicroButton:ClearAllPoints()
	TalentMicroButton:ClearAllPoints()
	QuestLogMicroButton:ClearAllPoints()
	SocialsMicroButton:ClearAllPoints()
	WorldMapMicroButton:ClearAllPoints()
	MainMenuMicroButton:ClearAllPoints()
	HelpMicroButton:ClearAllPoints()
	MainMenuBarBackpackButton:ClearAllPoints()
	CharacterBag0Slot:ClearAllPoints()
	CharacterBag1Slot:ClearAllPoints()
	CharacterBag2Slot:ClearAllPoints()
	CharacterBag3Slot:ClearAllPoints()
	KeyRingButton:ClearAllPoints()

	CharacterMicroButton:SetScale(scaleFactor*42)
	SpellbookMicroButton:SetScale(scaleFactor*42)
	TalentMicroButton:SetScale(scaleFactor*42)
	QuestLogMicroButton:SetScale(scaleFactor*42)
	SocialsMicroButton:SetScale(scaleFactor*42)
	WorldMapMicroButton:SetScale(scaleFactor*42)
	MainMenuMicroButton:SetScale(scaleFactor*42)
	HelpMicroButton:SetScale(scaleFactor*42)
	MainMenuBarBackpackButton:SetScale(scaleFactor*38)
	CharacterBag0Slot:SetScale(scaleFactor*38)
	CharacterBag1Slot:SetScale(scaleFactor*38)
	CharacterBag2Slot:SetScale(scaleFactor*38)
	CharacterBag3Slot:SetScale(scaleFactor*38)
	KeyRingButton:SetScale(scaleFactor*38)

	CharacterMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",-125,0)
	SpellbookMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",-100,0)
	TalentMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",-75,0)
	QuestLogMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",-50,0)
	SocialsMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",-25,0)
	WorldMapMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",0,0)
	MainMenuMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",25,0)
	HelpMicroButton:SetPoint("BOTTOM", UIParent, "BOTTOM",50,0)

	MainMenuBarBackpackButton:SetPoint("BOTTOM", UIParent, "BOTTOM",400,1)
	CharacterBag0Slot:SetPoint("BOTTOM", UIParent, "BOTTOM",360,1)
	CharacterBag1Slot:SetPoint("BOTTOM", UIParent, "BOTTOM",320,1)
	CharacterBag2Slot:SetPoint("BOTTOM", UIParent, "BOTTOM",280,1)
	CharacterBag3Slot:SetPoint("BOTTOM", UIParent, "BOTTOM",240,1)
	KeyRingButton:SetPoint("BOTTOM", UIParent, "BOTTOM", 200,1)

	CharacterMicroButton.ignoreFramePositionManager = true
	SpellbookMicroButton.ignoreFramePositionManager = true
	TalentMicroButton.ignoreFramePositionManager = true
	QuestLogMicroButton.ignoreFramePositionManager = true
	MainMenuMicroButton.ignoreFramePositionManager = true
	MainMenuBarBackpackButton.ignoreFramePositionManager = true
	CharacterBag0Slot.ignoreFramePositionManager = true
	CharacterBag1Slot.ignoreFramePositionManager = true
	CharacterBag2Slot.ignoreFramePositionManager = true
	CharacterBag3Slot.ignoreFramePositionManager = true
	KeyRingButton.ignoreFramePositionManager = true

	ShapeshiftButton1:ClearAllPoints()
	ShapeshiftButton1:SetScale(scaleFactor*48)
	ShapeshiftButton1:SetPoint("BOTTOM", UIParent, "BOTTOM",-318,1)

	ShapeshiftButton2:ClearAllPoints()
	ShapeshiftButton2:SetScale(scaleFactor*48)
	ShapeshiftButton2:SetPoint("BOTTOM", UIParent, "BOTTOM",-286,1) --62

	ShapeshiftButton3:ClearAllPoints()
	ShapeshiftButton3:SetScale(scaleFactor*48)
	ShapeshiftButton3:SetPoint("BOTTOM", UIParent, "BOTTOM",-254,1)

	ShapeshiftButton4:ClearAllPoints()
	ShapeshiftButton4:SetScale(scaleFactor*48)
	ShapeshiftButton4:SetPoint("BOTTOM", UIParent, "BOTTOM",-222,1)

	ShapeshiftButton5:ClearAllPoints()
	ShapeshiftButton5:SetScale(scaleFactor*48)
	ShapeshiftButton5:SetPoint("BOTTOM", UIParent, "BOTTOM",-190,1)

	ShapeshiftButton6:ClearAllPoints()
	ShapeshiftButton6:SetScale(scaleFactor*48)
	ShapeshiftButton6:SetPoint("BOTTOM", UIParent, "BOTTOM",-158,1)		
	
	if UnitLevel("player") < 60 then
		MainMenuExpBar:ClearAllPoints()
		MainMenuExpBar:SetScale(scaleFactor*31)
		MainMenuExpBar:SetPoint("BOTTOM", UIParent, "BOTTOM",-3,229)--249
	end
	--MainMenuExpBar.Hide = function() end
	--ReputationWatchBar:ClearAllPoints()
	--ReputationWatchBar:SetScale(scaleFactor*31/100)
	--ReputationWatchBar:SetPoint("BOTTOM", UIParent, "BOTTOM",-3,215)--235

	--ActionBarUpButton:ClearAllPoints()
	--ActionBarUpButton:SetScale(scaleFactor*66/100)
	--ActionBarUpButton:SetPoint("BOTTOM", UIParent, "BOTTOM",0,16)

	--ActionBarDownButton:ClearAllPoints()
	--ActionBarDownButton:SetScale(scaleFactor*66/100)
	--ActionBarDownButton:SetPoint("BOTTOM", UIParent, "BOTTOM",0,-2)
end

local function setupOrbs()
	--BDOMod_RedOrb:SetVertexColor(0.85,0.2,0.2)
	--BDOMod_RedOrb:SetAlpha(0.95)
	BDOMod_RedOrb:SetVertexColor(0.0,1.0,0.0)
	BDOMod_RedOrb:SetTexCoord(0, 1, 0, 1)
	BDOMod_DruidRight:SetVertexColor(0.2,0.2,1.0)
	BDOMod_DruidRight:SetTexCoord(0, 1, 0, 1)	
	
	BDOMod_HealthText:SetFont("Fonts\\FRIZQT__.TTF", 12)
	BDOMod_HealthPercentage:SetFont("Interface\\AddOns\\CaestielleOrbs\\fonts\\exocetBold.ttf", 30)
	BDOMod_HealthText:SetText(UnitHealth("player").." / ".. UnitHealthMax("player"))
	BDOMod_HealthPercentage:SetText(100)

	BDOMod_ManaText:SetFont("Fonts\\FRIZQT__.TTF", 12)
	BDOMod_ManaPercentage:SetFont("Interface\\AddOns\\CaestielleOrbs\\fonts\\exocetBold.ttf", 30)
	BDOMod_ManaText:SetText(UnitMana("player").." / ".. UnitManaMax("player"))
	BDOMod_ManaText:SetText(100)
	BDOMod_DruidLeft:Hide()
	BDOMod_DruidRight:Hide()
end

local function updatePowerType()
	local powerType = UnitPowerType("player")
	if (powerType == 0) then -- Mana
		BDOMod_BlueOrb:SetVertexColor(0.2,0.2,1.0)
		--BDOMod_BlueOrb:SetAlpha(0.95)
		BDOMod_BlueOrb:SetTexCoord(0, 1, 0, 1)
		BDOMod_DruidLeft:SetVertexColor(0.2,0.2,1.0)
		BDOMod_DruidLeft:SetTexCoord(0, 1, 0, 1)
		return
	end
	if (powerType == 1) then -- Rage
		BDOMod_BlueOrb:SetVertexColor(1.0,0.15,0.15)
		--BDOMod_BlueOrb:SetAlpha(0.95)
		BDOMod_BlueOrb:SetTexCoord(0, 1, 0, 1)
		BDOMod_DruidLeft:SetVertexColor(1.0,0.15,0.15)
		BDOMod_DruidLeft:SetTexCoord(0, 1, 0, 1)
		return
	end
	if (powerType == 3) then -- Energy
		BDOMod_BlueOrb:SetVertexColor(1.0,1.0,0.0)
		--BDOMod_BlueOrb:SetAlpha(0.95)
		BDOMod_BlueOrb:SetTexCoord(0, 1, 0, 1)
		BDOMod_DruidLeft:SetVertexColor(1.0,1.0,0.0)
		BDOMod_DruidLeft:SetTexCoord(0, 1, 0, 1)
		return
	end
	if (powerType == 6) then -- Runic_Power
		BDOMod_BlueOrb:SetVertexColor(0.2,0.75,1.0)
		--BDOMod_BlueOrb:SetAlpha(0.95)
		BDOMod_BlueOrb:SetTexCoord(0, 1, 0, 1)
		BDOMod_DruidLeft:SetVertexColor(0.2,0.75,1.0)
		BDOMod_DruidLeft:SetTexCoord(0, 1, 0, 1)
		return
	end
end

function BDOMod_OnEvent(event)
	if (event=="PLAYER_ENTERING_WORLD") then
		updatePowerType()
		setupOrbs()
		createArtwork()
		reconfigUI()
		updateHealthOrb()
		updateManaOrb()
		if (UnitClass("player") == "Druid") then
			updateDruidMana()
			if (UnitPowerType("player") ~= 0 ) then
				BDOMod_BlueOrb:Hide()
				BDOMod_DruidLeft:Show()
				BDOMod_DruidRight:Show()
				BDOMod_BlueOrbGloss:SetTexture(images.."druid_gloss.tga")
			else
				BDOMod_BlueOrb:Show()
				BDOMod_DruidLeft:Hide()
				BDOMod_DruidRight:Hide()
				BDOMod_BlueOrbGloss:SetTexture(images.."orb_gloss.tga")
			end
		end
		return
	end 
	if (event=="UNIT_DISPLAYPOWER") then 
		updatePowerType()
		updateHealthOrb()
		updateManaOrb()
		if (UnitClass("player") == "Druid") then
			updateDruidMana()
			if (UnitPowerType("player") ~= 0 ) then
				BDOMod_BlueOrb:Hide()
				BDOMod_DruidLeft:Show()
				BDOMod_DruidRight:Show()
				BDOMod_BlueOrbGloss:SetTexture(images.."druid_gloss.tga")
			else
				BDOMod_BlueOrb:Show()
				BDOMod_DruidLeft:Hide()
				BDOMod_DruidRight:Hide()
				BDOMod_BlueOrbGloss:SetTexture(images.."orb_gloss.tga")
			end
		end
		return
	end
	if (event=="UNIT_HEALTH") then 
		updateHealthOrb()
		return
	end
	if (event=="UNIT_MANA" or event=="UNIT_RAGE" or event=="UNIT_ENERGY" or event=="UNIT_RUNIC_POWER") then    
		updateManaOrb()
		if (UnitClass("player") == "Druid") then
			updateDruidMana()
			if (UnitPowerType("player") ~= 0 ) then
				BDOMod_BlueOrb:Hide()
				BDOMod_DruidLeft:Show()
				BDOMod_DruidRight:Show()
				BDOMod_BlueOrbGloss:SetTexture(images.."druid_gloss.tga")
			else
				BDOMod_BlueOrb:Show()
				BDOMod_DruidLeft:Hide()
				BDOMod_DruidRight:Hide()
				BDOMod_BlueOrbGloss:SetTexture(images.."orb_gloss.tga")
			end
		end
		return
	end
	if (event=="UPDATE_BONUS_ACTIONBAR" or event=="ACTIONBAR_SLOT_CHANGED" or event=="ACTIONBAR_SHOWGRID" or event=="LOOT_CLOSED") then
		changeActionBar()
		return
	end
	if (event=="PET_BAR_UPDATE") then
		handlePetActionBar()
		return
	end
end
