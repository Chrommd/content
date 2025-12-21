require('logichelper')

-- 콘솔창에 test test_ls_open 으로 로딩 페이지 미리 보기 가능하며 test test_ls_close 로 로딩 페이지 닫기

SPEEDGAME_PLAYCOUNT = 20
MAGICGAME_PLAYCOUNT = 20
DIALOGUE_NONE = 0
LIMIT_USER_LEVEL = 0

CaptureSceneParam =
{
    INVALID_USER_UID,

    GAMEMODE_NONE,
    GAMEMODE_SPEED,
    GAMEMODE_MAGIC,

    CHARID_BOY0,
    CHARID_BOY1,
    CHARID_GIRL0,

    DIALOGUE_GROUP_MAX,
}

-- 말능력치
MountAbilityParam = 
{
    MOUNT_AGILITY,      -- 민첩
    MOUNT_AMBITIOUS,    -- 경쟁
    MOUNT_RUSH,         -- 돌파
    MOUNT_ENDURANCE,    -- 근력
    MOUNT_COURAGE,      -- 용기
}

-- 말 성질
MountParam =
{
    MountTendency_None,             -- 특별한 기질 없음
    MountTendency_Greedy,           -- 식탐
    MountTendency_Vigorous,         -- 활발
    MountTendency_Timid,            -- 소심
    MountTendency_Curiosity,        -- 호기심
    MountTendency_Kindness,			-- 박애
    MountTendency_Clean,			-- 청결
    
    MOUNTGROUPFORCE_NORMAL,         -- 특별한 기세 없음
    MOUNTGROUPFORCE_GREED1,         -- 풀 다 먹을 기세
    MOUNTGROUPFORCE_GREED2,         -- 쇠도 씹어먹을 기세
    MOUNTGROUPFORCE_PLAY1,          -- 맹렬하게 놀 기세
    MOUNTGROUPFORCE_PLAY2,          -- 밤새워 놀 기세
    MOUNTGROUPFORCE_HASTE,          -- 1위할 기세
    MOUNTGROUPFORCE_SOLO,           -- 혼자서도 잘 할 기세
    MOUNTGROUPFORCE_REST,          -- 잠입액션 찍을 기세
}

-- MountCondition_Stamina
-- MountCondition_CharmPoint
-- MountCondition_FriendlyPoint -- 친밀도
-- MountCondition_InjuryPoint

-- MountCondition_Plenitude -- 만복도
-- MountCondition_BodyDirtiness
-- MountCondition_ManeTwisted
-- MountCondition_TailTwisted
-- MountCondition_Attachment
-- MountCondition_Boredom

-- MountCondition_BodyPolish
-- MountCondition_ManePolish
-- MountCondition_TailPolish

-- MountCondition_StopAmendsPoint

CaptureSceneGroupID = 
{
    CAPTURESCENE_GROUPNONE,
    CAPTURESCENE_GROUP00,
    CAPTURESCENE_GROUP01,
    CAPTURESCENE_GROUP02,
    CAPTURESCENE_GROUP03,
    CAPTURESCENE_GROUP04,
    CAPTURESCENE_GROUP05,
    CAPTURESCENE_GROUP06,
    CAPTURESCENE_GROUP07,
    CAPTURESCENE_GROUP08,
    CAPTURESCENE_GROUP09,
}

-----------------------------------------
-- INI 참조
-----------------------------------------

DIALOGUE01 = 1
DIALOGUE02 = 2

--
Dialogue = {}
Dialogue.group = {}
Dialogue.count = {}

-- INI CaptureSceneGroupInfo 와 연동됨
-- dlg_id는 INI CaptureSceneDialogue 테이블 아이디 참조
Dialogue.group[CAPTURESCENE_GROUP00] =
{
    dlg_id = { [DIALOGUE01] = 100,
               [DIALOGUE02] = 101 }
}

Dialogue.group[CAPTURESCENE_GROUP01] =
{
    dlg_id = { [DIALOGUE01] = 102,
               [DIALOGUE02] = 103 }
}

Dialogue.group[CAPTURESCENE_GROUP02] =
{
    dlg_id = { [DIALOGUE01] = 104,
               [DIALOGUE02] = 105 }
}

Dialogue.group[CAPTURESCENE_GROUP03] =
{
    dlg_id = { [DIALOGUE01] = 106,
               [DIALOGUE02] = 107 }
}

Dialogue.group[CAPTURESCENE_GROUP04] =
{
    dlg_id = { [DIALOGUE01] = 108,
               [DIALOGUE02] = 109 }
}

-----------------------------------------
-- Info 참조
-----------------------------------------

PlayerStatInfo = 
{
    level,
    maxspur,
    maxsinglewin,
    maxteamwin,

    mountFriendlyPoint,
    mountPlenitude,

    OnInitial = function()
        PlayerStatInfo.level = 0
        PlayerStatInfo.maxspur = 0
        PlayerStatInfo.maxsinglewin = 0
        PlayerStatInfo.maxteamwin = 0

        PlayerStatInfo.mountFriendlyPoint = 0
        PlayerStatInfo.mountPlenitude = 0
    end,
}

function ResetDialogue(group_idx)

    Dialogue.group[group_idx].flag = {}

    for i = 1, table.getn(Dialogue.group[group_idx].dlg_id) do
        Dialogue.group[group_idx].flag[i] = false
    end

    Dialogue.count[group_idx] = 0

end

function GetDialogueID(group_idx, index)

    if index == DIALOGUE_NONE then
        return DIALOGUE_NONE
    end

    -- 이 대사가 출력 됐다고 플래그 설정
    Dialogue.group[group_idx].flag[index] = true

    -- 이 그룹의 대사 카운트 1 증가시키기
    Dialogue.count[group_idx] = Dialogue.count[group_idx] + 1

    -- 대사 리턴
    return Dialogue.group[group_idx].dlg_id[index]

end

function CheckDialogueFlag(group_idx, index)

    -- 출력된 대사인지 여부 확인 true면 출력
    return Dialogue.group[group_idx].flag[index]

end

function GetNewDialogueID(group_idx)

    local dlgID = DIALOGUE_NONE

    for i = 1, table.getn(Dialogue.group[group_idx].dlg_id) do
        if CheckDialogueFlag(group_idx, i) == false then
            dlgID = i
            break
        end
    end

    return dlgID
end

function GetDialogueCount(group_idx)

    -- 그룹 대사 출력 횟수
    return Dialogue.count[group_idx]

end

function GetDialogueGroupIDSize(group_idx)

    return table.getn(Dialogue.group[group_idx].dlg_id)

end
-----------------------------------------
---
-----------------------------------------
CaptureScene =
{
    OnInitial = function()

        for i = 1, table.getn(Dialogue.group) do

            ResetDialogue(i)

        end

        PlayerStatInfo.OnInitial()

        return true
    end,

    CheckUserUID = function (user_uid)

        if user_uid == INVALID_USER_UID then
            return false
        end

        return true
    end,


    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- GetPlayerManager()
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- GetPlayerInfo
    -- GetWinner

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- PlayerMgr
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- GetMagicGamePlayCount 마법전 플레이 횟수
    -- GetSpeedGamePlayCount 스피드전 플레이 횟수
    -- GetLevel 레벨
    -- GetExp 경험치
    -- GetNickName
    -- GetCharInfo 캐릭터 관련 정보
    -- GetMountInfo 탈것 관련 정보

    CheckCondition = function(user_uid)

        local PlayerMgr = GetPlayerManager()
        local SceneManager = GetSceneManager()

        if PlayerMgr == nil or SceneManager == nil then
            return false
        end

        local playerInfo = PlayerMgr:GetPlayerInfo(user_uid)

        if playerInfo == nil then
            return false
        end

        if SceneManager:GetGameMode() ~= GAMEMODE_SPEED and
           SceneManager:GetGameMode() ~= GAMEMODE_MAGIC then
            return false
        end

        if SceneManager:GetGameMode() == GAMEMODE_SPEED then
            if SPEEDGAME_PLAYCOUNT > playerInfo:GetSpeedGamePlayCount() then
                return false
            end
        end

        if SceneManager:GetGameMode() == GAMEMODE_MAGIC then
            if MAGICGAME_PLAYCOUNT > playerInfo:GetMagicGamePlayCount() then
               return false
            end
        end

       if playerInfo:GetLevel() < LIMIT_USER_LEVEL then
            return false
       end

        if PlayerStatInfo.level == 0 then
            PlayerStatInfo.level = playerInfo:GetLevel()
        end

        local mountInfo = playerInfo:GetMountInfo()

        if mountInfo ~= nil then
            if PlayerStatInfo.mountFriendlyPoint == 0 then
                PlayerStatInfo.mountFriendlyPoint = mountInfo:GetApplicableMountCondition(MountCondition_FriendlyPoint)
            end

            if PlayerStatInfo.mountPlenitude == 0 then
                PlayerStatInfo.mountPlenitude = mountInfo:GetApplicableMountCondition(MountCondition_Plenitude)
            end
        end

       return true

    end,

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- sCharInfo
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- GetCharID
    -- GetFaceID
    -- GetEyeID
    -- GetColour

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- sMountInfo
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- GetAccDist 누적 주행 거리
    -- GetMountExp
    -- GetMountLevel
    -- GetMountOrgGrade 원래 등급
    -- GetMountCurGrade 현재 등급
    -- GetMountStatPT 남은 스탯 포인트

    -- GetMountTendency 말의 고유한 기질
    -- GetGroupForce 군집 기세

    -- GetMountStat(MountAbilityParam)
    -- GetApplicableMountCondition()

    GetDialogue = function(user_uid)

        local PlayerMgr = GetPlayerManager()

        if PlayerMgr == nil then
            return csinfo(DIALOGUE_NONE, CAPTURESCENE_GROUPNONE)
        end

        local playerInfo = PlayerMgr:GetPlayerInfo(user_uid)

        if playerInfo == nil then
            return csinfo(DIALOGUE_NONE, CAPTURESCENE_GROUPNONE)
        end

        --local charInfo = playerInfo:GetCharInfo()
        --local mountInfo = playerInfo:GetMountInfo()

        --if charInfo:GetCharID() == CHARID_GIRL0 then

        local groupSize = table.getn(Dialogue.group)
        local tempSize = 0

        -- 출력된 대화
        for i = 1, groupSize do
            if GetDialogueGroupIDSize(i) == GetDialogueCount(i) then
                tempSize = tempSize + 1
            end
        end

        -- 모든 대화가 출력됐다면 초기화
        if tempSize == groupSize then
            for i = 1, groupSize do
                ResetDialogue(i)
            end
        end

        local groupTable = {}
        local count = 1

        -- 출력 안된 그룹만 모으기
        for i = 1, groupSize do
            if GetDialogueGroupIDSize(i) ~= GetDialogueCount(i) then
                groupTable[count] = i
                count = count + 1
            end
        end

        local group_id = CAPTURESCENE_GROUPNONE
        local dialogue_id = DIALOGUE_NONE

        local tableSize = table.getn(groupTable)

        while tableSize > 0 do

            local index = math.random(tableSize)
            local rand_group = groupTable[index]
            local newdlg_id = GetNewDialogueID(rand_group)

            if newdlg_id ~= DIALOGUE_NONE then
                group_id = rand_group
                dialogue_id = newdlg_id
                break
            end

            groupTable[index] = nil
            tableSize = table.getn(groupTable)

        end

        return csinfo(GetDialogueID(group_id, dialogue_id), group_id)

    end,
}