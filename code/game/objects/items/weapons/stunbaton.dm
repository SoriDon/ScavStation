//replaces our stun baton code with /tg/station's code
/obj/item/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon = 'icons/obj/items/weapon/stunbaton.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	force = 15
	sharp = 0
	edge = 0
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':2}"
	attack_verb = list("beaten")
	base_parry_chance = 30
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/plastic      = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon      = MATTER_AMOUNT_REINFORCEMENT,
	)
	item_flags = ITEM_FLAG_IS_WEAPON
	var/stunforce = 0
	var/agonyforce = 30
	var/status = 0		//whether the thing is on or not
	var/obj/item/cell/bcell
	var/hitcost = 7

/obj/item/baton/loaded
	bcell = /obj/item/cell/device/high

/obj/item/baton/Initialize(var/ml)
	. = ..(ml)
	if(ispath(bcell))
		bcell = new bcell(src)
		update_icon()

/obj/item/baton/Destroy()
	if(bcell && !ispath(bcell))
		qdel(bcell)
		bcell = null
	return ..()

/obj/item/baton/get_cell()
	return bcell

/obj/item/baton/proc/update_status()
	if(bcell.charge < hitcost)
		status = 0
		update_icon()

/obj/item/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			update_status()
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/baton/on_update_icon()
	. = ..()
	if(status)
		add_overlay("[icon_state]-active")
		set_light(1.5, 2, "#ff6a00")
	else
		if(!bcell)
			add_overlay("[icon_state]-nocell")
		set_light(0)

/obj/item/baton/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		examine_cell(user)

// Addition made by Techhead0, thanks for fullfilling the todo!
/obj/item/baton/proc/examine_cell(mob/user)
	if(bcell)
		to_chat(user, "<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>")
	if(!bcell)
		to_chat(user, "<span class='warning'>The baton does not have a power source installed.</span>")

/obj/item/baton/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell/device))
		if(!bcell && user.try_unequip(W))
			W.forceMove(src)
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell into the [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
	else if(IS_SCREWDRIVER(W))
		if(bcell)
			bcell.update_icon()
			bcell.dropInto(loc)
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			status = 0
			update_icon()
	else
		..()

/obj/item/baton/attack_self(mob/user)
	set_status(!status, user)
	add_fingerprint(user)

/obj/item/baton/proc/set_status(var/newstatus, mob/user)
	if(bcell && bcell.charge >= hitcost)
		if(status != newstatus)
			change_status(newstatus)
			to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
			playsound(loc, "sparks", 75, 1, -1)
	else
		change_status(0)
		if(!bcell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user,  "<span class='warning'>[src] is out of charge.</span>")

// Proc to -actually- change the status, and update the icons as well.
// Also exists to ease "helpful" admin-abuse in case an bug prevents attack_self
// to occur would appear. Hopefully it wasn't necessary.
/obj/item/baton/proc/change_status(var/s)
	if (status != s)
		status = s
		update_icon()

/obj/item/baton/attack(mob/M, mob/user)
	if(status && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='danger'>You accidentally hit yourself with the [src]!</span>")
		SET_STATUS_MAX(user, STAT_WEAK, 30)
		deductcharge(hitcost)
		return
	return ..()

/obj/item/baton/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		affecting = GET_EXTERNAL_ORGAN(H, hit_zone)
	var/abuser =  user ? "" : "by [user]"
	if(user && user.a_intent == I_HURT)
		. = ..()
		if(.)
			return

		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		else
			agony = 0	//Shouldn't really stun if it's off, should it?
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else if(!status)
		if(affecting)
			target.visible_message("<span class='warning'>[target] has been prodded in the [affecting.name] with [src][abuser]. Luckily it was off.</span>")
		else
			target.visible_message("<span class='warning'>[target] has been prodded with [src][abuser]. Luckily it was off.</span>")
	else
		if(affecting)
			target.visible_message("<span class='danger'>[target] has been prodded in the [affecting.name] with [src]!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been prodded with [src][abuser]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	//stun effects
	if(status)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")
		deductcharge(hitcost)

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.forcesay(global.hit_appends)

	return 1

/obj/item/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

// Stunbaton module for Security synthetics
/obj/item/baton/robot
	bcell = null
	hitcost = 20

// Addition made by Techhead0, thanks for fullfilling the todo!
/obj/item/baton/robot/examine_cell(mob/user)
	to_chat(user, "<span class='notice'>The baton is running off an external power supply.</span>")

// Override proc for the stun baton module, found in PC Security synthetics
// Refactored to fix #14470 - old proc defination increased the hitcost beyond
// usability without proper checks.
// Also hard-coded to be unuseable outside their righteous synthetic owners.
/obj/item/baton/robot/attack_self(mob/user)
	var/mob/living/silicon/robot/R = isrobot(user) ? user : null // null if the user is NOT a robot
	update_cell(R) // takes both robots and null
	if (R)
		return ..()
	else	// Stop pretending and get out of your cardborg suit, human.
		to_chat(user, "<span class='warning'>You don't seem to be able interacting with this by yourself..</span>")
		add_fingerprint(user)
	return 0

/obj/item/baton/robot/attackby(obj/item/W, mob/user)
	return

/obj/item/baton/robot/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	update_cell(isrobot(user) ? user : null) // update the status before we apply the effects
	return ..()

// Updates the baton's cell to use user's own cell
// Otherwise, if null (when the user isn't a robot), render it unuseable
/obj/item/baton/robot/proc/update_cell(mob/living/silicon/robot/user)
	if (!user)
		bcell = null
		set_status(0)
	else if (!bcell || bcell != user.cell)
		bcell = user.cell // if it is null, nullify it anyway

// Traitor variant for Engineering synthetics.
/obj/item/baton/robot/electrified_arm
	name = "electrified arm"
	icon = 'icons/obj/items/borg_module/electrified_arm.dmi'
	icon_state = "electrified_arm"

/obj/item/baton/robot/electrified_arm/on_update_icon()
	. = ..()
	if(status)
		icon_state = "electrified_arm_active"
		set_light(1.5, 2, "#006aff")
	else
		icon_state = "electrified_arm"
		set_light(0)

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon = 'icons/obj/items/weapon/stunprod.dmi'
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 25
	attack_verb = list("poked")
	slot_flags = null
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_TRACE, /decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE)