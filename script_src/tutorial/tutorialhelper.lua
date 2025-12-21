if IS_SERVER then
	-- 서버는 필요없다.
else

TUTORIAL_MISSION_JUMP_HURDLE			= 1
TUTORIAL_MISSION_USE_SPUR				= 2
TUTORIAL_MISSION_DO_GOALIN				= 3
TUTORIAL_MISSION_GET_SPUR_ITEM			= 4
TUTORIAL_MISSION_DO_JUMP_2ND			= 5
TUTORIAL_MISSION_DO_GLIDING				= 6
TUTORIAL_MISSION_DO_SLIDING_DASH		= 7
TUTORIAL_MISSION_GOALIN_BEFORE_GHOST	= 8
TUTORIAL_MISSION_GET_MAGICITEM			= 9
TUTORIAL_MISSION_USE_MAGICITEM          = 10
TUTORIAL_MISSION_ATTACK_MAGICITEM       = 11
TUTORIAL_MISSION_RELAY_MAGICITEM        = 12
TUTORIAL_MISSION_SHILD_MAGICITEM        = 13
TUTORIAL_MISSION_CHASING                = 14
TUTORIAL_MISSION_SLIDING2               = 15
TUTORIAL_MISSION_SLIDING3               = 16
TUTORIAL_MISSION_COURBETTE              = 17
TUTORIAL_MISSION_DO_SPURLEVEL           = 18



TUTORIAL_MISSION_TITLE = "TutorialMissionTitle"

PLAYING				= 1
FAIL_TIME			= 2
FAIL_FALL			= 3


function PrepareGameTipWindow()
    util:ShowTutorialUI()
end

function CloseGameTipWindow()
    util:CloseTutorialUI()
end

function SubMissionSuccess(type)
    util:Incident(TutorialSubMissionSuccess)
    util:CheckTutorialMission(type, true)
end


function CourBetteSuccessEventCheck(maxCourbette)
    local e =
    {
        OnInit = function(self, game)
            game.Courbette = 0
            self.done = false

            self.fontImage = "race_font[50_68]_l"
            self.fontColor = 0xFFFDCD02
        end,
         
        OnStart = function(self, game)
            util:AddTutorialMission(TUTORIAL_MISSION_COURBETTE, util:GetMissionString("Tutorial_CourBette"))

            if self.counterUI==nil then
                util:RFCreateWnd(TUTORIAL_MISSION_TITLE, "tutorial_missiontitle_window.xml")
                util:RFSetPicture(TUTORIAL_MISSION_TITLE, "img_missiontitle", "tuto_txt_courbette.png")

                self.counterUI = util:CreateIncidentImageText(TutorialCounter, "count_r", tostring(maxCourbette), self.fontImage, self.fontColor)				
            else
                util:SetIncidentImageText(self.counterUI, "count_r", tostring(maxCourbette), self.fontImage, self.fontColor)
            end

            util:SetIncidentImageText(self.counterUI, "count_slash", "/", self.fontImage, self.fontColor)

            self:UpdateCourbetteer(game)
        end,

        OnEvent = function(self, game, strValue, intValue1, intValue2)
            if strValue=="COURBETTE_SUCC" then
                print('chasing succ\n')
                local prevComplete = self:IsComplete(game)

                game.Courbette = game.Courbette + 1
                game.Courbette = game.Courbette < maxCourbette and game.Courbette or maxCourbette

                self:UpdateCourbetteer(game)

                util:SetTutorialMissionText(TUTORIAL_MISSION_COURBETTE, self:GetCourBetteString(game))

                if  not prevComplete and self:IsComplete(game) then
                    SubMissionSuccess(TUTORIAL_MISSION_COURBETTE)
                end
            end
        end,         

        GetCourBetteString = function(self, game)
            return util:GetMissionString("Tutorial_DoCourBette", '$1['..maxCourbette..'] $2['..game.Courbette..']')
        end,

        UpdateCourbetteer = function (self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_l", tostring(game.Courbette), self.fontImage, self.fontColor)
            end
        end,

        OnRetry = function(self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_r", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_slash", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_l", "", self.fontImage, self.fontColor)
            end
        end,

        IsComplete = function (self, game)         
            if game.Courbette >= maxCourbette then
                return true
            end
            return false
        end,

        OnRelease = function(self, game)
            util:RFClose(TUTORIAL_MISSION_TITLE)
        end,
    }
    
    return e;
end



function Sliding3SuccessEventCheck(maxSliding3Count)
    local e =
    {
        OnInit = function(self, game)
            game.Sliding3Count = 0
            self.done = false

            self.fontImage = "race_font[50_68]_l"
            self.fontColor = 0xFFFDCD02
        end,
         
        OnStart = function(self, game)
            util:AddTutorialMission(TUTORIAL_MISSION_SLIDING3, self:GetSliding3String(game))

            if self.counterUI==nil then
                util:RFCreateWnd(TUTORIAL_MISSION_TITLE, "tutorial_missiontitle_window.xml")
                util:RFSetPicture(TUTORIAL_MISSION_TITLE, "img_missiontitle", "tuto_txt_sliding3.png")

                self.counterUI = util:CreateIncidentImageText(TutorialCounter, "count_r", tostring(maxSliding3Count), self.fontImage, self.fontColor)				
            else
                util:SetIncidentImageText(self.counterUI, "count_r", tostring(maxSliding3Count), self.fontImage, self.fontColor)
            end

            util:SetIncidentImageText(self.counterUI, "count_slash", "/", self.fontImage, self.fontColor)

            self:UpdateSliding3Counter(game)
        end,

        OnEvent = function(self, game, strValue, intValue1, intValue2)
            if strValue=="SLIDING3_SUCC" then
                print('chasing succ\n')
                local prevComplete = self:IsComplete(game)

                game.Sliding3Count = game.Sliding3Count + 1
                game.Sliding3Count = game.Sliding3Count < maxSliding3Count and game.Sliding3Count or maxSliding3Count

                self:UpdateSliding3Counter(game)

                util:SetTutorialMissionText(TUTORIAL_MISSION_SLIDING3, self:GetSliding3String(game))

                if  not prevComplete and self:IsComplete(game) then
                    SubMissionSuccess(TUTORIAL_MISSION_SLIDING3)
                end
            end
        end,         

        GetSliding3String = function(self, game)
            return util:GetMissionString("Tutorial_DoSliding3", '$1['..maxSliding3Count..'] $2['..game.Sliding3Count..']')
        end,

        UpdateSliding3Counter = function (self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_l", tostring(game.Sliding3Count), self.fontImage, self.fontColor)
            end
        end,

        OnRetry = function(self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_r", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_slash", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_l", "", self.fontImage, self.fontColor)
            end
        end,

        IsComplete = function (self, game)         
            if game.Sliding3Count >= maxSliding3Count then
                return true
            end
            return false
        end,
        OnRelease = function(self, game)
            util:RFClose(TUTORIAL_MISSION_TITLE)
        end,

    }
    
    return e;
end

function Sliding2SuccessEventCheck(maxSliding2Count)
    local e =
    {
        OnInit = function(self, game)
            game.Sliding2Count = 0
            self.done = false

            self.fontImage = "race_font[50_68]_l"
            self.fontColor = 0xFFFDCD02
        end,
         
        OnStart = function(self, game)
            util:AddTutorialMission(TUTORIAL_MISSION_SLIDING2, self:GetSliding2String(game))

            if self.counterUI==nil then
                util:RFCreateWnd(TUTORIAL_MISSION_TITLE, "tutorial_missiontitle_window.xml")
                util:RFSetPicture(TUTORIAL_MISSION_TITLE, "img_missiontitle", "tuto_txt_sliding2.png")

                self.counterUI = util:CreateIncidentImageText(TutorialCounter, "count_r", tostring(maxSliding2Count), self.fontImage, self.fontColor)				
            else
                util:SetIncidentImageText(self.counterUI, "count_r", tostring(maxSliding2Count), self.fontImage, self.fontColor)
            end

            util:SetIncidentImageText(self.counterUI, "count_slash", "/", self.fontImage, self.fontColor)

            self:UpdateSliding2Counter(game)
        end,

        OnEvent = function(self, game, strValue, intValue1, intValue2)
            if strValue=="SLIDING2_SUCC" then
                print('chasing succ\n')
                local prevComplete = self:IsComplete(game)

                game.Sliding2Count = game.Sliding2Count + 1
                game.Sliding2Count = game.Sliding2Count < maxSliding2Count and game.Sliding2Count or maxSliding2Count

                self:UpdateSliding2Counter(game)

                util:SetTutorialMissionText(TUTORIAL_MISSION_SLIDING2, self:GetSliding2String(game))

                if  not prevComplete and self:IsComplete(game) then
                    SubMissionSuccess(TUTORIAL_MISSION_SLIDING2)
                end
            end
        end,         

        GetSliding2String = function(self, game)
            return util:GetMissionString("Tutorial_DoSliding2", '$1['..maxSliding2Count..'] $2['..game.Sliding2Count..']')
        end,

        UpdateSliding2Counter = function (self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_l", tostring(game.Sliding2Count), self.fontImage, self.fontColor)
            end
        end,

        OnRetry = function(self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_r", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_slash", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_l", "", self.fontImage, self.fontColor)
            end
        end,

        IsComplete = function (self, game)         
            if game.Sliding2Count >= maxSliding2Count then
                return true
            end
            return false
        end,
        OnRelease = function(self, game)
            util:RFClose(TUTORIAL_MISSION_TITLE)
        end,
    }
    
    return e;
end


function ChasingSuccessEventCheck(maxChasingCount)
    local e =
    {
        OnInit = function(self, game)
            game.chasingCount = 0
            self.done = false

            self.fontImage = "race_font[50_68]_l"
            self.fontColor = 0xFFFDCD02
        end,
         
        OnStart = function(self, game)
            util:AddTutorialMission(TUTORIAL_MISSION_CHASING, self:GetChasingString(game))

            if self.counterUI==nil then
                util:RFCreateWnd(TUTORIAL_MISSION_TITLE, "tutorial_missiontitle_window.xml")
                util:RFSetPicture(TUTORIAL_MISSION_TITLE, "img_missiontitle", "tuto_txt_chasing.png")

                self.counterUI = util:CreateIncidentImageText(TutorialCounter, "count_r", tostring(maxChasingCount), self.fontImage, self.fontColor)				
            else
                util:SetIncidentImageText(self.counterUI, "count_r", tostring(maxChasingCount), self.fontImage, self.fontColor)
            end

            util:SetIncidentImageText(self.counterUI, "count_slash", "/", self.fontImage, self.fontColor)

            self:UpdateChasingCounter(game)
        end,

        OnEvent = function(self, game, strValue, intValue1, intValue2)
            if strValue=="CHASING_SUCC" then
                print('chasing succ\n')
                local prevComplete = self:IsComplete(game)

                game.chasingCount = game.chasingCount + 1
                game.chasingCount = game.chasingCount < maxChasingCount and game.chasingCount or maxChasingCount

                self:UpdateChasingCounter(game)

                util:SetTutorialMissionText(TUTORIAL_MISSION_CHASING, self:GetChasingString(game))

                if  not prevComplete and self:IsComplete(game) then
                    SubMissionSuccess(TUTORIAL_MISSION_CHASING)
                end
            end
        end,         

        GetChasingString = function(self, game)
            return util:GetMissionString("Tutorial_DoChasing", '$1['..maxChasingCount..'] $2['..game.chasingCount..']')
        end,

        UpdateChasingCounter = function (self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_l", tostring(game.chasingCount), self.fontImage, self.fontColor)
            end
        end,

        OnRetry = function(self, game)
            if self.counterUI ~= nil then
                util:SetIncidentImageText(self.counterUI, "count_r", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_slash", "", self.fontImage, self.fontColor)
                util:SetIncidentImageText(self.counterUI, "count_l", "", self.fontImage, self.fontColor)
            end
        end,

        IsComplete = function (self, game)         
            if game.chasingCount >= maxChasingCount then
                return true
            end
            return false
        end,
        OnRelease = function(self, game)
            util:RFClose(TUTORIAL_MISSION_TITLE)
        end,
    }
    
    return e;
end


function MagicItemShildSuccessEventCheck()
     local e =
     {
          OnInit = function(self, game)
               self.done = false
          end,
         
          OnStart = function(self, game)
               util:AddTutorialMission(TUTORIAL_MISSION_SHILD_MAGICITEM, util:GetMissionString("Tutorial_ShildMagicItem"))
          end,

          OnEvent = function(self, game, strValue, intValue1, intValue2)
               if strValue=="SHILD_MAGICITEM" then
                    if 1 <= intValue1 then
                        self.done = true
                    end
                    if self:IsComplete(game) then
                         SubMissionSuccess(TUTORIAL_MISSION_SHILD_MAGICITEM)
                    end
               end
                if strValue=="ATTACK_MAGICITEM" then
                    self.done = false
                    NEXT_STATE( game, "FAIL_RETRY" )	
                end
          end,

          IsComplete = function (self, game)         
               return self.done
          end,
     }
     return e;
end

function RelayMagicItemEventCheck()
     local e =
     {
          OnInit = function(self, game)
               self.done = false
          end,
         
          OnStart = function(self, game)
               util:AddTutorialMission(TUTORIAL_MISSION_RELAY_MAGICITEM, util:GetMissionString("Tutorial_MagicRelay"))
          end,

          OnEvent = function(self, game, strValue, intValue1, intValue2)
               if strValue=="RELAY_MAGICITEM" then
                    if 1 <= intValue1 then
                        self.done = true
                    end
                    if self:IsComplete(game) then
                         SubMissionSuccess(TUTORIAL_MISSION_RELAY_MAGICITEM)
                    end
               end
          end,         

          IsComplete = function (self, game)         
               return self.done
          end,
     }
    
     return e;
end

function AttackMagicItemEventCheck()
     local e =
     {
          OnInit = function(self, game)
               self.done = false
          end,
         
          OnStart = function(self, game)
               util:AddTutorialMission(TUTORIAL_MISSION_ATTACK_MAGICITEM, util:GetMissionString("Tutorial_MagicAttack"))
          end,

          OnEvent = function(self, game, strValue, intValue1, intValue2)
               if strValue=="ATTACK_MAGICITEM" then
                    if 1 <= intValue1 then
                        self.done = true
                    end
                    if self:IsComplete(game) then
                         SubMissionSuccess(TUTORIAL_MISSION_ATTACK_MAGICITEM)
                    end
               end
          end,         

          IsComplete = function (self, game)         
               return self.done
          end,
     }
    
     return e;
end

function GetMagicItemEventCheck()
     local e =
     {
          OnInit = function(self, game)
               self.done = false
          end,
         
          OnStart = function(self, game)
               util:AddTutorialMission(TUTORIAL_MISSION_GET_MAGICITEM, util:GetMissionString("Tutorial_MagicGet"))
          end,

          OnEvent = function(self, game, strValue, intValue1, intValue2)
               if strValue=="GET_MAGICITEM" then
                    if 1 < intValue1 then
                        self.done = true
                    end
                    if self:IsComplete(game) then
                         SubMissionSuccess(TUTORIAL_MISSION_GET_MAGICITEM)
                    end

               end
          end,         

          IsComplete = function (self, game)         
               return self.done
          end,
     }
    
     return e;
end

function UseMagicItemEventCheck()
     local e =
     {
          OnInit = function(self, game)
               self.done = false
          end,
         
          OnStart = function(self, game)
               util:AddTutorialMission(TUTORIAL_MISSION_USE_MAGICITEM, util:GetMissionString("Tutorial_MagicUse"))
          end,

          OnEvent = function(self, game, strValue, intValue1, intValue2)
               if strValue=="USE_MAGICITEM" then
                    if 1 < intValue1 then
                        self.done = true
                    end
                    if self:IsComplete(game) then
                         SubMissionSuccess(TUTORIAL_MISSION_USE_MAGICITEM)
                    end
               end
          end,         

          IsComplete = function (self, game)         
               return self.done
          end,
     }
    
     return e;
end


function SpurLevelEventChecker(maxSpurLevel)
	local e =
	{
		OnInit = function(self, game)
			self.done = false
		end,

		OnStart = function(self, game)
			util:AddTutorialMission(TUTORIAL_MISSION_DO_SPURLEVEL, util:GetMissionString("Tutorial_DoSpurLevel", '$1['..maxSpurLevel..']'))
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if strValue=="SPUR_LEVEL" then

				if not self.done then
					local spurCount = intValue1				
					if spurCount >= maxSpurLevel then
						self.done = true
					end

					if self:IsComplete(game) then
						SubMissionSuccess(TUTORIAL_MISSION_DO_SPURLEVEL)
					end
				end
			end
		end,

		OnRetry = function(self, game)
		end,

		IsComplete = function (self, game)		
			return self.done
		end,
	}

	return e
end

function GetSpurEventChecker(missionString)
	local e =
	{
		OnInit = function(self, game)
			self.done = false
		end,

		OnStart = function(self, game)
			util:AddTutorialMission(TUTORIAL_MISSION_JUMP_HURDLE, util:GetMissionString(missionString))
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if strValue=="GET_SPUR" then

				if not self.done then
					local spurCount = intValue1				
					if spurCount >= 1 then
						self.done = true
					end

					if self:IsComplete(game) then
						SubMissionSuccess(TUTORIAL_MISSION_JUMP_HURDLE)
					end
				end
			end
		end,

		OnRetry = function(self, game)
		end,

		IsComplete = function (self, game)		
			return self.done
		end,
	}

	return e
end


function SpurEventChecker(maxSpurCount)
	local e =
	{
		OnInit = function(self, game)
			self.spurCount = 0
		end,

		OnStart = function(self, game)
			util:AddTutorialMission(TUTORIAL_MISSION_USE_SPUR, util:GetMissionString("Tutorial_UseSpur")) 
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if strValue=="SPUR_START" then

				local prevComplete = self:IsComplete(game)
				local spurLevel = intValue1
				self.spurCount = self.spurCount + 1
				self.spurCount = self.spurCount < maxSpurCount and self.spurCount or maxSpurCount

				if not prevComplete and self:IsComplete(game) then
					SubMissionSuccess(TUTORIAL_MISSION_USE_SPUR)
				end

			end
		end,

		OnRetry = function(self, game)
		end,

		IsComplete = function (self, game)		
			if self.spurCount >= maxSpurCount then
				return true
			end
			return false
		end,
	}

	return e
end



function GoalInEventChecker(_missionString)
	local e =
	{
		OnInit = function(self, game)
			self.done = false
		end,

		OnStart = function(self, game)
			local missionStringKey = (_missionString~=nil and _missionString or "Tutorial_DoGoalIn")
			util:AddTutorialMission(TUTORIAL_MISSION_DO_GOALIN, util:GetMissionString(missionStringKey)) 
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if strValue=="GOALIN" then
				local prevComplete = self:IsComplete(game)
				self.done = true
				if not prevComplete and self:IsComplete(game) then
					SubMissionSuccess(TUTORIAL_MISSION_DO_GOALIN)
				end
			end
		end,

		IsComplete = function (self, game)
			return self.done
		end,
	}
	return e
end

function DashEventChecker(maxDashCount)
	local e =
	{
		OnInit = function(self, game)
			game.dashCount = 0

			self.fontImage = "race_font[50_68]_l"
			self.fontColor = 0xFFFDCD02
		end,

		OnStart = function(self, game)
			util:AddTutorialMission(TUTORIAL_MISSION_DO_SLIDING_DASH, self:GetSlidingDashString(game))
			
			if self.counterUI==nil then
				util:RFCreateWnd(TUTORIAL_MISSION_TITLE, "tutorial_missiontitle_window.xml")
				util:RFSetPicture(TUTORIAL_MISSION_TITLE, "img_missiontitle", "tuto_txt_slidingdash.png")

				self.counterUI = util:CreateIncidentImageText(TutorialCounter, "count_r", tostring(maxDashCount), self.fontImage, self.fontColor)				
			else
				util:SetIncidentImageText(self.counterUI, "count_r", tostring(maxDashCount), self.fontImage, self.fontColor)
			end

			util:SetIncidentImageText(self.counterUI, "count_slash", "/", self.fontImage, self.fontColor)
			
			self:UpdateDashCounter(game)
		end,

		GetSlidingDashString = function(self, game)
			return util:GetMissionString("Tutorial_DoSlidingDash", '$1['..maxDashCount..'] $2['..game.dashCount..']')
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if strValue=="DASH_START" then

				local prevComplete = self:IsComplete(game)

				game.dashCount = game.dashCount + 1
				game.dashCount = game.dashCount < maxDashCount and game.dashCount or maxDashCount

				self:UpdateDashCounter(game)

				util:SetTutorialMissionText(TUTORIAL_MISSION_DO_SLIDING_DASH, self:GetSlidingDashString(game))
				
				if not prevComplete and self:IsComplete(game) then
					SubMissionSuccess(TUTORIAL_MISSION_DO_SLIDING_DASH)
				end
			end
		end,

		OnRetry = function(self, game)
			if self.counterUI ~= nil then
				util:SetIncidentImageText(self.counterUI, "count_r", "", self.fontImage, self.fontColor)
				util:SetIncidentImageText(self.counterUI, "count_slash", "", self.fontImage, self.fontColor)
				util:SetIncidentImageText(self.counterUI, "count_l", "", self.fontImage, self.fontColor)
			end
		end,

		IsComplete = function (self, game)		
			if game.dashCount >= maxDashCount then
				return true
			end

			return false
		end,

		OnRelease = function(self, game)			
			util:RFClose(TUTORIAL_MISSION_TITLE)
		end,

		UpdateDashCounter = function (self, game)
			if self.counterUI ~= nil then
				util:SetIncidentImageText(self.counterUI, "count_l", tostring(game.dashCount), self.fontImage, self.fontColor)
			end
		end,
	}

	return e
end

function GlidingEventChecker(maxGlidingTime)
	local e =
	{
		OnInit = function(self, game)
			game.maxGlidingTime = 0
			self.curGlidingTime100 = 0

			self.fontImage = "race_font[50_68]_l"
			self.fontColor = 0xFFFDCD02
		end,

		OnStart = function(self, game)			
			util:AddTutorialMission(TUTORIAL_MISSION_DO_GLIDING, util:GetMissionString("Tutorial_DoGliding", '$1['..math.floor(maxGlidingTime)..']'))

			if self.timeUI==nil then				
				util:RFCreateWnd(TUTORIAL_MISSION_TITLE, "tutorial_missiontitle_window.xml")
				util:RFSetPicture(TUTORIAL_MISSION_TITLE, "img_missiontitle", "tuto_txt_glidingflight.png")

				self.timeUI = util:CreateIncidentImageText(TutorialTimer, "img_time_dot", '.', self.fontImage, self.fontColor)				
			else
				util:SetIncidentImageText(self.timeUI, "img_time_dot", ".", self.fontImage, self.fontColor)
			end

			self:UpdateGlidingTime(game)
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if strValue=="GLIDING_TIME" then

				local prevComplete = self:IsComplete(game)

				local glidingTime100 = intValue1
				local glidingTime	= glidingTime100 * 0.01

				game.maxGlidingTime = glidingTime > game.maxGlidingTime and glidingTime or game.maxGlidingTime

				--local sec = math.floor(game.maxGlidingTime)
				--local msec = math.floor(game.maxGlidingTime*100 - sec*100)
				
				self.curGlidingTime100 = glidingTime100
				
				self:UpdateGlidingTime(game)

				if not prevComplete and self:IsComplete(game) then
					self.done = true
					SubMissionSuccess(TUTORIAL_MISSION_DO_GLIDING)
				end
			end
		end,

		OnRetry = function(self, game)		
			if self.timeUI ~= nil then
				util:SetIncidentImageText(self.timeUI, "img_time_dot", "", self.fontImage, self.fontColor)
				util:SetIncidentImageText(self.timeUI, "img_time3", "", self.fontImage, self.fontColor)
				util:SetIncidentImageText(self.timeUI, "img_time4", "", self.fontImage, self.fontColor)
				util:SetIncidentImageText(self.timeUI, "img_time5", "", self.fontImage, self.fontColor)
			end
		end,

		IsComplete = function (self, game)		
			if game.maxGlidingTime >= maxGlidingTime then
				return true
			end

			return false
		end,
		
		OnRelease = function(self, game)					
			util:RFClose(TUTORIAL_MISSION_TITLE)
		end,

		UpdateGlidingTime = function (self, game)
			if self.timeUI ~= nil then
				local glidingTime	= self.curGlidingTime100 * 0.01
				local cur_sec = math.floor(glidingTime)
				local cur_msec = math.floor(self.curGlidingTime100 - cur_sec*100)

				self.curGlidingTime100 = glidingTime100

				local secWndName = (cur_sec >= 10 and "img_time3" or "img_time4")
				local msecPrefix = (cur_msec >= 10 and '' or '0')

				util:SetIncidentImageText(self.timeUI, secWndName, tostring(cur_sec), self.fontImage, self.fontColor)
				util:SetIncidentImageText(self.timeUI, "img_time5", msecPrefix..tostring(cur_msec), self.fontImage, self.fontColor)
			end
		end,
	}

	return e
end

function Jump2ndEventChecker()
	local e =
	{
		OnInit = function(self, game)
			self.done = false
		end,

		OnStart = function(self, game)
			util:AddTutorialMission(TUTORIAL_MISSION_DO_JUMP_2ND, util:GetMissionString("Tutorial_DoJump2nd"))
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if not self.done and strValue=="GET_SPUR" and intValue1>=1 then
				self.done = true
				SubMissionSuccess(TUTORIAL_MISSION_DO_JUMP_2ND)
			end
		end,

		OnRetry = function(self, game)
		end,

		IsComplete = function (self, game)		
			return self.done
		end,
	}

	return e
end

function GoalInBeforeGhostEventChecker()
	local e =
	{
		OnInit = function(self, game)
			self.done = false
		end,

		OnStart = function(self, game)
			util:AddTutorialMission(TUTORIAL_MISSION_GOALIN_BEFORE_GHOST, util:GetMissionString("Tutorial_GoalInBeforeGhost")) 
		end,

		OnEvent = function (self, game, strValue, intValue1, intValue2)
			if not self.done and game.result ~= FAIL_TIME and strValue=="GOALIN" then
				self.done = true
				if self:IsComplete(game) then
					SubMissionSuccess(TUTORIAL_MISSION_GOALIN_BEFORE_GHOST)
				end
			end
		end,

		IsComplete = function (self, game)
			return self.done
		end,
	}
	return e
end

end	--IS_SERVER 
