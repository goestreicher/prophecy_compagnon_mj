# prophecy_compagnon_mj

A companion app for the Prophecy RPG

Pretty much a WiP, not stable at the moment

# TODO

## Creation part

- [ ] Rewrite UUIDs when importing factions to prevent conflicts?
- [ ] Use UUIDs everywhere in the assets and make UUID mandatory in constructors
- [ ] Add dates in the factions leaders and members?
- [ ] Add artifacts resources?
- [ ] Fill in more places from the official docs
- [ ] Use the same leaders mechanism for places as exists for factions
- [ ] Link factions (and places) titles to NPCs
- [ ] Add draconic link
- [ ] Limit skills, specialized skills, advantage and disadvantages to their reserved caste

- [x] Migrate places to GenericTreeWidget
- [x] Add an optional UUID in ObjectSource to prevent conflicts in case of names collision
- [x] Do not commit resources to the store when editing a scenario (use Factions as an example)
  - [x] Places
  - [x] Maps
  - [x] Creatures
    - Require using a static instance cache?
  - [x] NPCs
    - Same as for creatures
- [x] Migrate to MarkdownFleatherToolbar
  - [x] Migrate the resource selector from ScenarioFleatherToolbar

## Play part

- [ ] Do the TODO