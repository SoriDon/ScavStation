/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID card modification program"
	nanomodule_path = /datum/nano_module/program/card_mod
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for programming crew ID cards."
	size = 8
	write_access = list(access_change_ids)
	category = PROG_COMMAND

/datum/nano_module/program/card_mod
	name = "ID card modification program"
	var/mod_mode = 1
	var/is_centcom = 0
	var/show_assignments = 0

/datum/nano_module/program/card_mod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/obj/item/stock_parts/computer/card_slot/card_slot = program.computer.get_component(PART_CARD)

	data["src"] = "\ref[src]"
	data["station_name"] = station_name()
	data["manifest"] = html_crew_manifest()
	data["assignments"] = show_assignments
	data["have_id_slot"] = !!card_slot
	data["have_printer"] = program.computer.has_component(PART_PRINTER)
	data["authenticated"] = program.get_file_perms(get_access(user), user) & OS_WRITE_ACCESS
	if(!data["have_id_slot"] || !data["have_printer"])
		mod_mode = 0 //We can't modify IDs when there is no card reader
	if(card_slot)
		var/obj/item/card/id/id_card = card_slot.stored_card
		data["has_id"] = !!id_card
		data["id_account_number"] = id_card ? id_card.associated_account_number : null
		data["network_account_login"] = id_card ? id_card.associated_network_account["login"] : null
		data["network_account_password"] = id_card ? stars(id_card.associated_network_account["password"], 0) : null
		data["id_rank"] = id_card && id_card.assignment ? id_card.assignment : "Unassigned"
		data["id_owner"] = id_card && id_card.registered_name ? id_card.registered_name : "-----"
		data["id_name"] = id_card ? id_card.name : "-----"
		data["gender"] = id_card ? id_card.card_gender : "UNSET"
		data["age"] = id_card ? id_card.age : "UNSET"
		data["dna_hash"] = id_card ? id_card.dna_hash : "UNSET"
		data["fingerprint_hash"] = id_card ? id_card.fingerprint_hash : "UNSET"
		data["blood_type"] = id_card ? id_card.blood_type : "UNSET"
		data["front_photo"] = id_card ? id_card.front : "UNSET"
		data["side_photo"] = id_card ? id_card.side : "UNSET"
	data["mmode"] = mod_mode
	data["centcom_access"] = is_centcom

	data["titles_by_dept"] = list()
	var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
	for(var/dept_key in all_departments)
		var/decl/department/dept = all_departments[dept_key]
		var/list/map_jobs = SSjobs.titles_by_department(dept.type)
		if(LAZYLEN(map_jobs))
			data["titles_by_dept"] += list(list(
				"department_colour" =  dept.colour,
				"department_name" =    capitalize(dept.name),
				"department_titles" =  format_jobs(map_jobs)
			))
	data["centcom_jobs"] = format_jobs(get_all_centcom_jobs())
	data["all_centcom_access"] = is_centcom ? get_accesses(1) : null
	data["regions"] = get_accesses()

	if(card_slot && card_slot.stored_card)
		var/obj/item/card/id/id_card = card_slot.stored_card
		if(is_centcom)
			var/list/all_centcom_access = list()
			for(var/access in get_all_centcom_access())
				all_centcom_access.Add(list(list(
					"desc" = replacetext(get_centcom_access_desc(access), " ", "&nbsp"),
					"ref" = access,
					"allowed" = (access in id_card.access) ? 1 : 0)))
			data["all_centcom_access"] = all_centcom_access
		else
			var/list/regions = list()
			for(var/i = 1; i <= 8; i++)
				var/list/accesses = list()
				for(var/access in get_region_accesses(i))
					if (get_access_desc(access))
						accesses.Add(list(list(
							"desc" = replacetext(get_access_desc(access), " ", "&nbsp"),
							"ref" = access,
							"allowed" = (access in id_card.access) ? 1 : 0)))

				regions.Add(list(list(
					"name" = get_region_accesses_name(i),
					"accesses" = accesses)))
			data["regions"] = regions

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "identification_computer.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/card_mod/proc/format_jobs(list/jobs)
	var/obj/item/card/id/id_card = program.computer.get_inserted_id()
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"display_name" = replacetext(job, " ", "&nbsp"),
			"target_rank" = id_card && id_card.assignment ? id_card.assignment : "Unassigned",
			"job" = job)))

	return formatted

/datum/nano_module/program/card_mod/proc/get_accesses(var/is_centcom = 0)
	return null

/datum/computer_file/program/card_mod/proc/get_photo(mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img

	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = user
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img

/datum/computer_file/program/card_mod/proc/get_access_by_rank(rank)
	var/datum/job/jobdatum = SSjobs.get_by_title(rank)
	if(!jobdatum)
		to_chat(usr, SPAN_WARNING("No log exists for this job: [rank]"))
		return

	return jobdatum.get_access()

/datum/computer_file/program/card_mod/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/obj/item/card/id/user_id_card = user.GetIdCard()
	var/obj/item/card/id/id_card = computer.get_inserted_id()

	var/datum/nano_module/program/card_mod/module = NM
	switch(href_list["action"])
		if("switchm")
			if(href_list["target"] == "mod")
				module.mod_mode = 1
			else if (href_list["target"] == "manifest")
				module.mod_mode = 0
		if("togglea")
			if(module.show_assignments)
				module.show_assignments = 0
			else
				module.show_assignments = 1
		if("print")
			if(!(get_file_perms(module.get_access(user), user) & OS_WRITE_ACCESS))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return
			if(computer.has_component(PART_PRINTER)) //This option should never be called if there is no printer
				if(module.mod_mode)
					var/contents = {"<h4>Access Report</h4>
								<u>Prepared By:</u> [user_id_card.registered_name ? user_id_card.registered_name : "Unknown"]<br>
								<u>For:</u> [id_card.registered_name ? id_card.registered_name : "Unregistered"]<br>
								<hr>
								<u>Assignment:</u> [id_card.assignment]<br>
								<u>Account Number:</u> #[id_card.associated_account_number]<br>
								<u>Network account:</u> [id_card.associated_network_account["login"]]
								<u>Network password:</u> [stars(id_card.associated_network_account["password"], 0)]
								<u>Blood Type:</u> [id_card.blood_type]<br><br>
								<u>Age:</u> [id_card.age]<br><br>
								<u>Gender:</u> [id_card.card_gender]<br><br>
								<u>Access:</u><br>
							"}

					var/known_access_rights = get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)
					for(var/A in id_card.access)
						if(A in known_access_rights)
							contents += "  [get_access_desc(A)]"

					if(!computer.print_paper(contents,"access report"))
						to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
						return
				else
					var/contents = {"<h4>Crew Manifest</h4>
									<br>
									[html_crew_manifest()]
									"}
					if(!computer.print_paper(contents, "crew manifest ([stationtime2text()])"))
						to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
						return
		if("eject")
			var/obj/item/stock_parts/computer/card_slot/card_slot = computer.get_component(PART_CARD)
			if(computer.get_inserted_id())
				card_slot.eject_id(user)
			else
				card_slot.insert_id(user.get_active_hand(), user)
		if("terminate")
			if(!(get_file_perms(module.get_access(user), user) & OS_WRITE_ACCESS))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return
			if(computer)
				id_card.assignment = "Terminated"
				remove_nt_access(id_card)
				callHook("terminate_employee", list(id_card))
		if("edit")
			if(!(get_file_perms(module.get_access(user), user) & OS_WRITE_ACCESS))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return
			if(computer)
				var/static/regex/hash_check = regex(@"^[0-9a-fA-F]{32}$")
				if(href_list["name"])
					var/temp_name = sanitize_name(input("Enter name.", "Name", id_card.registered_name),allow_numbers=TRUE)
					if(temp_name && CanUseTopic(user))
						id_card.registered_name = temp_name
						id_card.formal_name_suffix = initial(id_card.formal_name_suffix)
						id_card.formal_name_prefix = initial(id_card.formal_name_prefix)
					else
						computer.show_error(usr, "Invalid name entered!")
				else if(href_list["account"])
					var/account_num = text2num(input("Enter account number.", "Account", id_card.associated_account_number))
					id_card.associated_account_number = account_num
				else if(href_list["alogin"])
					var/account_login = input("Enter network account login.", "Network account login", id_card.associated_network_account["login"])
					id_card.associated_network_account["login"] = account_login
				else if(href_list["apswd"])
					var/account_password = input("Enter network account password.", "Network account password")
					id_card.associated_network_account["password"] = account_password
				else if(href_list["gender"])
					var/new_gender = input("Type gender.", "Gender", id_card.card_gender)
					if(!isnull(new_gender) && CanUseTopic(user))
						id_card.card_gender = new_gender
				else if(href_list["age"])
					var/sug_age = text2num(input("Enter age.", "Age", id_card.age))
					if(!isnull(sug_age) && CanUseTopic(user))
						id_card.age = sug_age
				else if(href_list["fingerprint_hash"])
					var/sug_fingerprint_hash = sanitize(input("Enter fingerprint hash.", "Fingerprint hash", id_card.fingerprint_hash), 32)
					if(hash_check.Find(sug_fingerprint_hash) && CanUseTopic(user))
						id_card.fingerprint_hash = sug_fingerprint_hash
				else if(href_list["dna_hash"])
					var/sug_dna_hash = sanitize(input("Enter DNA hash.", "DNA hash", id_card.dna_hash), 32)
					if(hash_check.Find(sug_dna_hash) && CanUseTopic(user))
						id_card.dna_hash = sug_dna_hash
				else if(href_list["blood_type"])
					var/sug_blood_type = input("Select blood type.", "Blood type") as null|anything in get_all_blood_types()
					if(!isnull(sug_blood_type) && CanUseTopic(user))
						id_card.blood_type = sug_blood_type
				else if(href_list["front_photo"])
					var/photo = get_photo(usr)
					if(photo && CanUseTopic(user))
						id_card.front = photo
				else if(href_list["side_photo"])
					var/photo = get_photo(usr)
					if(photo && CanUseTopic(user))
						id_card.side = photo
				else if(href_list["load_data"])
					var/list/ass_data = list()
					for(var/datum/computer_file/report/crew_record/CR in global.all_crew_records)
						ass_data.Add(list(CR.get_name() = CR))
					var/selected_CR_name = input("Select crew record for write down to the card.", "Crew record selection") as null|anything in ass_data
					var/datum/computer_file/report/crew_record/selected_CR = get_crewmember_record(selected_CR_name)
					if(!isnull(selected_CR) && CanUseTopic(user))
						id_card.registered_name = selected_CR.get_name()
						id_card.assignment = selected_CR.get_job()
						id_card.position = selected_CR.get_rank()
						id_card.dna_hash = selected_CR.get_dna()
						id_card.fingerprint_hash = selected_CR.get_fingerprint()
						id_card.card_gender = selected_CR.get_gender()
						id_card.age = selected_CR.get_age()
						id_card.blood_type = selected_CR.get_bloodtype()
						id_card.front = selected_CR.photo_front
						id_card.side = selected_CR.photo_side
						var/list/access = get_access_by_rank(selected_CR.get_job())
						if(isnull(access))
							SSnano.update_uis(NM)
							return 1
						remove_nt_access(id_card)
						apply_access(id_card, access)
		if("assign")
			if(!(get_file_perms(module.get_access(user), user) & OS_WRITE_ACCESS))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return
			if(computer && id_card)
				var/t1 = href_list["assign_target"]
				if(t1 == "Custom")
					var/temp_t = sanitize(input("Enter a custom job assignment.","Assignment", id_card.assignment), 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(module.is_centcom)
						access = get_centcom_access(t1)
					else
						access = get_access_by_rank(t1)

					remove_nt_access(id_card)
					apply_access(id_card, access)
					id_card.assignment = t1
					id_card.position = t1

				callHook("reassign_employee", list(id_card))
		if("access")
			if(href_list["allowed"] && id_card)
				var/access_type = href_list["access_target"]
				var/access_allowed = text2num(href_list["allowed"])
				if(access_type in get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM))
					for(var/access in module.get_access(user))
						var/region_type = get_access_region_by_id(access_type)
						if(access in global.using_map.access_modify_region[region_type])
							id_card.access -= access_type
							if(!access_allowed)
								id_card.access += access_type
							break
	if(id_card)
		id_card.SetName(text("[id_card.registered_name]'s ID Card ([id_card.assignment])"))

	SSnano.update_uis(NM)
	return 1

/datum/computer_file/program/card_mod/proc/remove_nt_access(var/obj/item/card/id/id_card)
	id_card.access -= get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)

/datum/computer_file/program/card_mod/proc/apply_access(var/obj/item/card/id/id_card, var/list/accesses)
	id_card.access |= accesses