
Instance.properties = properties({
	{ name="Edit", type="MetaProperty", onUpdate="onEdit"},
})

function Instance:onInit(constructor_type)

	if (constructor_type == "Default") then
		local scene = getEditor():createUIX(self:getObjectKit(), "Rendered Scene")
		scene:setName("Scene")
	end

end

function Instance:onPostInit(constructor_type)
	local scene = self:getObjectKit():findObjectByType("Scene")

	scene:addEventListener("onMemberUpdate", self, self.onMemberUpdate)

end

function Instance:onMemberUpdate()
	local scene = self:getObjectKit():findObjectByType("Scene")
	self:addCast(scene:castAs("Texture"))
end

function Instance:onEdit()
	local scene = self:getObjectKit():findObjectByType("Scene")
	scene:displayEditorUI()
end
