// Only actors explicitly tagged with afeix_v1_form are managed.
// This maps artwork, not promotion requirements, stats, skills or unlocks.
::AfeiArtV1 <- {
    FormFlag = "afeix_v1_form",
    DiscFlag = "afeix_v1_show_feidie",
    DiscLayer = "afeix_v1_feidie_layer",
    HairBrush = "hair_black_02",
    Forms = ["normal", "toad", "jiahao", "feidie"]
};
::AfeiArtV1.setdelegate(getroottable());

::AfeiArtV1.getForm <- function(_actor)
{
    if (_actor == null || !_actor.getFlags().has(this.FormFlag)) return "";
    local form = _actor.getFlags().get(this.FormFlag);
    return this.Forms.find(form) != null ? form : "";
};

::AfeiArtV1.isManaged <- function(_actor)
{
    return this.getForm(_actor) != "";
};

::AfeiArtV1.ensureDiscLayer <- function(_actor)
{
    if (!_actor.hasSprite(this.DiscLayer))
    {
        // Created consistently during player initialization, before save restore.
        // Empty/invisible on untagged actors; it never takes the helmet slot.
        _actor.addSprite(this.DiscLayer).Visible = false;
    }
    return _actor.getSprite(this.DiscLayer);
};

::AfeiArtV1.discIsEnabled <- function(_actor)
{
    if (_actor.getFlags().has(this.DiscFlag))
        return _actor.getFlags().get(this.DiscFlag) == true;
    return this.getForm(_actor) == "feidie";
};

::AfeiArtV1.setForm <- function(_actor, _form, _showDisc = null)
{
    if (_actor == null || this.Forms.find(_form) == null)
        throw "AfeiArtV1.setForm: expected normal, toad, jiahao or feidie";
    _actor.getFlags().set(this.FormFlag, _form);
    _actor.getFlags().set(this.DiscFlag, _showDisc == null ? _form == "feidie" : _showDisc);
    // Native appearance resolves armor, helmet, hair occlusion and weapons first.
    _actor.onAppearanceChanged(_actor.getItems().getAppearance(), true);
    this.apply(_actor);
    _actor.onUpdateInjuryLayer();
};

::AfeiArtV1.setDiscVisible <- function(_actor, _visible)
{
    if (!this.isManaged(_actor)) return false;
    _actor.getFlags().set(this.DiscFlag, _visible == true);
    return this.apply(_actor);
};

::AfeiArtV1.apply <- function(_actor)
{
    local form = this.getForm(_actor);
    if (form == "" || !_actor.hasSprite("head") || !_actor.hasSprite("body")) return false;
    if (!_actor.m.IsAlive || _actor.m.IsDying) return false;
    // The fourth figure is only a visual test using Jiahao's body plus the disc.
    local bodyForm = form == "feidie" ? "jiahao" : form;
    local headName = "afeix_v1_" + (form == "toad" ? "toad_head" : "human_head");
    local bodyName = "afeix_v1_" + bodyForm + "_body";
    local required = [headName, headName + "_dead", bodyName, bodyName + "_dead", bodyName + "_injured"];
    if (this.discIsEnabled(_actor)) required.push("afeix_v1_feidie");
    foreach (name in required)
    {
        if (!_actor.doesBrushExist(name))
        {
            ::logError("[AfeiArtV1] Missing brush: " + name);
            return false;
        }
    }

    local head = _actor.getSprite("head");
    local body = _actor.getSprite("body");
    head.setBrush(headName);
    body.setBrush(bodyName);
    foreach (sprite in [head, body])
    {
        sprite.Color = _actor.createColor("#ffffff");
        sprite.Saturation = 1.0;
    }
    // Retain the native visibility just resolved by onAppearanceChanged.
    // In particular, never force head/body visible under a concealing item.
    local hair = _actor.getSprite("hair");
    if (form == "toad")
    {
        hair.resetBrush();
        hair.Visible = false;
    }
    else
    {
        hair.setBrush(this.HairBrush);
        hair.Color = _actor.createColor("#ffffff");
        hair.Saturation = 1.0;
        local appearance = _actor.getItems().getAppearance();
        hair.Visible = (!appearance.HideHair && !appearance.HideHead) || _actor.m.IsHidingHelmet;
    }
    foreach (layer in ["beard", "beard_top"])
    {
        if (_actor.hasSprite(layer))
        {
            _actor.getSprite(layer).resetBrush();
            _actor.getSprite(layer).Visible = false;
        }
    }

    local disc = this.ensureDiscLayer(_actor);
    disc.Visible = this.discIsEnabled(_actor);
    if (disc.Visible)
    {
        disc.setBrush("afeix_v1_feidie");
        disc.Color = _actor.createColor("#ffffff");
        disc.Saturation = 1.0;
        disc.setHorizontalFlipping(!_actor.isAlliedWithPlayer());
        // The brush has its own elevated bounds; do not scale the character.
        _actor.setSpriteOffset(this.DiscLayer, _actor.createVec(0, 0));
    }
    else disc.resetBrush();
    _actor.setDirty(true);
    return true;
};

::AfeiArtV1.applyToadInjury <- function(_actor)
{
    if (this.getForm(_actor) != "toad" || !_actor.hasSprite("injury")) return;
    local hp = _actor.m.Hitpoints / _actor.getHitpointsMax();
    if (hp > 0.67) return;
    local name = "afeix_v1_toad_head_injured_" + (hp > 0.33 ? "01" : "02");
    // Optional tailored overlays. Missing overlays retain the native fallback.
    if (_actor.doesBrushExist(name)) _actor.getSprite("injury").setBrush(name);
};
