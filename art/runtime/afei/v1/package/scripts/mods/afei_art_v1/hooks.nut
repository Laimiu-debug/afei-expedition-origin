::mods_hookExactClass("entity/tactical/player", function(o)
{
    local onInit = o.onInit;
    o.onInit = function()
    {
        local result = onInit();
        ::AfeiArtV1.ensureDiscLayer(this);
        return result;
    };

    local onAppearanceChanged = o.onAppearanceChanged;
    o.onAppearanceChanged = function(_appearance, _setDirty = true)
    {
        local result = onAppearanceChanged(_appearance, _setDirty);
        if (::AfeiArtV1.isManaged(this)) ::AfeiArtV1.apply(this);
        return result;
    };

    local onUpdateInjuryLayer = o.onUpdateInjuryLayer;
    o.onUpdateInjuryLayer = function()
    {
        local result = onUpdateInjuryLayer();
        if (::AfeiArtV1.isManaged(this)) ::AfeiArtV1.applyToadInjury(this);
        return result;
    };

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function(_in)
    {
        ::AfeiArtV1.ensureDiscLayer(this);
        local result = onDeserialize(_in);
        if (::AfeiArtV1.isManaged(this))
        {
            this.onAppearanceChanged(this.getItems().getAppearance(), true);
            this.onUpdateInjuryLayer();
        }
        else this.getSprite(::AfeiArtV1.DiscLayer).Visible = false;
        return result;
    };

    local onFactionChanged = o.onFactionChanged;
    o.onFactionChanged = function()
    {
        local result = onFactionChanged();
        if (::AfeiArtV1.isManaged(this) && this.hasSprite(::AfeiArtV1.DiscLayer))
            this.getSprite(::AfeiArtV1.DiscLayer).setHorizontalFlipping(!this.isAlliedWithPlayer());
        return result;
    };

    local onDeath = o.onDeath;
    o.onDeath = function(_killer, _skill, _tile, _fatalityType)
    {
        // Native corpse construction uses *_dead on head/body/hair only.
        // The independent disc disappears and is never added to a corpse.
        if (::AfeiArtV1.isManaged(this) && this.hasSprite(::AfeiArtV1.DiscLayer))
            this.getSprite(::AfeiArtV1.DiscLayer).Visible = false;
        return onDeath(_killer, _skill, _tile, _fatalityType);
    };

    local onCombatFinished = o.onCombatFinished;
    o.onCombatFinished = function()
    {
        local result = onCombatFinished();
        // Recover the disc after an unconscious survivor returns to the roster.
        if (::AfeiArtV1.isManaged(this)) ::AfeiArtV1.apply(this);
        return result;
    };
});
