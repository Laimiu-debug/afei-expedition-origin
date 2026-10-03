// Only Douyu replaces the fixed native overlay. The actor, tile and bust stay
// at their original size/position; these native UI brushes have their own offset.
::AfeixExpedition.DouyuOverlay <- {
    Height = 165,
    function init(actor) {
        actor.m.AfeixBarSprites = [];
        actor.m.AfeixBarIcons = [];
        foreach (name in ["bottom", "head", "body", "hp", "top"]) {
            local id = "afeix_bar_" + name;
            local sprite = actor.addSprite(id);
            sprite.setBrush("entityoverlay_" + (name == "bottom" || name == "top" ? name : "bar_24"));
            actor.setSpriteOffset(id, ::createVec(0, this.Height + (name == "body" ? -6 : name == "hp" ? -12 : 0)));
            if (name == "head" || name == "body") sprite.Color = ::createColor("#a6b3bc");
            if (name == "hp") sprite.Color = ::createColor("#c9362b");
            actor.m.AfeixBarSprites.push(id);
        }
        actor.m.IsUsingCustomRendering = true;
        actor.setRenderCallbackEnabled(true);
        actor.updateOverlay();
        this.visibility(actor);
    },
    function values(actor, head, body, hp) {
        if (actor.m.AfeixBarSprites.len() == 0) return;
        local values = [head, body, hp], names = ["head", "body", "hp"];
        for (local i = 0; i < names.len(); ++i) {
            local steps = ::Math.max(0, ::Math.min(24, ::Math.ceil(values[i] * 24).tointeger()));
            local sprite = actor.getSprite("afeix_bar_" + names[i]);
            if (steps > 0) sprite.setBrush("entityoverlay_bar_" + steps);
            // An empty native bar has no white sliver left at zero.
            sprite.Alpha = steps > 0 ? 255 : 0;
        }
    },
    function icons(actor, icons) {
        if (actor.m.AfeixBarSprites.len() == 0) return;
        for (local i = actor.m.AfeixBarIcons.len(); i < icons.len(); ++i) {
            local id = "afeix_bar_icon_" + i;
            actor.addSprite(id);
            actor.m.AfeixBarIcons.push(id);
        }
        for (local i = 0; i < actor.m.AfeixBarIcons.len(); ++i) {
            local id = actor.m.AfeixBarIcons[i], sprite = actor.getSprite(id);
            sprite.Alpha = i < icons.len() ? 255 : 0;
            if (i >= icons.len()) continue;
            sprite.setBrush(icons[i]);
            sprite.Scale = 1.0;
            // Center the round icons above the three bars, not over the snout.
            actor.setSpriteOffset(id, ::createVec((i - (icons.len() - 1) * 0.5) * 20, this.Height + 34));
        }
        this.visibility(actor);
    },
    function visibility(actor) {
        local tile = ::Tactical.State.getLastTileHovered();
        local hovered = tile != null && tile.IsOccupiedByActor && tile.getEntity().getID() == actor.getID();
        local shown = actor.isAlive() && !actor.isDying() && actor.isPlacedOnMap() && !actor.isHiddenToPlayer()
            && (::Settings.getTempGameplaySettings().ShowOverlayStats || hovered);
        foreach (id in actor.m.AfeixBarSprites) actor.getSprite(id).Visible = shown;
        foreach (id in actor.m.AfeixBarIcons) actor.getSprite(id).Visible = shown;
    },
    function image(actor) {
        local excluded = "socket,miniboss,arrow";
        foreach (id in actor.m.AfeixBarSprites) excluded += "," + id;
        foreach (id in actor.m.AfeixBarIcons) excluded += "," + id;
        return actor.isPlacedOnMap() && !actor.isDiscovered() ? "ui/images/undiscovered_opponent.png"
            : "tacticalentity(" + actor.m.ContentID + "," + actor.getID() + "," + excluded + ")";
    }
};
