/mob/living/simple_animal/faithful_hound
	name = "spectral hound"
	desc = "A spooky looking ghost dog. Does not look friendly."
	icon = 'icons/mob/simple_animal/corgi_ghost.dmi'
	blend_mode = BLEND_SUBTRACT
	health = 100
	maxHealth = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	faction = MOB_FACTION_NEUTRAL
	density = 0
	stop_automated_movement = 1
	wander = 0
	anchored = 1
	faction = "cute ghost dogs"
	supernatural = 1

	var/password
	var/list/allowed_mobs = list() //Who we allow past us
	var/last_check = 0

/mob/living/simple_animal/faithful_hound/death()
	new /obj/item/ectoplasm (get_turf(src))
	..(null, "disappears!")
	qdel(src)

/mob/living/simple_animal/faithful_hound/Destroy()
	allowed_mobs.Cut()
	return ..()

/mob/living/simple_animal/faithful_hound/do_delayed_life_action()
	..()
	if(!stat && !client && world.time > last_check)
		last_check = world.time + 5 SECONDS
		var/aggressiveness = 0 //The closer somebody is to us, the more aggressive we are
		var/list/mobs = list()
		var/list/objs = list()
		get_mobs_and_objs_in_view_fast(get_turf(src),5, mobs, objs, 0)
		for(var/mob/living/m in mobs)
			if((m == src) || (m in allowed_mobs) || m.faction == faction)
				continue
			var/new_aggress = 1
			var/mob/living/M = m
			var/dist = get_dist(M, src)
			if(dist < 2) //Attack! Attack!
				var/attacking_with = get_natural_weapon()
				if(attacking_with)
					M.attackby(attacking_with, src)
				return .
			else if(dist == 2)
				new_aggress = 3
			else if(dist == 3)
				new_aggress = 2
			else
				new_aggress = 1
			aggressiveness = max(aggressiveness, new_aggress)
		switch(aggressiveness)
			if(1)
				src.audible_message("\The [src] growls.")
			if(2)
				src.audible_message("<span class='warning'>\The [src] barks threateningly!</span>")
			if(3)
				src.visible_message("<span class='danger'>\The [src] snaps at the air!</span>")

/mob/living/simple_animal/faithful_hound/hear_say(var/message, var/verb = "says", var/decl/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(password && findtext(message,password))
		allowed_mobs |= speaker
		spawn(10)
			src.visible_message("<span class='notice'>\The [src] nods in understanding towards \the [speaker].</span>")