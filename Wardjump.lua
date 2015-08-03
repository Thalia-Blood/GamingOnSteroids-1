require('Inspired')


local champ = GetObjectName(GetMyHero())

Config = scriptConfig("WardJump", "WardJump by Outbreak")
Config.addParam("Z", "Press to WardJump", SCRIPT_PARAM_KEYDOWN, string.byte("Z"))




local wardtimer = 0



function GetDistanceX(p1,p2) --thanks Inspired!
    p1 = GetOrigin(p1) or p1
    p2 = GetOrigin(p2) or p2
    return math.sqrt(GetDistanceSqrX(p1,p2))
end
function GetDistanceSqrX(p1,p2) --thanks Inspired!
    p2 = p2 or GetMyHeroPos()
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end


function CastWard()
	local wardid = {3340,3361,3154,2045,2049,2050,2044,2043}  	
    for i = 1,8 do
        local slot = GetItemSlot(GetMyHero(),wardid[i]) or 0	
		
        if slot > 0 and CanUseSpell(GetMyHero(),slot) == READY then
			local mymouse = GetMousePos()
			local origin = GetOrigin(myHero)
			
			if GetDistanceSqr(mymouse,origin) <= (600*600) then			
				CastSkillShot(slot,mymouse.x,mymouse.y,mymouse.z)				
				return true
			end			
        end		
    end
	return false
end


OnLoop(function(myHero)
	if champ == "LeeSin" or champ == "Jax" or champ == "Katarina" then
		if Config.Z then
			if champ == "LeeSin" and CanUseSpell(myHero,_W) == READY then
				if wardtimer < GetTickCount() then
					if CastWard() then
						wardtimer = GetTickCount() + 2000
					end			
				end
			end
			if champ == "Jax" and CanUseSpell(myHero,_Q) == READY then
				if wardtimer < GetTickCount() then
					if CastWard() then
						wardtimer = GetTickCount() + 2000
					end			
				end
			end
			if champ == "Katarina" and CanUseSpell(myHero,_E) == READY then
				if wardtimer < GetTickCount() then
					if CastWard() then
						wardtimer = GetTickCount() + 2000
					end			
				end
			end
		end
	end
end)

-- Ward jumping...

OnObjectLoop(function(Object,myHero)		
		
	local origin = GetOrigin(Object)
	local mousepoz = GetMousePos()
	if (GetDistanceX(origin,mousepoz) < 200) then		
		if GetObjectName(Object):lower()  == "yellowtrinket" or GetObjectName(Object):lower()  == "sightward" or GetObjectName(Object):lower()  == "visionward" then			
			wardtimer = GetTickCount() + 1000
			if Config.Z then	
				if champ == "LeeSin" then
					if CanUseSpell(myHero,_W) == READY then
						wardtimer = GetTickCount() + 3000
						CastTargetSpell(Object,_W)
					end	
				end
				if champ == "Jax" then
					if CanUseSpell(myHero,_Q) == READY then
						wardtimer = GetTickCount() + 3000
						CastTargetSpell(Object,_Q)
					end
				end
				if champ == "Katarina" then					
					if CanUseSpell(myHero,_E) == READY then
						wardtimer = GetTickCount() + 3000
						CastTargetSpell(Object,_E)
					end	
				end
			end		
		end			
	end
end)
