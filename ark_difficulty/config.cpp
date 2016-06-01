class CfgPatches {
    class ark_difficulty {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Data_F"};
        author = "ARK";
        authorUrl = "http://www.ark-group.org";
    };
};

class CfgAILevelPresets {
    class AILevelLow {
        displayName = "ARK";
        precisionAI = 0.285;
        skillAI = 1;  
    };
};

class CfgDifficultyPresets {
    defaultPreset = "Regular";
        class Regular {
            description = "Why do I have to write a mod for this?!";
            levelAI = "AILevelLow";
                class Options {
                    autoReport = 0;
                    cameraShake = 1;
                    commands = 0;
                    deathMessages = 0;
                    detectedMines = 0;
                    enemyTags = 0;
                    friendlyTags = 0;
                    groupIndicators = 0;
                    mapContent = 0;
                    multipleSaves = 0;
                    reducedDamage = 0;
                    scoreTable = 0;
                    staminaBar = 0;
                    stanceIndicator = 1;
                    thirdPersonView = 0;
                    visionAid = 0;
                    vonID = 0;
                    waypoints = 0;
                    weaponCrosshair = 1;
                    weaponInfo = 1;
                };
        };
};