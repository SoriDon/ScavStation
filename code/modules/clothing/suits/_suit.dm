/obj/item/clothing/suit
	name = "suit"
	icon = 'icons/clothing/suit/suit_jacket.dmi'
	icon_state = ICON_STATE_WORLD
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS
	allowed = list(/obj/item/tank/emergency)
	slot_flags = SLOT_OVER_BODY
	blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_OVER)
	var/protects_against_weather = FALSE
	var/fire_resist = T0C+100

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/suit/preserve_in_cryopod(var/obj/machinery/cryopod/pod)
	return TRUE

/obj/item/clothing/suit/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart, var/skip_offset = FALSE)
	if(overlay && item_state)
		overlay.icon_state = item_state
	. = ..()

/obj/item/clothing/suit/handle_shield()
	return FALSE

/obj/item/clothing/suit/proc/get_collar()
	var/icon/C = new('icons/mob/collar.dmi')
	if(icon_state in C.IconStates())
		var/image/I = image(C, icon_state)
		I.color = color
		return I