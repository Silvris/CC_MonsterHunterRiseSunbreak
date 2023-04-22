using System;
using System.Collections.Generic;
using CrowdControl.Common;
using CrowdControl.Games.Packs;
using ConnectorType = CrowdControl.Common.ConnectorType;

public class MHRSB : SimpleTCPPack
{
    public override string Host { get; } = "127.0.0.1";

    public override ushort Port { get; } = 64772;

    public MHRSB(IPlayer player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler) : base(player, responseHandler, statusUpdateHandler) { }

    public override Game Game { get; } = new Game(92, "Monster Hunter Rise: Sunbreak", "MHRSB", "PC", ConnectorType.SimpleTCPServerConnector);

    public override List<Effect> Effects => new List<Effect>
    {
        //General Effects
        new Effect("Reduce HP to 1", "hpone"),
      // Wait for 2.0, timers not working  new Effect("Switch Curse", "nswview"),
      new Effect("Hunter Invisible", "invisp1") {Duration = 30},
        new Effect ("Drain Stamina", "staminadrain"), //works, but timers aren't displaying in testing - per Kat, 2.0 may correct this
      //  new Effect ("Chainsaw Massacre", "chainsawinfini"),
        //new Effect("Give Wild Wirebug","addwirebug"), commented out as it's currently unstable

        //Armor Pigment
      //  new Effect("Change Armor Pigment","armorpigment",ItemKind.Folder),
      //  new Effect("Change Helm Pigment 1","pigment_helm1","armorpigment"),
    //    new Effect("Change Helm Pigment 2","pigment_helm2","armorpigment"),
    //    new Effect("Change Chest Pigment 1","pigment_chest1","armorpigment"),
    //    new Effect("Change Chest Pigment 2","pigment_chest2","armorpigment"),
    //    new Effect("Change Arms Pigment 1","pigment_arms1","armorpigment"),
  //      new Effect("Change Arms Pigment 2","pigment_arms2","armorpigment"),
  //      new Effect("Change Waist Pigment 1","pigment_waist1","armorpigment"),
  //      new Effect("Change Waist Pigment 2","pigment_waist2","armorpigment"),
    ///    new Effect("Change Legs Pigment 1","pigment_legs1","armorpigment"),
    //    new Effect("Change Legs Pigment 2","pigment_legs2","armorpigment"),

        //Debuffs/Blights
        new Effect("Inflict Debuff/Blight","debuffs",ItemKind.Folder),
        new Effect("Attack Down -50%", "attackdown","debuffs"),
        new Effect ("Defense Down -50%", "defensedown", "debuffs"),
        new Effect("Inflict Poison", "inflict_poison","debuffs"),
        new Effect("Inflict Noxious Poison", "inflict_noxiouspoison","debuffs"),
        new Effect("Inflict Deadly Poison", "inflict_deadlypoison", "debuffs"),
        new Effect("Inflict Mild Bubbleblight", "inflict_bubble_m","debuffs"),
        new Effect("Inflict Severe Bubbleblight", "inflict_bubble_l","debuffs"),
        new Effect("Inflict Frenzy Virus", "inflict_frenzy","debuffs"),
        new Effect("Inflict Bleed", "inflict_bleed","debuffs"),
        new Effect("Explode the Hunter", "inflict_blast","debuffs"),
        new Effect("Inflict Hellfire", "inflict_hellfire","debuffs"),
        new Effect("Inflict Fireblight", "inflict_fireblight","debuffs"),
        new Effect("Inflict Waterblight", "inflict_waterblight","debuffs"),
        new Effect("Inflict Iceblight", "inflict_iceblight","debuffs"),
        new Effect("Inflict Thunderblight", "inflict_thunderblight","debuffs"),
        new Effect("Inflict Dragonblight", "inflict_dragonblight","debuffs"),
        new Effect("Inflict Bloodblight", "inflict_bloodblight","debuffs"),
        new Effect("Inflict Stench", "inflict_stench","debuffs")

    };

    //Slider ranges need to be defined
    /*
    public override List<ItemType> ItemTypes => new List<ItemType>(new[]
    {
        new ItemType("Credits", "credits1000", ItemType.Subtype.Slider, "{\"min\":1,\"max\":1000}"),
        new ItemType("Skill Points", "skillpoints1000", ItemType.Subtype.Slider, "{\"min\":1,\"max\":1000}"),
        new ItemType("Amount","amount100",ItemType.Subtype.Slider, "{\"min\":1,\"max\":100}")
    });
    */
}
