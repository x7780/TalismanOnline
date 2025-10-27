CAI_10099 = class(CAIObject)
function CAI_10099:ctor(id, objid)
	Control = {};
	Control.SLEV = 0;
end

function CAI_10099:OnUpdate(dwNow)
	if CheckTimeFull(SLEVStart) and Control.SLEV == 0 then
		local npc10003 = GetNpcIdByTypeId(self.ObjID,10003);
		if npc10003 ~= 0 then
			SLEV_Time = dwNow;
			Control.SLEV = 1;
			SetTriggerUpdateEvent(npc10003, 1);
		end
	elseif not CheckTimeFull(SLEVStart) and Control.SLEV ~= 0 then
		Control.SLEV = 0;
	end
end

function PutContent(pathfilename,content)
	local writefile = io.open(pathfilename,"w+");
	if writefile then
		writefile:write(content);
		writefile:close();
		return true
	else 
		return false 
	end
end

CAI_10003 = class(CAIObject)
function CAI_10003:ctor(id, objid)
	SLEV_MaxRegiter = 64; -- MaxRegiter <= 64;
	SLEV_Path = "DEV/Solo_Ev/";
	SLEV_WMail = {"v=1;s=1|i=7619;%=1","Reward Winner","Change this"};
	SLEV_LMail = {"v=1;s=1|i=7619;%=10","Consolation","Change this"};
	SLEV_AllMail = {"v=1;s=2|i=7619;%=50|i=7630","Conso","Change this"};
	
	SLEV_Time = 0;
	SLEV_Key = "";
	SLEV_tblRegiter = {};
	SLEV_CountRegister = 0;
	SLEV_Mail_Win = {};
	SLEV_Mail_Lose = {};
	SLEV_Fgt1_Lst = {};
	SLEV_Fgt2_Lst = {};
	SLEV_Fgt3_Lst = {};
	SLEV_Fgt4_Lst = {};
	SLEV_Fgt5_Lst = {};
	SLEV_Fgt6_Lst = {};
	SLEV_Fgt7_Lst = {};
	SLEV_FgtFN_Lst = {};
	SLEV_Flag = {0,0,0,0,0,0,0};
end
function CAI_10003:OnCreate(dwNow)
	SLEVStart = {};
	SLEVStart.Hour = {21};
	SLEVStart.Week = {1,2,3,4,5,6};
end
function CAI_10003:OnUpdate(dwNow)
	if Control.SLEV == 1 then
		if SLEV_Key == "" then
			SendMedia("System: "..ColorMedia("King of Fighters","ff0000").."is now open, you can register for 5minutes",7);
			Bulletin("System:King of Fighters is now open, you can register for 5minutes");
			SLEV_Time = dwNow + (5*60);
			SLEV_Key = "Register";
		end
		if SLEV_Key == "Register" then
			if tablecount(SLEV_tblRegiter) == SLEV_MaxRegiter then
				SLEV_CountRegister = tablecount(SLEV_tblRegiter);
				SLEV_Key = "MoveUser";
				SLEV_Time = dwNow - 1;
			end
			if (SLEV_Time - dwNow) == 0 then
				if tablecount(SLEV_tblRegiter) >=2 and tablecount(SLEV_tblRegiter) < SLEV_MaxRegiter then
					SLEV_CountRegister = tablecount(SLEV_tblRegiter);
					SLEV_Key = "MoveUser";
					SLEV_Time = dwNow - 1;
				else
					SLEV_Time = dwNow - 1;
					SLEV_Key = "Empty-END";
				end
			end
		end
		if SLEV_Key == "MoveUser" then
			for k,v in pairs(SLEV_tblRegiter) do 
				if GetUserObjId(v) ~= 0 then
					IfCreRideThenUnRide(GetUserObjId(v));
					AddEffectEx(GetUserObjId(v),15017,0,2,-315,-1476);
					RemoveEffect(GetUserObjId(v),41);
				end
			end
			SLEV_Fgt1_Lst = RanTable(SLEV_tblRegiter);
			idx = 0;
			SLEV_Key = "Select_F1";
		end
		
		
		
		--  Round Select_F1 ---
		if SLEV_Key == "Select_F1" then
			idx = idx + 1 ;
			CharName_F1 = "Ready??";
			CharName_F2 = "Ready??";
			SLEV_Flag = {0,0,0,0,0,0,0};
			if SLEV_Mon1 and SLEV_Mon2 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
			end
			if SLEV_Fgt1_Lst[idx] then
				CharName_F1 = SLEV_Fgt1_Lst[idx];
				idx = idx + 1 ;
				if SLEV_Fgt1_Lst[idx] then
					CharName_F2 = SLEV_Fgt1_Lst[idx];
				end
				SLEV_Key = "Fight_F1";
			elseif tablecount(SLEV_Fgt2_Lst) == 1 and SLEV_CountRegister == 2 then
				idx = 0;
				SLEV_FgtFN_Lst = SLEV_Fgt2_Lst;
				SLEV_Key = "END";
			else
				idx = 0;
				SLEV_Fgt2_Lst = RanTable(SLEV_Fgt2_Lst);
				SLEV_Key = "Select_F2";
			end
			SLEV_Time = dwNow;
		elseif SLEV_Key == "Fight_F1" then
			local fTime = dwNow - SLEV_Time;
			if fTime == 2 and SLEV_Flag[1] == 0 then
				SendMedia("Player : "..ColorMedia(CharName_F1,"b800e6").." VS "..ColorMedia(CharName_F2,"b800e6").." ",6);
				if GetUserObjId(CharName_F1) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F1), -300, -1476, 1);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F2), -330, -1476, 1);
				end
				SLEV_Flag[1] = 1;
			elseif fTime == 5 and SLEV_Flag[2] == 0 then
				SLEV_Mon1 = CreateNpc(self.ObjID, 10005, -300, -1476, 1);
				SLEV_Mon2 = CreateNpc(self.ObjID, 10006, -330, -1476, 1);
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Your turn in 3",6);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Your turn in 3",6);
				end
				AddToHateList(SLEV_Mon1, GetUserObjId(CharName_F1), 8999999);
				AddToHateList(SLEV_Mon2, GetUserObjId(CharName_F2), 8999999);
				SLEV_Flag[2] = 1;
			elseif fTime == 6 and SLEV_Flag[3] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Your turn in 2",6);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Your turn in 2",6);
				end
				SLEV_Flag[3] = 1;
			elseif fTime == 7 and SLEV_Flag[4] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Your turn in 1",6);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Your turn in 1",6);
				end
				SLEV_Flag[4] = 1;
			elseif fTime <= 187  and fTime > 7 and SLEV_Flag[5] == 0 then
				if CharName_F2 ~= 0 then
					local uid_F1 = GetUserObjId(CharName_F1);
					local uid_F2 = GetUserObjId(CharName_F2);
					if uid_F1 ~= 0 then
						if uid_F2 ~= 0 then
							if SLEV_Flag[6] == 0 then
								RemoveEffect(uid_F1, 15017);
								RemoveEffect(uid_F2, 15017);
								SLEV_Flag[6] = 1;
							end
							if GetCreHp(uid_F1) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F2,15017,0,2,-315,-1476);
								SendMedia("Player : "..ColorMedia(CharName_F2,"b800e6").."won the round. ",6);
								table.insert(SLEV_Fgt2_Lst,CharName_F2);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F1";
							end
							if GetCreHp(uid_F2) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F1,15017,0,2,-315,-1476);
								SendMedia("Player"..ColorMedia(CharName_F1,"b800e6").."won the round.",6);
								table.insert(SLEV_Fgt2_Lst,CharName_F1);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F1";
							end
						else
							SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won the match.",6);
							table.insert(SLEV_Fgt2_Lst,CharName_F1);
							CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
							CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
							SLEV_Flag[5] = 1;
							SLEV_Key = "Select_F1";
							if GetUserObjId(CharName_F1) ~= 0 then
								CreSetPositionById(GetUserObjId(CharName_F1), -315,-1476, 1);
							end
						end
					else
						SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." won the match.",6);
						table.insert(SLEV_Fgt2_Lst,CharName_F2);
						CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
						CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
						SLEV_Flag[5] = 1;
						SLEV_Key = "Select_F1";
						if GetUserObjId(CharName_F2) ~= 0 then
							CreSetPositionById(GetUserObjId(CharName_F2), -315,-1476, 1);
						end
					end
				
				else
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won and will move to the next round.",6);
					table.insert(SLEV_Fgt2_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
					SLEV_Flag[5] = 1;
					SLEV_Key = "Select_F1";
					if GetUserObjId(CharName_F1) ~= 0 then
						CreSetPositionById(GetUserObjId(CharName_F1), -315, -1476, 1);
					end
				end
			elseif fTime > 188  and SLEV_Flag[7] == 0 then
				RemoveEffect(GetUserObjId(CharName_F1), 15018);
				RemoveEffect(GetUserObjId(CharName_F2), 15018);
				if GetCreHp(GetUserObjId(CharName_F1)) < GetCreHp(GetUserObjId(CharName_F2)) then
					AddEffectEx(GetUserObjId(CharName_F2),15017,0,2,-315,-1476);
					SendMedia("Player"..ColorMedia(CharName_F2,"b800e6").." has higher hp. He won the match",6);
					table.insert(SLEV_Fgt2_Lst,CharName_F2);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				else
					AddEffectEx(GetUserObjId(CharName_F1),15017,0,2,-315,-1476);
					SendMedia("Player"..ColorMedia(CharName_F1,"b800e6").."has higher hp. He won the match",6);
					table.insert(SLEV_Fgt2_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				end
				SLEV_Flag[7] = 1;
				SLEV_Key = "Select_F1";
			end
		end
		--  Round Select_F1 ---
		
		--  Round Select_F2 ---
		if SLEV_Key == "Select_F2" then
			idx = idx + 1 ;
			CharName_F1 = "Ready??";
			CharName_F2 = "Ready??";
			SLEV_Flag = {0,0,0,0,0,0,0};
			if SLEV_Mon1 and SLEV_Mon2 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
			end
			if SLEV_Fgt2_Lst[idx] then
				CharName_F1 = SLEV_Fgt2_Lst[idx];
				idx = idx + 1 ;
				if SLEV_Fgt2_Lst[idx] then
					CharName_F2 = SLEV_Fgt2_Lst[idx];
				end
				SLEV_Key = "Fight_F2";
			elseif tablecount(SLEV_Fgt3_Lst) == 1 and SLEV_CountRegister > 2 and SLEV_CountRegister <= 4 then
				idx = 0;
				SLEV_FgtFN_Lst = SLEV_Fgt3_Lst;
				SLEV_Key = "END";
			else
				idx = 0;
				SLEV_Fgt3_Lst = RanTable(SLEV_Fgt3_Lst);
				SLEV_Key = "Select_F3";
			end
			SLEV_Time = dwNow;
		elseif SLEV_Key == "Fight_F2" then
			local fTime = dwNow - SLEV_Time;
			if fTime == 2 and SLEV_Flag[1] == 0 then
				SendMedia("Player : "..ColorMedia(CharName_F1,"b800e6").." VS "..ColorMedia(CharName_F2,"b800e6").." ",6);
				if GetUserObjId(CharName_F1) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F1), -300, -1476, 1);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F2), -330, -1476, 1);
				end
				SLEV_Flag[1] = 1;
			elseif fTime == 5 and SLEV_Flag[2] == 0 then
				SLEV_Mon1 = CreateNpc(self.ObjID, 10005, -300, -1476, 1);
				SLEV_Mon2 = CreateNpc(self.ObjID, 10006, -330, -1476, 1);
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Your turn in 3",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Your turn in 3",7);
				end
				AddToHateList(SLEV_Mon1, GetUserObjId(CharName_F1), 8999999);
				AddToHateList(SLEV_Mon2, GetUserObjId(CharName_F2), 8999999);
				SLEV_Flag[2] = 1;
			elseif fTime == 6 and SLEV_Flag[3] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Your turn in 2",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Your turn in 2",7);
				end
				SLEV_Flag[3] = 1;
			elseif fTime == 7 and SLEV_Flag[4] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Your turn in 1",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Your turn in 1",7);
				end
				SLEV_Flag[4] = 1;
			elseif fTime <= 187  and fTime > 7 and SLEV_Flag[5] == 0 then
				if CharName_F2 ~= 0 then
					local uid_F1 = GetUserObjId(CharName_F1);
					local uid_F2 = GetUserObjId(CharName_F2);
					if uid_F1 ~= 0 then
						if uid_F2 ~= 0 then
							if SLEV_Flag[6] == 0 then
								RemoveEffect(uid_F1, 15017);
								RemoveEffect(uid_F2, 15017);
								SLEV_Flag[6] = 1;
							end
							if GetCreHp(uid_F1) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F2,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." won the round ",6);
								table.insert(SLEV_Fgt3_Lst,CharName_F2);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F2";
							end
							if GetCreHp(uid_F2) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F1,15017,0,2,-315,-1476);
								SendMedia("Player"..ColorMedia(CharName_F1,"b800e6").." won the round ",6);
								table.insert(SLEV_Fgt3_Lst,CharName_F1);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F2";
							end
						else
							SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won .",6);
							table.insert(SLEV_Fgt3_Lst,CharName_F1);
							CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
							CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
							SLEV_Flag[5] = 1;
							SLEV_Key = "Select_F2";
							if GetUserObjId(CharName_F1) ~= 0 then
								CreSetPositionById(GetUserObjId(CharName_F1), -315,-1476, 1);
							end
						end
					else
						SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").."won .",6);
						table.insert(SLEV_Fgt3_Lst,CharName_F2);
						CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
						CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
						SLEV_Flag[5] = 1;
						SLEV_Key = "Select_F2";
						if GetUserObjId(CharName_F2) ~= 0 then
							CreSetPositionById(GetUserObjId(CharName_F2), -315,-1476, 1);
						end
					end
				
				else
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."will move to the next round.",6);
					table.insert(SLEV_Fgt3_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
					SLEV_Flag[5] = 1;
					SLEV_Key = "Select_F2";
					if GetUserObjId(CharName_F1) ~= 0 then
						CreSetPositionById(GetUserObjId(CharName_F1), -315, -1476, 1);
					end
				end
			elseif fTime > 188  and SLEV_Flag[7] == 0 then
				RemoveEffect(GetUserObjId(CharName_F1), 15018);
				RemoveEffect(GetUserObjId(CharName_F2), 15018);
				if GetCreHp(GetUserObjId(CharName_F1)) < GetCreHp(GetUserObjId(CharName_F2)) then
					AddEffectEx(GetUserObjId(CharName_F2),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt3_Lst,CharName_F2);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				else
					AddEffectEx(GetUserObjId(CharName_F1),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt3_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				end
				SLEV_Flag[7] = 1;
				SLEV_Key = "Select_F2";
			end
		end
		--  Round Select_F2 ---
		
		--  Round Select_F3 ---
		if SLEV_Key == "Select_F3" then
			idx = idx + 1 ;
			CharName_F1 = "Ready??";
			CharName_F2 = "Ready??";
			SLEV_Flag = {0,0,0,0,0,0,0};
			if SLEV_Mon1 and SLEV_Mon2 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
			end
			if SLEV_Fgt3_Lst[idx] then
				CharName_F1 = SLEV_Fgt3_Lst[idx];
				idx = idx + 1 ;
				if SLEV_Fgt3_Lst[idx] then
					CharName_F2 = SLEV_Fgt3_Lst[idx];
				end
				SLEV_Key = "Fight_F3";
			elseif tablecount(SLEV_Fgt4_Lst) == 1 and SLEV_CountRegister > 4 and SLEV_CountRegister <= 8 then
				idx = 0;
				SLEV_FgtFN_Lst = SLEV_Fgt4_Lst;
				SLEV_Key = "END";
			else
				idx = 0;
				SLEV_Fgt4_Lst = RanTable(SLEV_Fgt4_Lst);
				SLEV_Key = "Select_F4";
			end
			SLEV_Time = dwNow;
		elseif SLEV_Key == "Fight_F3" then
			local fTime = dwNow - SLEV_Time;
			if fTime == 2 and SLEV_Flag[1] == 0 then
				SendMedia("Match : "..ColorMedia(CharName_F1,"b800e6").." VS "..ColorMedia(CharName_F2,"b800e6").." ",6);
				if GetUserObjId(CharName_F1) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F1), -300, -1476, 1);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F2), -330, -1476, 1);
				end
				SLEV_Flag[1] = 1;
			elseif fTime == 5 and SLEV_Flag[2] == 0 then
				SLEV_Mon1 = CreateNpc(self.ObjID, 10005, -300, -1476, 1);
				SLEV_Mon2 = CreateNpc(self.ObjID, 10006, -330, -1476, 1);
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 3",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 3",7);
				end
				AddToHateList(SLEV_Mon1, GetUserObjId(CharName_F1), 8999999);
				AddToHateList(SLEV_Mon2, GetUserObjId(CharName_F2), 8999999);
				SLEV_Flag[2] = 1;
			elseif fTime == 6 and SLEV_Flag[3] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 2",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 2",7);
				end
				SLEV_Flag[3] = 1;
			elseif fTime == 7 and SLEV_Flag[4] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 1",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 1",7);
				end
				SLEV_Flag[4] = 1;
			elseif fTime <= 187  and fTime > 7 and SLEV_Flag[5] == 0 then
				if CharName_F2 ~= 0 then
					local uid_F1 = GetUserObjId(CharName_F1);
					local uid_F2 = GetUserObjId(CharName_F2);
					if uid_F1 ~= 0 then
						if uid_F2 ~= 0 then
							if SLEV_Flag[6] == 0 then
								RemoveEffect(uid_F1, 15017);
								RemoveEffect(uid_F2, 15017);
								SLEV_Flag[6] = 1;
							end
							if GetCreHp(uid_F1) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F2,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." won ",6);
								table.insert(SLEV_Fgt4_Lst,CharName_F2);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F3";
							end
							if GetCreHp(uid_F2) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F1,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." won ",6);
								table.insert(SLEV_Fgt4_Lst,CharName_F1);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F3";
							end
						else
							SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won .",6);
							table.insert(SLEV_Fgt4_Lst,CharName_F1);
							CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
							CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
							SLEV_Flag[5] = 1;
							SLEV_Key = "Select_F3";
							if GetUserObjId(CharName_F1) ~= 0 then
								CreSetPositionById(GetUserObjId(CharName_F1), -315,-1476, 1);
							end
						end
					else
						SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").."won .",6);
						table.insert(SLEV_Fgt4_Lst,CharName_F2);
						CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
						CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
						SLEV_Flag[5] = 1;
						SLEV_Key = "Select_F3";
						if GetUserObjId(CharName_F2) ~= 0 then
							CreSetPositionById(GetUserObjId(CharName_F2), -315,-1476, 1);
						end
					end
				
				else
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."will move to the next round.",6);
					table.insert(SLEV_Fgt4_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
					SLEV_Flag[5] = 1;
					SLEV_Key = "Select_F3";
					if GetUserObjId(CharName_F1) ~= 0 then
						CreSetPositionById(GetUserObjId(CharName_F1), -315, -1476, 1);
					end
				end
			elseif fTime > 188  and SLEV_Flag[7] == 0 then
				RemoveEffect(GetUserObjId(CharName_F1), 15018);
				RemoveEffect(GetUserObjId(CharName_F2), 15018);
				if GetCreHp(GetUserObjId(CharName_F1)) < GetCreHp(GetUserObjId(CharName_F2)) then
					AddEffectEx(GetUserObjId(CharName_F2),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt4_Lst,CharName_F2);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				else
					AddEffectEx(GetUserObjId(CharName_F1),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt4_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				end
				SLEV_Flag[7] = 1;
				SLEV_Key = "Select_F3";
			end
		end
		--  Round Select_F3 ---
		
		--  Round Select_F4 ---
		if SLEV_Key == "Select_F4" then
			idx = idx + 1 ;
			CharName_F1 = "Ready??";
			CharName_F2 = "Ready??";
			SLEV_Flag = {0,0,0,0,0,0,0};
			if SLEV_Mon1 and SLEV_Mon2 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
			end
			if SLEV_Fgt4_Lst[idx] then
				CharName_F1 = SLEV_Fgt4_Lst[idx];
				idx = idx + 1 ;
				if SLEV_Fgt4_Lst[idx] then
					CharName_F2 = SLEV_Fgt4_Lst[idx];
				end
				SLEV_Key = "Fight_F4";
			elseif tablecount(SLEV_Fgt5_Lst) == 1 and SLEV_CountRegister > 8 and SLEV_CountRegister <= 15 then
				idx = 0;
				SLEV_FgtFN_Lst = SLEV_Fgt5_Lst;
				SLEV_Key = "END";
			else
				idx = 0;
				SLEV_Fgt5_Lst = RanTable(SLEV_Fgt5_Lst);
				SLEV_Key = "Select_F5";
			end
			SLEV_Time = dwNow;
		elseif SLEV_Key == "Fight_F4" then
			local fTime = dwNow - SLEV_Time;
			if fTime == 2 and SLEV_Flag[1] == 0 then
				SendMedia("Match : "..ColorMedia(CharName_F1,"b800e6").." VS "..ColorMedia(CharName_F2,"b800e6").." ",6);
				if GetUserObjId(CharName_F1) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F1), -300, -1476, 1);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F2), -330, -1476, 1);
				end
				SLEV_Flag[1] = 1;
			elseif fTime == 5 and SLEV_Flag[2] == 0 then
				SLEV_Mon1 = CreateNpc(self.ObjID, 10005, -300, -1476, 1);
				SLEV_Mon2 = CreateNpc(self.ObjID, 10006, -330, -1476, 1);
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 3",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 3",7);
				end
				AddToHateList(SLEV_Mon1, GetUserObjId(CharName_F1), 8999999);
				AddToHateList(SLEV_Mon2, GetUserObjId(CharName_F2), 8999999);
				SLEV_Flag[2] = 1;
			elseif fTime == 6 and SLEV_Flag[3] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 2",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 2",7);
				end
				SLEV_Flag[3] = 1;
			elseif fTime == 7 and SLEV_Flag[4] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 1",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 1",7);
				end
				SLEV_Flag[4] = 1;
			elseif fTime <= 187  and fTime > 7 and SLEV_Flag[5] == 0 then
				if CharName_F2 ~= 0 then
					local uid_F1 = GetUserObjId(CharName_F1);
					local uid_F2 = GetUserObjId(CharName_F2);
					if uid_F1 ~= 0 then
						if uid_F2 ~= 0 then
							if SLEV_Flag[6] == 0 then
								RemoveEffect(uid_F1, 15017);
								RemoveEffect(uid_F2, 15017);
								SLEV_Flag[6] = 1;
							end
							if GetCreHp(uid_F1) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F2,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." won ",6);
								table.insert(SLEV_Fgt5_Lst,CharName_F2);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F4";
							end
							if GetCreHp(uid_F2) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F1,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." won ",6);
								table.insert(SLEV_Fgt5_Lst,CharName_F1);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F4";
							end
						else
							SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won .",6);
							table.insert(SLEV_Fgt5_Lst,CharName_F1);
							CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
							CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
							SLEV_Flag[5] = 1;
							SLEV_Key = "Select_F4";
							if GetUserObjId(CharName_F1) ~= 0 then
								CreSetPositionById(GetUserObjId(CharName_F1), -315,-1476, 1);
							end
						end
					else
						SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").."won .",6);
						table.insert(SLEV_Fgt5_Lst,CharName_F2);
						CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
						CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
						SLEV_Flag[5] = 1;
						SLEV_Key = "Select_F4";
						if GetUserObjId(CharName_F2) ~= 0 then
							CreSetPositionById(GetUserObjId(CharName_F2), -315,-1476, 1);
						end
					end
				
				else
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."will move to the next round.",6);
					table.insert(SLEV_Fgt5_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
					SLEV_Flag[5] = 1;
					SLEV_Key = "Select_F4";
					if GetUserObjId(CharName_F1) ~= 0 then
						CreSetPositionById(GetUserObjId(CharName_F1), -315, -1476, 1);
					end
				end
			elseif fTime > 188  and SLEV_Flag[7] == 0 then
				RemoveEffect(GetUserObjId(CharName_F1), 15018);
				RemoveEffect(GetUserObjId(CharName_F2), 15018);
				if GetCreHp(GetUserObjId(CharName_F1)) < GetCreHp(GetUserObjId(CharName_F2)) then
					AddEffectEx(GetUserObjId(CharName_F2),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt5_Lst,CharName_F2);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				else
					AddEffectEx(GetUserObjId(CharName_F1),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt5_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				end
				SLEV_Flag[7] = 1;
				SLEV_Key = "Select_F4";
			end
		end
		--  Round Select_F4 ---
		
		--  Round Select_F5 ---
		if SLEV_Key == "Select_F5" then
			idx = idx + 1 ;
			CharName_F1 = "Ready??";
			CharName_F2 = "Ready??";
			SLEV_Flag = {0,0,0,0,0,0,0};
			if SLEV_Mon1 and SLEV_Mon2 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
			end
			if SLEV_Fgt5_Lst[idx] then
				CharName_F1 = SLEV_Fgt5_Lst[idx];
				idx = idx + 1 ;
				if SLEV_Fgt5_Lst[idx] then
					CharName_F2 = SLEV_Fgt5_Lst[idx];
				end
				SLEV_Key = "Fight_F5";
			elseif tablecount(SLEV_Fgt6_Lst) == 1 and SLEV_CountRegister > 16 and SLEV_CountRegister <= 32 then
				idx = 0;
				SLEV_FgtFN_Lst = SLEV_Fgt6_Lst;
				SLEV_Key = "END";
			else
				idx = 0;
				SLEV_Fgt6_Lst = RanTable(SLEV_Fgt6_Lst);
				SLEV_Key = "Select_F6";
			end
			SLEV_Time = dwNow;
		elseif SLEV_Key == "Fight_F5" then
			local fTime = dwNow - SLEV_Time;
			if fTime == 2 and SLEV_Flag[1] == 0 then
				SendMedia("Match : "..ColorMedia(CharName_F1,"b800e6").." VS "..ColorMedia(CharName_F2,"b800e6").." ",6);
				if GetUserObjId(CharName_F1) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F1), -300, -1476, 1);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F2), -330, -1476, 1);
				end
				SLEV_Flag[1] = 1;
			elseif fTime == 5 and SLEV_Flag[2] == 0 then
				SLEV_Mon1 = CreateNpc(self.ObjID, 10005, -300, -1476, 1);
				SLEV_Mon2 = CreateNpc(self.ObjID, 10006, -330, -1476, 1);
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 3",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 3",7);
				end
				AddToHateList(SLEV_Mon1, GetUserObjId(CharName_F1), 8999999);
				AddToHateList(SLEV_Mon2, GetUserObjId(CharName_F2), 8999999);
				SLEV_Flag[2] = 1;
			elseif fTime == 6 and SLEV_Flag[3] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 2",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 2",7);
				end
				SLEV_Flag[3] = 1;
			elseif fTime == 7 and SLEV_Flag[4] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 1",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 1",7);
				end
				SLEV_Flag[4] = 1;
			elseif fTime <= 187  and fTime > 7 and SLEV_Flag[5] == 0 then
				if CharName_F2 ~= 0 then
					local uid_F1 = GetUserObjId(CharName_F1);
					local uid_F2 = GetUserObjId(CharName_F2);
					if uid_F1 ~= 0 then
						if uid_F2 ~= 0 then
							if SLEV_Flag[6] == 0 then
								RemoveEffect(uid_F1, 15017);
								RemoveEffect(uid_F2, 15017);
								SLEV_Flag[6] = 1;
							end
							if GetCreHp(uid_F1) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F2,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." won ",6);
								table.insert(SLEV_Fgt6_Lst,CharName_F2);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F5";
							end
							if GetCreHp(uid_F2) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F1,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." won ",6);
								table.insert(SLEV_Fgt6_Lst,CharName_F1);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F5";
							end
						else
							SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won .",6);
							table.insert(SLEV_Fgt6_Lst,CharName_F1);
							CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
							CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
							SLEV_Flag[5] = 1;
							SLEV_Key = "Select_F5";
							if GetUserObjId(CharName_F1) ~= 0 then
								CreSetPositionById(GetUserObjId(CharName_F1), -315,-1476, 1);
							end
						end
					else
						SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").."won .",6);
						table.insert(SLEV_Fgt6_Lst,CharName_F2);
						CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
						CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
						SLEV_Flag[5] = 1;
						SLEV_Key = "Select_F5";
						if GetUserObjId(CharName_F2) ~= 0 then
							CreSetPositionById(GetUserObjId(CharName_F2), -315,-1476, 1);
						end
					end
				
				else
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."will move to the next round.",6);
					table.insert(SLEV_Fgt6_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
					SLEV_Flag[5] = 1;
					SLEV_Key = "Select_F5";
					if GetUserObjId(CharName_F1) ~= 0 then
						CreSetPositionById(GetUserObjId(CharName_F1), -315, -1476, 1);
					end
				end
			elseif fTime > 188  and SLEV_Flag[7] == 0 then
				RemoveEffect(GetUserObjId(CharName_F1), 15018);
				RemoveEffect(GetUserObjId(CharName_F2), 15018);
				if GetCreHp(GetUserObjId(CharName_F1)) < GetCreHp(GetUserObjId(CharName_F2)) then
					AddEffectEx(GetUserObjId(CharName_F2),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt6_Lst,CharName_F2);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				else
					AddEffectEx(GetUserObjId(CharName_F1),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt6_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				end
				SLEV_Flag[7] = 1;
				SLEV_Key = "Select_F5";
			end
		end
		--  Round Select_F5 ---
		
		--  Round Select_F6 ---
		if SLEV_Key == "Select_F6" then
			idx = idx + 1 ;
			CharName_F1 = "Ready??";
			CharName_F2 = "Ready??";
			SLEV_Flag = {0,0,0,0,0,0,0};
			if SLEV_Mon1 and SLEV_Mon2 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
			end
			if SLEV_Fgt6_Lst[idx] then
				CharName_F1 = SLEV_Fgt6_Lst[idx];
				idx = idx + 1 ;
				if SLEV_Fgt6_Lst[idx] then
					CharName_F2 = SLEV_Fgt6_Lst[idx];
				end
				SLEV_Key = "Fight_F6";
			elseif tablecount(SLEV_Fgt7_Lst) == 1 and SLEV_CountRegister > 32 and SLEV_CountRegister <= 64 then
				idx = 0;
				SLEV_FgtFN_Lst = SLEV_Fgt7_Lst;
				SLEV_Key = "END";
			else
				idx = 0;
				SLEV_Fgt7_Lst = RanTable(SLEV_Fgt7_Lst);
				SLEV_Key = "Select_F7";
			end
			SLEV_Time = dwNow;
		elseif SLEV_Key == "Fight_F6" then
			local fTime = dwNow - SLEV_Time;
			if fTime == 2 and SLEV_Flag[1] == 0 then
				SendMedia("Match : "..ColorMedia(CharName_F1,"b800e6").." VS "..ColorMedia(CharName_F2,"b800e6").." ",6);
				if GetUserObjId(CharName_F1) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F1), -300, -1476, 1);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					CreSetPositionById(GetUserObjId(CharName_F2), -330, -1476, 1);
				end
				SLEV_Flag[1] = 1;
			elseif fTime == 5 and SLEV_Flag[2] == 0 then
				SLEV_Mon1 = CreateNpc(self.ObjID, 10005, -300, -1476, 1);
				SLEV_Mon2 = CreateNpc(self.ObjID, 10006, -330, -1476, 1);
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 3",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 3",7);
				end
				AddToHateList(SLEV_Mon1, GetUserObjId(CharName_F1), 8999999);
				AddToHateList(SLEV_Mon2, GetUserObjId(CharName_F2), 8999999);
				SLEV_Flag[2] = 1;
			elseif fTime == 6 and SLEV_Flag[3] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 2",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 2",7);
				end
				SLEV_Flag[3] = 1;
			elseif fTime == 7 and SLEV_Flag[4] == 0 then
				if GetUserObjId(CharName_F1) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F1), "Ready in 1",7);
				end
				if GetUserObjId(CharName_F2) ~= 0 then
					ReceiveMsg(GetUserObjId(CharName_F2), "Ready in 1",7);
				end
				SLEV_Flag[4] = 1;
			elseif fTime <= 187  and fTime > 7 and SLEV_Flag[5] == 0 then
				if CharName_F2 ~= 0 then
					local uid_F1 = GetUserObjId(CharName_F1);
					local uid_F2 = GetUserObjId(CharName_F2);
					if uid_F1 ~= 0 then
						if uid_F2 ~= 0 then
							if SLEV_Flag[6] == 0 then
								RemoveEffect(uid_F1, 15017);
								RemoveEffect(uid_F2, 15017);
								SLEV_Flag[6] = 1;
							end
							if GetCreHp(uid_F1) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F2,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." won ",6);
								table.insert(SLEV_Fgt7_Lst,CharName_F2);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F6";
							end
							if GetCreHp(uid_F2) < 1 then
								RemoveEffect(uid_F1, 15018); RemoveEffect(uid_F2, 15018);
								AddEffectEx(uid_F1,15017,0,2,-315,-1476);
								SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." won ",6);
								table.insert(SLEV_Fgt7_Lst,CharName_F1);
								CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
								CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
								SLEV_Flag[5] = 1;
								SLEV_Key = "Select_F6";
							end
						else
							SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."won .",6);
							table.insert(SLEV_Fgt7_Lst,CharName_F1);
							CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
							CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
							SLEV_Flag[5] = 1;
							SLEV_Key = "Select_F6";
							if GetUserObjId(CharName_F1) ~= 0 then
								CreSetPositionById(GetUserObjId(CharName_F1), -315,-1476, 1);
							end
						end
					else
						SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").."won .",6);
						table.insert(SLEV_Fgt7_Lst,CharName_F2);
						CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
						CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
						SLEV_Flag[5] = 1;
						SLEV_Key = "Select_F6";
						if GetUserObjId(CharName_F2) ~= 0 then
							CreSetPositionById(GetUserObjId(CharName_F2), -315,-1476, 1);
						end
					end
				
				else
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").."will move to the next round.",6);
					table.insert(SLEV_Fgt7_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
					SLEV_Flag[5] = 1;
					SLEV_Key = "Select_F6";
					if GetUserObjId(CharName_F1) ~= 0 then
						CreSetPositionById(GetUserObjId(CharName_F1), -315, -1476, 1);
					end
				end
			elseif fTime > 188  and SLEV_Flag[7] == 0 then
				Disappear(SLEV_Mon1);
				Disappear(SLEV_Mon2);
				RemoveEffect(GetUserObjId(CharName_F1), 15018);
				RemoveEffect(GetUserObjId(CharName_F2), 15018);
				if GetCreHp(GetUserObjId(CharName_F1)) < GetCreHp(GetUserObjId(CharName_F2)) then
					AddEffectEx(GetUserObjId(CharName_F2),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F2,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt7_Lst,CharName_F2);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				else
					AddEffectEx(GetUserObjId(CharName_F1),15017,0,2,-315,-1476);
					SendMedia("Player "..ColorMedia(CharName_F1,"b800e6").." had higher HP, so he won the battle",6);
					table.insert(SLEV_Fgt7_Lst,CharName_F1);
					CreateCodeItemAddMailByName(CharName_F1, 11112,SLEV_WMail[1], SLEV_WMail[2], SLEV_WMail[3]);
					CreateCodeItemAddMailByName(CharName_F2, 11112,SLEV_LMail[1], SLEV_LMail[2], SLEV_LMail[3]);
				end
				SLEV_Flag[7] = 1;
				SLEV_Key = "Select_F6";
			end
		end
		--  Round Select_F6 ---
		
		
		
		if SLEV_Key == "END" then
			PutContent(SLEV_Path.."Winner.ini",SLEV_FgtFN_Lst[1]);
			RemoveEffect(GetUserObjId(SLEV_FgtFN_Lst[1]), 15017);
			RemoveEffect(GetUserObjId(SLEV_FgtFN_Lst[1]), 15018);
			SendMedia("Player "..ColorMedia(SLEV_FgtFN_Lst[1],"b800e6").." won the match today.",6);
			CreateCodeItemAddMailByName(SLEV_FgtFN_Lst[1], 11112,SLEV_AllMail[1], SLEV_AllMail[2], SLEV_AllMail[3]);
			SLEV_Time = 0;
			SLEV_Key = "";
			SLEV_tblRegiter = {};
			SLEV_CountRegister = 0;
			SLEV_Mail_Win = {};
			SLEV_Mail_Lose = {};
			SLEV_Fgt1_Lst = {};
			SLEV_Fgt2_Lst = {};
			SLEV_Fgt3_Lst = {};
			SLEV_Fgt4_Lst = {};
			SLEV_Fgt5_Lst = {};
			SLEV_Fgt6_Lst = {};
			SLEV_Fgt7_Lst = {};
			SLEV_FgtFN_Lst = {};
			SLEV_Flag = {0,0,0,0,0,0,0};
			SetTriggerUpdateEvent(self.ObjID, 0);
		end
		if SLEV_Key == "Empty-END" then
			SendMedia(ColorMedia("King of Fighters Ended","b800e6").." not enough players to start the event",6);
			SLEV_Time = 0;
			SLEV_Key = "";
			SLEV_tblRegiter = {};
			SLEV_CountRegister = 0;
			SLEV_Mail_Win = {};
			SLEV_Mail_Lose = {};
			SLEV_Fgt1_Lst = {};
			SLEV_Fgt2_Lst = {};
			SLEV_Fgt3_Lst = {};
			SLEV_Fgt4_Lst = {};
			SLEV_Fgt5_Lst = {};
			SLEV_Fgt6_Lst = {};
			SLEV_Fgt7_Lst = {};
			SLEV_FgtFN_Lst = {};
			SLEV_Flag = {0,0,0,0,0,0,0};
			SetTriggerUpdateEvent(self.ObjID, 0);
		end
	end
end
function CAI_10003:OnInteractive(uid, event)
	if event == "defaulttalk" then
		return Talk_SoloEv();
	elseif event == "Register" then
		if SLEV_Key == "Register" then
			if GetUserLevel(uid) >= 90 then
				if GetCreHp(uid) >= 70000 then
						if tablecount(SLEV_tblRegiter) <= SLEV_MaxRegiter then
							if HaveChar(SLEV_tblRegiter, GetUserNameByObjId(uid)) then
								table.insert(SLEV_tblRegiter,GetUserNameByObjId(uid));
								return XmlText("Succesfully registered, be ready.","ss");
							else
								
								return XmlText("You are already registered.","er");
							end
						else
							return XmlText("Player count is already at max.","er");
						end
				else
				return XmlText("Minimum required HP is 70,000","er");
				end
			else
				return XmlText("Minimum required level is 90","er");
			end
		end
	end
end

function Talk_SoloEv()
	local content = "";
	content = content..XmlText("Event will start at : 20:00 PM");
	content = content..XmlText("Rewards: KoF Points, King of Fighters Buff");
	content = content..XmlText("Minimum player register level is 90 and Minimum player HP is 70,000");
	local lc_winner = "";
	if GetContent(SLEV_Path.."Winner.ini") ~= "" then
		lc_winner = GetContent(SLEV_Path.."Winner.ini");
	end
	content = content..XmlTextSize("Previous Winner: "..lc_winner,"er",15);
	lc_listreg = "";
	if tablecount(SLEV_tblRegiter) >= 1 then
		for k,v in pairs(SLEV_tblRegiter) do 
			lc_listreg = lc_listreg.." "..v;
		end
	end
	
	if SLEV_Key == "Register" then
		content = content..XmlTextSize("Players: "..tablecount(SLEV_tblRegiter).."/"..SLEV_MaxRegiter.." MAX","er",15);
		content = content..XmlTextSize("Players Registered :  "..lc_listreg,"ss",15);
		content = content..XmlLink("Register to KoF","Register","18");
	end
	return content;
end
function tablecount(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function RanTable(tbl) -- suffles numeric indices
	local len, random = tablecount(tbl), math.random ;
	for i = len, 2, -1 do
		local j = random( 1, i );
		tbl[i], tbl[j] = tbl[j], tbl[i];
	end
	return tbl;
end

function CheckTimeFull(tbl)
	local DayOfWeek = GetServerDayOfWeek();
	local Hour = GetServerHour();
	local tmp = false;
	local tmp2 = false;
	for i =1,table.getn(tbl.Week) do
		if tonumber(tbl.Week[i]) == DayOfWeek then
			tmp = true;
		end
	end
	for i =1,table.getn(tbl.Hour) do
		if tonumber(tbl.Hour[i]) == Hour then
			tmp2 = true;
		end
	end
	if tmp and tmp2 then
		return true
	else
		return false
	end
end

function ColorMedia(ct,cl)
	return "#c"..cl..""..ct.."#n";
end


function XmlText(msg,cl)
	if cl then
		if cl == "er" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ffff4da6\"/></Items></Line>";
		elseif cl == "ss" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ff00ff80\"/></Items></Line>";
		else
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ff"..cl.."\"/></Items></Line>";
		end
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ffa6a845\"/></Items></Line>";
	end
end
function XmlTextSize(msg,cl,size)
	if cl then
		if cl == "er" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ffff4da6\"/></Items></Line>";
		elseif cl == "ss" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ff00ff80\"/></Items></Line>";
		else
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ff"..cl.."\"/></Items></Line>";
		end
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ffa6a845\"/></Items></Line>";
	end
end
function XmlLink(msg,event,size)
	if size then
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line><Line/>";
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\"16\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line><Line/>";
	end
end
function GetContent(pathfilename)
    local readfile = io.open(pathfilename,"r+");
    local data = readfile:read("*all");
    readfile:close()
    return data
end


function HaveChar(tbl, val)
	for i, v in ipairs(tbl) do
		if v == val then
			return false
		end
	end
	return true
end