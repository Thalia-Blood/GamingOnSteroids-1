require('Inspired')

Config = scriptConfig("Corki", "Corki by Outbreak")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)


Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))


OnLoop(function(myHero)
	if Config.Combo then
		local target = GetTarget(1500)
		
		if Config.Q and ValidTarget(target, 850) then			
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1000,300,850,250,false,true)
			
			if CanUseSpell(myHero,_Q) == READY and QPred.HitChance == 1 then				
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end
		end
		if Config.E and ValidTarget(target, 600)then
			if CanUseSpell(myHero,_E) == READY then
				CastTargetSpell(myHero, _E)
			end
		end
		if Config.R and ValidTarget(target, 1500)then
			local RPred = nil
			local missile = GotBuff(myHero,"mbcheck2")		
			
			if missile == 1 then
				RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,200,1500,40,true,true)
				if CanUseSpell(myHero,_R) == READY and RPred.HitChance == 1 then
					CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)					
				end
			else
				RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,200,1300,40,true,true)
				if CanUseSpell(myHero,_R) == READY and RPred.HitChance == 1 then					
					CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)					
				end
			end	
			
		end
	end	
end)
