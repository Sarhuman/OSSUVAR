# OSSUVAR

ARPG isométrico 2D, tiles 64×32. Bootstrap T-001, sem gameplay.

## Abrir

Instale Godot **4.7.2 Standard**, importe `project.godot` e abra no Editor.
Execute com F6 (`main.tscn`) ou F5 (cena inicial).
Renderer Compatibility, viewport 1280×720, stretch `canvas_items`.

## Testes e lint

GUT **9.6.1** está incluído em `addons/gut` (upstream bitwes/Gut,
commit `c80954f47bed74a0a2c471d472c0389f98e0a8f6`, licença MIT inclusa).
Com Godot 4.7.2 disponível como `godot`, execute na raiz:

```sh
godot --headless --path . --editor --import
godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
python -m pip install gdtoolkit==4.3.4
gdlint core tests
```

Os scripts próprios usam GDScript tipado. O lint exclui o addon de terceiros.
Autoloads preservam os nomes públicos solicitados; `class_name` usa nomes
separados para evitar colisão com os singletons.

As regras da seção 5 do Documento Mestre estão em `docs/ARCHITECTURE.md`.
Pendências e saídas reais das verificações estão em `docs/T-001-REPORT.md`.
