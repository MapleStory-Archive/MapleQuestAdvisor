--[[
    This file is part of the MapleQuestAdvisor planning tool
    Copyleft (L) 2020 - 2021 RonanLana

    GNU General Public License v3.0

    Permissions of this strong copyleft license are conditioned on making available complete
    source code of licensed works and modifications, which include larger works using a licensed
    work, under the same license. Copyright and license notices must be preserved. Contributors
    provide an express grant of patent rights.
--]]

require("ui.constant.view.resource")
require("ui.struct.component.canvas.resource.item.link")
require("ui.struct.component.canvas.resource.item.picture")

local function make_tab_resources_items(pRscProp)
    local rgpVwItems = {}

    local siType = RResourceTable.TAB.ITEMS.ID

    for iId, iCount in pairs(pRscProp:get_info_item():get_items()) do
        local pVwItem = CRscElemItemPicture:new()

        local pImg = ctHrItems:load_image_by_id(iId)
        local sDesc = ctItemsMeta:get_text(iId, 1)
        local iFieldRef = pVwItem:get_field_link()

        pVwItem:load(siType, iId, tpRscGrid, pImg, iCount, sDesc, iFieldRef, RResourceTable.VW_BASE.ITEMS, RResourceTable.VW_GRID.ITEMS, false)

        table.insert(rgpVwItems, pVwItem)
    end

    return rgpVwItems
end

local function make_tab_resources_mobs(pRscProp)
    local rgpVwItems = {}

    local siType = RResourceTable.TAB.MOBS.ID

    for iId, iCount in pairs(pRscProp:get_info_mob():get_mobs()) do
        local pVwItem = CRscElemItemPicture:new()

        local pImg = ctHrMobs:load_image_by_id(iId)
        local sDesc = ctMobsMeta:get_text(iId)
        local iFieldRef = pVwItem:get_field_link()

        local pVwBase = {W = pImg:getWidth(), H = pImg:getHeight()}
        pVwItem:load(siType, iId, tpRscGrid, pImg, iCount, sDesc, iFieldRef, pVwBase, pVwBase, false)

        table.insert(rgpVwItems, pVwItem)
    end

    return rgpVwItems
end

local function make_tab_resources_npc(pRscProp)
    local rgpVwItems = {}

    local siType = RResourceTable.TAB.NPC.ID

    local iId = pRscProp:get_info_npc():get_npc()
    if iId >= 0 then
        local pVwItem = CRscElemItemPicture:new()

        local pImg = ctHrNpcs:load_image_by_id(iId)
        local sDesc = ctNpcsMeta:get_text(iId)
        local iFieldRef = pVwItem:get_field_link()

        local pVwBase = {W = pImg:getWidth(), H = pImg:getHeight()}
        pVwItem:load(siType, iId, tpRscGrid, pImg, nil, sDesc, iFieldRef, pVwBase, pVwBase, false)

        table.insert(rgpVwItems, pVwItem)
    end

    return rgpVwItems
end

local function make_tab_resources_field_enter(pRscProp)
    local rgpVwItems = {}

    local siType = RResourceTable.TAB.FIELD_ENTER.ID
    for _, iId in pairs(pRscProp:get_info_field_enter():get_fields()) do
        local sDesc = ctFieldsMeta:get_area_name(iId)
        local iFieldRef = iId

        local pVwItem = CRscElemItemLink:new()
        pVwItem:load(siType, iId, tpRscGrid, sDesc, iFieldRef, RResourceTable.VW_GRID.FIELD_ENTER, false)

        table.insert(rgpVwItems, pVwItem)
    end

    return rgpVwItems
end

_tpVwItemsB = {}

local function clear_resource_items(pVwRscs)
    for siTab, rgpVwItems in pairs(_tpVwItemsB) do
        pVwRscs:add_tab_items(siTab, rgpVwItems)
        clear_table(rgpVwItems)
    end

    pVwRscs:clear_tab_items()
end

local function insert_resource_items(pVwRscs, pRscProp)
    local tpVwItems = {}

    tpVwItems[RResourceTable.TAB.MOBS.ID] = make_tab_resources_mobs(pRscProp)
    tpVwItems[RResourceTable.TAB.ITEMS.ID] = make_tab_resources_items(pRscProp)
    tpVwItems[RResourceTable.TAB.NPC.ID] = make_tab_resources_npc(pRscProp)
    tpVwItems[RResourceTable.TAB.FIELD_ENTER.ID] = make_tab_resources_field_enter(pRscProp)
    tpVwItems[RResourceTable.TAB.REWARD.ID] = {}

    for siTab, rgpVwItems in pairs(tpVwItems) do
        pVwRscs:add_tab_items(siTab, rgpVwItems)
    end

    _tpVwItemsB = tpVwItems
end

function update_resource_items(pVwRscs, pRscProp, pQuest)
    clear_resource_items(pVwRscs)
    insert_resource_items(pVwRscs, pRscProp)

    pVwRscs:refresh_view_items()
    pVwRscs:set_quest_reward(pQuest)
end
