# A simple version of opening cases
***The plugin is a case model spawner that starts a timer before creating an entity simulating a reward.***
[^1]: It is a standalone plugin, on the basis of which I am currently writing a private(maybe public) CORE equal to WSGK.

The plugin supports mysql and sqlite. Before launching the plugin, make sure that the "case_opener" section is exist in the **addons/sourcemod/configs/database.cfg** configuration file:
```
"case_opener"
{
  "driver"      "mysql"
  "host"	"255.255.255.255"
  "database"	"dbname"
  "user"	"dbuser"
  "pass"	"password"
}
```
## Commands 
- **sm_case** - Case spawn
- **sm_reset_counter** - Reset counter for admins(ROOT)
## ConVars
The plugin has auto-generation of a configuration file as **CaseOpener.cfg** located on the path **cfg/sourcemod/** containing ConVars:
- **sm_opener_time_give_vip** - Time of VIP in seconds. 0 - forever.	**Default: 604700**
- **sm_opener_min_exp** - Minimum number of received experience.	**Default: 400**
- **sm_opener_max_exp** - Maximum number of received experience.	**Default: 1000**
- **sm_opener_time_before_next_open** - Time between case openings in seconds.	**Default: 604800**
- **sm_opener_open_anim_speed** - The animation speed of the case. It is configured together with sm_opener_open_speed.	**Default: 0.1**
- **sm_opener_open_speed** - Case opening speed. It is configured together with sm_opener_open_anim_speed.	**Default: 11.5**
- **sm_opener_open_speed_scroll** - Scroll speed.	**Default: 0.25**
- **sm_opener_min_credits** - Minimum number of credits received.	**Default: 500**
- **sm_opener_max_credits** - Maximum number of credits received.	**Default: 2500**
- **sm_opener_max_position_value** - The maximum distance to case spawn. Depends by sm_opener_max_position.	**Default: 3**
- **sm_opener_case_kill_time** - The time after which the case will disappear in seconds.	**Default: 3**
- **sm_opener_same_plat** - Spawn the case on the same plane with the owner.	**1 - Yes | 0 - No.**
- **sm_opener_kill_case_sound** - Turn on the sound of the case disappearing.	**1 - Yes | 0 - No.**
- **sm_opener_case_opening_sound** - Enable case opening sounds.	**1 - Yes | 0 - No.**
- **sm_opener_case_messages** - Enable chat messages.	**1 - Yes | 0 - No.**
- **sm_opener_case_messages_hint** - Enable messages in the hint.	**1 - Yes | 0 - No.**
- **sm_opener_case_access** - Access only for admins.	**1 - Yes | 0 - No.**
- **sm_opener_max_position** - Limit the spawn distance.	**1 - Yes | 0 - No.**
- **sm_opener_open_output_beam** - Display the maximum spawn radius.	**1 - Yes | 0 - No.**
- **sm_opener_freeze_open** - Freeze the player while opening the case.	**1 - Yes | 0 - No.**
- **sm_opener_give_vip** - Drop a VIP group.	**1 - Yes | 0 - No.**
- **sm_opener_give_exp** - Drop a experience.	**1 - Yes | 0 - No.**
- **sm_opener_reset_counter** - Allow admins to reset the counter.	**1 - Yes | 0 - No.**

**mark**: For exclusion the VIP-group should to has a prefixes < `_` > as first and last symbols. For example `_SUPER_`

But descs of ConVars inside plugin are will contain Russian lang bcz im is lazy :)

## Directory contents
- The necessary files for the plugin to work, as well as their .bz2 archives for fastdl
- The source file **CaseOpener.sp** with additional libraries for compilation and auxiliary files containing paths to sounds and models:
  - **csgo_colors.inc** - [CS:GO Color Library](https://hlmod.ru/threads/inc-cs-go-colors.46870/)
    - **lvl_ranks.inc** - Library of [LEVELS RANKS CORE](https://github.com/levelsranks/levels-ranks-core/tree/3.1.7B2)
      - **shop.inc** - Library of [SHOP CORE](https://github.com/hlmod/Shop-Core)
        - **vip_core.inc** - Library of [VIP CORE](https://github.com/R1KO/VIP-Core/releases)
- A translation file containing RU and EN langs

## About possible problems, please let me know: 
- Quake#2601 - DISCORD
- [HLMOD](https://hlmod.ru/members/palonez.92448/)
