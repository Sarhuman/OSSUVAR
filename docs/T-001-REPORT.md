# T-001 — Relatório

## Arquivos

- Raiz: project.godot, main.tscn, .gitignore, .gdlintrc, README.md.
- core/: cinco autoloads vazios, tipados por `extends Node`, com class_name e comentário de propósito.
- combat/, entities/player/, entities/monsters/, entities/npcs/, items/, skills/, world/, ui/, data/: .gitkeep para preservar pastas vazias no Git.
- addons/gut/: GUT 9.6.1 original, incluindo licença MIT.
- tests/test_smoke.gd: instancia a cena principal e verifica o texto OSSUVAR.
- docs/ARCHITECTURE.md: cópia literal da seção 5 do Documento Mestre fornecido.
- docs/import.log, docs/gut.log, docs/gdlint.log: saídas reais das execuções locais.
- .github/workflows/ci.yml: importação, GUT headless e gdlint; exceção de caminho autorizada pelo usuário nesta tarefa.

## Verificações locais

Godot 4.7.2.stable.official.ed1daf0bf, GUT 9.6.1 e gdtoolkit 4.3.4.
Importação headless concluída sem ERROR/WARNING no log final.
GUT: 1 teste, 2 asserts, 1 aprovado; gdlint: Success: no problems found.
Saídas completas nos arquivos .log deste diretório.
A primeira tentativa sob sandbox encontrou acesso negado do gdlint e falha ao salvar preferências do Editor; as verificações foram repetidas com permissões de execução e os logs finais são dessas execuções.

## Validar no Editor (homologação)

- Abrir project.godot no Godot 4.7.2 em checkout limpo e confirmar ausência de erros e avisos de importação.
- F5: janela 1280×720 com Label OSSUVAR; redimensionamento com stretch canvas_items.
- Confirmar renderer Compatibility, cinco autoloads e todas as teclas/botões no InputMap.
- Nenhuma cena de jogador, mapa, fórmula ou gameplay incluídos.

## Perguntas

Nenhuma pendência de design. A exceção para .github/workflows foi autorizada explicitamente.
Os nomes de class_name diferem dos nomes de singleton por exigência do namespace global do Godot; os cinco nomes públicos de autoload são exatamente os solicitados.
