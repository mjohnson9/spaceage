TOOL.Tab = "SpaceAge"
TOOL.Category = "Resources"
TOOL.Name = "#tool.sa_resource_link.name"

if CLIENT then
	language.Add("tool.sa_resource_link.name", "Resource Link")
	language.Add("tool.sa_resource_link.desc", "Link two resource nodes together")
	language.Add("tool.sa_resource_link.0", "Left click on a resource node to select it.")
	language.Add("tool.sa_resource_link.1", "Left click on another resource node to link it.")

	language.Add("Undone_Resource Link", "Undone Resource Link")
end

local function undoLink(_, source, target)
	if not source:IsInNetwork(target) then
		return
	end

	local network = source:GetNetwork()
	network:removeLink(source, target)
end

function TOOL:LeftClick(trace)
	if not IsValid(trace.Entity) then
		return false
	end

	if not trace.Entity.ResourceLinkable then
		return false
	end

	local operationNum = self:NumObjects() -- how many objects have been linked so far?
	self:SetObject(operationNum + 1, trace.Entity, trace.HitPos, trace.Entity:GetPhysicsObjectNum(trace.PhysicsBone), trace.PhysicsBone, trace.HitNormal)

	if operationNum == 1 then
		local source = self:GetEnt(1)
		local target = self:GetEnt(2)
		if not source:IsValid() or not target:IsValid() then
			self:SetStage(0)
			self:ClearObjects()
			return true
		end

		if source:IsInNetwork(target) then
			self:SetStage(0)
			self:ClearObjects()
			return false
		end

		if SERVER then
			source:ResourceLink(target)

			local sourceBone = self:GetBone(1)
			local targetBone = self:GetBone(2)

			local sourceLocalPos = self:GetLocalPos(1)
			local targetLocalPos = self:GetLocalPos(2)

			local sourceWorldPos = self:GetPos(1)
			local targetWorldPos = self:GetPos(2)

			local ropeLength = sourceWorldPos:Distance(targetWorldPos)

			local constraint, rope = constraint.Rope(source, target, sourceBone, targetBone, sourceLocalPos, targetLocalPos, ropeLength, 32, 0, 1.5, "cable/cable2", false)

			undo.Create("Resource Link")
				undo.AddEntity(constraint)
				undo.AddEntity(rope)
				undo.AddFunction(undoLink, source, target)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()
		end

		self:SetStage(0)
		self:ClearObjects()

		return true
	else
		self:SetStage(1)
	end

	return true
end
