class CBA_Extended_EventHandlers_base;

class CfgVehicles {
    class C_Soldier_VR_F;
    class C_Jeff_VR : C_Soldier_VR_F {
        author = "Navy";
        displayName = "Navy Path Base";
        faction = "Navy";
        side = 3;
        vehicleClass = "Navy_Paths";
        class EventHandlers {
            init = "(_this #0) disableAI 'ALL'";
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
    };

    class ARK_Module;
    class ARK_Navy_Paradrop: ARK_Module {
        scope = 2;
        displayName = "Navy - Paradrop";
        icon = "\x\ark\addons\ark_navy\resources\paradrop.paa";
        function = "ark_navy_module_preinit";
        isTriggerActivated = 1;
        isGlobal = 0;
        isDisposable = 1;
        class ModuleDescription {
            description = "Paradrops EI on the first waypoint";
        };
        class Arguments {
            class Fly_Height {
                displayName = "Set fly in height";
                description = "Set the height in meters the helo will try to fly at";
                typeName = "NUMBER";
                defaultValue = 200;
            };
            class Fly_Speed {
                displayName = "Set aircraft speed";
                description = "Set the speed the aircraft will maintain";
                typeName = "STRING";
                defaultValue = "NORMAL";
                class Values {
                    class limited_speed {name = "Slow";  value = "LIMITED";};
                    class normal_speed {name = "Normal"; value = "NORMAL";};
                    class full_speed {name = "Fast"; value = "FULL";};
                };
            };
            class Crew_Percentage {
                displayName = "Set amount of troops";
                description = "Set the percentage of the vehicle filled with troops";
                typeName = "NUMBER";
                defaultValue = 50;
                class Values {
                    class twenty_five {name = "25%"; value = 25;};
                    class fifty {name = "50%"; value = 50;};
                    class seventy_five {name = "75%"; value = 75;};
                    class one_hundred {name = "100%"; value = 100;};
                };
            };
            class Routine_Function {
                displayName = "Routine Function";
                description = "The function called by this module. Do not change this unless you know what it does";
                typeName = "STRING";
                defaultValue = "ark_navy_fnc_paradrop";
            };
        };
    };
    
    class ARK_Navy_Insert: ARK_Module {
        scope = 2;
        displayName = "Navy - Infantry Insert";
        icon = "\x\ark\addons\ark_navy\resources\insert.paa";
        function = "ark_navy_module_preinit";
        isTriggerActivated = 1;
        isGlobal = 0;
        isDisposable = 1;
        class ModuleDescription {
            description = "Lands the helo at the first waypoint";
        };
        class Arguments {
            class Fly_Height {
                displayName = "Set fly in height";
                description = "Set the height in meters the helo will try to fly at";
                typeName = "NUMBER";
                defaultValue = 200;
            };
            class Fly_Speed {
                displayName = "Set aircraft speed";
                description = "Set the speed the aircraft will maintain";
                typeName = "STRING";
                defaultValue = "NORMAL";
                class Values {
                    class limited_speed {name = "Slow";  value = "LIMITED";};
                    class normal_speed {name = "Normal"; value = "NORMAL";};
                    class full_speed {name = "Fast"; value = "FULL";};
                };
            };
            class Crew_Percentage {
                displayName = "Set amount of troops";
                description = "Set the percentage of the vehicle filled with troops";
                typeName = "NUMBER";
                defaultValue = 50;
                class Values {
                    class twenty_five {name = "25%"; value = 25;};
                    class fifty {name = "50%"; value = 50;};
                    class seventy_five {name = "75%"; value = 75;};
                    class one_hundred {name = "100%"; value = 100;};
                };
            };
            class Routine_Function {
                displayName = "Routine Function";
                description = "The function called by this module. Do not change this unless you know what it does";
                typeName = "STRING";
                defaultValue = "ark_navy_fnc_insert";
            };
        };
    };
    
    class ARK_Navy_Barrelbomb: ARK_Module {
        scope = 2;
        displayName = "Navy - Barrel Bomb";
        icon = "\x\ark\addons\ark_navy\resources\barrel.paa";
        function = "ark_navy_module_preinit";
        isTriggerActivated = 1;
        isGlobal = 0;
        isDisposable = 1;
        class ModuleDescription {
            description = "Drops barrel bombs at the second waypoint";
        };
        class Arguments {
            class Fly_Height {
                displayName = "Set fly in height";
                description = "Set the height in meters the helo will try to fly at";
                typeName = "NUMBER";
                defaultValue = 200;
            };
            class Fly_Speed {
                displayName = "Set aircraft speed";
                description = "Set the speed the aircraft will maintain";
                typeName = "STRING";
                defaultValue = "NORMAL";
                class Values {
                    class limited_speed {name = "Slow";  value = "LIMITED";};
                    class normal_speed {name = "Normal"; value = "NORMAL";};
                    class full_speed {name = "Fast"; value = "FULL";};
                };
            };
            class Bomb_Amount {
                displayName = "Set barrel amount";
                description = "Set the amount of barrels dropped";
                typeName = "NUMBER";
                defaultValue = 3;
                class Values {
                    class one_barrel {name = "One";  value = 1;};
                    class two_barrel {name = "Two";  value = 2;};
                    class three_barrel {name = "Three";  value = 3;};
                    class four_barrel {name = "Four";  value = 4;};
                    class five_barrel {name = "Five";  value = 5;};
                };
            };
            class Routine_Function {
                displayName = "Routine Function";
                description = "The function called by this module. Do not change this unless you know what it does";
                typeName = "STRING";
                defaultValue = "ark_navy_fnc_barrelbomb";
            };
        };
    };
};