/obj/item/flame/candle
	name = "candle"
	desc = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = ITEM_SIZE_TINY
	light_color = "#e09d37"

	var/available_colours = list(COLOR_WHITE, COLOR_DARK_GRAY, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)
	var/wax
	var/last_lit
	var/icon_set = "candle"
	var/candle_range = CANDLE_LUM
	var/candle_power

/obj/item/flame/candle/Initialize()
	wax = rand(27 MINUTES, 33 MINUTES) / SSobj.wait // Enough for 27-33 minutes. 30 minutes on average, adjusted for subsystem tickrate.
	if(available_colours)
		color = pick(available_colours)
	. = ..()

/obj/item/flame/candle/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	//#FIXME: Candles handle their lit overlays weirdly
	switch(wax)
		if(1500 to INFINITY)
			icon_state = "[icon_set]1"
		if(800 to 1500)
			icon_state = "[icon_set]2"
		else
			icon_state = "[icon_set]3"

	if(lit != last_lit)
		last_lit = lit
		cut_overlays()
		if(lit)
			add_overlay(overlay_image(icon, "[icon_state]_lit", flags = RESET_COLOR))

/obj/item/flame/candle/attackby(obj/item/W, mob/user)
	..()
	if(W.isflamesource() || W.get_heat() > T100C)
		light(user)

/obj/item/flame/candle/resolve_attackby(var/atom/A, mob/user)
	. = ..()
	if(istype(A, /obj/item/flame/candle) && lit)
		var/obj/item/flame/candle/other_candle = A
		other_candle.light()

/obj/item/flame/candle/light(mob/user, no_message)
	if(!lit)
		..()
		update_force()
		if(!no_message)
			user.visible_message(SPAN_NOTICE("\The [user] lights \the [src]."), SPAN_NOTICE("You light \the [src]."))
		set_light(candle_range, candle_power)
		START_PROCESSING(SSobj, src)

/obj/item/flame/candle/Process()
	if(!lit)
		return
	wax--
	if(!wax)
		var/obj/item/trash/candle/C = new(loc)
		C.color = color
		qdel(src)
		return
	update_icon()
	if(isturf(loc)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/flame/candle/attack_self(mob/user)
	if(lit)
		extinguish(user)
		update_icon()
		set_light(0)
		remove_extension(src, /datum/extension/scent)

/obj/item/storage/candle_box
	name = "candle pack"
	desc = "A pack of unscented candles in a variety of colours."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox"
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/cardboard

/obj/item/storage/candle_box/WillContain()
	return list(/obj/item/flame/candle = 7)