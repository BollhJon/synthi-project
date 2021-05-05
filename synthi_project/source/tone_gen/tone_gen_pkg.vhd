-------------------------------------------------------------------------------
-- Project     : audio_top
-- Description : Constants and LUT for tone generation with DDS
--
--
-------------------------------------------------------------------------------
--
-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 12.04.13 | dqtm     | file created for DTP2 Milestone-3 in FS13
-- 02.04.14 | dqtm     | updated for DTP2 in FS14, cause using new parameters
-- 04.05.21 | muellpav | added LUT for Piano
-- 05.05.21 | muellpav | added LUT for Orgel
-- 05.05.21 | muellpav | added LUT for guitar
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Package  Declaration
-------------------------------------------------------------------------------
-- Include in Design of Block dds.vhd and tone_decoder.vhd :
--   use work.tone_gen_pkg.all;
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package tone_gen_pkg is

 type t_tone_array is array (0 to 9) of std_logic_vector(6 downto 0) ;

  
    -------------------------------------------------------------------------------
	-- TYPES AND CONSTANTS FOR MIDI INTERFACE
	-------------------------------------------------------------------------------	
	-- type t_note_record is
	--   record
	-- 	valid 		: std_logic;
	-- 	number 		: std_logic_vector(6 downto 0);
	-- 	velocity	: std_logic_vector(6 downto 0); 
	--   end record;

	-- CONSTANT NOTE_INIT_VALUE : t_note_record := (valid  	=> '0',
	-- 											 number 	=> (others => '0'),
	-- 											 velocity 	=> (others => '0'));
	  
	-- type t_midi_array is array (0 to 9) of t_note_record; -- 10x note_record


    -------------------------------------------------------------------------------
	-- CONSTANT DECLARATION FOR SEVERAL BLOCKS (DDS, TONE_GENERATOR, ...)
	-------------------------------------------------------------------------------
    constant N_CUM:					natural :=19; 			-- number of bits in phase cumulator phicum_reg
    constant N_LUT:					natural :=8;  			-- number of bits in LUT address
    constant L: 					natural := 2**N_LUT; 	-- length of LUT
    constant N_RESOL:				natural := 13;			-- Attention: 1 bit reserved for sign
	constant N_AUDIO :				natural := 16;			-- Audio Paralell Bus width
	-------------------------------------------------------------------------------
	-- TYPE DECLARATION FOR DDS
	-------------------------------------------------------------------------------
    subtype t_audio_range is integer range -(2**(N_RESOL-1)) to (2**(N_RESOL-1))-1;  -- range : [-2^12; +(2^12)-1]

 --type t_lut_rom is array (0 to L-1) of t_audio_range;
   type t_lut_rom is array (0 to L-1) of integer;

	constant LUT : t_lut_rom :=(
	0, 101, 201, 301, 401, 501, 601, 700, 799, 897, 995, 1092, 1189, 1285, 1380, 1474, 1567,
	1660, 1751, 1842, 1931, 2019, 2106, 2191, 2276, 2359, 2440, 2520, 2598, 2675, 2751, 2824,
	2896, 2967, 3035, 3102, 3166, 3229, 3290, 3349, 3406, 3461, 3513, 3564, 3612, 3659, 3703,
	3745, 3784, 3822, 3857, 3889, 3920, 3948, 3973, 3996, 4017, 4036, 4052, 4065, 4076, 4085,
	4091, 4095, 4095, 4095, 4091, 4085, 4076, 4065, 4052, 4036, 4017, 3996, 3973, 3948, 3920,
	3889, 3857, 3822, 3784, 3745, 3703, 3659, 3612, 3564, 3513, 3461, 3406, 3349, 3290, 3229,
	3166, 3102, 3035, 2967, 2896, 2824, 2751, 2675, 2598, 2520, 2440, 2359, 2276, 2191, 2106,
	2019, 1931, 1842, 1751, 1660, 1567, 1474, 1380, 1285, 1189, 1092, 995, 897, 799, 700, 601,
	501, 401, 301, 201, 101, 0, -101, -201, -301, -401, -501, -601, -700, -799, -897, -995,
	-1092, -1189, -1285, -1380, -1474, -1567, -1660, -1751, -1842, -1931, -2019, -2106, -2191,
	-2276, -2359, -2440, -2520, -2598, -2675, -2751, -2824, -2896, -2967, -3035, -3102, -3166,
	-3229, -3290, -3349, -3406, -3461, -3513, -3564, -3612, -3659, -3703, -3745, -3784, -3822,
	-3857, -3889, -3920, -3948, -3973, -3996, -4017, -4036, -4052, -4065, -4076, -4085, -4091,
	-4095, -4096, -4095, -4091, -4085, -4076, -4065, -4052, -4036, -4017, -3996, -3973, -3948,
	-3920, -3889, -3857, -3822, -3784, -3745, -3703, -3659, -3612, -3564, -3513, -3461, -3406,
	-3349, -3290, -3229, -3166, -3102, -3035, -2967, -2896, -2824, -2751, -2675, -2598, -2520,
	-2440, -2359, -2276, -2191, -2106, -2019, -1931, -1842, -1751, -1660, -1567, -1474, -1380,
	-1285, -1189, -1092, -995, -897, -799, -700, -601, -501, -401, -301, -201, -101 );
	
	
	
	constant LUT_klavier : t_lut_rom :=(
	0,121,243,355,420,484,547,604,661,715,763,812,855,895,935,967,999,1030,1055,1080,1105,1127,
	1148,1169,1190,1210,1231,1253,1275,1301,1329,1357,1392,1428,1465,1511,1558,1606,1663,1721,
	1781,1849,1916,1988,2064,2140,2221,2304,2387,2474,2561,2649,2736,2824,2911,2995,3080,3162,
	3240,3318,3391,3459,3526,3584,3636,3689,3727,3762,3797,3814,3831,3844,3842,3840,3832,3811,
	3789,3758,3718,3678,3626,3570,3513,3445,3376,3306,3228,3150,3070,2987,2903,2820,2736,2652,
	2571,2492,2414,2343,2277,2210,2156,2105,2053,2019,1985,1953,1936,1919,1906,1904,1901,1905,
	1913,1922,1935,1949,1964,1977,1990,2004,2009,2014,2017,2009,2001,1988,1965,1942,1911,1872,
	1832,1782,1727,1671,1605,1536,1468,1389,1311,1232,1145,1059,970,876,782,685,585,485,381,
	275,168,56,-57,-171,-291,-412,-534,-660,-786,-913,-1039,-1166,-1291,-1413,-1536,-1652,
	-1764,-1877,-1977,-2075,-2173,-2253,-2333,-2409,-2470,-2530,-2583,-2623,-2664,-2695,
	-2717,-2740,-2752,-2759,-2766,-2763,-2758,-2753,-2739,-2725,-2710,-2690,-2669,-2647,-2620,
	-2593,-2564,-2531,-2498,-2462,-2424,-2386,-2346,-2305,-2265,-2223,-2182,-2140,-2101,-2061,
	-2024,-1991,-1957,-1929,-1905,-1881,-1863,-1849,-1835,-1828,-1823,-1818,-1819,-1820,-1821,
	-1824,-1827,-1828,-1827,-1826,-1820,-1809,-1799,-1779,-1755,-1731,-1692,-1651,-1609,-1549,
	-1488,-1425,-1345,-1266,-1182,-1086,-991,-891,-785,-679,-571,-460,-350,-234,-117,0
	);


	constant LUT_orgel : t_lut_rom :=(
	0,48,173,340,548,785,1038,1295,1543,1772,1971,2140,2280,2397,2500,2600,2705,2825,2962,3117,
	3287,3464,3638,3796,3929,4029,4083,4092,4061,3991,3893,3780,3660,3544,3436,3342,3258,3183,
	3110,3033,2946,2845,2723,2584,2430,2260,2085,1910,1744,1595,1467,1368,1297,1250,1223,1205,
	1184,1148,1084,988,858,693,508,314,126,-42,-182,-281,-345,-379,-390,-396,-410,-449,-523,
	-635,-787,-970,-1170,-1370,-1550,-1695,-1793,-1830,-1815,-1754,-1652,-1532,-1409,-1299,
	-1213,-1153,-1122,-1111,-1106,-1097,-1067,-1010,-915,-780,-613,-422,-218,-18,165,313,422,
	491,514,508,483,453,432,429,451,495,554,620,677,715,720,685,611,502,365,216,69,-59,-159,
	-225,-247,-233,-190,-125,-51,20,77,111,121,103,62,6,-56,-115,-162,-191,-194,-175,-134,-74,
	-7,61,116,150,156,127,64,-24,-133,-249,-362,-460,-536,-588,-615,-622,-617,-611,-613,-630,
	-668,-730,-810,-900,-992,-1074,-1137,-1170,-1171,-1142,-1084,-1007,-921,-838,-769,-722,
	-704,-719,-762,-827,-908,-992,-1070,-1129,-1167,-1182,-1173,-1150,-1122,-1102,-1102,-1131,
	-1198,-1304,-1440,-1601,-1772,-1938,-2087,-2204,-2287,-2334,-2341,-2324,-2289,-2247,-2209,
	-2185,-2180,-2194,-2224,-2263,-2299,-2324,-2325,-2296,-2234,-2139,-2012,-1866,-1710,-1554,
	-1411,-1287,-1192,-1123,-1076,-1046,-1020,-988,-941,-873,-783,-671,-544,-411,-281,-166,-72,
	-5,32,49,50,49,58,0
	);

	constant LUT_guitar : t_lut_rom :=(
	0,174,252,244,121,-79,-276,-368,-307,-107,153,402,596,708,715,631,474,305,191,204,331,544,
	758,903,927,863,766,704,711,804,947,1107,1246,1332,1308,1170,933,672,490,500,710,1056,1427,
	1711,1829,1790,1624,1351,1029,719,503,433,549,767,1015,1214,1332,1345,1284,1168,1034,911,
	825,781,776,802,833,845,829,804,812,871,963,1032,1039,967,856,733,607,474,336,224,180,234,
	368,550,721,838,875,844,755,633,504,398,341,360,450,593,769,952,1138,1318,1481,1595,1649,
	1638,1588,1532,1499,1497,1531,1606,1715,1851,2000,2154,2306,2448,2555,2609,2610,2578,2551,
	2555,2591,2650,2733,2841,2977,3118,3225,3257,3231,3180,3134,3093,3024,2905,2733,2530,2322,
	2127,1954,1812,1709,1624,1520,1362,1150,902,658,427,198,-38,-264,-459,-633,-835,-1104,-1424,
	-1704,-1859,-1888,-1892,-1984,-2184,-2435,-2654,-2820,-2962,-3120,-3278,-3376,-3401,-3398,
	-3453,-3605,-3823,-4011,-4095,-4056,-3930,-3746,-3560,-3414,-3346,-3343,-3370,-3379,-3351,
	-3288,-3204,-3084,-2919,-2724,-2556,-2465,-2479,-2539,-2574,-2524,-2419,-2299,-2183,-2058,
	-1912,-1784,-1740,-1815,-1957,-2064,-2057,-1913,-1675,-1426,-1232,-1117,-1089,-1148,-1264,
	-1402,-1505,-1527,-1426,-1230,-979,-741,-571,-519,-561,-673,-806,-927,-1003,-1015,-929,-726,
	-453,-188,-24,-13,-145,-327,-469,-522,-487,-385,-244,-70,113,259,303,247,129,35,0
	);
    -------------------------------------------------------------------------------
	-- More Constant Declarations (DDS: Phase increment values for tones in 10 octaves of piano)
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	-- OCTAVE # Minus-2 (C-2 until B-2)
	constant CM2_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858/64,N_CUM)); -- CM2_DO	tone ~(2^-6)*261.63Hz
    constant CM2S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028/64,N_CUM)); -- CM2S_DOS	tone ~(2^-6)*277.18Hz
    constant DM2_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208/64,N_CUM)); -- DM2_RE	tone ~(2^-6)*293.66Hz
    constant DM2S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398/64,N_CUM)); -- DM2S_RES	tone ~(2^-6)*311.13Hz
    constant EM2_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600/64,N_CUM)); -- EM2_MI	tone ~(2^-6)*329.63Hz
    constant FM2_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815/64,N_CUM)); -- FM2_FA	tone ~(2^-6)*349.23Hz
    constant FM2S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041/64,N_CUM)); -- FM2S_FAS	tone ~(2^-6)*369.99Hz
    constant GM2_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282/64,N_CUM)); -- GM2_SOL  tone ~(2^-6)*392.00Hz
    constant GM2S_SOLS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536/64,N_CUM)); -- GM2S_SOLS	tone ~(2^-6)*415.30Hz
    constant AM2_LA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806/64,N_CUM)); -- AM2_LA	tone ~(2^-6)*440.00Hz
    constant AM2S_LAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092/64,N_CUM)); -- AM2S_LAS	tone ~(2^-6)*466.16Hz
    constant BM2_SI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394/64,N_CUM)); -- BM2_SI	tone ~(2^-6)*493.88Hz
	-------------------------------------------------------------------------------
	-- OCTAVE # Minus-1 (C-1 until B-1)
	constant CM1_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858/32,N_CUM)); -- CM1_DO	tone ~(2^-5)*261.63Hz
    constant CM1S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028/32,N_CUM)); -- CM1S_DOS	tone ~(2^-5)*277.18Hz
    constant DM1_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208/32,N_CUM)); -- DM1_RE	tone ~(2^-5)*293.66Hz
    constant DM1S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398/32,N_CUM)); -- DM1S_RES	tone ~(2^-5)*311.13Hz
    constant EM1_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600/32,N_CUM)); -- EM1_MI	tone ~(2^-5)*329.63Hz
    constant FM1_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815/32,N_CUM)); -- FM1_FA	tone ~(2^-5)*349.23Hz
    constant FM1S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041/32,N_CUM)); -- FM1S_FAS	tone ~(2^-5)*369.99Hz
    constant GM1_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282/32,N_CUM)); -- GM1_SOL  tone ~(2^-5)*392.00Hz
    constant GM1S_SOLS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536/32,N_CUM)); -- GM1S_SOLS	tone ~(2^-5)*415.30Hz
    constant AM1_LA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806/32,N_CUM)); -- AM1_LA	tone ~(2^-5)*440.00Hz
    constant AM1S_LAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092/32,N_CUM)); -- AM1S_LAS	tone ~(2^-5)*466.16Hz
    constant BM1_SI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394/32,N_CUM)); -- BM1_SI	tone ~(2^-5)*493.88Hz
	-------------------------------------------------------------------------------
    -- OCTAVE #0 (C0 until B0)
	constant C0_DO		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858/16,N_CUM)); -- C0_DO		tone ~(2^-4)*261.63Hz
    constant C0S_DOS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028/16,N_CUM)); -- C0S_DOS	tone ~(2^-4)*277.18Hz
    constant D0_RE		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208/16,N_CUM)); -- D0_RE		tone ~(2^-4)*293.66Hz
    constant D0S_RES	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398/16,N_CUM)); -- D0S_RES	tone ~(2^-4)*311.13Hz
    constant E0_MI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600/16,N_CUM)); -- E0_MI		tone ~(2^-4)*329.63Hz
    constant F0_FA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815/16,N_CUM)); -- F0_FA		tone ~(2^-4)*349.23Hz
    constant F0S_FAS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041/16,N_CUM)); -- F0S_FAS	tone ~(2^-4)*369.99Hz
    constant G0_SOL  	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282/16,N_CUM)); -- G0_SOL  	tone ~(2^-4)*392.00Hz
    constant G0S_SOLS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536/16,N_CUM)); -- G0S_SOLS	tone ~(2^-4)*415.30Hz
    constant A0_LA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806/16,N_CUM)); -- A0_LA		tone ~(2^-4)*440.00Hz
    constant A0S_LAS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092/16,N_CUM)); -- A0S_LAS	tone ~(2^-4)*466.16Hz
    constant B0_SI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394/16,N_CUM)); -- B0_SI		tone ~(2^-4)*493.88Hz
	-------------------------------------------------------------------------------
     -- OCTAVE #1 (C1 until B1)
	constant C1_DO		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858/8,N_CUM)); -- C1_DO		tone ~(2^-3)*261.63Hz
    constant C1S_DOS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028/8,N_CUM)); -- C1S_DOS	tone ~(2^-3)*277.18Hz
    constant D1_RE		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208/8,N_CUM)); -- D1_RE		tone ~(2^-3)*293.66Hz
    constant D1S_RES	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398/8,N_CUM)); -- D1S_RES	tone ~(2^-3)*311.13Hz
    constant E1_MI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600/8,N_CUM)); -- E1_MI		tone ~(2^-3)*329.63Hz
    constant F1_FA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815/8,N_CUM)); -- F1_FA		tone ~(2^-3)*349.23Hz
    constant F1S_FAS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041/8,N_CUM)); -- F1S_FAS	tone ~(2^-3)*369.99Hz
    constant G1_SOL  	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282/8,N_CUM)); -- G1_SOL  	tone ~(2^-3)*392.00Hz
    constant G1S_SOLS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536/8,N_CUM)); -- G1S_SOLS	tone ~(2^-3)*415.30Hz
    constant A1_LA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806/8,N_CUM)); -- A1_LA		tone ~(2^-3)*440.00Hz
    constant A1S_LAS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092/8,N_CUM)); -- A1S_LAS	tone ~(2^-3)*466.16Hz
    constant B1_SI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394/8,N_CUM)); -- B1_SI		tone ~(2^-3)*493.88Hz
	-------------------------------------------------------------------------------
	-- OCTAVE #2 (C2 until B2)
	constant C2_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858/4,N_CUM)); -- C2_DO		tone ~0,25*261.63Hz
    constant C2S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028/4,N_CUM)); -- C2S_DOS	tone ~0,25*277.18Hz
    constant D2_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208/4,N_CUM)); -- D2_RE		tone ~0,25*293.66Hz
    constant D2S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398/4,N_CUM)); -- D2S_RES	tone ~0,25*311.13Hz
    constant E2_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600/4,N_CUM)); -- E2_MI		tone ~0,25*329.63Hz
    constant F2_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815/4,N_CUM)); -- F2_FA		tone ~0,25*349.23Hz
    constant F2S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041/4,N_CUM)); -- F2S_FAS	tone ~0,25*369.99Hz
    constant G2_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282/4,N_CUM)); -- G2_SOL  	tone ~0,25*392.00Hz
    constant G2S_SOLS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536/4,N_CUM)); -- G2S_SOLS	tone ~0,25*415.30Hz
    constant A2_LA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806/4,N_CUM)); -- A2_LA		tone ~0,25*440.00Hz
    constant A2S_LAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092/4,N_CUM)); -- A2S_LAS	tone ~0,25*466.16Hz
    constant B2_SI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394/4,N_CUM)); -- B2_SI		tone ~0,25*493.88Hz
	-------------------------------------------------------------------------------
	-- OCTAVE #3 (C3 until B3)
	constant C3_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858/2,N_CUM)); -- C2_DO		tone ~0,5*261.63Hz
    constant C3S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028/2,N_CUM)); -- C2S_DOS	tone ~0,5*277.18Hz
    constant D3_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208/2,N_CUM)); -- D2_RE		tone ~0,5*293.66Hz
    constant D3S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398/2,N_CUM)); -- D2S_RES	tone ~0,5*311.13Hz
    constant E3_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600/2,N_CUM)); -- E2_MI		tone ~0,5*329.63Hz
    constant F3_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815/2,N_CUM)); -- F2_FA		tone ~0,5*349.23Hz
    constant F3S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041/2,N_CUM)); -- F2S_FAS	tone ~0,5*369.99Hz
    constant G3_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282/2,N_CUM)); -- G2_SOL  	tone ~0,5*392.00Hz
    constant G3S_SOLS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536/2,N_CUM)); -- G2S_SOLS	tone ~0,5*415.30Hz
    constant A3_LA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806/2,N_CUM)); -- A2_LA		tone ~0,5*440.00Hz
    constant A3S_LAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092/2,N_CUM)); -- A2S_LAS	tone ~0,5*466.16Hz
    constant B3_SI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394/2,N_CUM)); -- B2_SI		tone ~0,5*493.88Hz
	-------------------------------------------------------------------------------
    -- OCTAVE #4 (C4 until B4)
	constant C4_DO		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858,N_CUM));   -- C4_DO		tone ~261.63Hz
    constant C4S_DOS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028,N_CUM));   -- C4S_DOS	tone ~277.18Hz
    constant D4_RE		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208,N_CUM));   -- D4_RE		tone ~293.66Hz
    constant D4S_RES	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398,N_CUM));   -- D4S_RES	tone ~311.13Hz
    constant E4_MI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600,N_CUM));   -- E4_MI		tone ~329.63Hz
    constant F4_FA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815,N_CUM));   -- F4_FA		tone ~349.23Hz
    constant F4S_FAS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041,N_CUM));   -- F4S_FAS	tone ~369.99Hz
    constant G4_SOL  	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282,N_CUM));   -- G4_SOL  	tone ~392.00Hz
    constant G4S_SOLS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536,N_CUM));   -- G4S_SOLS	tone ~415.30Hz
    constant A4_LA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806,N_CUM));   -- A4_LA		tone ~440.00Hz
    constant A4S_LAS	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092,N_CUM));   -- A4S_LAS	tone ~466.16Hz
    constant B4_SI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394,N_CUM));   -- B4_SI		tone ~493.88Hz
	-------------------------------------------------------------------------------
     -- OCTAVE #5 (C5 until B5)
	constant C5_DO		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858*2,N_CUM)); -- C5_DO		tone ~2*261.63Hz
    constant C5S_DOS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028*2,N_CUM)); -- C5S_DOS	tone ~2*277.18Hz
    constant D5_RE		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208*2,N_CUM)); -- D5_RE		tone ~2*293.66Hz
    constant D5S_RES	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398*2,N_CUM)); -- D5S_RES	tone ~2*311.13Hz
    constant E5_MI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600*2,N_CUM)); -- E5_MI		tone ~2*329.63Hz
    constant F5_FA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815*2,N_CUM)); -- F5_FA		tone ~2*349.23Hz
    constant F5S_FAS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041*2,N_CUM)); -- F5S_FAS	tone ~2*369.99Hz
    constant G5_SOL  	: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282*2,N_CUM)); -- G5_SOL  	tone ~2*392.00Hz
    constant G5S_SOLS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536*2,N_CUM)); -- G5S_SOLS	tone ~2*415.30Hz
    constant A5_LA		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806*2,N_CUM)); -- A5_LA		tone ~2*440.00Hz
    constant A5S_LAS	:  	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092*2,N_CUM)); -- A5S_LAS	tone ~2*466.16Hz
    constant B5_SI		: 	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394*2,N_CUM)); -- B5_SI		tone ~2*493.88Hz
	-------------------------------------------------------------------------------
	-- OCTAVE #6 (C6 until B6)
	constant C6_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858*4,N_CUM)); -- C6_DO		tone ~4*261.63Hz
    constant C6S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028*4,N_CUM)); -- C6S_DOS	tone ~4*277.18Hz
    constant D6_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208*4,N_CUM)); -- D6_RE		tone ~4*293.66Hz
    constant D6S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398*4,N_CUM)); -- D6S_RES	tone ~4*311.13Hz
    constant E6_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600*4,N_CUM)); -- E6_MI		tone ~4*329.63Hz
    constant F6_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815*4,N_CUM)); -- F6_FA		tone ~4*349.23Hz
    constant F6S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041*4,N_CUM)); -- F6S_FAS	tone ~4*369.99Hz
    constant G6_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282*4,N_CUM)); -- G6_SOL  	tone ~4*392.00Hz
    constant G6S_SOLS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536*4,N_CUM)); -- G6S_SOLS	tone ~4*415.30Hz
    constant A6_LA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806*4,N_CUM)); -- A6_LA		tone ~4*440.00Hz
    constant A6S_LAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092*4,N_CUM)); -- A6S_LAS	tone ~4*466.16Hz
    constant B6_SI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394*4,N_CUM)); -- B6_SI		tone ~4*493.88Hz
	-------------------------------------------------------------------------------
	-- OCTAVE #7 (C7 until B7)
	constant C7_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858*8,N_CUM)); -- C7_DO		tone ~8*261.63Hz
    constant C7S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028*8,N_CUM)); -- C7S_DOS	tone ~8*277.18Hz
    constant D7_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208*8,N_CUM)); -- D7_RE		tone ~8*293.66Hz
    constant D7S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398*8,N_CUM)); -- D7S_RES	tone ~8*311.13Hz
    constant E7_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600*8,N_CUM)); -- E7_MI		tone ~8*329.63Hz
    constant F7_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815*8,N_CUM)); -- F7_FA		tone ~8*349.23Hz
    constant F7S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041*8,N_CUM)); -- F7S_FAS	tone ~8*369.99Hz
    constant G7_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282*8,N_CUM)); -- G7_SOL  	tone ~8*392.00Hz
    constant G7S_SOLS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4536*8,N_CUM)); -- G7S_SOLS	tone ~8*415.30Hz
    constant A7_LA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4806*8,N_CUM)); -- A7_LA		tone ~8*440.00Hz
    constant A7S_LAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5092*8,N_CUM)); -- A7S_LAS	tone ~8*466.16Hz
    constant B7_SI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(5394*8,N_CUM)); -- B7_SI		tone ~8*493.88Hz
	-------------------------------------------------------------------------------
	-- OCTAVE #8 (C8 until G8)
	constant C8_DO		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(2858*16,N_CUM)); -- C8_DO		tone ~16*261.63Hz
    constant C8S_DOS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3028*16,N_CUM)); -- C8S_DOS	tone ~16*277.18Hz
    constant D8_RE		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3208*16,N_CUM)); -- D8_RE		tone ~16*293.66Hz
    constant D8S_RES	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3398*16,N_CUM)); -- D8S_RES	tone ~16*311.13Hz
    constant E8_MI		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3600*16,N_CUM)); -- E8_MI		tone ~16*329.63Hz
    constant F8_FA		:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(3815*16,N_CUM)); -- F8_FA		tone ~16*349.23Hz
    constant F8S_FAS	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4041*16,N_CUM)); -- F8S_FAS	tone ~16*369.99Hz
    constant G8_SOL  	:	std_logic_vector(N_CUM-1 downto 0):= std_logic_vector(to_unsigned(4282*16,N_CUM)); -- G8_SOL  	tone ~16*392.00Hz
    -- STOP MIDI RANGE ------------------------------------------------------------ 	


    -------------------------------------------------------------------------------
	-- TYPE AND LUT FOR MIDI NOTE_NUMBER (need to translate midi_cmd.number for dds.phi_incr)
	-------------------------------------------------------------------------------
	type t_lut_note_number is array (0 to 127) of std_logic_vector(N_CUM-1 downto 0);

	constant LUT_midi2dds : t_lut_note_number :=(
		0	 => CM2_DO		,  
		1	 => CM2S_DOS	,  
		2	 => DM2_RE		,  
		3	 => DM2S_RES	,  
		4	 => EM2_MI		,  
		5	 => FM2_FA		,  
		6	 => FM2S_FAS	,  
		7	 => GM2_SOL  	,  
		8	 => GM2S_SOLS	,  
		9    => AM2_LA		,  
		10	 => AM2S_LAS	,  
		11	 => BM2_SI		,  
		12	 => CM1_DO		,  
		13	 => CM1S_DOS	,  
		14	 => DM1_RE		,  
		15	 => DM1S_RES	,  
		16	 => EM1_MI		,  
		17	 => FM1_FA		,  
		18	 => FM1S_FAS	,  
		19   => GM1_SOL  	,  
		20	 => GM1S_SOLS	,  
		21	 => AM1_LA		,  
		22	 => AM1S_LAS	,  
		23	 => BM1_SI		,  
		24	 => C0_DO		,  
		25	 => C0S_DOS		,  
		26	 => D0_RE		,  
		27	 => D0S_RES		,  
		28	 => E0_MI		,  
		29   => F0_FA		,  
		30	 => F0S_FAS		,  
		31	 => G0_SOL  	,  
		32	 => G0S_SOLS	,  
		33	 => A0_LA		,  
		34	 => A0S_LAS		,  
		35	 => B0_SI		,  
		36	 => C1_DO		,  
		37	 => C1S_DOS		,  
		38	 => D1_RE		,  
		39   => D1S_RES		,  
		40	 => E1_MI		,  
		41	 => F1_FA		,  
		42	 => F1S_FAS		,  
		43	 => G1_SOL  	,  
		44	 => G1S_SOLS	,  
		45	 => A1_LA		,  
		46	 => A1S_LAS		,  
		47	 => B1_SI		,  
		48	 =>  C2_DO		,
		49   =>  C2S_DOS	,
		50	 =>  D2_RE		,
		51	 =>  D2S_RES	,
		52	 =>  E2_MI		,
		53	 =>  F2_FA		,
		54	 =>  F2S_FAS	,
		55	 =>  G2_SOL  	,
		56	 =>  G2S_SOLS	,
		57	 =>  A2_LA		,
		58	 =>  A2S_LAS	,
		59   =>  B2_SI		,
		60	 =>  C3_DO		, 
		61	 =>  C3S_DOS	, 
		62	 =>  D3_RE		, 
		63	 =>  D3S_RES	, 
		64	 =>  E3_MI		, 
		65	 =>  F3_FA		, 
		66	 =>  F3S_FAS	, 
		67	 =>  G3_SOL  	, 
		68	 =>  G3S_SOLS	, 
		69   =>  A3_LA		, 
		70	 =>  A3S_LAS	, 
		71	 =>  B3_SI		, 
		72	 =>  C4_DO		, 
		73	 =>  C4S_DOS	, 
		74	 =>  D4_RE		, 
		75	 =>  D4S_RES	, 
		76	 =>  E4_MI		, 
		77	 =>  F4_FA		, 
		78	 =>  F4S_FAS	, 
		79   =>  G4_SOL  	, 
		80	 =>  G4S_SOLS	, 
		81	 =>  A4_LA		, 
		82	 =>  A4S_LAS	, 
		83	 =>  B4_SI		, 
		84	 =>  C5_DO		, 
		85	 =>  C5S_DOS	, 
		86	 =>  D5_RE		, 
		87	 =>  D5S_RES	, 
		88	 =>  E5_MI		, 
		89   =>  F5_FA		, 
		90	 =>  F5S_FAS	, 
		91	 =>  G5_SOL  	, 
		92	 =>  G5S_SOLS	, 
		93	 =>  A5_LA		, 
		94	 =>  A5S_LAS	, 
		95	 =>  B5_SI		, 
		96	 =>  C6_DO		, 
		97	 =>  C6S_DOS	, 
		98	 =>  D6_RE		, 
		99   =>  D6S_RES	, 
		100	 =>  E6_MI		, 
		101	 =>  F6_FA		, 
		102	 =>  F6S_FAS	, 
		103	 =>  G6_SOL  	, 
		104	 =>  G6S_SOLS	, 
		105	 =>  A6_LA		, 
		106	 =>  A6S_LAS	, 
		107	 =>  B6_SI		, 
		108	 =>  C7_DO		, 
		109  =>  C7S_DOS	, 
		110	 =>  D7_RE		, 
		111	 =>  D7S_RES	, 
		112	 =>  E7_MI		, 
		113	 =>  F7_FA		, 
		114	 =>  F7S_FAS	, 
		115	 =>  G7_SOL  	, 
		116	 =>  G7S_SOLS	, 
		117	 =>  A7_LA		, 
		118	 =>  A7S_LAS	, 
		119  =>  B7_SI		, 
		120	 =>  C8_DO		, 
		121	 =>  C8S_DOS	, 
		122	 =>  D8_RE		, 
		123	 =>  D8S_RES	, 
		124	 =>  E8_MI		, 
		125	 =>  F8_FA		, 
		126	 =>  F8S_FAS	, 
		127	 =>  G8_SOL  	
		);
	
	-------------------------------------------------------------------------------		
end package;
