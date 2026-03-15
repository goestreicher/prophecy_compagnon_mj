import "package:prophecy_compagnon_mj/classes/creature.dart";
import "package:prophecy_compagnon_mj/classes/entity_instance.dart";
import "package:prophecy_compagnon_mj/classes/equipment/armor.dart";
import "package:prophecy_compagnon_mj/classes/equipment/cloth.dart";
import "package:prophecy_compagnon_mj/classes/equipment/jewel.dart";
import "package:prophecy_compagnon_mj/classes/equipment/misc_gear.dart";
import "package:prophecy_compagnon_mj/classes/equipment/shield.dart";
import "package:prophecy_compagnon_mj/classes/equipment/weapon.dart";
import "package:prophecy_compagnon_mj/classes/exportable_binary_data.dart";
import "package:prophecy_compagnon_mj/classes/faction.dart";
import "package:prophecy_compagnon_mj/classes/game_session.dart";
import "package:prophecy_compagnon_mj/classes/non_player_character.dart";
import "package:prophecy_compagnon_mj/classes/npc_category.dart";
import "package:prophecy_compagnon_mj/classes/place.dart";
import "package:prophecy_compagnon_mj/classes/place_map.dart";
import "package:prophecy_compagnon_mj/classes/player_character.dart";
import "package:prophecy_compagnon_mj/classes/scenario.dart";
import "package:prophecy_compagnon_mj/classes/star.dart";
import "package:prophecy_compagnon_mj/classes/table.dart";

import "classes/storage/storage.dart";

void registerStoreAdapters() {
  DataStorage.registerStoreAdapter(
    CreatureCategoryStore().storeCategory(),
    () => CreatureCategoryStore(),
  );
  DataStorage.registerStoreAdapter(
    CreatureSummaryStore().storeCategory(),
    () => CreatureSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    CreatureStore().storeCategory(),
    () => CreatureStore(),
  );
  DataStorage.registerStoreAdapter(
    EntityInstanceStore().storeCategory(),
    () => EntityInstanceStore(),
  );
  DataStorage.registerStoreAdapter(
    ArmorModelStore().storeCategory(),
    () => ArmorModelStore(),
  );
  DataStorage.registerStoreAdapter(
    ClothModelStore().storeCategory(),
    () => ClothModelStore(),
  );
  DataStorage.registerStoreAdapter(
    JewelModelStore().storeCategory(),
    () => JewelModelStore(),
  );
  DataStorage.registerStoreAdapter(
    MiscGearModelStore().storeCategory(),
    () => MiscGearModelStore(),
  );
  DataStorage.registerStoreAdapter(
    ShieldModelStore().storeCategory(),
    () => ShieldModelStore(),
  );
  DataStorage.registerStoreAdapter(
    WeaponModelStore().storeCategory(),
    () => WeaponModelStore(),
  );
  DataStorage.registerStoreAdapter(
    BinaryDataStore().storeCategory(),
    () => BinaryDataStore(),
  );
  DataStorage.registerStoreAdapter(
    FactionSummaryStore().storeCategory(),
    () => FactionSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    FactionStore().storeCategory(),
    () => FactionStore(),
  );
  DataStorage.registerStoreAdapter(
    GameSessionStore().storeCategory(),
    () => GameSessionStore(),
  );
  DataStorage.registerStoreAdapter(
    NonPlayerCharacterSummaryStore().storeCategory(),
    () => NonPlayerCharacterSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    NonPlayerCharacterStore().storeCategory(),
    () => NonPlayerCharacterStore(),
  );
  DataStorage.registerStoreAdapter(
    NPCCategoryStore().storeCategory(),
    () => NPCCategoryStore(),
  );
  DataStorage.registerStoreAdapter(
    NPCSubCategoryStore().storeCategory(),
    () => NPCSubCategoryStore(),
  );
  DataStorage.registerStoreAdapter(
    PlaceSummaryStore().storeCategory(),
    () => PlaceSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    PlaceStore().storeCategory(),
    () => PlaceStore(),
  );
  DataStorage.registerStoreAdapter(
    PlaceMapStore().storeCategory(),
    () => PlaceMapStore(),
  );
  DataStorage.registerStoreAdapter(
    PlayerCharacterSummaryStore().storeCategory(),
    () => PlayerCharacterSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    PlayerCharacterStore().storeCategory(),
    () => PlayerCharacterStore(),
  );
  DataStorage.registerStoreAdapter(
    ScenarioSummaryStore().storeCategory(),
    () => ScenarioSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    ScenarioStore().storeCategory(),
    () => ScenarioStore(),
  );
  DataStorage.registerStoreAdapter(
    StarStore().storeCategory(),
    () => StarStore(),
  );
  DataStorage.registerStoreAdapter(
    PlayersStarStore().storeCategory(),
    () => PlayersStarStore(),
  );
  DataStorage.registerStoreAdapter(
    GameTableSummaryStore().storeCategory(),
    () => GameTableSummaryStore(),
  );
  DataStorage.registerStoreAdapter(
    GameTableStore().storeCategory(),
    () => GameTableStore(),
  );
}
