local agent_actions = include("hud/agent_actions")
local mui_tooltip = include("mui/mui_tooltip")
local util = include("client_util")
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")

local uitr_util = include(SCRIPT_PATHS.qed_uitr .. "/uitr_util")

-- ====
-- Tooltips for vision mode actions
-- ====

local vision_tooltip = class(mui_tooltip)

function vision_tooltip:init(hud, unit)
    mui_tooltip.init(
            self, util.sformat(STRINGS.UITWEAKSR.UI.HOVER_VISION, util.toupper(unit:getName())),
            nil, nil)
    self._game = hud._game
    self._unit = unit
end

function vision_tooltip:activate(screen)
    mui_tooltip.activate(self, screen)

    local sim = self._game.simCore
    local losCoords, cells = {}, {}
    sim:getLOS():getVizCells(self._unit:getID(), losCoords)
    for i = 1, #losCoords, 2 do
        local x, y = losCoords[i], losCoords[i + 1]
        table.insert(cells, sim:getCell(x, y))
    end
    self._hiliteID = self._game.boardRig:hiliteCells(cells)
end

function vision_tooltip:deactivate()
    mui_tooltip.deactivate(self)
    self._game.boardRig:unhiliteCells(self._hiliteID)
    self._hiliteID = nil
end

-- ====

local explode_tooltip = class(mui_tooltip)

function explode_tooltip:init(hud, unit)
    mui_tooltip.init(
            self, util.sformat(STRINGS.UITWEAKSR.UI.HOVER_EFFECT, util.toupper(unit:getName())),
            nil, nil)
    self._game = hud._game
    self._unit = unit
end

function explode_tooltip:activate(screen)
    mui_tooltip.activate(self, screen)

    local cells
    local unit = self._unit
    if (unit:getUnitData().type == "simemppack" and not unit:getTraits().flash_pack) or
            unit:getTraits().targeting_ignoreLOS then
        local sim = self._game.simCore
        local x0, y0 = unit:getLocation()
        cells = simquery.rasterCircle(sim, x0, y0, unit:getTraits().range)
    else
        cells = unit:getExplodeCells()
    end

    self._hiliteID = self._game.boardRig:hiliteCells(cells)
end

function explode_tooltip:deactivate()
    mui_tooltip.deactivate(self)
    self._game.boardRig:unhiliteCells(self._hiliteID)
    self._hiliteID = nil
end

-- ====

local pulse_scan_tooltip = class(mui_tooltip)

function pulse_scan_tooltip:init(hud, unit)
    mui_tooltip.init(
            self, util.sformat(STRINGS.UITWEAKSR.UI.PULSE_EFFECT, util.toupper(unit:getName())),
            nil, nil)
    self._game = hud._game
    self._unit = unit
end

function pulse_scan_tooltip:activate(screen)
    mui_tooltip.activate(self, screen)

    local unit = self._unit
    local cells = unit:getAreaCells()

    self._hiliteID = self._game.boardRig:hiliteCells(cells)
end

function pulse_scan_tooltip:deactivate()
    mui_tooltip.deactivate(self)
    self._game.boardRig:unhiliteCells(self._hiliteID)
    self._hiliteID = nil
end

-- ====

function showvision_tooltip(unit)
    return string.format(
            "<ttheader>%s\n<ttbody>%s</>",
            util.sformat(STRINGS.UITWEAKSR.UI.BTN_UNITVISION_HEADER, util.toupper(unit:getName())),
            STRINGS.UITWEAKSR.UI.BTN_UNITVISION_HIDE_TXT)
end

local hidevision_tooltip = class(mui_tooltip)

function hidevision_tooltip:init(hud, unit)
    mui_tooltip.init(
            self,
            util.sformat(STRINGS.UITWEAKSR.UI.BTN_UNITVISION_HEADER, util.toupper(unit:getName())),
            STRINGS.UITWEAKSR.UI.BTN_UNITVISION_HIDE_TXT, nil)
    self._game = hud._game
    self._unit = unit
end

function hidevision_tooltip:activate(screen)
    mui_tooltip.activate(self, screen)

    -- Enable one-unit-vision.
    local sim = self._game.simCore
    sim:getTags().uitr_oneVision = self._unit:getID()

    -- Show player-unseen cells that are seen by this unit (because normal vision won't).
    -- So that tooltip on a seen unit isn't worse than on a ghost.
    local localPlayer = self._game:getLocalPlayer()
    local losCoords, cells = {}, {}
    sim:getLOS():getVizCells(self._unit:getID(), losCoords)
    for i = 1, #losCoords, 2 do
        local x, y = losCoords[i], losCoords[i + 1]
        if localPlayer and not sim:canPlayerSee(localPlayer, x, y) then
            table.insert(cells, sim:getCell(x, y))
        end
    end
    if #cells > 0 then
        self._hiliteID = self._game.boardRig:hiliteCells(cells)
    end

    self._game.boardRig:refresh()
end

function hidevision_tooltip:deactivate()
    mui_tooltip.deactivate(self)

    -- Reset one-unit-vision.
    local sim = self._game.simCore
    sim:getTags().uitr_oneVision = nil

    -- Reset unseen highlighted cells.
    if self._hiliteID then
        self._game.boardRig:unhiliteCells(self._hiliteID)
        self._hiliteID = nil
    end

    self._game.boardRig:refresh()
end

-- ====

local show_interest_tooltip = class(mui_tooltip)

function show_interest_tooltip:init(hud, unit, x, y, x0, y0)
    mui_tooltip.init(
            self, util.sformat(STRINGS.UITWEAKSR.UI.HOVER_INTEREST, util.toupper(unit:getName())),
            nil, nil)
    self._game = hud._game
    self._unit = unit
    self._x, self._y = x, y
    self._x0, self._y0 = x0, y0
end

function show_interest_tooltip:activate(screen)
    mui_tooltip.activate(self, screen)

    self._fx = self._game.fxmgr:addAnimFx(
            {
                loop = true,
                kanim = "gui/guard_interest_fx",
                symbol = "effect",
                anim = "in",
                x = self._x0,
                y = self._y0,
            })
end

function show_interest_tooltip:deactivate()
    mui_tooltip.deactivate(self)

    if self._fx then
        self._game.fxmgr:removeFx(self._fx)
        self._fx = nil
    end
end

-- ====
-- Helper functions
-- ====

local function addVisionActionsForUnit(hud, actions, targetUnit, isSeen, staleGhost)
    local localPlayer = hud._game:getLocalPlayer()
    local x, y
    if staleGhost then
        x, y = staleGhost:getLocation()
    else
        x, y = targetUnit:getLocation()
    end
    local z = targetUnit:getTraits().breakIceOffset -- nil for most units. Z offset for cameras.
    local sim = hud._game.simCore
    local unitRig = hud._game.boardRig:getUnitRig(targetUnit:getID())

    local unitCanSee = simquery.couldUnitSee(sim, targetUnit)
    local canNormallySeeLOS = sim:getParams().difficultyOptions.dangerZones or isSeen

    if targetUnit:getUnitData().type == "eyeball" then
        return
    end

    if not staleGhost and unitCanSee and (not isSeen or targetUnit:getPlayerOwner() == localPlayer) then
        table.insert(
                actions, {
                    txt = "",
                    icon = "gui/items/icon-action_peek.png",
                    x = x,
                    y = y,
                    z = z,
                    enabled = false,
                    layoutID = targetUnit:getID(),
                    tooltip = vision_tooltip(hud, targetUnit),
                    priority = -10.1,
                })
    end
    -- getExplodeCells = grenade or EMP pack.
    -- has range = not stickycam/holo cover/transport beacon
    -- not has carryable or deployed = planted EMP or deployed grenade, not dropped item
    if not staleGhost and targetUnit.getExplodeCells and targetUnit:hasTrait("range") and
            (not targetUnit:hasAbility("carryable") or targetUnit:getTraits().deployed) then
        table.insert(
                actions, {
                    txt = "",
                    icon = "gui/items/icon-emp.png",
                    x = x,
                    y = y,
                    z = z,
                    enabled = false,
                    layoutID = targetUnit:getID(),
                    tooltip = explode_tooltip(hud, targetUnit),
                    priority = -9,
                })
    end
    if not staleGhost and targetUnit:getTraits().pulseScan and targetUnit:isNPC() and
            targetUnit:getTraits().range > 0 then
        table.insert(
                actions, {
                    txt = "",
                    icon = "gui/items/icon-emp.png",
                    x = x,
                    y = y,
                    z = z,
                    enabled = false,
                    layoutID = targetUnit:getID(),
                    tooltip = pulse_scan_tooltip(hud, targetUnit),
                    priority = -8,
                })
    end
    if not staleGhost and unitCanSee and canNormallySeeLOS and
            (targetUnit:getPlayerOwner() ~= localPlayer) then
        local doEnable = not targetUnit:getTraits().uitr_hideVision
        table.insert(
                actions, {
                    txt = "",
                    icon = doEnable and "gui/items/icon-action_peek.png" or
                            "gui/items/uitr-icon-action_unpeek.png",
                    x = x,
                    y = y,
                    z = z,
                    enabled = true,
                    layoutID = targetUnit:getID(),
                    tooltip = doEnable and hidevision_tooltip(hud, targetUnit) or
                            showvision_tooltip(targetUnit),
                    priority = -10,
                    onClick = function()
                        targetUnit:getTraits().uitr_hideVision = not targetUnit:getTraits().uitr_hideVision
                        hud._game.boardRig:refresh()
                        hud:refreshHud()
                    end,
                })
    end
    -- Allowed on stale ghosts. Info is not connected to current location.
    if unitRig and unitRig.interestProp then
        local x0, y0 = unitRig.interestProp:getLoc()
        local xc, yc = hud._game.boardRig:worldToCell(x0, y0)
        table.insert(
                actions, {
                    txt = "",
                    icon = targetUnit:isAlerted() and "gui/icons/thought_icons/status_hunting.png" or
                            "gui/icons/thought_icons/status_investigating.png",
                    x = x,
                    y = y,
                    z = z,
                    enabled = true,
                    layoutID = targetUnit:getID(),
                    tooltip = show_interest_tooltip(hud, targetUnit, xc, yc, x0, y0),
                    priority = -9.9,
                    onClick = function()
                        hud._game:cameraPanToCell(xc, yc)
                        hud._game.fxmgr:addAnimFx(
                                {
                                    kanim = "gui/guard_interest_fx",
                                    symbol = "effect",
                                    anim = "in",
                                    x = x0,
                                    y = y0,
                                })
                    end,
                })
    end
end

local function resolveGhost(sim, unitID, ghostUnit)
    local unit = sim:getUnit(ghostUnit:getID())
    if not unit then
        return nil
    end
    local x0, y0 = ghostUnit:getLocation()
    local x1, y1 = unit:getLocation()
    if x0 ~= x1 or y0 ~= y1 then
        -- Ghost is stale (by the metric used for shift-highlighting)
        return unit, true
    end
    return unit, false
end

-- LuaFormatter off
local POTENTIAL_ACTIONS = {
    0, 0,
    1, 0,
    -1, 0,
    0, 1,
    0, -1,
    2, 0,
    -2, 0,
    0, 2,
    0, -2,
    1, 1,
    1, -1,
    -1, 1,
    -1, -1,
}
-- LuaFormatter on

local function canModifyExit(unit, exitop, cell, dir, sim)
    if not simquery.canReachDoor(unit, cell, dir) then
        return false
    end

    local exit = cell.exits[dir]
    if exitop == simdefs.EXITOP_CLOSE and exit.no_close then
        return false
    end

    return simquery.canModifyExit(unit, exitop, cell, dir)
end

local function generateDoorActionForCell(hud, unit, cell, sim)
    for dir, exit in pairs(cell.exits) do
        if exit.door and exit.keybits ~= simdefs.DOOR_KEYS.ELEVATOR and exit.keybits ~=
                simdefs.DOOR_KEYS.ELEVATOR_INUSE then
            local exitop = exit.closed and simdefs.EXITOP_OPEN or simdefs.EXITOP_CLOSE
            if canModifyExit(unit, exitop, cell, dir, sim) then
                return {
                    hotkey = "abilityOpenDoor",
                    onHotkey = function()
                        agent_actions.checkForSingleDoor(hud._game, exitop, unit, cell, dir, sim)
                    end,
                }
            end
        end
    end
end

local function generateDoorAction(hud, unit)
    local sim = hud._game.simCore
    local localPlayer = hud._game:getLocalPlayer()
    local x0, y0 = unit:getLocation()
    if not localPlayer or not x0 then
        return
    end

    for i = 1, #POTENTIAL_ACTIONS, 2 do
        local dx, dy = POTENTIAL_ACTIONS[i], POTENTIAL_ACTIONS[i + 1]
        local cell = localPlayer:getCell(x0 + dx, y0 + dy)
        if cell then
            local action = generateDoorActionForCell(hud, unit, cell, sim)
            if action then
                return action
            end
        end
    end
end

-- ===
-- Appends
-- ===

local oldGeneratePotentialActions = agent_actions.generatePotentialActions
function agent_actions.generatePotentialActions(hud, actions, unit, cellx, celly, ...)
    if hud._uitr_isVisionMode then
        return
    end
    return oldGeneratePotentialActions(hud, actions, unit, cellx, celly, ...)
end

local oldShouldShowProxyAbility = agent_actions.shouldShowProxyAbility
function agent_actions.shouldShowProxyAbility(
        game, ability, abilityOwner, abilityUser, actions, ...)
    if game.hud and game.hud._uitr_isVisionMode then
        return false
    end
    return oldShouldShowProxyAbility(game, ability, abilityOwner, abilityUser, actions, ...)
end

function agent_actions.generateVisionActions(hud, actions)
    local sim = hud._game.simCore
    local localPlayer = hud._game:getLocalPlayer()
    if not localPlayer then
        return
    end

    -- Vision actions for seen units
    for i, targetUnit in ipairs(localPlayer:getSeenUnits()) do
        addVisionActionsForUnit(hud, actions, targetUnit, true, false)
    end

    -- Vision actions for known ghosts
    for unitID, ghostUnit in pairs(localPlayer._ghost_units) do
        local targetUnit, isStale = resolveGhost(sim, unitID, ghostUnit)
        if targetUnit then
            addVisionActionsForUnit(hud, actions, targetUnit, false, isStale and ghostUnit)
        end
    end
end

-- Non-Vision actions that should still support hotkeys while in vision mode.
function agent_actions.generateNonVisionActions(hud, actions, unit)
    -- Non-proxy abilities that normally go in the bottom-left panel.
    for _, ability in ipairs(unit:getAbilities()) do
        if agent_actions.shouldShowAbility(hud._game, ability, unit, unit) and
                not ability.acquireTargets and ability.hotkey then
            table.insert(actions, {ability = ability, abilityOwner = unit, abilityUser = unit})
        end
    end

    -- Add a single action for the toggle-door hotkey binding.
    if unit:getTraits().canUseDoor ~= false then
        local doorAction = generateDoorAction(hud, unit)
        if doorAction then
            table.insert(actions, doorAction)
        end
    end
end
