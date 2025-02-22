//Common breathing procs

#define MOB_BREATH_DELAY 2

//Start of a breath chain, calls breathe()
/mob/living/carbon/handle_breathing()
	if((life_tick - last_breath_tick >= MOB_BREATH_DELAY) || failed_last_breath || is_asystole())
		breathe()

/mob/living/carbon/proc/breathe(var/active_breathe = 1)
	last_breath_tick = life_tick

	if(!need_breathe()) return

	if(stat != CONSCIOUS && holding_breath)
		holding_breath = (holding_breath >= 2 ? 3 : 0)

	if(holding_breath == 3)
		holding_breath = 0
		handle_post_breath(breath)

	//First, check if we can breathe at all
	if(handle_drowning() || (is_asystole() && !GET_CHEMICAL_EFFECT(src, CE_STABLE) && active_breathe)) //crit aka circulatory shock
		losebreath = max(2, losebreath + 1)

	if(losebreath>0) //Suffocating so do not take a breath
		losebreath--
		if (prob(10) && !is_asystole() && active_breathe) //Gasp per 10 ticks? Sounds about right.
			INVOKE_ASYNC(src, .proc/emote, "gasp")
	else if(holding_breath < 2 || !breath)
		//Okay, we can breathe, now check if we can get air
		var/volume_needed = get_breath_volume()
		breath = get_breath_from_internal(volume_needed) //First, check for air from internals
		if(!breath)
			breath = get_breath_from_environment(volume_needed) //No breath from internals so let's try to get air from our location
		if(!breath)
			var/static/datum/gas_mixture/vacuum //avoid having to create a new gas mixture for each breath in space
			if(!vacuum) vacuum = new

			breath = vacuum //still nothing? must be vacuum

	handle_breath(breath)
	if(holding_breath == 1)
		holding_breath = 2
	handle_post_breath(breath)

/mob/living/carbon/proc/get_breath_from_internal(var/volume_needed=STD_BREATH_VOLUME) //hopefully this will allow overrides to specify a different default volume without breaking any cases where volume is passed in.
	if(internal)
		if (!contents.Find(internal))
			set_internals(null)
		var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
		if (!mask || !(mask.item_flags & ITEM_FLAG_AIRTIGHT))
			set_internals(null)
		if(internal)
			if (internals)
				internals.icon_state = "internal1"
			return internal.remove_air_volume(volume_needed)
		else
			if (internals)
				internals.icon_state = "internal0"
	return null

/mob/living/carbon/proc/get_breath_from_environment(var/volume_needed=STD_BREATH_VOLUME, var/atom/location = src.loc)
	if(volume_needed <= 0)
		return
	var/datum/gas_mixture/breath = null

	var/datum/gas_mixture/environment
	if(location)
		environment = location.return_air()

	if(environment)
		breath = environment.remove_volume(volume_needed)
		handle_chemical_smoke(environment) //handle chemical smoke while we're at it

	if(breath && breath.total_moles)
		//handle mask filtering
		var/obj/item/clothing/mask/M = get_equipped_item(slot_wear_mask_str)
		if(istype(M) && breath)
			var/datum/gas_mixture/filtered = M.filter_air(breath)
			location.assume_air(filtered)
		return breath
	return null

//Handle possble chem smoke effect
/mob/living/carbon/proc/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(species && environment.return_pressure() < species.breath_pressure/5)
		return //pressure is too low to even breathe in.
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	if(mask && (mask.item_flags & ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT))
		return

	for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.total_volume)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INGEST, copy = 1)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INJECT, copy = 1)
			// I dunno, maybe the reagents enter the blood stream through the lungs?
			break // If they breathe in the nasty stuff once, no need to continue checking

/mob/living/carbon/proc/get_breath_volume()
	return STD_BREATH_VOLUME

/mob/living/carbon/proc/handle_breath(datum/gas_mixture/breath)
	return

/mob/living/carbon/proc/handle_post_breath(datum/gas_mixture/breath)
	if(holding_breath)
		return
	if(breath)
		//by default, exhale
		var/datum/gas_mixture/internals_air = internal?.return_air()
		var/datum/gas_mixture/loc_air = loc?.return_air()
		if(internals_air && (internals_air.return_pressure() < loc_air.return_pressure())) // based on the assumption it has a one-way valve for gas release
			internals_air?.merge(breath)
		else
			loc_air?.merge(breath)
