# prophecy_compagnon_mj

A companion app for the Prophecy RPG

Pretty much a WiP, not stable at the moment

# TODO

## Creation part

- [x] Migrate to MarkdownFleatherToolbar
  - [x] Migrate the resource selector from ScenarioFleatherToolbar
- [ ] Migrate places to GenericTreeWidget
- [ ] Do not commit resources to the store when editing a scenario (use Factions as an example)
  - [ ] Places
  - [ ] Maps
  - [ ] Creatures
    - Require using a static instance cache?
  - [ ] NPCs
    - Same as for creatures
- [ ] Rewrite UUIDs when importing factions to prevent conflicts?
- [ ] Use UUIDs everywhere in the assets and make UUID mandatory in constructors
- [ ] Add an optional UUID in ObjectSource to prevent conflicts in case of names collision
- [ ] Add dates in the factions leaders and members?
- [ ] Add artifacts resources?
- [ ] Fill in more places from the official docs

## Play part

- [ ] Do the TODO