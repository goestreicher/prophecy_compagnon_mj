import "package:prophecy_compagnon_shared/classes/creature.dart";
import "package:prophecy_compagnon_shared/classes/entity_instance.dart";
import "package:prophecy_compagnon_shared/classes/equipment/armor.dart";
import "package:prophecy_compagnon_shared/classes/equipment/cloth.dart";
import "package:prophecy_compagnon_shared/classes/equipment/jewel.dart";
import "package:prophecy_compagnon_shared/classes/equipment/magic_gear.dart";
import "package:prophecy_compagnon_shared/classes/equipment/misc_gear.dart";
import "package:prophecy_compagnon_shared/classes/equipment/shield.dart";
import "package:prophecy_compagnon_shared/classes/equipment/weapon.dart";
import "package:prophecy_compagnon_shared/classes/exportable_binary_data.dart";
import "package:prophecy_compagnon_shared/classes/faction.dart";
import "package:prophecy_compagnon_shared/classes/non_player_character.dart";
import "package:prophecy_compagnon_shared/classes/npc_category.dart";
import "package:prophecy_compagnon_shared/classes/place.dart";
import "package:prophecy_compagnon_shared/classes/place_map.dart";
import "package:prophecy_compagnon_shared/classes/player_character.dart";
import "package:prophecy_compagnon_shared/classes/scenario/scenario.dart";
import "package:prophecy_compagnon_shared/classes/session/game_session.dart";
import "package:prophecy_compagnon_shared/classes/star.dart";
import "package:prophecy_compagnon_shared/classes/table.dart";

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
    MagicGearModelStore().storeCategory(),
    () => MagicGearModelStore(),
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
    GameSessionStore().storeCategory(),
    () => GameSessionStore(),
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
