/obj/machinery/suit_cycler/Initialize()
	LAZYDISTINCTADD(available_bodytypes, BODYTYPE_YINGLET)
	. = ..()

/obj/machinery/suit_cycler/tradeship
	boots = /obj/item/clothing/shoes/magboots
	req_access = list()

/obj/machinery/suit_cycler/tradeship/Initialize()
	if(prob(75))
		suit = pick(list(
			/obj/item/clothing/suit/space/void/mining,
			/obj/item/clothing/suit/space/void/engineering,
			/obj/item/clothing/suit/space/void/expedition,
			/obj/item/clothing/suit/space/void/excavation,
			/obj/item/clothing/suit/space/void/engineering/salvage
		))
	if(prob(75))
		helmet = pick(list(
			/obj/item/clothing/head/helmet/space/void/mining,
			/obj/item/clothing/head/helmet/space/void/engineering,
			/obj/item/clothing/head/helmet/space/void/expedition,
			/obj/item/clothing/head/helmet/space/void/excavation,
			/obj/item/clothing/head/helmet/space/void/engineering/salvage
		))
	. = ..()

/obj/item/clothing/suit/space/void/Initialize()
	. = ..()
	set_yinglet_sprite_override()

/obj/item/clothing/suit/space/void/proc/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/nasa/suit.dmi')

/obj/item/clothing/head/helmet/space/void/Initialize()
	. = ..()
	set_yinglet_sprite_override()

/obj/item/clothing/head/helmet/space/void/proc/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/nasa/helmet.dmi')

/obj/item/clothing/suit/space/void/merc/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/merc/suit.dmi')

/obj/item/clothing/head/helmet/space/void/merc/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/merc/helmet.dmi')

/obj/item/clothing/suit/space/void/swat/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/deathsquad/suit.dmi')

/obj/item/clothing/suit/space/void/engineering/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/engineering/suit.dmi')

/obj/item/clothing/head/helmet/space/void/engineering/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/engineering/helmet.dmi')

/obj/item/clothing/suit/space/void/mining/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/mining/suit.dmi')

/obj/item/clothing/head/helmet/space/void/mining/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/mining/helmet.dmi')

/obj/item/clothing/suit/space/void/medical/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/medical/suit.dmi')

/obj/item/clothing/head/helmet/space/void/medical/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/medical/helmet.dmi')

/obj/item/clothing/suit/space/void/security/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/sec/suit.dmi')

/obj/item/clothing/head/helmet/space/void/security/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/sec/helmet.dmi')

/obj/item/clothing/suit/space/void/atmos/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/atmos/suit.dmi')

/obj/item/clothing/head/helmet/space/void/atmos/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/atmos/helmet.dmi')

/obj/item/clothing/suit/space/void/engineering/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/engineering_alt/suit.dmi')

/obj/item/clothing/head/helmet/space/void/engineering/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/engineering_alt/helmet.dmi')

/obj/item/clothing/suit/space/void/mining/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/mining_alt/suit.dmi')

/obj/item/clothing/head/helmet/space/void/mining/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/mining_alt/helmet.dmi')

/obj/item/clothing/suit/space/void/medical/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/medical_alt/suit.dmi')

/obj/item/clothing/head/helmet/space/void/medical/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/medical_alt/helmet.dmi')

/obj/item/clothing/suit/space/void/security/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/sec_alt/suit.dmi')

/obj/item/clothing/head/helmet/space/void/security/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/sec_alt/helmet.dmi')

/obj/item/clothing/suit/space/void/atmos/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/atmos_alt/suit.dmi')

/obj/item/clothing/head/helmet/space/void/atmos/alt/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/atmos_alt/helmet.dmi')

/obj/item/clothing/suit/space/void/engineering/salvage/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/salvage/suit.dmi')

/obj/item/clothing/head/helmet/space/void/engineering/salvage/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/salvage/helmet.dmi')

/obj/item/clothing/suit/space/void/expedition/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/expedition/suit.dmi')

/obj/item/clothing/head/helmet/space/void/expedition/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/expedition/helmet.dmi')

/obj/item/clothing/suit/space/void/wizard/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/wizard/suit.dmi')

/obj/item/clothing/head/helmet/space/void/wizard/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/wizard/helmet.dmi')

/obj/item/clothing/suit/space/void/excavation/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/excavation/suit.dmi')

/obj/item/clothing/head/helmet/space/void/excavation/set_yinglet_sprite_override()
	LAZYSET(sprite_sheets, BODYTYPE_YINGLET, 'mods/valsalia/icons/clothing/suit/void/excavation/helmet.dmi')

/obj/item/clothing/suit/space/void/merc/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/merc/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/swat/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/engineering/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/engineering/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/mining/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/mining/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/medical/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/medical/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/security/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/security/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/atmos/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/atmos/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/engineering/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/engineering/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/mining/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/mining/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/medical/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/medical/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/security/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/security/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/atmos/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/atmos/alt/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/engineering/salvage/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/engineering/salvage/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/expedition/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/expedition/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/wizard/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/wizard/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/suit/space/void/excavation/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)

/obj/item/clothing/head/helmet/space/void/excavation/scav/Initialize()
	. = ..()
	refit_for_bodytype(BODYTYPE_YINGLET)
