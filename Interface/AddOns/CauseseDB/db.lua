CauseseDB = {
    targeted = {
        [434756] = {"Targeted", "Targeted.ogg"}, --Throw Chair
        [441119] = {"Knock", "Knock.ogg"}, --Bee-Zooka
        [426619] = {"Charge", "Charge.ogg"}, --One-Hand Headlock
        [474031] = {"Spread", "Spread.ogg"}, --Void Crush
        [430179] = {"Drop", "Drop.ogg"}, --Seeping Corruption
        [424423] = {"Spread", "Spread.ogg"}, --Lunging Strike
        [448787] = {"Targeted", "Targeted.ogg"}, --Purification
        [1217279] = {"Knock", "Knock.ogg"}, --Uppercut
        [257582] = {"Fixate", "Fixate.ogg"}, --Raging Gaze
        [262794] = {"Targeted", "Targeted.ogg"}, --Mind Lash
        [268846] = {"Spread", "Spread.ogg"}, --Echo Blade
        [262383] = {"Fixate", "Fixate.ogg"}, --Deploy Crawler Mine
        [330532] = {"Bleed", "Bleed.ogg"}, --Jagged Quarrel
        [333861] = {"Bleed", "Bleed.ogg"}, --Ricocheting Blade
        [448619] = {"Charge", ""}, --Reckless Delivery
    },
    trash_cc = {
        --[spellID] = {"name",category,"soundFile","role", "show target" (true/false), "important" (true/false)},
        [267354] = {"KNIVES",2,"","ALL",false,true}, --Fan of Knives
        [268702] = {"AoE",0,"","ALL",false,true}, --Furious Quake
        [330810] = {"DoT",0,"","ALL",true,true}, --Bind Soul
        [427342] = {"DEFEND",2,"CC.ogg","ALL",false,true}, --Defend
        [1215412] = {"HEALABSORB",2,"CC.ogg","ALL",false,true}, --Corrosive Gunk
        [465120] = {"FIXATE INC",2,"CC.ogg","ALL",true,true}, --Wind Up Cast
        [465127] = {"FIXATE",2,"","ALL",true,true}, --Wind Up Channel
        [341969] = {"AoE",0,"","ALL",false,true}, --Withering Discharge
        [471733] = {"Heal",0,"","ALL",false,true}, --Restorative Algae
        [1214780] = {"AoE",0,"Interrupt.ogg","ALL",false,true}, --Maximum Distortion
    },
    timers = {
        --Cinderbrew Meadery
        ["214697"] = {[463206] = {"SPELL_CAST_START", 1, "ALL", "Knock Inc", 8.1, 18.1}}, --Tenderize
        ["210269"] = {[463218] = {"SPELL_CAST_START", 1, "ALL", "DoT Inc", 8.5, 24.2}}, --Volatile Keg
        ["223423"] = {[448619] = {"SPELL_CAST_START", 1, "ALL", "Charge Inc", 9.1, 30.3}}, --Reckless Delivery
        ["220946"] = {[442995] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 10.3, 23}}, --Swarming Surprise
        ["220141"] = {[440687] = {"SPELL_CAST_START", 6, "ALL", "Volley Inc", 5.9, 25.4}}, --Honey Volley
        --Darkflame Cleft
        ["211121"] = {[428066] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 9.8, 23.4}}, --Overpowering Roar55555555555555555555555555555555555555555555555
        ["233152"] = {[430171] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 5.3, 18.2}}, --Quenching Blast
        ["208450"] = {[430171] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 5.3, 18.2}}, --Quenching Blast
        ["212411"] = {[1218117] = {"SPELL_CAST_START", 0, "ALL", "Knock Inc", 4.9, 18.2}}, --Massive Stomp
        --The Rookery
        ["209801"] = {[426893] = {"SPELL_CAST_START", 2, "ALL", "Dodge Inc", 4.9, 13.3}}, --Bounding Void
        ["212786"] = {[427404] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 15.4, 23}}, --Localized Storm
        ["214421"] = {[430812] = {"SPELL_CAST_START", 0, "ALL", "DoT Inc", 5.2, 21.8}}, --Attracting Shadows
        ["212793"] = {[1214523] = {"SPELL_CAST_START", 1, "ALL", "DoT Inc", 5.2, 24.2}}, --Feasting Void
        --Priory of the Scared Flame
        ["206696"] = {[427609] = {"SPELL_CAST_START", 1, "ALL", "Stopcast Inc", 20.4, 23}}, --Disrupting Shout
        ["212826"] = {
            [448485] = {"SPELL_CAST_START", 4, "TANK", "Buster Inc", 5.9, 12.1}, --Shield Slam
            [448492] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 14.7, 15.7}, --Thunderclap
        },
        ["212831"] = {[427897] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 10.8, 18.2}}, --Heat Wave
        ["239833"] = {[424431] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 26.1, 37.6}}, --Holy Radiance
        ["206704"] = {[448791] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 15.5, 21.7}}, --Sacred Toll
        ["206710"] = {[427601] = {"SPELL_CAST_START", 2, "ALL", "Heal Inc", 50, 0.1}}, --Burst of Light
        --Floodgate
        ["230748"] = {[465827] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 6.8, 19.4}}, --Warp Blood
        ["231197"] = {
            [469818] = {"SPELL_CAST_START", 2, "ALL", "Bait Inc", 4.5, 21.8} , --Bubble Burp
            [469721] = {"SPELL_CAST_START", 1, "ALL", "DoT Inc", 15.5, 21.8} , --Backwash
        },
        ["231014"] = {[465120] = {"SPELL_CAST_START", 2, "ALL", "Fixate Inc", 8.3, 17}}, --Wind Up
        --Mechagon
        ["144293"] = {[1215409] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 6.8, 25.4}}, --Mega Drill
        ["144298"] = {[297128] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 10.8, 27.9}}, --Short Out
        ["151476"] = {[295169] = {"SPELL_CAST_START", 2, "ALL", "Hide Inc", 16.7, 27.9}}, --Capacitor Discharge
        ["144299"] = {[293683] = {"SPELL_CAST_SUCCESS", 5, "ALL", "Shield Inc", 9.7, 21.9}}, --Shield Generator
        ["236033"] = {[1215412] = {"SPELL_CAST_START", 2, "ALL", "Absorb Inc", 8.5, 24.3}}, --Corrosive Gunk
        --Motherlode
        ["136139"] = {
            [263628] = {"SPELL_CAST_START", 4, "TANK", "Buster Inc", 16.5, 27}, --Charged Shield
            [472041] = {"SPELL_CAST_START", 5, "ALL", "Bait Inc", 8.5, 19.4}, --Tear Gas
        },
        ["130485"] = {
            [263628] = {"SPELL_CAST_START", 4, "TANK", "Buster Inc", 16.5, 27}, --Charged Shield
            [472041] = {"SPELL_CAST_START", 5, "ALL", "Bait Inc", 8.5, 19.4}, --Tear Gas
        },
        ["134232"] = {[267354] = {"SPELL_CAST_SUCCESS", 0, "ALL", "Knives Inc", 13, 20.6}}, --Fan of Knives
        ["136643"] = {[473168] = {"SPELL_CAST_START", 0, "ALL", "Dance Inc", 15.5, 26.7}}, --Rapid Extraction
        ["133430"] = {[473304] = {"SPELL_CAST_START", 2, "ALL", "Drop Inc", 7.9, 23}}, --Brainstorm
        ["133463"] = {[269429] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 7.4, 18.2}}, --Charged Shot
        --Theater of Pain
        ["170850"] = {[333241] = {"SPELL_CAST_START", 1, "ALL", "AoE Inc", 7.2, 18.2}}, --Raging Tantrum
        ["167998"] = {
            [330716] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 9.4, 27.1}, --Soulstorm
            [330725] = {"SPELL_CAST_SUCCESS", 2, "ALL", "Curse Inc", 3.6, 18.2}, --Shadow Vulnerability
        },
        ["163086"] = {[330614] = {"SPELL_CAST_START", 2, "ALL", "Dodge Inc", 7, 15.7}}, --Vile Eruption
        ["169927"] = {[330586] = {"SPELL_CAST_START", 4, "TANK", "Buster Inc", 0.1, 26.7}}, --Devour Flesh
        ["162744"] = {[342135] = {"SPELL_CAST_START", 0, "ALL", "Stopcast Inc", 10.4, 17.9}}, --Interrupting Roar
        ["167532"] = {[342135] = {"SPELL_CAST_START", 0, "ALL", "Stopcast Inc", 2.4, 17.9}}, --Interrupting Roar
        ["167538"] = {[1215850] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 10.4, 13.2}}, --Earthcrusher
        ["167533"] = {[333827] = {"SPELL_CAST_START", 0, "ALL", "AoE Inc", 2.1, 9.7}}, --Seismic Stomp
        ["169893"] = {[333299] = {"SPELL_CAST_SUCCESS", 2, "ALL", "Curse Inc", 6.9, 12.1}}, --Curse of Desolation
    },
    private_auras = {

    },
    tank = {
        [432229] = {"Knock", 4, true, "Knock.ogg"}, --Keg Smash
        [439031] = {"Knock", 4, true, "Knock.ogg"}, --Bottoms Uppercut
        [436592] = {"Clear", 4, true, "Clear.ogg"}, --Cash Cannon
        [422245] = {"Buster", 4, true, "Bite.ogg"}, --Rock Buster
        [445457] = {"Frontal", 4, true, "Bite.ogg"}, --Oblivion Wave
        [448485] = {"Knock", 4, true, "Knock.ogg"}, --Shield Slam
        [448515] = {"Buster", 4, true, "Bite.ogg"}, --Divine Judgement
        [424414] = {"Bleed", 4, true, ""}, --Pierce Armor
        [435165] = {"Buster", 4, true, "Bite.ogg"}, --Blazing Strike
        [471585] = {"Move", 4, true, "Move.ogg"}, --Mobilizing Mechadrones
        [473351] = {"Buster", 4, true, "Bite.ogg"}, --Electrocrush
        [469478] = {"Buster", 4, true, "Bite.ogg"}, --Sludge Claws
        [465666] = {"Buster", 4, true, "Bite.ogg"}, --Sparkslam
        [466190] = {"Knock", 4, true, "Knock.ogg"}, --Thunder Punch
        [1215065] = {"Buster", 4, true, "Bite.ogg"}, --Platinum Pummel
        [1215411] = {"Bleed", 4, true, ""}, --Puncture
        [291878] = {"Buster", 4, true, ""}, --Pulse Blast
        [263628] = {"Buster", 4, true, "Bite.ogg"}, --Charged Shield
        [320069] = {"Buster", 4, true, ""}, --Mortal Strike
        [474087] = {"Frontal", 4, true, "Bite.ogg"}, --Necrotic Eruption
        [330586] = {"Leech", 4, true, "Bite.ogg"}, --Devour Flesh
        [323515] = {"Buster", 4, true, "Bite.ogg"}, --Hateful Strike
        [324079] = {"Buster", 4, true, "Bite.ogg"}, --Reaping Scythe
        [331316] = {"Buster", 4, true, "Bite.ogg"}, --Savage Flurry
        [459799] = {"Knock Up", 4, true, "Bite.ogg"}, --Wallop
    },
}