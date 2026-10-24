# Registro de decisões do OSSUVAR

Atualizado em 24/10/2026. Este arquivo distingue instruções do responsável,
propostas editoriais e lacunas de gameplay. Estar escrito ou publicado não
equivale a estar implementado ou homologado.

## Instruções confirmadas do responsável

| ID | Decisão |
| --- | --- |
| F-01 | ARPG de fantasia sombria, exclusivamente 2D, em Godot 4 |
| F-02 | Diablo II é a referência central de experiência e profundidade |
| F-03 | Claude como referência de design/arquitetura; Codex executor por tarefas; responsável define prioridades e valida no Editor |
| F-04 | HUD com barras horizontais de Vida, Mana, Vigor e XP; apresentação isolada do modelo |
| F-05 | Project Diablo 2 e o vídeo Maps.mp4 fornecidos como referências adicionais de mapas; identidade e assets próprios para OSSUVAR |
| F-06 | Preparar prompts para o Codex e trabalhar na documentação/história enquanto a execução de código ocorre em outra frente |
| F-07 | Atualizar a main documental e preencher as lacunas narrativas, conforme pedido de 24/10/2026; isso não autoriza merge dos PRs de código |

## Propostas preservadas do planejamento original

| ID | Conteúdo | Estado |
| --- | --- | --- |
| P-01 | Nome OSSUVAR e subtítulo Os Treze Sinos | Uso de trabalho; verificação de marca e homologação formal pendentes |
| P-02 | Premissa e quatro atos | Desenvolvidos na narrativa v0.2; revisão editorial do Claude pendente |
| P-03 | Godot 4.7.2, Compatibility e GDScript tipado | Base usada nos PRs experimentais; não é evidência de homologação no Editor |
| P-04 | Isometria 2:1, tiles 64×32 e oito direções | Diretriz do documento mestre e do protótipo |
| P-05 | Penitente com 12 skills em Ferro/Cal/Cinza | Catálogo planejado; parâmetros e implementação completos pendentes |
| P-06 | Uma classe, Ato I, loot completo | Escopo planejado; contagem geográfica detalhada na v0.2 |
| P-07 | Fórmulas e tick fixo de 25 Hz | Contratos mecânicos a completar; não inferir que o protótipo implementa tudo |
| P-08 | Componentes, dados, sinais, AStarGrid2D, RNG e save versionado | Diretrizes técnicas preservadas; migração gradual do protótipo |
| P-09 | Marcos M0–M5 e backlog T-001–T-012 | Histórico de planejamento, não medidor automático de conclusão |
| P-10 | PR pequeno por tarefa, draft, relatório e sem merge automático | Fluxo para código; atualização documental em main foi pedida separadamente |

## Resoluções narrativas escritas, ainda em revisão editorial

| ID | Lacuna | Resolução nesta versão |
| --- | --- | --- |
| N-01 | Quarta área do Ato I | Estrada dos Ossários; hub + quatro áreas + cripta |
| N-02 | Halric voltou ou desapareceu | Morreu, retornou sob o chamado e partiu outra vez; o encontro e seu selamento ocorrem na cripta |
| N-03 | Função dos sinos e deus morto | Treze dispersam a vontade divina; o Décimo Quarto a reconecta e vincula os mortos à rede |
| N-04 | Esposa do Sineiro-Mor sem identidade | Edda Vael, restauradora de registros; retorno contra sua vontade e recusa explícita |
| N-05 | Chefes dos Atos II e III | Vigário Neral, o Afogado; Mestre Vardek, o Fundidor |
| N-06 | Desfecho e custos | Último Silêncio e Nova Vigília, sem terceiro final sem custo |
| N-07 | Repetição versus continuidade | Quest concluída é única; vestígios e modos de rejogo não desfazem acontecimentos |

As resoluções acima preenchem o texto para revisão; não declaram que Claude já
as homologou. Implementação por parte do Codex depende de tarefa e contrato
específicos. Os IDs N são documentais, não IDs de entidades do código.

## Pendências atuais

| ID original/novo | Pendência | Situação precisa |
| --- | --- | --- |
| D-02 | Nome definitivo e marca | Mantida; esta documentação não faz verificação de marca |
| D-03 | Início da T-001 | A condição antiga de nenhum código ainda existir está desatualizada: há bootstrap no PR #2; homologação e integração continuam separadas |
| D-04 | Desfecho | Texto desenvolvido em N-06; falta revisão editorial, não falta mais um esboço de solução |
| D-05 | Chefes II/III | Identidades e motivos desenvolvidos em N-05; mecânicas e revisão editorial pendentes |
| D-06 | Licença | Não foi escolhida por esta atualização |
| D-07 | Política de spoilers públicos | Documentos editoriais aqui têm aviso e README sem revelações; política definitiva continua pendente |
| D-08 | Metas de desempenho | Somente após benchmark real |
| D-09 | Contratos de gameplay | Atributos, progressão, skills, dimensões, níveis, densidade e economia precisam de tabelas próprias |
| D-10 | Morte e retorno em gameplay | Não confundir reload ou respawn com imortalidade canônica |
| D-11 | Endgame depois do final | Narrativa admite estado anterior ao confronto; persistência/interface precisam de contrato técnico |
| D-12 | Revisão editorial v0.2 | Claude/responsável revisam as resoluções; não bloquear auditoria técnica independente |

## Precedência e histórico

Instrução explícita mais recente do responsável prevalece. O Documento Mestre
v0.1 é preservado como histórico. A narrativa v0.2 desenvolve suas lacunas sem
reescrever fórmulas; valores provisórios da arena não se tornam balanceamento
final por aparecerem numa branch.

| Data | Registro |
| --- | --- |
| 24/10/2026 | Proposta documental original no PR #1; HUD horizontal registrado como F-04 |
| 24/10/2026 | Bootstrap no PR #2 e arena experimental no PR #3, sem presumir homologação |
| 24/10/2026 | Responsável pediu prompts ao executor; documentação/história passam a ser frente separada |
| 24/10/2026 | Atualização da main documental e narrativa editorial v0.2, com resoluções N-01 a N-07 |
