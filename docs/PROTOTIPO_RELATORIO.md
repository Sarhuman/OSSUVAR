# Relatório — protótipo Vigília de Cal

Data: 24/10/2026. Base: bootstrap T-001, commit
`da1dc027a8291e74eed4053e990f915781f74116`. PR independente e empilhado sobre
`codex/T-001`; não integrar antes de resolver a base e conciliar o README do PR #1.

## Alterações

- `core/arena_run.gd`, `core/prototype.gd`: estado local, simulação e entradas.
- `combat/combat_math.gd`: somente chance de acertar, não a T-002 completa.
- `world/iso_math.gd`, `world/arena_view.gd`, `world/stone_tiles.svg`: grade e apresentação.
- `data/arena_rules.gd`, `.tres`: parâmetros provisórios da arena.
- `ui/arena_hud.gd`, `ui/ossuvar_opening.png`, `ui/opening.svg`: HUD e menu.
- `main.tscn`: conexão do controlador de composição, preservando o Label do smoke.
- `project.godot`: mínimo de janela para manter o HUD legível.
- `tests/test_arena.gd`, `tests/test_prototype.gd`: regras e fluxo integrado.
- `.github/workflows/ci.yml`: lint ampliado aos novos diretórios.
- README, documentação visual, limites e captura real em `docs/screenshots/arena.png`.
- `.uid` e `.import`: metadados produzidos pelo Godot para os arquivos novos.

## Verificações executadas

Godot 4.7.2.stable.official.ed1daf0bf, GUT 9.6.1, gdtoolkit 4.3.4.

Importação headless final: exit 0, nenhuma ocorrência de ERROR ou WARNING.
Saída real final de GUT:

```text
Totals
------
Scripts               3
Tests                16
Passing Tests        16
Asserts              68
Time              0.493s

---- All tests passed! ----
```

Saída real de `gdlint core combat data ui world tests`:

```text
Success: no problems found
```

`gdformat` aplicado aos nove scripts novos; verificação final sem reformatação.
Smoke de execução da arena headless também encerrou com exit 0.

Renderização real em X11 virtual com Mesa llvmpipe/OpenGL Compatibility:
menu e arena inspecionados visualmente. Corrigidos durante a validação o deslocamento
de meio tile da origem e o preenchimento involuntário dos traços do SVG.
A execução gráfica final encerrou com exit 0; houve aviso de V-Sync não suportado
pelo driver virtual. Isso não substitui um teste no hardware do jogador.

## Limites e validação humana

Não foram feitos export Windows, benchmark, playtest manual de longa duração
ou homologação do GDD completo. Testes locais não significam CI remoto aprovado.
O roteiro de playtest está em `PROTOTIPO_VIGILIA.md`. A arena e os itens são fixos;
personagens são placeholders; Vigor ainda não é consumido. Sem persistência.

Antes de expandir a campanha, revisar a extração dos componentes e dados tipados.
Nada foi mesclado. Não foram alterados os PRs #1 e #2.
