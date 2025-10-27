
CAI_10100 = class(CAIObject)
function CAI_10100:ctor(id, objid)
end
function CAI_10100:OnInteractive(uid, event)
	content = "";
	local eff = Zodiac_GetEff(uid);
	local numeff = Zodiac_GetCount(uid)+1;
	local cnt1 = GetContent("DEV/Zodiac/main.xml");
	local item1 = GetItemCount(uid,15386);
	local item2 = GetItemCount(uid,15393);
	if not item1 then item1 = 0; end
	if not item2 then item2 = 0; end
	local cnt2 = string.gsub(cnt1,"xNUM1",numeff);
	local cnt3 = string.gsub(cnt2,"$_LUCKPER",Zodiac_GetLuck(uid,15385)*5);
	local cnt4 = string.gsub(cnt3,"$_Item1",item1);
	local cnt5 = string.gsub(cnt4,"$_Item2",item2);
	if event == "defaulttalk" then
		if eff == 15079 then
			return CenterMsg(uid, "Your (Zodiac Power) is max level!");
		else
			content = cnt5;
		end
	end
	for i=1,50 do
		if event == "UPDATE+"..i then
			local uptmp = 0;
			local tmprate = nil; 
			if i >= 100 then
				tmprate = 1;
			else
				tmprate = 100-i;
			end
			if eff == 0 then
			-- Zodiac_Update(objeff,uid,haveeff,toeff,reqitem1,reqitem2,amount1,amount2,rate)
				uptmp = Zodiac_Update(self.ObjID,uid,0,15030,15386,15393,i*10,i,tmprate);
			else
			-- Zodiac_Update(objeff,uid,haveeff,toeff,reqitem1,reqitem2,amount1,amount2,rate)
				uptmp = Zodiac_Update(self.ObjID,uid,eff,eff+1,15386,15393,i*10,i,tmprate); 
			end
			if uptmp == 0 then
				OutputLog(GetUserNameByObjId(uid).."Zodiac Err tmp value = 0");
				uptmp = nil;
			elseif uptmp == 1 then 
				CenterMsg(uid,"Wrong Eff condition, try later");
				uptmp = nil;
			elseif uptmp == 2 then 
				CenterMsg(uid,"Not enough item/s ");
				uptmp = nil;
			elseif uptmp == 3 then 
				CenterMsg(uid,"Can't take item ");
				uptmp = nil;
			elseif uptmp == 10 then 
				if i >= 50 then
					BroadcastMedia(str,"#cFF5151 Pushing past their limits! #cFF995B"..(GetUserNameByObjId(uid)).."#cFF5151 upgraded Zodiac Power to #cFF995B"..("Level "..i).."#cFF5151 !",6); 
					CenterMsg(uid,"Congratulations! Upgrade succeeded!");
					uptmp = nil;
					if i == 50 then return CenterMsg(uid, "Your (Zodiac Power) is max level!"); end
				else
					CenterMsg(uid,"Congratulations! Upgrade succeeded!");
					uptmp = nil;
				end
			elseif uptmp == 11 then 
				if i >= 50 then
					SendMedia("Condolatory "..ColorMedia(GetUserNameByObjId(uid),"b800e6").." Update fail "..ColorMedia("Level "..i,"b800e6"),7);
					CenterMsg(uid,"Upgrade failed...");
					uptmp = nil;
				else
					CenterMsg(uid,"Upgrade failed...");
					uptmp = nil;
				end
			end
		end
	end
	return content;
end

function Zodiac_GetEff(uid)
	for i=15030,15079 do
		if CreHasEff(uid, i) == 1 then
			return i
		end
	end
	return 0
end
function Zodiac_GetCount(uid)
	local count = 0;
	for i=15030,15079 do
		count = count+1;
		if CreHasEff(uid, i) == 1 then
			return count
		end
	end
	return 0
end
function Zodiac_GetLuck(uid,itemid)
	local luckitem = GetItemCount(uid,itemid);
	if luckitem >= 1 then
		if luckitem == 1 then
			return 1;
		elseif luckitem == 2 then
			return 2;
		elseif luckitem == 3 then
			return 3;
		elseif luckitem >= 4 then
			return 4;
		end
	else
		return 0
	end
end
function Zodiac_GetAndRevLuck(uid,rate,itemid)
	local luckitem = GetItemCount(uid,itemid);
	if luckitem >= 1 then
		if luckitem == 1 then
			if rate + 5 <= 100 then
				RemoveItem(uid,itemid,1);
				return 1
			else
				return 0
			end
		elseif luckitem == 2 then
			if rate + 10 <= 100 then
				RemoveItem(uid,itemid,2);
				return 2
			elseif rate + 5 <= 100 then
				RemoveItem(uid,itemid,1);
				return 1
			else
				return 0
			end
		elseif luckitem == 3 then
			if rate + 15 <= 100 then
				RemoveItem(uid,itemid,3);
				return 3
			elseif rate + 10 <= 100 then
				RemoveItem(uid,itemid,2);
				return 2
			elseif rate + 5 <= 100 then
				RemoveItem(uid,itemid,1);
				return 1
			else
				return 0
			end
		elseif luckitem >= 4 then
		
			if rate + 20 <= 100 then
				RemoveItem(uid,itemid,4);
				return 4
			elseif rate + 15 <= 100 then
				RemoveItem(uid,itemid,3);
				return 3
			elseif rate + 10 <= 100 then
				RemoveItem(uid,itemid,2);
				return 2
			elseif rate + 5 <= 100 then
				RemoveItem(uid,itemid,1);
				return 1
			else
				return 0
			end
		end
	else
		return 0
	end
end
function Zodiac_Update(objeff,uid,haveeff,toeff,reqitem1,reqitem2,amount1,amount2,rate)
	if haveeff == 0 then
		if GetItemCount(uid,reqitem1) >= amount1 and GetItemCount(uid,reqitem2) >= amount2 then
			if RemoveItem(uid,reqitem1,amount1) and RemoveItem(uid,reqitem2,amount2) then
				local rdn = math.random(1,100);
				OutputLog("Zodiac usn="..GetUserNameByObjId(uid).." rate="..rate.." rdn="..rdn.." toeff="..toeff);
				if rdn <= rate + (Zodiac_GetAndRevLuck(uid,rate,15385) * 5) then
					AddCreEff(uid, objeff, toeff);
					return 10
				else
					return 11
				end
			else
				return 3
			end
		else
			return 2
		end
	elseif CreHasEff(uid, haveeff) ~= 0 then
		if GetItemCount(uid,reqitem1) >= amount1 and GetItemCount(uid,reqitem2) >= amount2 then
			if RemoveItem(uid,reqitem1,amount1) and RemoveItem(uid,reqitem2,amount2) then
				local rdn = math.random(1,100);
				OutputLog("Zodiac usn="..GetUserNameByObjId(uid).." rate="..rate.." rdn="..rdn.." toeff="..toeff);
				if rdn <= rate + (Zodiac_GetAndRevLuck(uid,rate,15385) * 5) then
					RemoveEffect(uid, haveeff);
					AddCreEff(uid, objeff, toeff);
					return 10
				else
					return 11
				end
			else
				return 3
			end
		else
			return 2
		end
	else
		return 1
	end
end

