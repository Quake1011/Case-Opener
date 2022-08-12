#pragma tabsize 0

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <csgo_colors>
#include <shop>
#tryinclude <vip_core>
#tryinclude <lvl_ranks>
#tryinclude <FirePlayersStats>

char sCrates[][] =  
{
    "models/props/crates/csgo_drop_crate_winteroffensive.mdl",
    "models/props/crates/csgo_drop_crate_wildfire.mdl",
    "models/props/crates/csgo_drop_crate_vanguard.mdl",
    "models/props/crates/csgo_drop_crate_spectrum2.mdl",
    "models/props/crates/csgo_drop_crate_spectrum.mdl",
    "models/props/crates/csgo_drop_crate_shadow.mdl",
    "models/props/crates/csgo_drop_crate_revolver.mdl",
    "models/props/crates/csgo_drop_crate_phoenix.mdl",
    "models/props/crates/csgo_drop_crate_hydra.mdl",
    "models/props/crates/csgo_drop_crate_huntsman.mdl",
    "models/props/crates/csgo_drop_crate_horizon.mdl",
    "models/props/crates/csgo_drop_crate_glove.mdl",
    "models/props/crates/csgo_drop_crate_gamma2.mdl",
    "models/props/crates/csgo_drop_crate_gamma.mdl",
    "models/props/crates/csgo_drop_crate_dangerzone.mdl",
    "models/props/crates/csgo_drop_crate_community_31.mdl",
    "models/props/crates/csgo_drop_crate_community_30.mdl",
    "models/props/crates/csgo_drop_crate_community_29.mdl",
    "models/props/crates/csgo_drop_crate_community_28.mdl",
    "models/props/crates/csgo_drop_crate_community_27.mdl",
    "models/props/crates/csgo_drop_crate_community_26.mdl",
    "models/props/crates/csgo_drop_crate_community_25.mdl",
    "models/props/crates/csgo_drop_crate_community_24.mdl",
    "models/props/crates/csgo_drop_crate_community_23.mdl",
    "models/props/crates/csgo_drop_crate_community_22.mdl",
    "models/props/crates/csgo_drop_crate_clutch.mdl",
    "models/props/crates/csgo_drop_crate_chroma3.mdl",
    "models/props/crates/csgo_drop_crate_chroma2.mdl",
    "models/props/crates/csgo_drop_crate_chroma.mdl",
    "models/props/crates/csgo_drop_crate_breakout.mdl",
    "models/props/crates/csgo_drop_crate_bravo.mdl",
    "models/props/crates/csgo_drop_crate_bloodhound.mdl",
    "models/props/crates/csgo_drop_crate_armsdeal3.mdl",
    "models/props/crates/csgo_drop_crate_armsdeal1.mdl",
    "models/props/crates/csgo_drop_crate_armsdeal2.mdl"
};

char sDownloadPaths[][] =  
{
	"models/ktm/prop_crystal/crystal_cluster_small.mdl",
	"models/props/xan13rus/items/diamond/diamond_icon.mdl",
	"models/props/xan13rus/items/coins/gift_coins.mdl",
	"models/ktm/prop_crystal/crystal_cluster_small.phy",
	"models/props/xan13rus/items/diamond/diamond_icon.phy",
	"models/props/xan13rus/items/coins/gift_coins.phy",
	"materials/models/props/xan13rus/items/coins/coins.vmt",
	"materials/ktm/prop_crystal/crystal_default_small_multi.vmt",
	"materials/models/props/xan13rus/items/diamond/diamond_01.vmt",
	"materials/models/props/xan13rus/items/diamond/diamond_02.vmt",
	"materials/models/props/xan13rus/items/coins/coins.vtf",
	"materials/models/props/xan13rus/items/coins/coins_exp.vtf",
	"materials/ktm/prop_crystal/crystal_default_small_multi.vtf",
	"materials/models/props/xan13rus/items/diamond/diamond_01.vtf",
	"materials/models/props/xan13rus/items/diamond/diamond_02.vtf",
	"models/ktm/prop_crystal/crystal_cluster_small.dx90.vtx",
	"models/props/xan13rus/items/diamond/diamond_icon.dx80.vtx",
	"models/props/xan13rus/items/diamond/diamond_icon.dx90.vtx",
	"models/props/xan13rus/items/diamond/diamond_icon.sw.vtx",
	"models/props/xan13rus/items/coins/gift_coins.dx80.vtx",
	"models/props/xan13rus/items/coins/gift_coins.dx90.vtx",
	"models/props/xan13rus/items/coins/gift_coins.sw.vtx",
	"models/ktm/prop_crystal/crystal_cluster_small.vvd",
	"models/props/xan13rus/items/diamond/diamond_icon.vvd",
	"models/props/xan13rus/items/coins/gift_coins.vvd"
};

char sRewardMDL[][] = 
{
    "models/props/xan13rus/items/coins/gift_coins.mdl",
    "models/props/xan13rus/items/diamond/diamond_icon.mdl",
    "models/ktm/prop_crystal/crystal_cluster_small.mdl"
};

#if defined _vip_core_included
	int iTimeGiveVip;
	bool bGiveVIP;
	ConVar g_hGiveVIP;
	ConVar g_hTimeGiveVip;
	ArrayList hArrayList;
    #warning "VIP LOADED"
#else
    #warning "VIP NOT LOADED"
#endif

#if defined _levelsranks_included_ || defined _fire_players_stats_included
    #if defined _levelsranks_included_
        #warning "LR LOADED"
    #endif
    #if defined _fire_players_stats_included
        #warning "FPS LOADED"
    #endif
    #if defined _fire_players_stats_included && defined _levelsranks_included_
        #error "CANT USE TWO STATS PLUGINS TOGETHER. REMOVE FirePlayerStats.inc or lvl_ranks.inc"
    #endif
    int iMinExp; 
    int iMaxExp; 
    bool bGiveExp;
    ConVar g_hGiveExp; 
    ConVar g_hMinExp;
    ConVar g_hMaxExp;
#else
    #warning "LR/FPS NOT LOADED"  
#endif

Database gDatabase;

Handle hTimers[MAXPLAYERS+1][5];

float fOpenSpeed; 
float fOpenSpeedScroll;
float fOpenSpeedAnim;

int iTimeBeforeNextOpen;
int iMinCredits; 
int iMaxCredits; 
int iMaxPositionValue; 
int iCaseKillTimer; 
int iExplode; 
int iReward[MAXPLAYERS+1] = {-1,...}; 
int iEntCaseData[MAXPLAYERS+1][5]; 
int g_HaloSprite;
int g_BeamSprite;

//bool bFreezePlayer; 
bool bEnableBoom; 
bool bVarn[MAXPLAYERS+1]; 
bool bOutputBeam; 
bool bSamePlat; 
bool bKillCaseSound; 
bool bCaseOpeningSound; 
bool bCaseMessages; 
bool bCaseMessagesHint; 
bool bCaseAccess; 
bool bMaxPosition; 
bool bResetCounter; 
bool bPrintAll; 
bool bDropLog;
bool bStartCounter;
//bool bNoDeath;
//bool TakeDMG[MAXPLAYERS+1] = {true,...};

//ConVar g_hFreezePlayer; 
ConVar g_hEnableBoom; 
ConVar g_hOutputBeam; 
ConVar g_hOpenSpeedAnim; 
ConVar g_hOpenSpeedScroll; 
ConVar g_hTimeBeforeNextOpen; 
ConVar g_hOpenSpeed; 
ConVar g_hMinCredits; 
ConVar g_hMaxCredits; 
ConVar g_hPrintAll; 
ConVar g_hDropLog; 
ConVar g_hMaxPositionValue; 
ConVar g_hCaseKillTimer; 
ConVar g_hSamePlat; 
ConVar g_hKillCaseSound; 
ConVar g_hCaseOpeningSound; 
ConVar g_hCaseMessages; 
ConVar g_hCaseMessagesHint; 
ConVar g_hCaseAccess; 
ConVar g_hMaxPosition;  
ConVar g_hResetCounter;
ConVar g_hStartCounter;
//ConVar g_hNoDeath;

static char sLog[PLATFORM_MAX_PATH];

enum {x = 0,y,z};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{
    if(GetEngineVersion() != Engine_CSGO) 
    {
        SetFailState("[CASEOPENER] Error loading plugin: Only for CS:GO");
        return APLRes_Failure;
    }

    if(error[0]) 
    {
        SetFailState("[CASEOPENER] Error loading plugin: %s", error);
        return APLRes_Failure;
    }
    return APLRes_Success;
}

char sColor[][] = {"FF0000", "00FF00"};

public Plugin myinfo = 
{
    name = "Case Opener",
    author = "Quake1011",
    description = "Spawning case with reward",
    version = "1.22",
    url = "https://github.com/Quake1011/"
}

public void OnPluginStart() 
{
    if(!SQL_CheckConfig("case_opener")) 
    {
        SetFailState("[CASEOPENER] Section \"case_opener\" is not found in databases.cfg");
        return;
    }

    Database.Connect(SQLConnectGlobalDB, "case_opener");

    RegConsoleCmd("sm_case", Command_Case);
    RegAdminCmd("sm_reset_counter", CommandResetCounter, ADMFLAG_ROOT);
    RegAdminCmd("sm_reset_for", CommandResetFor, ADMFLAG_ROOT);
    HookEvent("round_start", EventRoundStart, EventHookMode_Post);
    //HookEvent("weapon_fire", EventFire, EventHookMode_Pre);

    for(int i = 1;i <= MaxClients;i++) 
    {
        NullClient(i);	
	}

    LoadTranslations("CaseOpener.phrases.txt");
#if defined _vip_core_included
    HookConVarChange((g_hTimeGiveVip =                  CreateConVar("sm_opener_time_give_vip","604700","Time of VIP in seconds. 0 - forever.",0)), OnConvarChanged);
    iTimeGiveVip = g_hTimeGiveVip.IntValue;

	HookConVarChange((g_hGiveVIP =                  	CreateConVar("sm_opener_give_vip","1","Give the VIP Group [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bGiveVIP = g_hGiveVIP.BoolValue;
#endif
#if defined _levelsranks_included_ || defined _fire_players_stats_included
	HookConVarChange((g_hGiveExp =                  	CreateConVar("sm_opener_give_exp","1","Give the experience [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bGiveExp = g_hGiveExp.BoolValue;
	
    HookConVarChange((g_hMinExp =                       CreateConVar("sm_opener_min_exp","400","Minimum number of received experience.",0)), OnConvarChanged);
    iMinExp = g_hMinExp.IntValue;

    HookConVarChange((g_hMaxExp =                       CreateConVar("sm_opener_max_exp","1000","Maximum number of received experience.",0)), OnConvarChanged);
    iMaxExp = g_hMaxExp.IntValue;
#endif
    HookConVarChange((g_hResetCounter =                 CreateConVar("sm_opener_reset_counter","1","Allow admins to reset the counter [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bResetCounter = g_hResetCounter.BoolValue;

	HookConVarChange((g_hDropLog =                      CreateConVar("sm_opener_log","1","Enable logging case drops [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bDropLog = g_hDropLog.BoolValue;

    HookConVarChange((g_hPrintAll =                     CreateConVar("sm_opener_print_all","1","Print for all when player items drops [1 - For all | 0 - For self]. When enabled sm_opener_case_messages",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bPrintAll = g_hPrintAll.BoolValue;
	
    HookConVarChange((g_hTimeBeforeNextOpen =           CreateConVar("sm_opener_time_before_next_open",  "604800", "Time between case openings in seconds.",0)), OnConvarChanged);
    iTimeBeforeNextOpen = g_hTimeBeforeNextOpen.IntValue;

    HookConVarChange((g_hOpenSpeedAnim =                CreateConVar("sm_opener_open_anim_speed","0.1","The animation speed of the case. It is configured together with sm_opener_open_speed.",0)), OnConvarChanged);
    fOpenSpeedAnim = g_hOpenSpeedAnim.FloatValue;

    HookConVarChange((g_hOpenSpeed =                    CreateConVar("sm_opener_open_speed","11.5","Case opening speed. It is configured together with sm_opener_open_anim_speed.",0)), OnConvarChanged);
    fOpenSpeed = g_hOpenSpeed.FloatValue;

    HookConVarChange((g_hOpenSpeedScroll =              CreateConVar("sm_opener_open_speed_scroll","0.25","Speed of scrolls.",0)), OnConvarChanged);
    fOpenSpeedScroll = g_hOpenSpeedScroll.FloatValue;

    HookConVarChange((g_hOutputBeam =                   CreateConVar("sm_opener_open_output_beam","1","Display the maximum spawn radius of the case [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bOutputBeam = g_hOutputBeam.BoolValue;

    //HookConVarChange((g_hFreezePlayer =                 CreateConVar("sm_opener_freeze_open","0","Freeze the player while opening the case [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    //bFreezePlayer = g_hFreezePlayer.BoolValue;

    HookConVarChange((g_hMinCredits =                   CreateConVar("sm_opener_min_credits","500","Minimum number of credits received.",0)), OnConvarChanged);
    iMinCredits = g_hMinCredits.IntValue;

    HookConVarChange((g_hMaxCredits =                   CreateConVar("sm_opener_max_credits","2500","Maximum number of credits received.",0)), OnConvarChanged);
    iMaxCredits = g_hMaxCredits.IntValue;

    HookConVarChange((g_hMaxPositionValue =             CreateConVar("sm_opener_max_position_value","3","The maximum distance to case spawn. Depends by sm_opener_max_position",0)), OnConvarChanged);
    iMaxPositionValue = g_hMaxPositionValue.IntValue;

    HookConVarChange((g_hCaseKillTimer =                CreateConVar("sm_opener_case_kill_time","3","The time after which the case will disappear in seconds.",0)), OnConvarChanged);     
    iCaseKillTimer = g_hCaseKillTimer.IntValue;

    HookConVarChange((g_hSamePlat =                     CreateConVar("sm_opener_same_plat","1","Spawn the case on the same plane with the owner [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bSamePlat = g_hSamePlat.BoolValue;

    HookConVarChange((g_hKillCaseSound =                CreateConVar("sm_opener_kill_case_sound","1","Turn on the sound of the case disappearing [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bKillCaseSound = g_hKillCaseSound.BoolValue;

    HookConVarChange((g_hCaseOpeningSound =             CreateConVar("sm_opener_case_opening_sound","1","Enable case opening sounds [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bCaseOpeningSound = g_hCaseOpeningSound.BoolValue;

    HookConVarChange((g_hCaseMessages =                 CreateConVar("sm_opener_case_messages","1","Enable chat messages [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bCaseMessages = g_hCaseMessages.BoolValue;

    HookConVarChange((g_hCaseMessagesHint =             CreateConVar("sm_opener_case_messages_hint","1","Enable messages in the hint [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bCaseMessagesHint = g_hCaseMessagesHint.BoolValue;

    HookConVarChange((g_hCaseAccess =                   CreateConVar("sm_opener_case_access","0","Access only for admins [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bCaseAccess = g_hCaseAccess.BoolValue;

    HookConVarChange((g_hMaxPosition =                  CreateConVar("sm_opener_max_position","1","Restrict distance for spawn case [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bMaxPosition = g_hMaxPosition.BoolValue;
	
    HookConVarChange((g_hEnableBoom =                   CreateConVar("sm_opener_no_boom","1","Disable the explosion when removing the case [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bEnableBoom = g_hEnableBoom.BoolValue;

    HookConVarChange((g_hStartCounter =                 CreateConVar("sm_opener_start_counter","1","To start counter [1 - after touch, 0 - after open]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    bStartCounter = g_hStartCounter.BoolValue;

    // HookConVarChange((g_hNoDeath =                      CreateConVar("sm_opener_no_death","1","Enable immortality while opening the case [1 - Yes | 0 - No]",0, true, 0.0, true, 1.0)), OnConvarChanged);
    // bNoDeath = g_hNoDeath.BoolValue;

    AutoExecConfig(true, "CaseOpener");
	
    char sPath[PLATFORM_MAX_PATH];	
#if defined _vip_core_included
    hArrayList = new ArrayList(ByteCountToCells(32));
    BuildPath(Path_SM, sPath, sizeof(sPath), "data/vip/cfg/groups.ini");
    KeyValues kv = new KeyValues("VIP_GROUPS");
    if(kv.ImportFromFile(sPath)) 
    {
        kv.Rewind();
        kv.GotoFirstSubKey();
        do{
            char buffer[32];
            kv.GetSectionName(buffer, sizeof(buffer));
            int len = strlen(buffer);
            if(buffer[0] == '_' && buffer[len-1] == '_') 
            {
                LogMessage("VIP founded in groups.ini: %s", buffer);
                hArrayList.PushString(buffer);
            }
            else LogMessage("VIP founded in groups.ini has not prefixes \"_\": %s", buffer);
        } while(kv.GotoNextKey())
    }
    CloseHandle(kv);
#endif
	if(bDropLog)
	{
		FormatTime(sPath, sizeof(sPath), "%d_%b_%Y", GetTime());
		BuildPath(Path_SM, sLog, sizeof(sLog), "logs/CaseOpener_%s.txt", sPath);
		Handle file = OpenFile(sLog, "a+");
		CloseHandle(file);
	}
}

public Action CommandResetFor(int client, int args)
{
    if(bResetCounter)
    {
        Menu hMenu = CreateMenu(SelectPlayer);
        hMenu.SetTitle("Select player");
        char temp[2][256];
        for(int i = 1; i <= MaxClients; i++)
        {
            if(i)
            {
                if(IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
                {
                    Format(temp[0], 256, "%i", i);
                    Format(temp[1], 256, "%N(%i)", i, GetClientUserId(i))
                    hMenu.AddItem(temp[0], temp[1]);
                }               
            }
        }
        //hMenu.ExitBackButton = true;
        hMenu.ExitButton = true;
        hMenu.Display(client, 0);
    }
    else 
    {
        if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "not_works");
        EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
    }
}

public int SelectPlayer(Menu menu, MenuAction action, int client, int item)
{
    switch(action)
    {
        case MenuAction_End: delete menu;
        case MenuAction_Select: 
        {
            char tmp[32];
            menu.GetItem(item, tmp, sizeof(tmp));
            int idx = StringToInt(tmp);
            char sQuery[256], auth[22];
            GetClientAuthId(idx, AuthId_Steam2, auth, sizeof(auth));
            FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
            SQL_LockDatabase(gDatabase);
            DBResultSet result = SQL_Query(gDatabase, sQuery);
            SQL_UnlockDatabase(gDatabase);
            if(result != INVALID_HANDLE) 
            {
                if(result.HasResults) 
                {
                    if(result.RowCount > 0) 
                    {
                        FormatEx(sQuery, sizeof(sQuery), "UPDATE `opener_base` SET `available`='1', `last_open`='0' WHERE `steam`='%s'", auth);
                        SQL_Query(gDatabase, sQuery);
                        if(bCaseMessages) CGOPrintToChat(idx, "%t%t", "prefix", "counter_reseted");
                    }
                }
            }
            delete result;
            Menu hMenu = CreateMenu(SelectPlayer);
            hMenu.SetTitle("Select player");
            char temp[2][256];
            for(int i = 1; i <= MaxClients; i++)
            {
                if(i)
                {
                    if(IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
                    {
                        Format(temp[0], 256, "%i", i);
                        Format(temp[1], 256, "%N(%i)", i, GetClientUserId(i))
                        hMenu.AddItem(temp[0], temp[1]);
                    }                    
                }
            }
            //hMenu.ExitBackButton = true;
            hMenu.ExitButton = true;
            hMenu.Display(client, 0);
        }
    }
}

public void SQLConnectGlobalDB(Database db, const char[] error, any data) 
{
    if (db == null || error[0]) 
    {
        SetFailState("[CASEOPENER] Problem with connection to Database");
        return;
    }

    LogMessage("Connection is READY!");
    gDatabase = db;
    CreateTableDB();
}

public void CreateTableDB() 
{
    char sQuery[512];
    FormatEx(sQuery, sizeof(sQuery), "CREATE TABLE IF NOT EXISTS `opener_base` (`steam` VARCHAR(24) NOT NULL PRIMARY KEY, `last_open` INTEGER(20) NOT NULL, `available` INTEGER(8) NOT NULL)");
    SQL_TQuery(gDatabase, SQLTQueryCallBack, sQuery);
}

public void SQLTQueryCallBack(Handle owner, Handle hndl, const char[] error, any data) 
{
    if(!error[0] && hndl != INVALID_HANDLE) LogMessage("[CASEOPENER] The table has been created");
    else 
    {
        SetFailState("[CASEOPENER] Cant create a table \"opener_base\"");
        LogError(error);
        return;
    }
}

public void OnConvarChanged(ConVar convar, const char[] oldValue, const char[] newValue) 
{
    if(convar != INVALID_HANDLE) 
    {
        if(convar == g_hOpenSpeedScroll) fOpenSpeedScroll = convar.FloatValue;
		else if(convar == g_hTimeBeforeNextOpen) iTimeBeforeNextOpen = convar.IntValue;
#if defined _vip_core_included
        else if(convar == g_hTimeGiveVip) iTimeGiveVip = convar.IntValue;
		else if(convar == g_hGiveVIP) bGiveVIP = convar.BoolValue;
#endif
#if defined _levelsranks_included_ || defined _fire_players_stats_included
        else if(convar == g_hMinExp) iMinExp = convar.IntValue;
		else if(convar == g_hGiveExp) bGiveExp = convar.BoolValue;
		else if(convar == g_hMaxExp) iMaxExp = convar.IntValue;
#endif
        else if(convar == g_hOutputBeam) bOutputBeam = convar.BoolValue;
        else if(convar == g_hOpenSpeed) fOpenSpeed = convar.FloatValue;
        else if(convar == g_hOpenSpeedAnim) fOpenSpeedAnim = convar.FloatValue;
        else if(convar == g_hMinCredits) iMinCredits = convar.IntValue;
        else if(convar == g_hMaxCredits) iMaxCredits = convar.IntValue;        
        else if(convar == g_hMaxPositionValue) iMaxPositionValue = convar.IntValue;
        else if(convar == g_hCaseKillTimer) iCaseKillTimer = convar.IntValue;
        else if(convar == g_hSamePlat) bSamePlat = convar.BoolValue;
        else if(convar == g_hKillCaseSound) bKillCaseSound = convar.BoolValue;
        else if(convar == g_hCaseOpeningSound) bCaseOpeningSound = convar.BoolValue;
        else if(convar == g_hCaseMessages) bCaseMessages = convar.BoolValue;
        else if(convar == g_hCaseMessagesHint) bCaseMessagesHint = convar.BoolValue;
        else if(convar == g_hCaseAccess) bCaseAccess = convar.BoolValue;
        else if(convar == g_hMaxPosition) bMaxPosition = convar.BoolValue;
//        else if(convar == g_hFreezePlayer) bFreezePlayer = convar.BoolValue;
        else if(convar == g_hResetCounter) bResetCounter = convar.BoolValue;
        else if(convar == g_hDropLog) bDropLog = convar.BoolValue;
        else if(convar == g_hPrintAll) bPrintAll = convar.BoolValue;
		else if(convar == g_hEnableBoom) bEnableBoom = convar.BoolValue;
        else if(convar == g_hStartCounter) bStartCounter = convar.BoolValue;
    }
}

public void OnMapStart() 
{
    for(int i = 0;i < sizeof(sDownloadPaths);i++) 
    {
		AddFileToDownloadsTable(sDownloadPaths[i]);	
	}
	
	PreCacheFiles();
}

public void PreCacheFiles() 
{
    for(int i = 0;i < sizeof(sCrates); i++) 
    {
		PrecacheModel(sCrates[i]);
	}
    
    for(int i = 0;i < sizeof(sRewardMDL); i++) 
    {
        PrecacheModel(sRewardMDL[i]);
	}

    PrecacheModel("sprites/glow01.spr", true);
    iExplode = PrecacheModel("materials/sprites/zerogxplode.vmt", true);
    g_HaloSprite = PrecacheModel("sprites/halo.vmt", true);
    g_BeamSprite = PrecacheModel("sprites/laserbeam.vmt", true);
    PrecacheSound("ui/csgo_ui_crate_item_scroll.wav", true);
    PrecacheSound("ui/csgo_ui_crate_display.wav", true);
    PrecacheSound("weapons/hegrenade/explode3.wav", true);
    PrecacheSound("ui/panorama/case_drop_01.wav", true);
	PrecacheSound("buttons/blip1.wav", true);
    PrecacheSound("ui/panorama/music_equip_01.wav", true);
}

public void OnClientPostAdminCheck(int client) 
{
    if(!IsFakeClient(client)) 
    {
        AddDataToDB(client);
        for(int i = 0;i <= 4; i++) 
        {
            iEntCaseData[client][i] = -1;		
		}
    }
}

public void AddDataToDB(int client) 
{
    char sQuery[256], auth[22];
    GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
    FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
    SQL_LockDatabase(gDatabase);
    DBResultSet result = SQL_Query(gDatabase, sQuery);
    SQL_UnlockDatabase(gDatabase);
    if(result != INVALID_HANDLE) 
    {
        if(result.HasResults) 
        {
            if(result.RowCount == 0) 
            {
                FormatEx(sQuery, sizeof(sQuery), "INSERT INTO `opener_base` (`steam`, `last_open`, `available`) VALUES ('%s', '0', 1)", auth);
                SQL_Query(gDatabase, sQuery);
                LogMessage("[CASEOPENER] The player has been added to the database");
            }
            else LogMessage("[CASEOPENER] The player %N is already in the database", client);
        }
    }
    else 
    {
        SetFailState("[CASEOPENER] Error adding player %N data", client);
        delete result;
        return;
    }
    delete result;
}

public void EventRoundStart(Event hEvent, const char[] sEvent, bool bdb) 
{
    for(int i = 0;i <= MaxClients; i++) 
    {
        if(i && IsClientInGame(i) && !IsFakeClient(i))
        {
            NullClient(i);	
            if(GetEntProp(i, Prop_Data, "m_takedamage") == 0) SetEntProp(i, Prop_Data, "m_takedamage", 2);       
            iReward[i] = -1;
            //if(TakeDMG[i] == false) TakeDMG[i] = true;
        }
	}
}

public void OnClientDisconnect(int client) 
{
    if(!IsFakeClient(client)) 
    {
        NullClient(client);
        for(int edict = 0;edict <= 4; edict++) 
        {
            if(iEntCaseData[client][edict] != -1) AcceptEntityInput(iEntCaseData[client][edict] ,"kill");		
		}
    }
}

public Action CommandResetCounter(int client, int args) 
{
    if(bResetCounter) 
    {
        char sQuery[256], auth[22];
        GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
        FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
        SQL_LockDatabase(gDatabase);
        DBResultSet result = SQL_Query(gDatabase, sQuery);
        SQL_UnlockDatabase(gDatabase);
        if(result != INVALID_HANDLE) 
        {
            if(result.HasResults) 
            {
                if(result.RowCount > 0) 
                {
                    FormatEx(sQuery, sizeof(sQuery), "UPDATE `opener_base` SET `available`='1', `last_open`='0' WHERE `steam`='%s'", auth);
                    SQL_Query(gDatabase, sQuery);
		            if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "counter_reseted");
                }
            }
        }
        delete result;
    }
    else 
    {
        if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "not_works");
		EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
    }
    return Plugin_Handled;
}

public Action Command_Case(int client, int args) 
{
	if(IsPlayerAlive(client)) 
	{
		char auth[22], sQuery[256];
		GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
		FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
		SQL_LockDatabase(gDatabase);
		DBResultSet result = SQL_Query(gDatabase, sQuery);
		SQL_UnlockDatabase(gDatabase);
		if(result != INVALID_HANDLE) 
		{
			if(result.HasResults) 
			{
				if(result.RowCount > 0) 
				{
					int time = GetTime();
					result.FetchRow();
					if((result.FetchInt(1) + iTimeBeforeNextOpen) <= time) 
					{
						FormatEx(sQuery, sizeof(sQuery), "UPDATE `opener_base` SET `available`='1' WHERE `steam`='%s'", auth);
						SQL_Query(gDatabase, sQuery);
					}
				}
			}
		}
		GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
		FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s' AND `available`='1'", auth);
		SQL_LockDatabase(gDatabase);
		result = SQL_Query(gDatabase, sQuery);
		SQL_UnlockDatabase(gDatabase);
		if(result == INVALID_HANDLE) return Plugin_Stop;
		if(result.HasResults) 
		{
			if(result.RowCount > 0) 
			{
				if(iEntCaseData[client][0] == -1 && iEntCaseData[client][1] == -1 && iEntCaseData[client][2] == -1 && iEntCaseData[client][3] == -1 && iEntCaseData[client][4]) 
                {
					if(bCaseAccess) 
					{
						AdminId AdminID = GetUserAdmin(client);
						if(AdminID == INVALID_ADMIN_ID) 
						{
							if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "not_admin");
							EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
							delete result;
							return Plugin_Stop;
						}
					}
					if(!IsFakeClient(client)) 
					{
						float fOrig[3], fAng[3], fEndOfTrace[3];
						GetClientEyePosition(client, fOrig);
						GetClientEyeAngles(client, fAng);
						Handle hTrace = TR_TraceRayFilterEx(fOrig, fAng, CONTENTS_SOLID, RayType_Infinite, TRFilter, client);
						if(TR_DidHit(hTrace) && hTrace != INVALID_HANDLE) 
						{
							TR_GetEndPosition(fEndOfTrace, hTrace);
							float fClientOrigin[3];
							GetClientAbsOrigin(client, fClientOrigin);
							if(fEndOfTrace[z] != fClientOrigin[z] && bSamePlat) 
							{
								if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "same_level_case");
							} 
							else if(GetVectorDistance(fClientOrigin, fEndOfTrace) > float(iMaxPositionValue*100) && bMaxPosition) 
							{
								if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "too_longer", iMaxPositionValue);
								if(bOutputBeam) 
								{
									float fDist = float(iMaxPositionValue*100);
									TE_SetupBeamRingPoint(fClientOrigin, 0.0, fDist*2, g_BeamSprite, g_HaloSprite, 0, 660, 1.0, 2.0, 0.0, {255, 255, 0, 255}, 1000, 0);  
									TE_SendToClient(client);                                      
								}
								EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
							}
							else 
							{
								DataPack dp = CreateDataPack();
								float fPosit[3]; 
								// if(bFreezePlayer) 
								// {
									// SetEntityMoveType(client, MOVETYPE_NONE);
									// if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "freeze_open", RoundToFloor(fOpenSpeed));
								// }
                                // if(bNoDeath)
                                // {
                                //     SetEntProp(client, Prop_Data, "m_takedamage", 0);
                                //     //if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "immortal");
                                //     LogMessage("The player is immortal");
                                //     TakeDMG[client] = false;
                                // }
                                //SDKHook(client, SDKHook_OnTakeDamage, SDKCBOnTakeDMG);
                                
								fPosit = SpawnCase(client, fEndOfTrace, fAng);
								hTimers[client][4] = CreateTimer(1.4, FallAfterTimer, dp);
								dp.WriteCell(client);
								dp.WriteFloat(fPosit[0]);
								dp.WriteFloat(fPosit[1]);
								dp.WriteFloat(fPosit[2]);
							}
						}
						delete hTrace;
					}
				}
				else 
				{
					if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "existing_case");
					EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
				}
			}
			else if(result.RowCount == 0) 
			{
				FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
				SQL_LockDatabase(gDatabase);
				result = SQL_Query(gDatabase, sQuery);
				SQL_UnlockDatabase(gDatabase);
				if(result == INVALID_HANDLE) return Plugin_Stop;
				if(result.HasResults) 
				{
					if(result.RowCount > 0) 
					{
						result.FetchRow();
						int time = (result.FetchInt(1) + iTimeBeforeNextOpen) - GetTime();
						if(time >= 0) CGOPrintToChat(client, "%t%t", "prefix", "wait_next_case", time / 3600 / 24, time / 3600 % 24, time / 60 % 60, time % 60);
						EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
						LogMessage("[CASEOPENER] The player %N trying to use !case command but already has active block after opening", client);
					}
				}
			}
		} 
		delete result;
	}
	else 
	{
		if(bCaseMessages) CGOPrintToChat(client, "%t%t", "prefix", "be_alive");
		EmitSoundToClient(client, "buttons/blip1.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
	}
    return Plugin_Handled;
}

// public Action EventFire(Event hEvent, const char[] sEvent, bool bdb)
// {
//     if(TakeDMG[GetClientOfUserId(hEvent.GetInt("userid"))] == false) return Plugin_Handled;
//     return Plugin_Continue
// }

// public Action SDKCBOnTakeDMG(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
// {
//     if(TakeDMG[attacker] == false)
//     {
//         if (attacker > 0 && attacker < MaxClients && victim != attacker)
//         {
//             damage = 0.0;
//             return Plugin_Changed;
//         }
//     }
//     return Plugin_Continue;
// }

public Action FallAfterTimer(Handle hTimer, Handle dp) 
{
    DataPack hPack = view_as<DataPack>(dp);
    float fPos[3];
    hPack.Reset();
    int client = hPack.ReadCell();
    fPos[0] = hPack.ReadFloat();
    fPos[1] = hPack.ReadFloat();
    fPos[2] = hPack.ReadFloat();
    SpawningReward(fPos, client);
    delete hPack;
    return Plugin_Continue;
}

public bool TRFilter(int client, int mask) 
{ 
	return client ? false : true;
}

float[] SpawnCase(int iClient, float fPos[3], float fAng[3]) 
{
    char sTargetName[64];

    fAng[x] = 0.0;
    fAng[y] += 90.0;
    
    iEntCaseData[iClient][0] = CreateEntityByName("prop_dynamic");

    Format(sTargetName, sizeof(sTargetName), "case_%i", iClient);
    DispatchKeyValue(iEntCaseData[iClient][0], "targetname", sTargetName);

    DispatchKeyValue(iEntCaseData[iClient][0], "model", sCrates[GetRandomInt(0, sizeof(sCrates)-1)]);
    DispatchKeyValue(iEntCaseData[iClient][0], "modelscale", "1.0");
    DispatchKeyValue(iEntCaseData[iClient][0], "spawnflags", "16");
    DispatchKeyValue(iEntCaseData[iClient][0], "solid", "6");
    DispatchKeyValueVector(iEntCaseData[iClient][0], "origin", fPos);
    DispatchKeyValueVector(iEntCaseData[iClient][0], "angles", fAng);

    DispatchSpawn(iEntCaseData[iClient][0]);

    SetVariantString("fall");
    AcceptEntityInput(iEntCaseData[iClient][0], "SetAnimation", -1, -1, -1);
    AcceptEntityInput(iEntCaseData[iClient][0], "EnableCollision");
    DispatchKeyValueFloat(iEntCaseData[iClient][0], "playbackrate", 1.1);
    EmitSoundToAll("ui/panorama/case_drop_01.wav", iEntCaseData[iClient][0], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, fPos);
    fPos[z] += 20.0;
    return fPos;
}

public void SpawningReward(float fPos[3], int client) 
{
    SetVariantString("open");
	AcceptEntityInput(iEntCaseData[client][0], "SetAnimation", -1, -1, -1);
	AcceptEntityInput(iEntCaseData[client][0], "EnableCollision");
	DispatchKeyValueFloat(iEntCaseData[client][0], "playbackrate", fOpenSpeedAnim);
#if ((defined _levelsranks_included_ || defined _fire_players_stats_included) && defined _vip_core_included)
    int iRandom = GetRandomInt(1,99);
    if(iRandom >= 1  && iRandom <= 33) iReward[client] = 0;
    if(iRandom >= 34  && iRandom <= 66) iReward[client] = 1;
    if(iRandom >= 67  && iRandom <= 99) iReward[client] = 2;
#elseif ((defined _levelsranks_included_ || defined _fire_players_stats_included) && !defined _vip_core_included)
	int iRandom = GetRandomInt(1,66);
	if(iRandom >= 1  && iRandom <= 33) iReward[client] = 0;
    if(iRandom >= 34  && iRandom <= 66) iReward[client] = 1;
#elseif (defined _vip_core_included && !(defined _levelsranks_included_ || defined _fire_players_stats_included))
	int iRandom = GetRandomInt(1,66);
	if(iRandom >= 1  && iRandom <= 33) iReward[client] = 0;
    if(iRandom >= 34  && iRandom <= 66) iReward[client] = 2;
#endif
	
	if(client && IsClientInGame(client)) 
    {
        char 
            clr[20],
            sTargetName[32],
            sBufer[70];

        iEntCaseData[client][1] = CreateEntityByName("prop_dynamic");

        Format(sTargetName, sizeof(sTargetName), "Reward_%i", iEntCaseData[client][1]);
        DispatchKeyValue(iEntCaseData[client][1], "targetname", sTargetName);
        DispatchKeyValueVector(iEntCaseData[client][1], "origin", fPos);
        DispatchKeyValue(iEntCaseData[client][1], "modelscale", "0.1");
        DispatchKeyValue(iEntCaseData[client][1], "solid", "6");
		switch(iReward[client]) 
        {
			case 0: 
            {
				DispatchKeyValue(iEntCaseData[client][1], "model", sRewardMDL[iReward[client]]);
			}
#if (defined _levelsranks_included_ || defined _fire_players_stats_included)
			case 1: 
            {
				if(bGiveExp) DispatchKeyValue(iEntCaseData[client][1], "model", sRewardMDL[iReward[client]]);				
				else DispatchKeyValue(iEntCaseData[client][1], "model", sRewardMDL[0]);	
			}
#endif
#if defined _vip_core_included
			case 2: 
            {
				if(bGiveVIP) DispatchKeyValue(iEntCaseData[client][1], "model", sRewardMDL[iReward[client]]);				
				else DispatchKeyValue(iEntCaseData[client][1], "model", sRewardMDL[0]);
			}
#endif
		}
        SetVariantString(sTargetName);

        DispatchSpawn(iEntCaseData[client][1]);
        SetEntProp(iEntCaseData[client][1], Prop_Send, "m_usSolidFlags", 8);
        SetEntProp(iEntCaseData[client][1], Prop_Send, "m_CollisionGroup", 1);
        Format(sBufer, sizeof(sBufer), "OnUser1 !self:kill::999.0:-1");
        SetVariantString(sBufer);
        AcceptEntityInput(iEntCaseData[client][1], "AddOutput");
        AcceptEntityInput(iEntCaseData[client][1], "FireUser1");

        iEntCaseData[client][2] = CreateEntityByName("func_rotating", -1);

        DispatchKeyValueVector(iEntCaseData[client][2], "origin", fPos);
        DispatchKeyValue(iEntCaseData[client][2], "targetname", sTargetName);
        DispatchKeyValue(iEntCaseData[client][2], "maxspeed", "50");
        DispatchKeyValue(iEntCaseData[client][2], "friction", "0");
        DispatchKeyValue(iEntCaseData[client][2], "dmg", "0");
        DispatchKeyValue(iEntCaseData[client][2], "solid", "6");
        DispatchKeyValue(iEntCaseData[client][2], "spawnflags", "64");
        DispatchSpawn(iEntCaseData[client][2]);

        SetVariantString("!activator");

        AcceptEntityInput(iEntCaseData[client][1], "SetParent", iEntCaseData[client][2], iEntCaseData[client][2]);
        AcceptEntityInput(iEntCaseData[client][2], "Start", -1, -1);
        SetEntProp(iEntCaseData[client][2], Prop_Send, "m_CollisionGroup", 1);
        Format(sBufer, sizeof(sBufer), "OnUser1 !self:kill::999.0:-1");
        SetVariantString(sBufer);
        AcceptEntityInput(iEntCaseData[client][2], "AddOutput");
        AcceptEntityInput(iEntCaseData[client][2], "FireUser1");
        SetEntPropEnt(iEntCaseData[client][1], Prop_Send, "m_hEffectEntity", iEntCaseData[client][2]);
        
        Format(clr, sizeof(clr), "%i %i %i", GetRandomInt(0,255),GetRandomInt(0,255),GetRandomInt(0,255));

        iEntCaseData[client][3] = CreateEntityByName("env_sprite");

        DispatchKeyValue(iEntCaseData[client][3], "rendermode", "5");
        DispatchKeyValue(iEntCaseData[client][3], "rendercolor", view_as<char>(clr));
        DispatchKeyValue(iEntCaseData[client][3], "renderamt", "255");
        DispatchKeyValue(iEntCaseData[client][3], "scale", "1");
        DispatchKeyValue(iEntCaseData[client][3], "model", "sprites/glow01.spr");
        DispatchKeyValueVector(iEntCaseData[client][3], "origin", fPos);
        DispatchSpawn(iEntCaseData[client][3]);
        SetVariantString("!activator");
        AcceptEntityInput(iEntCaseData[client][3], "SetParent", iEntCaseData[client][1]);

        hTimers[client][2] = CreateTimer(fOpenSpeedScroll, Scrolling, client, TIMER_REPEAT);
        hTimers[client][0] = CreateTimer(fOpenSpeed, SpawnReward, client, TIMER_FLAG_NO_MAPCHANGE);
        hTimers[client][1] = CreateTimer(fOpenSpeed, SoundOpen, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Scrolling(Handle hNewTimer, int client) 
{
    int clr[4];
    float fPos[3];
    clr[0] = GetRandomInt(0,255);
    clr[1] = GetRandomInt(0,255);
    clr[2] = GetRandomInt(0,255);
    clr[3] = 255;

    GetEntPropVector(iEntCaseData[client][0], Prop_Data, "m_vecAbsOrigin", fPos);

    if(bCaseOpeningSound) EmitSoundToAll("ui/csgo_ui_crate_item_scroll.wav", iEntCaseData[client][0], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, fPos);

    SetVariantColor(clr);
    AcceptEntityInput(iEntCaseData[client][3], "color");

    if(bCaseMessagesHint) PrintToHintScrolling(client);

    return Plugin_Continue;
}

public Action SoundOpen(Handle hNewTimer, int client) 
{
    if(hTimers[client][2] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][2]);
        hTimers[client][2] = null;
    }

    if(hTimers[client][1] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][1]);
        hTimers[client][1] = null;
    }

    float fPos[3];
    GetEntPropVector(iEntCaseData[client][0], Prop_Data, "m_vecAbsOrigin", fPos);

    // if(bFreezePlayer) 
    // {
        // if(GetEntityMoveType(client) == MOVETYPE_NONE) SetEntityMoveType(client, MOVETYPE_WALK);	
	// }

    // if(bNoDeath)
    // {
    //     if(GetEntProp(client, Prop_Data, "m_takedamage") == 0) SetEntProp(client, Prop_Data, "m_takedamage", 2);
    // }
 
    if(bCaseOpeningSound) EmitSoundToAll("ui/csgo_ui_crate_display.wav", iEntCaseData[client][0], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, fPos);
    
    switch(iReward[client]) 
    {
        case 0: 
        {
			while(iEntCaseData[client][4] == -1)
			{
				iEntCaseData[client][4] = GetRandomInt(iMinCredits,iMaxCredits);
			}
			
            if(bCaseMessagesHint) PrintHintText(client, "%t", "credits_scroll", sColor[1], iEntCaseData[client][4]);
        }
#if (defined _levelsranks_included_ || defined _fire_players_stats_included)
        case 1: 
        {
			while(iEntCaseData[client][4] == -1)
			{
				iEntCaseData[client][4] = GetRandomInt(iMinExp,iMaxExp);
			}
			
			if(bGiveExp) 
            {
				if(bCaseMessagesHint) PrintHintText(client, "%t", "exp_scroll", sColor[1], iEntCaseData[client][4]);                
            }
			else if(bCaseMessagesHint) PrintHintText(client, "%t", "credits_scroll", sColor[1], iEntCaseData[client][4]);
        }
#endif
#if defined _vip_core_included
        case 2: 
        {
			if(bGiveVIP)
            {
				iEntCaseData[client][4] = GetRandomInt(0, hArrayList.Length - 1);
				if(bCaseMessagesHint) 
                {
					char buffer[32];
					hArrayList.GetString(iEntCaseData[client][4], buffer,sizeof(buffer))
					PrintHintText(client, "%t", "vip_scroll", sColor[1], buffer);
				}		
			}
			else 
            {
				iEntCaseData[client][4] = GetRandomInt(iMinCredits,iMaxCredits);
				if(bCaseMessagesHint) PrintHintText(client, "%t", "credits_scroll", sColor[1], iEntCaseData[client][4]);
			}
		}
		#endif
    }
    return Plugin_Continue;
}

public Action SpawnReward(Handle hNewTimer, int client) 
{
    DispatchKeyValue(iEntCaseData[client][1], "modelscale", "1.0");
    DispatchSpawn(iEntCaseData[client][1]);
    if(!bStartCounter)
    {
        char sQuery[256], auth[22];
        GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));
        FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
        SQL_LockDatabase(gDatabase);
        DBResultSet result = SQL_Query(gDatabase, sQuery);
        SQL_UnlockDatabase(gDatabase);
        if(result != INVALID_HANDLE) 
        {
            if(result.HasResults) 
            {
                if(result.RowCount > 0) 
                {
                    int time = GetTime();
                    FormatEx(sQuery, sizeof(sQuery), "UPDATE `opener_base` SET `available`='0', `last_open`='%i' WHERE `steam`='%s'", time, auth);
                    SQL_Query(gDatabase, sQuery);                
                }
            }                
        }
        delete result;                   
    }
    SDKHook(iEntCaseData[client][1], SDKHook_StartTouch, Hook_GiftStartTouch);
    //TakeDMG[client] = true;
    if(hTimers[client][0] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][0]);
        hTimers[client][0] = null;
    }
    return Plugin_Continue;
}

public Action OnTouchDelete(Handle hNewTimer, int activator) 
{
	float fPos[3];
	GetEntPropVector(iEntCaseData[activator][0], Prop_Data, "m_vecAbsOrigin", fPos);
    if(bKillCaseSound)
    {
        EmitSoundToAll("weapons/hegrenade/explode3.wav", iEntCaseData[activator][0], SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, fPos);
	}	
	
	if(bEnableBoom)
	{
        TE_SetupExplosion(fPos, iExplode, 10.0, 1, 0, 275, 160);
        TE_SendToAll();	
	}

    AcceptEntityInput(iEntCaseData[activator][0], "Kill");

    if(hTimers[activator][3] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[activator][3]);
        hTimers[activator][3] = null;
    }

    for(int i = 0;i <= 4; i++) 
    {
        iEntCaseData[activator][i] = -1;        
    }

    iReward[activator] = -1;
	
	bVarn[activator] = false;
    return Plugin_Continue;
}

void NullClient(int client) 
{
    if(hTimers[client][0] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][0]);
        hTimers[client][0] = null;
    }

    if(hTimers[client][1] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][1]);
        hTimers[client][1] = null;
    }

    if(hTimers[client][2] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][2]);
        hTimers[client][2] = null;
    }

    if(hTimers[client][3] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][3]);
        hTimers[client][3] = null;
    }
	
	if(hTimers[client][4] != INVALID_HANDLE) 
    {
        KillTimer(hTimers[client][4]);
        hTimers[client][4] = null;
    }

    for(int i = 0;i <= 4; i++) 
    {
        iEntCaseData[client][i] = -1;
    }

    iReward[client] = -1;
	
	bVarn[client] = false;
}

public void PrintToHintScrolling(client) 
{
	int Random; 
#if ((defined _levelsranks_included_ || defined _fire_players_stats_included) && !defined _vip_core_included)
    Random = GetRandomInt(0,1);
#elseif (!(defined _levelsranks_included_ || defined _fire_players_stats_included) && defined _vip_core_included)
	Random = GetRInt()
#else 
	Random = GetRandomInt(0,2);
#endif
    switch(Random) 
    {
        case 0: PrintHintText(client, "%t", "credits_scroll", sColor[0], GetRandomInt(iMinCredits,iMaxCredits));
#if defined _levelsranks_included_ || defined _fire_players_stats_included
        case 1: 
        {
			if(bGiveExp) PrintHintText(client, "%t", "exp_scroll", sColor[0], GetRandomInt(iMinExp,iMaxExp));
			else PrintHintText(client, "%t", "credits_scroll", sColor[0], GetRandomInt(iMinCredits,iMaxCredits));
		}
#endif
#if defined _vip_core_included
        case 2: 
        {
			if(bGiveVIP) 
            {
				char buffer[32];
				hArrayList.GetString(GetRandomInt(0,hArrayList.Length - 1), buffer,sizeof(buffer));
				PrintHintText(client, "%t", "vip_scroll", sColor[0], buffer);			
			}
			else PrintHintText(client, "%t", "credits_scroll", sColor[0], GetRandomInt(iMinCredits,iMaxCredits));
        }
#endif
    }
}

stock int GetRInt()
{
	if(GetRandomInt(0,100) > 50) return 2;
	return 0
}

public Action Hook_GiftStartTouch(int iEntity, int activator) 
{
	if(iEntCaseData[activator][1] == iEntity && iEntity > MaxClients) 
	{
		if (activator > 0 && activator <= MaxClients) 
		{
			char sTime[32];
			FormatTime(sTime, sizeof(sTime), "%X", GetTime());

			switch (iReward[activator]) 
			{
				case 0: 
				{
					Shop_GiveClientCredits(activator, iEntCaseData[activator][4], CREDITS_BY_NATIVE);
					if(bCaseMessages)
					{
						if(bPrintAll) CGOPrintToChatAll("%t%t", "prefix", "received_credits_all", activator, iEntCaseData[activator][4]);
						else CGOPrintToChat(activator, "%t%t", "prefix", "received_credits", iEntCaseData[activator][4]);
					}
					LogMessage("[CASEOPENER] The player %N received %i credits", activator, iEntCaseData[activator][4]);
					if(bDropLog) LogToFileEx(sLog, "[ %s ] The player %N got %i credits ", sTime, activator, iEntCaseData[activator][4]);
				}
#if defined _levelsranks_included_ || defined _fire_players_stats_included
				case 1: 
				{
					if(bGiveExp) 
					{	
#if defined _levelsranks_included_ || !defined _fire_players_stats_included
                        LR_ChangeClientValue(activator, iEntCaseData[activator][4]);
#elseif !defined _levelsranks_included_ || defined _fire_players_stats_included
						FPS_SetPoints(activator, float(iEntCaseData[activator][4]), false);
#endif
						if(bCaseMessages) 
						{   
							if(bPrintAll) CGOPrintToChatAll("%t%t", "prefix", "received_exp_all", activator, iEntCaseData[activator][4]);
							else CGOPrintToChat(activator, "%t%t", "prefix", "received_exp", iEntCaseData[activator][4]);
						}
						LogMessage("[CASEOPENER] The player %N received %i experience", activator, iEntCaseData[activator][4]);
						if(bDropLog) LogToFileEx(sLog, "[ %s ] The player %N got %i experience ", sTime, activator, iEntCaseData[activator][4]);
					}
					else 
					{
						Shop_GiveClientCredits(activator, iEntCaseData[activator][4], CREDITS_BY_NATIVE);
						if(bCaseMessages) 
						{
							if(bPrintAll) CGOPrintToChatAll("%t%t", "prefix", "received_credits_all", activator, iEntCaseData[activator][4]);
							else CGOPrintToChat(activator, "%t%t", "prefix", "received_credits", iEntCaseData[activator][4]);
						}
						LogMessage("[CASEOPENER] The player %N received %i credits", activator, iEntCaseData[activator][4]);
						if(bDropLog) LogToFileEx(sLog, "[ %s ] The player %N got %i credits ", sTime, activator, iEntCaseData[activator][4]);
					}
				}
#endif
#if defined _vip_core_included
				case 2: 
				{
					if(bGiveVIP) 
					{
						if(!VIP_IsClientVIP(activator)) 
						{
							char buffer[32];
							hArrayList.GetString(iEntCaseData[activator][4], buffer,sizeof(buffer));
							VIP_GiveClientVIP(0, activator, iTimeGiveVip, buffer, true);
							if(bCaseMessages) 
							{
								if(bPrintAll) CGOPrintToChatAll("%t%t", "prefix", "got_vip_all", activator, buffer, iTimeGiveVip/3600%24);
							}
							LogMessage("[CASEOPENER] The player %N received a privilege: %s", activator, buffer);
							if(bDropLog) LogToFileEx(sLog, "[ %s ] The player %N got %s for %i hours ", sTime, activator, buffer, iTimeGiveVip/3600%24);
						}
						else 
						{
							if(bCaseMessages) 
							{
								if(bPrintAll) CGOPrintToChatAll("%t%t", "prefix", "nothing", activator);
								else CGOPrintToChat(activator, "%t%t", "prefix", "already_has_vip");
							}
							LogMessage("[CASEOPENER] The player %N already has vip", activator);
						}					
					}
					else 
					{
						Shop_GiveClientCredits(activator, iEntCaseData[activator][4], CREDITS_BY_NATIVE);
						if(bCaseMessages)
						{
							if(bPrintAll) CGOPrintToChatAll("%t%t", "prefix", "received_credits_all", activator, iEntCaseData[activator][4]);
							else CGOPrintToChat(activator, "%t%t", "prefix", "received_credits", iEntCaseData[activator][4]);
						}
						LogMessage("[CASEOPENER] The player %N received %i credits", activator, iEntCaseData[activator][4]);
						if(bDropLog) LogToFileEx(sLog, "[ %s ] The player %N got %i credits ", sTime, activator, iEntCaseData[activator][4]);
					}
				}
#endif
			}
			EmitSoundToClient(activator, "ui/panorama/music_equip_01.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR);
			if(bStartCounter)
            {
                char sQuery[256], auth[22];
                GetClientAuthId(activator, AuthId_Steam2, auth, sizeof(auth));
                FormatEx(sQuery, sizeof(sQuery), "SELECT * FROM `opener_base` WHERE `steam`='%s'", auth);
                SQL_LockDatabase(gDatabase);
                DBResultSet result = SQL_Query(gDatabase, sQuery);
                SQL_UnlockDatabase(gDatabase);
                if(result != INVALID_HANDLE) 
                {
                    if(result.HasResults) 
                    {
                        if(result.RowCount > 0) 
                        {
                            int time = GetTime();
                            FormatEx(sQuery, sizeof(sQuery), "UPDATE `opener_base` SET `available`='0', `last_open`='%i' WHERE `steam`='%s'", time, auth);
                            SQL_Query(gDatabase, sQuery);                
                        }
                    }                
                }
                delete result;                   
            }
     
			if(IsValidEdict(iEntCaseData[activator][1])) 
			{
				iEntCaseData[activator][2] = GetEntPropEnt(iEntCaseData[activator][1], Prop_Send, "m_hEffectEntity");
				if(iEntCaseData[activator][2] && IsValidEdict(iEntCaseData[activator][2])) AcceptEntityInput(iEntCaseData[activator][2], "Kill");
				AcceptEntityInput(iEntCaseData[activator][1], "Kill");
				hTimers[activator][3] = CreateTimer(float(iCaseKillTimer), OnTouchDelete, activator, TIMER_FLAG_NO_MAPCHANGE);
			}  
		}
	}
	else if(bCaseMessages) 
	{
		if(!bVarn[activator]) 
		{
			CGOPrintToChat(activator, "%t%t", "prefix", "not_your_case");
			bVarn[activator] = true;
		}
	}
    return Plugin_Continue;
}
