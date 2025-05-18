ENT.Base	    			= "base_ai"
ENT.Type	    			= "ai"
ENT.PrintName				= "NPC Magie"
ENT.Author					= "Yam"
ENT.Category 				= "Mana"
ENT.Spawnable				= true
ENT.AdminSpawnable			= true
ENT.AutomaticFrameAdvance	= true

function ENT:SetAutomaticFrameAdvance(byUsingAnim)
	self.AutomaticFrameAdvance = byUsingAnim
end