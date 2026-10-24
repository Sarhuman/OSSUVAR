5. Arquitetura técnica (contrato com o Codex)
5.1 Stack
• Godot 4.7.2, renderer Compatibility (2D, máxima compatibilidade com hardware modesto).
• GDScript com tipagem estática em todo o código. Formatação e lint com gdtoolkit.
• Testes com GUT, executados em modo headless. CI no GitHub Actions rodando os testes a cada PR.
• Meta numérica de FPS só depois de um benchmark no M1.
5.2 Estrutura de pastas
res://
  core/        # autoloads: EventBus, GameState, SaveService, DataRegistry, Rng
  combat/      # CombatMath, components, hitbox/hurtbox, damage pipeline
  entities/    # player/, monsters/, npcs/
  items/       # data, affixes, generator, inventory
  skills/      # SkillData, SkillCaster, effects
  world/       # maps, generator, tiles, minimap, waypoints
  ui/          # hud, inventory, skill tree, menus
  data/        # .tres: items, affixes, skills, monsters, loot tables, zones
  tests/       # GUT
  docs/        # decisões e relatórios
5.3 Regras de arquitetura
1. Lógica pura separada de cenas. Fórmulas e geradores são scripts sem Node (class_name, funções estáticas) e totalmente testáveis. Cenas só montam e conectam.
2. Composição por componentes: HealthComponent, StatsComponent, HurtboxComponent, HitboxComponent, SkillCaster, StateMachine. Estados do jogador e dos monstros: idle, move, attack, cast, hit_recovery, dead.
3. Dados em Resource (.tres): ItemBase, Affix, SkillData, MonsterData, LootTable, ZoneData. Nada de números de balanceamento no código.
4. Comunicação por sinais e EventBus. Proibido get_node("../..") entre cenas distintas.
5. Isometria: tiles 64×32 em TileMapLayer com Y-sort. Lógica de movimento em um único módulo IsoMath (conversões grade, mundo e tela). Pathfinding com AStarGrid2D sobre o grid lógico gerado.
6. Determinismo: um Rng central com semente por run e por zona; testes usam sementes fixas.
7. Save em JSON com save_version e função de migração por versão.
8. Pooling para projéteis, números de dano e efeitos.
