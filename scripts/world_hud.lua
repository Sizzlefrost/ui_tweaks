local world_hud = include( "hud/hud-inworld" )
local mui_defs = include( "mui/mui_defs")

local uitr_util = include( SCRIPT_PATHS.qed_uitr .. "/uitr_util" )

local oldRefreshWidgets = world_hud.refreshWidgets

function world_hud:refreshWidgets( ... )
	oldRefreshWidgets( self, ... )

	if uitr_util.checkOption("cleanShift") then
		local shouldShowHudActions = not (inputmgr.keyIsDown(mui_defs.K_SHIFT) and not inputmgr.keyIsDown(mui_defs.K_CONTROL))
		if shouldShowHudActions ~= self._uitr_hudActionsVisible  then
			local widgets = self._widgets[world_hud.HUD] or {}
			for _,widget in ipairs(widgets) do
				widget:setVisible(shouldShowHudActions)
			end
		end
		self._uitr_hudActionsVisible = shouldShowHudActions
	else
		self._uitr_showHudActions = nil
	end
end