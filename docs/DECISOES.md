# Registro de decisões do OSSUVAR

Este arquivo diz o que está **fechado**, o que é **proposta do Tech Lead** (vigente para o planejamento, mas sem homologação formal) e o que está **em aberto**. Uma decisão só vale quando aparece aqui.

Última atualização: 24/10/2026 (PR #1).

## Como ler os status

- **Fechada:** requisito do responsável pelo projeto; não muda sem pedido dele.
- **Proposta:** definida pelo Tech Lead para orientar o planejamento; pode ser revista e ainda aguarda aprovação formal do responsável.
- **Aberta:** ainda sem decisão; nenhuma tarefa deve depender dela até que seja fechada.

## Fechadas

| ID | Decisão |
| --- | --- |
| F-01 | O jogo é um ARPG de fantasia sombria, **2D**, para **Godot 4**. |
| F-02 | O combate deve ter profundidade comparável à dos ARPGs clássicos de referência. |
| F-03 | Claude é Tech Lead e Product Owner; Codex é executor de tarefas delimitadas; o responsável pelo projeto aprova, valida no Editor e integra. |
| F-04 | (antiga D-01, decidida em 24/10/2026) O HUD usa **barras horizontais**, não orbes. O HUD continua isolado em `ui/hud`. |

## Propostas (aguardando aprovação formal)

| ID | Proposta |
| --- | --- |
| P-01 | Nome **OSSUVAR** e subtítulo *Os Treze Sinos*. |
| P-02 | Premissa da história e estrutura em quatro atos. |
| P-03 | Godot 4.7.2 com renderer Compatibility e GDScript tipado. |
| P-04 | Isometria 2:1, tiles 64×32, oito direções. |
| P-05 | Classe Penitente com 12 skills em três árvores (Ferro, Cal, Cinza). |
| P-06 | Escopo do MVP: uma classe, Ato I completo, loot completo. |
| P-07 | Fórmulas de combate e tick fixo de 25 Hz descritos no Documento Mestre. |
| P-08 | Arquitetura: lógica pura separada de cenas, componentes, dados em Resources, EventBus, AStarGrid2D, RNG com semente e save JSON versionado. |
| P-09 | Marcos M0 a M5 e backlog T-001 a T-012. |
| P-10 | Regras de trabalho do executor: um PR pequeno por tarefa, PR draft, sem merge automático, relatório padrão. |

## Em aberto

| ID | Pendência | Observação |
| --- | --- | --- |
| D-02 | Aprovação formal do nome e da premissa, e verificação de marca | O nome já é usado no repositório, mas não foi homologado. |
| D-03 | Autorização formal para iniciar a T-001 | Nenhum código deve ser pedido ao executor antes disso. |
| D-04 | Desfecho e reviravolta da história | Existe apenas um esboço no Documento Mestre; será detalhado no M4. |
| D-05 | Chefes dos Atos II e III | A definir. |
| D-06 | Licença do projeto | Sem arquivo `LICENSE` por enquanto. |
| D-07 | Política de spoilers em repositório público | Decidir se o material de spoilers fica em `docs/` com aviso ou fora do repositório. |
| D-08 | Metas numéricas de desempenho | Só após o benchmark do M1. |

## Histórico

| Data | Alteração |
| --- | --- |
| 24/10/2026 | Criação do registro, com as decisões do Documento Mestre v0.1 classificadas por status. |
| 24/10/2026 | D-01 fechada como F-04: HUD com barras horizontais. |
