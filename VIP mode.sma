#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <amxmisc>
#include <fun>
#include <colorchat>

#define PLUGIN_NAME "Vipy DeathRun"
#define PLUGIN_AUTHOR ".minD"
#define PLUGIN_VERSION "0.1"

static const COLOR[] = "^x04"
static const CONTACT[] = "GG: 2257420"

new maxplayers
new gmsgSayText

public plugin_init()
{
register_plugin(PLUGIN_NAME, PLUGIN_AUTHOR, PLUGIN_VERSION);

register_event("ResetHUD","event_reset_hud","be");
register_event("ResetHUD", "resetModel", "b")
register_clcmd("say /vip","admin_motd",0,"- Shows the MOTD.")

register_clcmd("say", "handle_say")
register_cvar("amx_contactinfo", CONTACT, FCVAR_SERVER)
gmsgSayText = get_user_msgid("SayText")

maxplayers = get_maxplayers()

return PLUGIN_CONTINUE

}

public plugin_precache() {
precache_model("models/player/smith/smith.mdl")
precache_model("models/player/smith/smith.mdl")

return PLUGIN_CONTINUE
}

public resetModel(id, level, cid) {
if (get_user_flags(id) & ADMIN_CVAR) {
new CsTeams:userTeam = cs_get_user_team(id)
if (userTeam == CS_TEAM_T) {
cs_set_user_model(id, "smith")
}
else if(userTeam == CS_TEAM_CT) {
cs_set_user_model(id, "smith")
}
else {
cs_reset_user_model(id)
}
}

return PLUGIN_CONTINUE
}


public event_reset_hud(id)
{
if(!is_user_connected(id))
return PLUGIN_CONTINUE;

ColorChat(id,  GREEN, "^x04 [VIP] ^x01 Napisz /vip na czacie by zobaczyc przywileje VIP'a.")

if(!access(id,ADMIN_CVAR))
return PLUGIN_CONTINUE;

set_task(1.0,"give_stuff",id);

return PLUGIN_CONTINUE;
}

public admin_motd(id,level,cid) {

	if (!cmd_access(id,level,cid,1))
	return PLUGIN_CONTINUE
	
	show_motd(id,"vip.txt","VIP'y")
	return PLUGIN_CONTINUE   
}



public give_stuff(id)
{
if(!is_user_connected(id))
return;

   fm_give_item(id, "item_assaultsuit");
   fm_give_item(id, "weapon_flashbang");
   fm_give_item(id, "weapon_flashbang");
   fm_give_item(id, "weapon_hegrenade");
   fm_give_item(id, "weapon_smokegrenade");
   cs_set_user_money(id, cs_get_user_money(id) + 500); 
   set_user_health (id, 135)
   set_user_armor (id, 100)
   set_user_gravity (id, 0.75);
}

public handle_say(id)
{
	new said[192]
	read_args(said,192)
	if(( containi(said, "who") != -1 && containi(said, "admin") != -1) || contain(said, "/vips") != -1)
		set_task(0.1,"print_viplist", id)
	return PLUGIN_CONTINUE
}

public print_viplist(user) 
{
	new adminnames[33][32]
	new message[256]
	new contactinfo[256], contact[112]
	new id, count, x, len
	
	for(id = 1 ; id <= maxplayers ; id++)
		if(is_user_connected(id))
			if(get_user_flags(id) & ADMIN_CVAR)
				get_user_name(id, adminnames[count++], 31)

	len = format(message, 255, "%s VIP'y na serwerze: ",COLOR)
	if(count > 0) {
		for(x = 0 ; x < count ; x++) {
			len += format(message[len], 255-len, "%s%s ", adminnames[x], x < (count-1) ? ", ":"")
			if(len > 96 ) {
				print_message(user, message)
				len = format(message, 255, "%s ",COLOR)
			}
		}
		print_message(user, message)
	}
	else {
		len += format(message[len], 255-len, "Brak VIP'ow na serwerze.")
		print_message(user, message)
	}

	get_cvar_string("amx_contactinfo", contact, 63)
	if(contact[0])  {
		format(contactinfo, 111, "%s Kontakt z Head Adminem serwera -  %s", COLOR, contact)
		print_message(user, contactinfo)
	}
}

print_message(id, msg[])
{
	message_begin(MSG_ONE, gmsgSayText, {0,0,0}, id)
	write_byte(id)
	write_string(msg)
	message_end()
}