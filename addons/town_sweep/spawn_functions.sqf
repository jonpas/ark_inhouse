#include "\x\ark\addons\admiral\admiral_macros.h"



ts_spawn_location_sizeChange = 100;

ts_spawn_fnc_preinit = {
    ts_spawn_selectedLocationMarkerName = "ts_spawn_selectedLocation";
    ts_spawn_selectedLocation = [];
    ts_spawn_placedFortifications = [];
    ts_spawn_ai_multiplier = 2;
    ts_spawn_cqc_percent = 0.3;
    ts_spawn_playerCount = 0;
    ts_spawn_aiCount = 0;
    ts_spawn_cqcCount = 0;
    ts_spawn_patrolInfGroupCount = 0;
    ts_spawn_patrolTechGroupCount = 0;
    ts_spawn_patrolArmourGroupCount = 0;
    ts_spawn_unitTemplate = "Base";

    call ts_spawn_fnc_createLocationMarker;
};

ts_spawn_fnc_onAdmiralInit = {
    private _templateConfigs = "ts_camouflage in getArray (_x >> 'camouflage') && {configName _x != 'Base'} && {getText (_x >> 'side') != ts_player_factionRawSide}" configClasses (ADMIRAL_CONFIG_FILE >> "UnitTemplates");
    private _templateConfig = selectRandom _templateConfigs;
    ts_spawn_unitTemplate = configName _templateConfig;
    adm_camp_defaultUnitTemplate = ts_spawn_unitTemplate;
    adm_patrol_defaultUnitTemplate = ts_spawn_unitTemplate;
    adm_cqc_defaultUnitTemplate = ts_spawn_unitTemplate;
    adm_common_fnc_getUnitTemplateSide = { ts_enemy_side };
};

ts_spawn_fnc_selectLocation = {
    hintSilent "Click on map to select attack location.";
    ["ts_mapClick", "onMapSingleClick", {
        [0, { _this call ts_spawn_fnc_moveLocationMarker; ts_spawn_selectedLocation set [0, (_this #0)]; ts_spawn_selectedLocation set [1, (_this #1)]; ts_spawn_selectedLocation set [2, (_this #2)]; ts_spawn_playerCount = count (playableUnits select { isPlayer _x });}, [_pos, 1000, false]] call CBA_fnc_globalExecute;
        ["ts_mapClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
    }] call BIS_fnc_addStackedEventHandler;
};

ts_spawn_fnc_canLocationBeActivated = {
    count ts_spawn_selectedLocation > 0 && {!(ts_spawn_selectedLocation #2)}
};

ts_spawn_fnc_changeLocationSize = {
    params ["_sizeChange"];

    if !(call ts_spawn_fnc_canLocationBeActivated) exitWith {};
    private _size = (ts_spawn_selectedLocation #1) + _sizeChange;
    ts_spawn_selectedLocation set [1, _size];
    ts_spawn_selectedLocationMarkerName setMarkerSize [_size, _size];
};

ts_spawn_fnc_activateLocation = {
    if !(call ts_spawn_fnc_canLocationBeActivated) exitWith {};
    call ts_spawn_fnc_activateLocationMarker;
    ts_spawn_aiCount = ceil (ts_spawn_playerCount * ts_spawn_ai_multiplier);
    ts_spawn_cqcCount = ceil (ts_spawn_aiCount * ts_spawn_cqc_percent);
    private _fireTeamSize = ["ZoneTemplates", adm_patrol_defaultZoneTemplate, "infFireteamSize"] call adm_config_fnc_getNumber;
    private _patrolAiCount = ceil (ts_spawn_aiCount * (1 - ts_spawn_cqc_percent));
    ts_spawn_patrolInfGroupCount = ceil (_patrolAiCount / _fireTeamSize);
    ts_spawn_patrolTechGroupCount = 1 + (floor (ts_spawn_playerCount / 10));
    ts_spawn_patrolArmourGroupCount = 1 + (floor (ts_spawn_playerCount / 25));
    call ts_spawn_fnc_createLocationZones;
    ts_spawn_selectedLocation set [2, true];
    call ts_spawn_fnc_createFortifications;
    [
        {count (allPlayers inAreaArray ts_spawn_selectedLocationMarkerName) > 0},
        {[{private _insertType = selectRandomWeighted ["paradrop", 0.5, "insert", 0.5]; _insertType call ts_spawn_fnc_enableRotor;}, [], 180] call CBA_fnc_waitAndExecute;}
    ] call CBA_fnc_waitUntilAndExecute;
};

ts_spawn_fnc_createLocationMarker = {
    private _marker = createmarker [ts_spawn_selectedLocationMarkerName, [0, 0, 0]];
    _marker setMarkerSize [1, 1];
    _marker setMarkerAlpha 0.5;
    _marker setMarkerShape "ELLIPSE";
    _marker setMarkerBrush "Solid";
    _marker setMarkerColor "ColorRed";
};

ts_spawn_fnc_moveLocationMarker = {
    params ["_position", "_size"];
    ts_spawn_selectedLocationMarkerName setMarkerPos _position;
    ts_spawn_selectedLocationMarkerName setMarkerSize [_size, _size];
    ts_spawn_selectedLocationMarkerName setMarkerAlpha 0.5;
    ts_spawn_selectedLocationMarkerName setMarkerBrush "Solid";
    ts_spawn_selectedLocationMarkerName setMarkerColor "ColorRed";
};

ts_spawn_fnc_activateLocationMarker = {
    ts_spawn_selectedLocationMarkerName setMarkerAlpha 0.4;
    ts_spawn_selectedLocationMarkerName setMarkerBrush "Solid";
    ts_spawn_selectedLocationMarkerName setMarkerColor "ColorRed";
};

ts_spawn_fnc_createLocationZones = {
    ts_spawn_selectedLocation params ["_position", "_size", "_active"];

    [ ["type", "cqc"]
    , ["position", _position]
    , ["area", [_size, _size, 0, false]]
    , ["pool", ts_spawn_cqcCount]
    , ["unitTemplate", adm_cqc_defaultUnitTemplate]
    , ["zoneTemplate", adm_cqc_defaultZoneTemplate]
    , ["enabled", _active]
    ] call adm_api_fnc_initZone;

    [ ["type", "patrol"]
    , ["position", _position]
    , ["area", [_size, _size, 0, false]]
    , ["pool", [ts_spawn_patrolInfGroupCount, ts_spawn_patrolTechGroupCount, ts_spawn_patrolArmourGroupCount]]
    , ["unitTemplate", adm_patrol_defaultUnitTemplate]
    , ["zoneTemplate", adm_patrol_defaultZoneTemplate]
    , ["enabled", _active]
    ] call adm_api_fnc_initZone;
};

ts_spawn_fnc_enableRotor = {
    params ["_insertType"];
    ts_spawn_selectedLocation params ["_position"];

    private _lzPos = [_position, 0, 150, 10, 0, 0.2] call BIS_fnc_findSafePos;
    // BIS_fnc_findSafePos returns X and Y with success and  X Y Z on failure... fucking BI
    if (count _selectedPos isEqualTo 3) exitWith {};

    private _spawnPos = _position getPos [3000, random 360];
    private _spawnZone = createTrigger ["EmptyDetector", _spawnPos, false];
    private _grp = createGroup civilian;
    _grp deleteGroupWhenEmpty true;
    private _jeff = _grp createUnit ["C_Jeff_VR", _spawnPos, [], 0, "NONE"];
    _grp addWaypoint [_lzPos, 0, 1];
    _grp addWaypoint [[worldSize, worldSize, 0], 100, 2];

    private "_module";
    if (_insertType isEqualTo "paradrop") then {
        _module = "ARK_Rotor_Paradrop" createVehicleLocal _spawnPos;
        _module setVariable ["Routine_Function", "ark_rotor_fnc_paradrop"];
    } else {
        _module = "ARK_Rotor_Insert" createVehicleLocal _spawnPos;
        _module setVariable ["Routine_Function", "ark_rotor_fnc_insert"];
        _module setVariable ["Fly_Height", 75];
    };

    _module setVariable ["Crew_Percentage", 100];
    _spawnZone synchronizeObjectsAdd [_module,_jeff];
};

ts_spawn_fnc_createFortifications = {
    ts_spawn_selectedLocation params ["_position"];

    private "_fortificationArr";
    if (ts_camouflage isEqualTo "woodland") then {
        _fortificationArr = [
            "Land_BagBunker_01_small_green_F",
            "Land_Misc_deerstand",
            "cwa_Fortress1",
            "cwa_Fortress2",
            "Land_Bunker_01_small_F",
            "Land_PillboxBunker_01_hex_F",
            "Land_BagBunker_01_large_green_F",
            "Land_GuardTower_01_F",
            "Land_Bunker_02_double_F"
        ];
    } else {
        _fortificationArr = [
            "Land_BagBunker_Small_F",
            "Land_Misc_deerstand",
            "Fortress1",
            "Fortress2",
            "Land_PillboxBunker_01_hex_F",
            "Land_BagBunker_Large_F",
            "Land_GuardTower_01_F",
            "WarfareBCamp"
        ];
    };

    private _fortificationPosArr = [];
    for "_i" from 1 to 20 do {
        private _selectedPos = [_position, 250, 400, 10, 0, 0.2] call BIS_fnc_findSafePos;
        if (count _selectedPos isEqualTo 2 && { !(isOnRoad _selectedPos) }) then {
            _fortificationPosArr pushBackUnique _selectedPos;
        };
    };

    private _totalPosAmount = count _fortificationPosArr;
    private _fortificationAmount = 5;
    if (_totalPosAmount < 5) then {
        _fortificationAmount = _totalPosAmount;
    };

    for "_i" from 1 to _fortificationAmount do {
        private _selectedFortification = selectRandom _fortificationArr;
        private _selectedLocation = selectRandom _fortificationPosArr;
        _fortificationPosArr deleteAt (_fortificationPosArr find _selectedLocation);

        private _fortification = createVehicle [_selectedFortification, _selectedLocation, [], 0, "NONE"];
        _fortification setVectorDir (getpos _fortification vectorFromTo _position);
        _fortification setVectorUp surfaceNormal position _fortification;
        _fortification call ts_spawn_fnc_fillFortifications;
        ts_spawn_placedFortifications pushBack _fortification;
    };
};

ts_spawn_fnc_fillFortifications = {
    params ["_building"];

    private _buildingPositions = _building buildingPos -1;
    private _scaledBuildingPositions = [];

    if (count _buildingPositions < 6) then {
        _scaledBuildingPositions = _buildingPositions;
    } else {
        for "_i" from 0 to (count _buildingPositions) step 2 do {
            _scaledBuildingPositions pushBack (_buildingPositions select _i);
        };
    };

    private _grp = createGroup ts_enemy_side;
    _grp deleteGroupWhenEmpty true;
    _grp enableDynamicSimulation true;
    private _skillArray = ["Camp"] call adm_common_fnc_getZoneTemplateSkillValues;
    private _infantryClassnames = [adm_camp_defaultUnitTemplate, "infantry"] call adm_common_fnc_getUnitTemplateArray;

    {
        private _unit = [_x, _grp, _infantryClassnames, _skillArray] call adm_common_fnc_placeMan;
        [_unit, true] call ark_ai_sentry_fnc_make_sentry;
        _unit setUnitPos "UP";
    } forEach _scaledBuildingPositions;
};

