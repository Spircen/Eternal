proc/random_hair_style(gender, species = "Human")
	var/h_style = "Bald"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

proc/random_facial_hair_style(gender, species = "Human")
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

proc/random_name(gender, species = "Human")

	var/datum/species/current_species
	if(species)
		current_species = all_species[species]

	if(!current_species || current_species.name == "Human")
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return current_species.get_random_name(gender)

proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(4 to 12)			return "child"
		if(13 to 19)		return "teenager"
		if(20 to 29)		return "young adult"
		if(30 to 45)		return "adult"
		if(46 to 59)		return "middle-aged"
		if(60 to 69)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(95 to 99)		//For telling patients to eat a warm donk pocket and go on with their shift.
			return "health95"
		if(90 to 94)
			return "health90"
		if(80 to 89)
			return "health80"
		if(70 to 79)
			return "health70"
		if(60 to 69)
			return "health60"
		if(50 to 59)
			return "health50"
		if(40 to 49)
			return "health40"
		if(30 to 39)
			return "health30"
		if(20 to 29)
			return "health20"
		if(10 to 19)
			return "health10"
		if(1 to 9)
			return "health1"
		if(-9 to 0) 		//Hard crit begins here. The health bar will turn a brilliant red and deducted health will be black.
			return "health-0"
		if(-19 to -10)
			return "health-10"
		if(-29 to -20)
			return "health-20"
		if(-39 to -30)
			return "health-30"
		if(-49 to -40)
			return "health-40"
		if(-59 to -50)
			return "health-50"
		if(-69 to -60)
			return "health-60"
		if(-79 to -70)
			return "health-70"
		if(-89 to -80)
			return "health-80"
		if(-94 to -90)
			return "health-90"
		if(-99 to -95)		//HURRY UP, DOC!
			return "health-95"
		else
			return "health-100"
	return "0"

/*
Proc for attack log creation, because really why not
1 argument is the actor
2 argument is the target of action
3 is the description of action(like punched, throwed, or any other verb)
4 should it make adminlog note or not
5 is the tool with which the action was made(usually item)					5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
6 is additional information, anything that needs to be added
*/

/proc/add_logs(mob/user, mob/target, what_done, var/admin=1, var/object=null, var/addition=null)
	if(user && ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(target && ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(admin)
		log_attack("<font color='red'>[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] [what_done] [target ? "[target.name][(ismob(target) && target.ckey)? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
