require('Inspired')



Config = scriptConfig("Twisted Fate", "Twisted Fate by Outbreak")

Config.addParam("Q","Use Q",SCRIPT_PARAM_ONOFF,true)
Config.addParam("R", "Yellow Card on ult", SCRIPT_PARAM_ONOFF, true)
Config.addParam("Killable","Can be killed",SCRIPT_PARAM_ONOFF,true)
Config.addParam("Farm","W - Smart Farming",SCRIPT_PARAM_ONOFF,true)


Config.addParam("E", "Blue Card", SCRIPT_PARAM_KEYDOWN, string.byte("E"))
Config.addParam("T", "Red Card", SCRIPT_PARAM_KEYDOWN, string.byte("T"))
Config.addParam("Combo", "Yellow Card", SCRIPT_PARAM_KEYDOWN, string.byte(" "))


myHero = GetMyHero()
tick = 0
ultimateused = false
tickwarn = 0
selectedcard = ""



OnLoop(function(myHero)

	if selectedcard ~= "" then
		SelectCard()
	end	
	
	if Config.Killable then
		Killable()
	end	
	
	if Config.Farm and GetTickCount() > tick  and KeyIsDown(0x56) then
		Farm()
	end
	
	if Config.E and GetTickCount() > tick then
		if CanUseSpell(myHero,_W) == READY and GetCastName(myHero,_W) == "PickACard" then
			selectedcard = "bluecardlock"
			tick = GetTickCount() + 3000
			CastSpell(_W)
		end
	end
	
	if Config.T and GetTickCount() > tick then
		if CanUseSpell(myHero,_W) == READY and GetCastName(myHero,_W) == "PickACard" then
			selectedcard = "redcardlock"
			tick = GetTickCount() + 3000
			CastSpell(_W)
		end
	end	

	if Config.Combo then
		Combo()
	end
end)

OnProcessSpell(function(Object,spellProc)
	if not Config.R then
		return
	end
	
	if Object and Object == myHero then
		local name = spellProc.name:lower()		
		
		
		if name == "destiny" then
			ultimateused = true
		end
		if name == "gate" then 
			ultimateused = false
			selectedcard = "goldcardlock"
				
			if CanUseSpell(myHero,_W) == READY and GetCastName(myHero,_W) == "PickACard" then					
				CastSpell(_W)
			end
		end
				
	end	
end)







function Killable()
	
	local ad = GetBonusDmg(myHero) + GetBaseDamage(myHero)
	local Wlevel = GetCastLevel(myHero,_W) - 1
	local Qlevel = GetCastLevel(myHero,_Q) - 1
		
	local bcard = (40 + (20 * Wlevel) + (ad) + (GetBonusAP(myHero) * 0.5 ))		
	local ycard = (15 + (7.5 * Wlevel) + (ad) + (GetBonusAP(myHero) * 0.5 ))
	local qdmg = (60 + (50 * Qlevel) + (GetBonusAP(myHero) * 0.65 ))
		
		
	for _,unit in pairs(GetEnemyHeroes()) do
		if not IsDead(unit) and ValidTarget(unit,6500) then
			local hp = GetCurrentHP(unit)
			local Ydmg = CalcDamage(myHero, unit, 0, ycard + qdmg) or 0
			local Bdmg = CalcDamage(myHero, unit, 0, bcard + qdmg) or 0
				
			if Ydmg > hp and tickwarn < GetTickCount() then
				local HPBARPOS = GetHPBarPos(myHero)
				if HPBARPOS.x > 0 then
					if HPBARPOS.y > 0 then				
						DrawText(string.format("You can kill %s(YellowCard)",GetObjectName(unit)),12,HPBARPOS.x,HPBARPOS.y - 30,0xffffff00)						
					end
				end
				tickwarn = GetTickCount() + 5000
				return
			elseif Bdmg > hp then
				local HPBARPOS = GetHPBarPos(myHero)
				if HPBARPOS.x > 0 then
					if HPBARPOS.y > 0 then				
						DrawText(string.format("You can kill %s(BlueCard)",GetObjectName(unit)),12,HPBARPOS.x,HPBARPOS.y - 30,0xffffff00)
					end
				end					
				tickwarn = GetTickCount() + 5000
				return
			end
		end
	end
end

function SelectCard()
	local name = GetCastName(myHero,_W):lower()
	if name == "goldcardlock" and selectedcard == name then
		CastSpell(_W)
		selectedcard = ""			
	end
	if name == "redcardlock" and selectedcard == name then
		CastSpell(_W)
		selectedcard = ""			
	end
	if name == "bluecardlock" and selectedcard == name then
		CastSpell(_W)
		selectedcard = ""			
	end
end

function Combo()
	local target = GetTarget(1450)		
	local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1000,250,1450,40,false,true)
		
	if Config.Q and ValidTarget(target,1450) then
		if CanUseSpell(myHero,_Q) == READY and QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)			
		end	
	end
	if GetTickCount() > tick then
		selectedcard = "goldcardlock"
		tick = GetTickCount() + 3000
		CastSpell(_W)
	end
end

function Farm()
	local pmana = (GetCurrentMana(myHero)/GetMaxMana(myHero)) * 100
	
	if pmana >= 65 then
		if CanUseSpell(myHero,_W) == READY and GetCastName(myHero,_W) == "PickACard" then
			selectedcard = "redcardlock"
			tick = GetTickCount() + 3000
			CastSpell(_W)			
		end
	else
		if CanUseSpell(myHero,_W) == READY and GetCastName(myHero,_W) == "PickACard" then
			selectedcard = "bluecardlock"
			tick = GetTickCount() + 3000
			CastSpell(_W)			
		end
	end
end

