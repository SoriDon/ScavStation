//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon = 'icons/mob/simple_animal/cat_calico.dmi'
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	holder_type = /obj/item/holder
	mob_size = MOB_SIZE_SMALL
	possession_candidate = 1
	pass_flags = PASS_FLAG_TABLE
	skin_material = /decl/material/solid/skin/fur/orange
	base_animal_type = /mob/living/simple_animal/cat

	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/mob/flee_target

/mob/living/simple_animal/cat/Initialize()
	if(isnull(hat_offsets))
		hat_offsets = list(
			"[NORTH]" = list( 1,  -9),
			"[SOUTH]" = list( 1, -12),
			"[EAST]" =  list( 7, -10),
			"[WEST]" =  list(-7, -10)
		)
	. = ..()

/mob/living/simple_animal/cat/do_delayed_life_action()
	..()
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(!M.stat)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
					movement_target = null
					stop_automated_movement = 0
					break

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hisses and spits!","mrowls fiercely!","eyes [snack] hungrily."))
		break

	turns_since_scan++
	if (turns_since_scan > 5)
		walk_to(src,0)
		turns_since_scan = 0

		if (flee_target) //fleeing takes precendence
			handle_flee_target()
		else
			handle_movement_target()

	if(prob(2)) //spooky
		var/mob/observer/ghost/spook = locate() in range(src,5)
		if(spook)
			var/turf/T = spook.loc
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

/mob/living/simple_animal/cat/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		stop_automated_movement = 0
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		stop_automated_movement = 0
		for(var/mob/living/simple_animal/mouse/snack in oview(src)) //search for a new target
			if(isturf(snack.loc) && !snack.stat)
				movement_target = snack
				break

	if(movement_target)
		stop_automated_movement = 1
		walk_to(src,movement_target,0,3)

/mob/living/simple_animal/cat/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target.loc in view(src)))
		flee_target = null
		stop_automated_movement = 0

	if (flee_target)
		if(prob(25)) say("HSSSSS")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/cat/proc/set_flee_target(atom/A)
	if(A)
		flee_target = A
		turns_since_scan = 5

/mob/living/simple_animal/cat/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		set_flee_target(user? user : src.loc)

/mob/living/simple_animal/cat/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		set_flee_target(user)

/mob/living/simple_animal/cat/explosion_act()
	. = ..()
	set_flee_target(src.loc)

/mob/living/simple_animal/cat/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	set_flee_target(isliving(proj.firer) ? proj.firer : src.loc)

/mob/living/simple_animal/cat/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	set_flee_target(TT.thrower? TT.thrower : src.loc)

/mob/living/simple_animal/cat/harvest_skin()
	. = ..()
	. += new/obj/item/cat_hide(get_turf(src))

/obj/item/cat_hide
	name = "cat hide"
	desc = "The by-product of cat farming."
	icon = 'icons/obj/items/sheet_hide.dmi'
	icon_state = "sheet-cat"
	material = /decl/material/solid/leather/fur

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/cat/fluff/handle_movement_target()
	if (!QDELETED(friend))
		var/follow_dist = 4
		if (friend.stat >= DEAD || friend.is_asystole()) //danger
			follow_dist = 1
		else if (friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if (movement_target != friend)
			if (current_dist > follow_dist && !istype(movement_target, /mob/living/simple_animal/mouse) && (friend in oview(src)))
				//stop existing movement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to friend
				stop_automated_movement = 1
				movement_target = friend
				walk_to(src, movement_target, near_dist, 4)

		//already following and close enough, stop
		else if (current_dist <= near_dist)
			walk_to(src,0)
			movement_target = null
			stop_automated_movement = 0
			if (prob(10))
				say("Meow!")

	if (QDELETED(friend) || movement_target != friend)
		..()

/mob/living/simple_animal/cat/fluff/do_delayed_life_action()
	..()
	if (stat || QDELETED(friend))
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.is_asystole())
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "purrs."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/cat/fluff/verb/become_friends()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(!friend)
		var/mob/living/carbon/human/H = usr
		if(istype(H) && (!befriend_job || H.job == befriend_job))
			friend = usr
			. = 1
	else if(usr == friend)
		. = 1 //already friends, but show success anyways

	if(.)
		set_dir(get_dir(src, friend))
		visible_emote(pick("nuzzles [friend].",
						   "brushes against [friend].",
						   "rubs against [friend].",
						   "purrs."))
	else
		to_chat(usr, "<span class='notice'>[src] ignores you.</span>")
	return

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon = 'icons/mob/simple_animal/cat_black.dmi'
	skin_material = /decl/material/solid/skin/fur/black
	holder_type = /obj/item/holder/runtime

/obj/item/holder/runtime
	origin_tech = "{'programming':1,'biotech':1}"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon = 'icons/mob/simple_animal/kitten.dmi'
	gender = NEUTER
	meat_amount = 1
	bone_amount = 3
	skin_amount = 3

/mob/living/simple_animal/cat/kitten/Initialize()
	if(isnull(hat_offsets))
		hat_offsets = list(
			"[NORTH]" = list( 1, -14),
			"[SOUTH]" = list( 1, -14),
			"[EAST]" =  list( 5, -14),
			"[WEST]" =  list(-5, -14)
		)
	. = ..()
	gender = pick(MALE, FEMALE)

/mob/living/simple_animal/cat/fluff/ran
	name = "Rantime"
	desc = "Her full name is Ran Ste-Su G'Mindel Time. Under no circumstances is this feline allowed inside the atmospherics system."
	gender = FEMALE
	holder_type = /obj/item/holder/runtime
