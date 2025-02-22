/datum/ailment
	var/name                      // Descriptive name, primarily used for adminbus.
	var/timer_id                  // Current timer waiting to proc next symptom message.
	var/min_time = 2 MINUTES      // Minimum time between symptom messages.
	var/max_time = 5 MINUTES      // Maximum time between symptom messages.
	var/category = /datum/ailment // Used similar to hierarchies, if category == type then the
	                              // ailment is a category and won't be applied to organs.
	var/obj/item/organ/organ      // Organ associated with the ailment (ailment is in organ.ailments list).

	// Requirements before applying to a target.
	var/list/applies_to_organ         // What organ tags (BP_HEAD, etc) is the ailment valid for?
	var/affects_robotics = FALSE      // Does the ailment affect prosthetics specifically or flesh?
	var/specific_organ_subtype = /obj/item/organ/external // What organ subtype, if any, does the ailment apply to?

	// Treatment types
	var/treated_by_item_type                // What item type can be used in physical interaction to cure the ailment?
	var/treated_by_item_cost = 1            // If treated_by_item_type is a stack, how many should be used?
	var/treated_by_reagent_type             // What reagent type cures this ailment when metabolized?
	var/treated_by_reagent_dosage = 1       // What is the minimum dosage for a reagent to cure this ailment?
	var/treated_by_chem_effect              // What chemical effect cures this ailment?
	var/treated_by_chem_effect_strength = 1 // How strong must the chemical effect be to cure this ailment?

	// Fluff strings
	var/initial_ailment_message = "Your $ORGAN$ $ORGAN_DOES$n't feel quite right..."        // Shown in New()
	var/third_person_treatment_message = "$USER$ treats $TARGET$'s ailment with $ITEM$."    // Shown when treating other with an item.
	var/self_treatment_message = "$USER$ treats $USER_HIS$ ailment with $ITEM$."            // Shown when treating self with an item.
	var/medication_treatment_message = "Your ailment abates."                               // Shown when treated by a metabolized reagent or CE_X effect.
	var/manual_diagnosis_string  /* ex: "$USER_HIS$ $ORGAN$ has something wrong with it" */ // Shown when grab-diagnosed by a doctor. Leave null to be undiagnosable.
	var/scanner_diagnosis_string /* ex: "Significant swelling" */                           // Shown on the handheld and body scanners. Leave null to be undiagnosable.

/datum/ailment/New(var/obj/item/organ/_organ)
	..()
	if(_organ)
		organ = _organ
		if(organ.owner)
			to_chat(organ.owner, SPAN_WARNING(replace_tokens(initial_ailment_message)))
			begin_ailment_event()

/datum/ailment/proc/can_apply_to(var/obj/item/organ/_organ)
	if(specific_organ_subtype && !istype(_organ, specific_organ_subtype))
		return FALSE
	if(affects_robotics != !!(BP_IS_PROSTHETIC(_organ)))
		return FALSE
	if(length(applies_to_organ) && !(_organ?.organ_tag in applies_to_organ))
		return FALSE
	return TRUE

/datum/ailment/Destroy()
	if(organ)
		LAZYREMOVE(organ.ailments, src)
		organ = null
	. = ..()

/datum/ailment/proc/begin_ailment_event()
	if(!organ?.owner)
		return
	timer_id = addtimer(CALLBACK(src, .proc/do_malfunction), rand(min_time, max_time), TIMER_STOPPABLE | TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

/datum/ailment/proc/do_malfunction()
	if(!organ?.owner)
		timer_id = null
		return
	begin_ailment_event()
	on_ailment_event()

/datum/ailment/proc/on_ailment_event()
	return

/datum/ailment/proc/treated_by_item(var/obj/item/treatment)
	return treated_by_item_type && istype(treatment, treated_by_item_type)

/datum/ailment/proc/replace_tokens(var/message, var/obj/item/treatment, var/mob/user, var/mob/target)
	. = message
	if(treatment)
		. = replacetext(., "$ITEM$", "\the [treatment]")
	if(user)
		var/decl/pronouns/G = user.get_pronouns()
		. = replacetext(., "$USER$", "\the [user]")
		. = replacetext(., "$USER_HIS$", G.his)
	if(target)
		. = replacetext(., "$TARGET$", "\the [target]")
	if(organ)
		. = replacetext(., "$ORGAN$", organ.name)
		var/decl/pronouns/organ_pronouns = get_pronouns_by_gender(organ.gender)
		. = replacetext(., "$ORGAN_DOES$", organ_pronouns.does)
		. = replacetext(., "$ORGAN_IS$", organ_pronouns.is)
	. = capitalize(trim(.))

/datum/ailment/proc/was_treated_by_item(var/obj/item/treatment, var/mob/user, var/mob/target)
	var/show_message
	if(user == target && self_treatment_message)
		show_message = self_treatment_message
	else
		show_message = third_person_treatment_message
	if(!show_message)
		return

	user.visible_message(SPAN_NOTICE(replace_tokens(show_message, treatment, user, target)))

	if(istype(treatment, /obj/item/stack))
		var/obj/item/stack/stack = treatment
		stack.use(treated_by_item_cost)
	qdel(src)

/datum/ailment/proc/treated_by_medication(var/reagent_type, var/dosage)
	return treated_by_reagent_type && ispath(reagent_type, treated_by_reagent_type) && dosage >= treated_by_reagent_dosage

/datum/ailment/proc/was_treated_by_medication(var/datum/reagents/source, var/reagent_type)
	source.remove_reagent(reagent_type, treated_by_reagent_dosage)
	to_chat(organ.owner, SPAN_NOTICE(replace_tokens(medication_treatment_message)))
	qdel(src)

/datum/ailment/proc/was_treated_by_chem_effect()
	to_chat(organ.owner, SPAN_NOTICE(replace_tokens(medication_treatment_message)))
	qdel(src)
