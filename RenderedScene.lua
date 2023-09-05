
Instance.properties = properties({
	{ name="Width", type="Int", range={min=0}, value=800, onUpdate="onDimUpdate" },
	{ name="Height", type="Int", range={min=0}, value=600, onUpdate="onDimUpdate" },
})


Instance.emitMemberUpdate = event("onMemberUpdate")

function Instance:onInit(constructor_type)
	-- Limit our scene display's functionality to just image filters
	self:getRenderStack():getDisplay():getDisplayBinding():setGraphicsPipelineFeatures({"ImageFilters"})
	self:getRenderStack():getViewPort().enableAlphaBlending = false

	-- Hide layer from scene layout
	getUI():setUIProperty({{obj=self:getActiveProperty(), visible=false}})

	self:getRenderStack():getViewPort().clearColor = vector4(0,0,0,0)
	self:getRenderStack():getViewPort().clearMode = "Clear"

	self:getLayerKit():addEventListener("onUpdate", self, self.emitMemberUpdate)
	self:onDimUpdate()
end

function Instance:onMemberUpdate()
	self:onDimUpdate()
	self:emitMemberUpdate()
end

function Instance:onDimUpdate()
	self:getRenderStack():setResolution(self.properties.Width, self.properties.Height)
end

function Instance:displayEditorUI()

	if (getEditor():getEditingScene() == self) then
		return
	end

	getEditor():pushEditingScene(self, "Default")

	if (self:getRenderStack():getDisplay():getDisplayTexture():isManualRenderingEnabled()) then
		self:getRenderStack():getDisplay():getDisplayTexture():enableManualRendering(false)
		getEditor():addEventListener("onEditingSceneChange", self, self.onExitUIEdit)
	end

end

function Instance:onExitUIEdit()
	-- Handle weird case of deleting crop while editing it
	if (not exists(self)) then
		return
	end
	self:getRenderStack():getDisplay():getDisplayTexture():enableManualRendering(true)
	getEditor():removeEventListener("onEditingSceneChange", self, self.onExitUIEdit)
end
