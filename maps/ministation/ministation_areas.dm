/datum/event/prison_break/medical
	areaType = list(/area/ministation/medical)

/datum/event/prison_break/science
	areaType = list(/area/ministation/science)

/datum/event/prison_break/station
	areaType = list(/area/ministation/security)

/area/ministation
	name = "\improper Ministation"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg')
	icon = 'maps/ministation/ministation_areas.dmi'
	icon_state = "default"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/ministation/supply_dock
	name = "Supply Shuttle Dock"
	icon_state = "yellow"
	base_turf = /turf/space
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/ministation/supply
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	req_access = list(access_cargo)
	requires_power = 0
	holomap_color = HOLOMAP_AREACOLOR_CARGO

//Hallways
/area/ministation/hall
	icon_state = "white"
	area_flags = AREA_FLAG_HALLWAY
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/ministation/hall/w
	name = "\improper Port Hallway"

/area/ministation/hall/s
	name = "\improper Aft Hallway"

/area/ministation/hall/e
	name = "\improper Starboard Hallway"

/area/ministation/hall/n
	name = "\improper Forward Hallway"

//Maintenance
/area/ministation/maint
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_MAINTENANCE
	req_access = list(access_maint_tunnels)
	turf_initializer = /decl/turf_initializer/maintenance
	icon_state = "orange"
	secure = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MAINTENANCE

/area/ministation/maint/nw
	name = "\improper Port Forward Maintenance"

/area/ministation/maint/ne
	name = "\improper Starboard Forward Maintenance"

/area/ministation/maint/w
	name = "\improper Port Maintenance"

/area/ministation/maint/e
	name = "\improper Starboard Maintenance"

/area/ministation/maint/sw
	name = "\improper Port Quarter Maintenance"

/area/ministation/maint/se
	name = "\improper Starboard Quarter Maintenance"

/area/ministation/maint/sec
	name = "\improper Security Maintenance"

/area/ministation/maint/detective
	name = "\improper Detective Office Maintenance"

//Departments
/area/ministation/hop
	name = "\improper Lieutenant's Office"
	req_access = list(access_hop)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/janitor
	name = "\improper Custodial Closet"
	req_access = list(access_janitor)
	icon_state = "janitor"

/area/ministation/commons
	name = "\improper Common Area"
	icon_state = "pink"

/area/ministation/cargo
	name = "\improper Cargo Bay"
	req_access = list(access_cargo)
	icon_state = "brown"
	secure = TRUE
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/ministation/bridge
	name = "\improper Bridge"
	req_access = list(access_heads)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/bridge/vault
	name = "\improper Vault"
	req_access = list(access_heads_vault)
	ambience = list()
	icon_state = "green"

/area/ministation/security
	name = "\improper Security Office"
	req_access = list(access_security)
	secure = TRUE
	icon_state = "red"
	area_flags = AREA_FLAG_SECURITY
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/ministation/detective
	name = "\improper Detective Office"
	req_access = list(access_forensics_lockers)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/court
	name = "\improper Court Room"
	req_access =list(access_lawyer)
	secure = TRUE
	icon_state = "pink"

/area/ministation/library
	name = "\improper Library"
	icon_state = "LIB"

/area/ministation/atmospherics
	name = "\improper Atmospherics"
	req_access = list(access_atmospherics)
	icon_state = "ATMOS"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ministation/science
	name = "\improper Research & Development Laboratory"
	req_access = list(access_research)
	secure = TRUE
	icon_state = "purple"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/ministation/eva
	name = "\improper EVA Storage"
	req_access = list(access_eva)
	secure = TRUE
	icon_state = "dark_blue"

/area/ministation/medical
	name = "\improper Infirmary"
	req_access = list(access_medical)
	icon_state = "light_blue"
	secure = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/ministation/cryo
	name = "\improper Cryogenic Storage"
	req_access = list()
	icon_state = "green"
	secure = FALSE

/area/ministation/hydro
	name = "\improper Hydroponics"
	req_access = list(access_hydroponics)
	icon_state = "green"

/area/ministation/cafe // no access requirement to get in. inner doors need access kitchen
	name = "\improper Cafeteria"
	icon_state = "red"
	secure = TRUE

/area/ministation/engine
	name = "Engineering"
	req_access = list(access_engine)
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	secure = TRUE
	icon_state = "yellow"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ministation/supermatter
	name = "\improper Supermatter Engine"
	req_access = list(access_engine)
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	secure = TRUE
	icon_state = "brown"

/area/ministation/smcontrol
	name = "\improper Supermatter Control"
	req_access = list(access_engine)
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
	secure = TRUE
	icon_state = "red"

/area/ministation/telecomms
	name = "\improper Telecommunications Control"
	req_access = list(list(access_engine),list(access_heads)) //can get inside to monitor but not actually access anything important. Inner doors have tcomm access
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/signal.ogg','sound/ambience/sonar.ogg')
	secure = TRUE
	icon_state = "light_blue"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/ministation/yinglet_rep
	name = "\improper Tradehouse Representative Chamber"
	req_access = list(access_lawyer)
	icon_state = "brown"

/area/ministation/yinglet_enclave
	name = "\improper Abandoned section"
	req_access = list(access_lawyer)
	icon_state = "white"

/area/ministation/Arrival
	name = "\improper Arrival Shuttle" // I hate this ugly thing
	icon_state = "white"
	requires_power = 0

/area/ministation/shuttle/outgoing
	name = "\improper Science Shuttle"
	icon_state = "shuttle"

//satellite
/area/ministation/ai_sat
	name = "\improper Satellite"
	secure = TRUE
	turf_initializer = /decl/turf_initializer/maintenance
	icon_state = "brown"

/area/ministation/ai_core
	name = "\improper AI Core"
	req_access = list(access_ai_upload)
	secure = TRUE
	icon_state = "green"

/area/ministation/ai_upload
	name = "\improper AI Upload Control"
	secure = TRUE
	req_access = list(access_ai_upload)
	icon_state = "light_blue"

/datum/goal/scav_hoard_junk
	valid_areas = list(/area/ministation/yinglet_rep)

/area/shuttle/escape_shuttle
	name = "\improper Emergency Shuttle"
	icon_state = "shuttle"
