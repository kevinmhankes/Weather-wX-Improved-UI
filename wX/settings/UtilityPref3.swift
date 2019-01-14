/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityPref3 {

	static func prefInitRIDLoc() {
		let value = Utility.readPref("RID_LOC_TLVE", "")
		if value == "" {
			editor.putString("RID_LOC_iowa_mosaic_AKCOMP", "AK, ")
			editor.putString("RID_LOC_iowa_mosaic_PRCOMP", "PR, ")
			editor.putString("RID_LOC_iowa_mosaic_HICOMP", "HI, ")
			editor.putString("RID_LOC_iowa_mosaic_USCOMP", "CONUS, ")
			editor.putString("RID_LOC_alaska", "AK, ")
			editor.putString("RID_LOC_NATAK", "AK, ")
			editor.putString("RID_LOC_hawaii", "HI, ")
			editor.putString("RID_LOC_NATPR", "HI, ")
			editor.putString("RID_LOC_pacsouthwest", "pacsouthwest, ")
			editor.putString("RID_LOC_pacnorthwest", "pacnorthwest, ")
			editor.putString("RID_LOC_southrockies", "southrockies, ")
			editor.putString("RID_LOC_northrockies", "northrockies, ")
			editor.putString("RID_LOC_southplains", "southplains, ")
			editor.putString("RID_LOC_centgrtlakes", "centgrtlakes, ")
			editor.putString("RID_LOC_southmissvly", "southmissvly, ")
			editor.putString("RID_LOC_uppermissvly", "uppermissvly, ")
			editor.putString("RID_LOC_southeast", "southeast, ")
			editor.putString("RID_LOC_southeast", "southeast, ")
			editor.putString("RID_LOC_conus", "CONUS, ")
			editor.putString("RID_LOC_latest", "CONUS, ")
			editor.putString("RID_LOC_NAT", "CONUS, ")
			editor.putString("RID_LOC_TLVE", "OH, Cleveland")
			editor.putString("RID_LOC_TADW", "MD,  Andrews Air Force Base")
			editor.putString("RID_LOC_TATL", "GA, Atlanta")
			editor.putString("RID_LOC_TBWI", "MD, Baltimore/Wash")
			editor.putString("RID_LOC_TBOS", "MA, Boston")
			editor.putString("RID_LOC_TCLT", "NC, Charlotte")
			editor.putString("RID_LOC_TMDW", "IL, Chicago Midway")
			editor.putString("RID_LOC_TORD", "IL, Chicago O'Hare")
			editor.putString("RID_LOC_TCLE", "OH, Cleveland")
			editor.putString("RID_LOC_TCMH", "OH, Columbus")
			editor.putString("RID_LOC_TCVG", "OH, Covington")
			editor.putString("RID_LOC_TDAL", "TX, Dallas Love Field")
			editor.putString("RID_LOC_TDFW", "TX, Dallas/Ft. Worth")
			editor.putString("RID_LOC_TDAY", "OH, Dayton")
			editor.putString("RID_LOC_TDEN", "CO, Denver")
			editor.putString("RID_LOC_TDTW", "MI, Detroit")
			editor.putString("RID_LOC_TIAD", "VA, Dulles")
			editor.putString("RID_LOC_TFLL", "FL, Fort Lauderdale")
			editor.putString("RID_LOC_THOU", "TX, Houston Hobby")
			editor.putString("RID_LOC_TIAH", "TX, Houston International")
			editor.putString("RID_LOC_TIDS", "IN, Indianapolis"); // was IDS
			editor.putString("RID_LOC_TMCI", "MO, Kansas City")
			editor.putString("RID_LOC_TLAS", "NV, Las Vegas")
			editor.putString("RID_LOC_TSDF", "KY, Louisville")
			editor.putString("RID_LOC_TMEM", "TN, Memphis")
			editor.putString("RID_LOC_TMIA", "FL, Miami")
			editor.putString("RID_LOC_TMKE", "WI, Milwaukee")
			editor.putString("RID_LOC_TMSP", "MN, Minneapolis")
			editor.putString("RID_LOC_TBNA", "TN, Nashville")
			editor.putString("RID_LOC_TMSY", "LA, New Orleans")
			editor.putString("RID_LOC_TJFK", "NY, New York City")
			editor.putString("RID_LOC_TEWR", "NJ, Newark")
			editor.putString("RID_LOC_TOKC", "OK, Oklahoma City")
			editor.putString("RID_LOC_TMCO", "FL, Orlando International")
			editor.putString("RID_LOC_TPHL", "PA, Philadelphia")
			editor.putString("RID_LOC_TPHX", "AZ, Phoenix")
			editor.putString("RID_LOC_TPIT", "PA, Pittsburgh")
			editor.putString("RID_LOC_TRDU", "NC, Raleigh Durham")
			editor.putString("RID_LOC_TSLC", "UT, Salt Lake City")
			editor.putString("RID_LOC_TSJU", "PR, San Juan")
			editor.putString("RID_LOC_TSTL", "MO, St Louis")
			editor.putString("RID_LOC_TTPA", "FL, Tampa Bay")
			editor.putString("RID_LOC_TTUL", "OK, Tulsa")
			editor.putString("RID_LOC_TDCA", "MD, Washington National")
			editor.putString("RID_LOC_TPBI", "FL, West Palm Beach")
			editor.putString("RID_LOC_TICT", "KS, Wichita")
			editor.putString("RID_LOC_JUA", "PR, San Juan")
			editor.putString("RID_LOC_CBW", "ME, Loring AFB")
			editor.putString("RID_LOC_GYX", "ME, Portland")
			editor.putString("RID_LOC_CXX", "VT, Burlington")
			editor.putString("RID_LOC_BOX", "MA, Boston")
			editor.putString("RID_LOC_ENX", "NY, Albany")
			editor.putString("RID_LOC_BGM", "NY, Binghamton")
			editor.putString("RID_LOC_BUF", "NY, Buffalo")
			editor.putString("RID_LOC_TYX", "NY, Montague")
			editor.putString("RID_LOC_OKX", "NY, New York City")
			editor.putString("RID_LOC_DOX", "DE, Dover AFB")
			editor.putString("RID_LOC_DIX", "PA, Philadelphia")
			editor.putString("RID_LOC_PBZ", "PA, Pittsburgh")
			editor.putString("RID_LOC_CCX", "PA, State College")
			editor.putString("RID_LOC_RLX", "WV, Charleston")
			editor.putString("RID_LOC_AKQ", "VA, Norfolk/Richmond")
			editor.putString("RID_LOC_FCX", "VA, Roanoke")
			editor.putString("RID_LOC_LWX", "VA, Sterling")
			editor.putString("RID_LOC_MHX", "NC, Morehead City")
			editor.putString("RID_LOC_RAX", "NC, Raleigh/Durham")
			editor.putString("RID_LOC_LTX", "NC, Wilmington")
			editor.putString("RID_LOC_CLX", "SC, Charleston")
			editor.putString("RID_LOC_CAE", "SC, Columbia")
			editor.putString("RID_LOC_GSP", "SC, Greer")
			editor.putString("RID_LOC_FFC", "GA, Atlanta")
			editor.putString("RID_LOC_VAX", "GA, Moody AFB")
			editor.putString("RID_LOC_JGX", "GA, Robins AFB")
			editor.putString("RID_LOC_EVX", "FL, Eglin AFB")
			editor.putString("RID_LOC_JAX", "FL, Jacksonville")
			editor.putString("RID_LOC_BYX", "FL, Key West")
			editor.putString("RID_LOC_MLB", "FL, Melbourne")
			editor.putString("RID_LOC_AMX", "FL, Miami")
			editor.putString("RID_LOC_TLH", "FL, Tallahassee")
			editor.putString("RID_LOC_TBW", "FL, Tampa")
			editor.putString("RID_LOC_BMX", "AL, Birmingham")
			editor.putString("RID_LOC_EOX", "AL, Fort Rucker")
			editor.putString("RID_LOC_HTX", "AL, Huntsville")
			editor.putString("RID_LOC_MXX", "AL, Maxwell AFB")
			editor.putString("RID_LOC_MOB", "AL, Mobile")
			editor.putString("RID_LOC_DGX", "MS, Brandon/Jackson")
			editor.putString("RID_LOC_GWX", "MS, Columbus AFB")
			editor.putString("RID_LOC_MRX", "TN, Knoxville/Tri Cities")
			editor.putString("RID_LOC_NQA", "TN, Memphis")
			editor.putString("RID_LOC_OHX", "TN, Nashville")
			editor.putString("RID_LOC_HPX", "KY, Fort Campbell")
			editor.putString("RID_LOC_JKL", "KY, Jackson")
			editor.putString("RID_LOC_LVX", "KY, Louisville")
			editor.putString("RID_LOC_PAH", "KY, Paducah")
			editor.putString("RID_LOC_ILN", "OH, Wilmington")
			editor.putString("RID_LOC_CLE", "OH, Cleveland")
			editor.putString("RID_LOC_DTX", "MI, Detroit/Pontiac")
			editor.putString("RID_LOC_APX", "MI, Gaylord")
			editor.putString("RID_LOC_GRR", "MI, Grand Rapids")
			editor.putString("RID_LOC_MQT", "MI, Marquette")
			editor.putString("RID_LOC_VWX", "IN, Evansville")
			editor.putString("RID_LOC_IND", "IN, Indianapolis")
			editor.putString("RID_LOC_IWX", "IN, North Webster")
			editor.putString("RID_LOC_LOT", "IL, Chicago")
			editor.putString("RID_LOC_ILX", "IL, Lincoln")
			editor.putString("RID_LOC_GRB", "WI, Green Bay")
			editor.putString("RID_LOC_ARX", "WI, La Crosse")
			editor.putString("RID_LOC_MKX", "WI, Milwaukee")
			editor.putString("RID_LOC_DLH", "MN, Duluth")
			editor.putString("RID_LOC_MPX", "MN, Minneapolis/St. Paul")
			editor.putString("RID_LOC_DVN", "IA, Davenport")
			editor.putString("RID_LOC_DMX", "IA, Des Moines")
			editor.putString("RID_LOC_EAX", "MO, Kansas City")
			editor.putString("RID_LOC_SGF", "MO, Springfield")
			editor.putString("RID_LOC_LSX", "MO, St. Louis")
			editor.putString("RID_LOC_SRX", "AR, Fort Smith")
			editor.putString("RID_LOC_LZK", "AR, Little Rock")
			editor.putString("RID_LOC_POE", "LA, Fort Polk")
			editor.putString("RID_LOC_LCH", "LA, Lake Charles")
			editor.putString("RID_LOC_LIX", "LA, New Orleans")
			editor.putString("RID_LOC_SHV", "LA, Shreveport")
			editor.putString("RID_LOC_AMA", "TX, Amarillo")
			editor.putString("RID_LOC_EWX", "TX, Austin/San Antonio")
			editor.putString("RID_LOC_BRO", "TX, Brownsville")
			editor.putString("RID_LOC_CRP", "TX, Corpus Christi")
			editor.putString("RID_LOC_FWS", "TX, Dallas/Ft. Worth")
			editor.putString("RID_LOC_DYX", "TX, Dyess AFB")
			editor.putString("RID_LOC_EPZ", "TX, El Paso")
			editor.putString("RID_LOC_GRK", "TX, Fort Hood")
			editor.putString("RID_LOC_HGX", "TX, Houston/Galveston")
			editor.putString("RID_LOC_DFX", "TX, Laughlin AFB")
			editor.putString("RID_LOC_LBB", "TX, Lubbock")
			editor.putString("RID_LOC_MAF", "TX, Midland/Odessa")
			editor.putString("RID_LOC_SJT", "TX, San Angelo")
			editor.putString("RID_LOC_FDR", "OK, Frederick")
			editor.putString("RID_LOC_TLX", "OK, Oklahoma City")
			editor.putString("RID_LOC_INX", "OK, Tulsa")
			editor.putString("RID_LOC_VNX", "OK, Vance AFB")
			editor.putString("RID_LOC_DDC", "KS, Dodge City")
			editor.putString("RID_LOC_GLD", "KS, Goodland")
			editor.putString("RID_LOC_TWX", "KS, Topeka")
			editor.putString("RID_LOC_ICT", "KS, Wichita")
			editor.putString("RID_LOC_UEX", "NE, Grand Island/Hastings")
			editor.putString("RID_LOC_LNX", "NE, North Platte")
			editor.putString("RID_LOC_OAX", "NE, Omaha")
			editor.putString("RID_LOC_ABR", "SD, Aberdeen")
			editor.putString("RID_LOC_UDX", "SD, Rapid City")
			editor.putString("RID_LOC_FSD", "SD, Sioux Falls")
			editor.putString("RID_LOC_BIS", "ND, Bismarck")
			editor.putString("RID_LOC_MVX", "ND, Grand Forks (Mayville)")
			editor.putString("RID_LOC_MBX", "ND, Minot AFB")
			editor.putString("RID_LOC_BLX", "MT, Billings")
			editor.putString("RID_LOC_GGW", "MT, Glasgow")
			editor.putString("RID_LOC_TFX", "MT, Great Falls")
			editor.putString("RID_LOC_MSX", "MT, Missoula")
			editor.putString("RID_LOC_CYS", "WY, Cheyenne")
			editor.putString("RID_LOC_RIW", "WY, Riverton")
			editor.putString("RID_LOC_FTG", "CO, Denver")
			editor.putString("RID_LOC_GJX", "CO, Grand Junction")
			editor.putString("RID_LOC_PUX", "CO, Pueblo")
			editor.putString("RID_LOC_ABX", "NM, Albuquerque")
			editor.putString("RID_LOC_FDX", "NM, Cannon AFB")
			editor.putString("RID_LOC_HDX", "NM, Holloman AFB")
			editor.putString("RID_LOC_FSX", "AZ, Flagstaff")
			editor.putString("RID_LOC_IWA", "AZ, Phoenix")
			editor.putString("RID_LOC_EMX", "AZ, Tucson")
			editor.putString("RID_LOC_YUX", "AZ, Yuma")
			editor.putString("RID_LOC_ICX", "UT, Cedar City")
			editor.putString("RID_LOC_MTX", "UT, Salt Lake City")
			editor.putString("RID_LOC_CBX", "ID, Boise")
			editor.putString("RID_LOC_SFX", "ID, Pocatello/Idaho Falls")
			editor.putString("RID_LOC_LRX", "NV, Elko")
			editor.putString("RID_LOC_ESX", "NV, Las Vegas")
			editor.putString("RID_LOC_RGX", "NV, Reno")
			editor.putString("RID_LOC_BBX", "CA, Beale AFB")
			editor.putString("RID_LOC_EYX", "CA, Edwards AFB")
			editor.putString("RID_LOC_BHX", "CA, Eureka")
			editor.putString("RID_LOC_VTX", "CA, Los Angeles")
			editor.putString("RID_LOC_DAX", "CA, Sacramento")
			editor.putString("RID_LOC_NKX", "CA, San Diego")
			editor.putString("RID_LOC_MUX", "CA, San Francisco")
			editor.putString("RID_LOC_HNX", "CA, San Joaquin Valley")
			editor.putString("RID_LOC_SOX", "CA, Santa Ana Mountains")
			editor.putString("RID_LOC_VBX", "CA, Vandenberg AFB")
			editor.putString("RID_LOC_HKI", "HI, Kauai")
			editor.putString("RID_LOC_HKM", "HI, Kohala")
			editor.putString("RID_LOC_HMO", "HI, Molokai")
			editor.putString("RID_LOC_HWA", "HI, South Shore")
			editor.putString("RID_LOC_MAX", "OR, Medford")
			editor.putString("RID_LOC_PDT", "OR, Pendleton")
			editor.putString("RID_LOC_RTX", "OR, Portland")
			editor.putString("RID_LOC_LGX", "WA, Langley Hill")
			editor.putString("RID_LOC_ATX", "WA, Seattle/Tacoma")
			editor.putString("RID_LOC_OTX", "WA, Spokane")
			editor.putString("RID_LOC_ABC", "AK, Bethel")
			editor.putString("RID_LOC_APD", "AK, Fairbanks/Pedro Dome")
			editor.putString("RID_LOC_AHG", "AK, Kenai")
			editor.putString("RID_LOC_AKC", "AK, King Salmon")
			editor.putString("RID_LOC_AIH", "AK, Middleton Island")
			editor.putString("RID_LOC_AEC", "AK, Nome")
			editor.putString("RID_LOC_ACG", "AK, Sitka/Biorka Island")
			editor.putString("RID_LOC_GUA", "GU, Andersen AFB")
			editor.putString("RID_LOC_PLA", "NA, Lajes Field, Azores")
			editor.putString("RID_LOC_KJK", "NA, Kunsan Air Base, South Korea")
			editor.putString("RID_LOC_KSG", "NA, Camp Humphreys, South Korea")
			editor.putString("RID_LOC_ODN", "NA, Kadena Air Base, Japan")
		}
	}
}
