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
| F-08 | Incorporar a história expandida O Décimo Quarto Sino à main: pacto da guerra civil, vozes aprisionadas, Halric vivo, novos chefes e possibilidades finais. A direção do responsável substitui as propostas narrativas conflitantes da v0.2 |

## Propostas preservadas do planejamento original

| ID | Conteúdo | Estado |
| --- | --- | --- |
| P-01 | Nome OSSUVAR e subtítulo Os Treze Sinos | Uso de trabalho; verificação de marca e homologação formal pendentes |
| P-02 | Premissa e quatro atos | Direção v0.3 fornecida pelo responsável; parâmetros e execução continuam por contratos próprios |
| P-03 | Godot 4.7.2, Compatibility e GDScript tipado | Base usada nos PRs experimentais; não é evidência de homologação no Editor |
| P-04 | Isometria 2:1, tiles 64×32 e oito direções | Diretriz do documento mestre e do protótipo |
| P-05 | Penitente com 12 skills em Ferro/Cal/Cinza | Catálogo planejado; parâmetros e implementação completos pendentes |
| P-06 | Uma classe, Ato I, loot completo | Escopo planejado; contagem geográfica preservada na v0.3 |
| P-07 | Fórmulas e tick fixo de 25 Hz | Contratos mecânicos a completar; não inferir que o protótipo implementa tudo |
| P-08 | Componentes, dados, sinais, AStarGrid2D, RNG e save versionado | Diretrizes técnicas preservadas; migração gradual do protótipo |
| P-09 | Marcos M0–M5 e backlog T-001–T-012 | Histórico de planejamento, não medidor automático de conclusão |
| P-10 | PR pequeno por tarefa, draft, relatório e sem merge automático | Fluxo para código; atualização documental em main foi pedida separadamente |

## Direção narrativa vigente — v0.3

| ID | Tema | Resolução vigente |
| --- | --- | --- |
| N-01 | Geografia do Ato I | Um hub, Campos, Bosque, Estrada dos Ossários, Mosteiro e Cripta; sequência preservada |
| N-02 | Halric | Vivo, marcado pelo sino e corresponsável pela fundição; aparece pessoalmente no Ato III |
| N-03 | Origem do pacto | Reis da guerra civil aprisionaram vozes; a Ordem vigia âncoras e oculta a história |
| N-04 | Motor da crise | Décimo Quarto criado para quebrar o mecanismo; ossos dos primeiros reis na fundição; arco de Irrik/Edda não é o motor vigente |
| N-05 | Chefes e confronto final | Comandante no I; Pranteadora no II; antigo Penitente no III; encontro com Halric no IV, sem combate obrigatório presumido |
| N-06 | Desfechos | Destruir, tocar ou reforjar; revelação pública como resultado político articulável à escolha ritual |
| N-07 | Continuidade | Recompensas únicas e rejogo não desfazem fatos da campanha |
| N-08 | Protagonista e aliados | Não é o último Penitente vivo de toda a Ordem; alianças da Vigília têm consequências explícitas |
| N-09 | Abertura | Funeral, três batidas, silêncio dos Treze, mensageiro e carta; mortos inicialmente podem repetir memórias sem atacar |

Esta direção veio do responsável e não aguarda aprovação para substituir o
roteiro antigo. Revisão de coerência, detalhes não definidos e contratos de
implementação permanecem tarefas separadas; nenhuma homologação de gameplay
é inferida. Os IDs N são documentais.

## Pendências atuais

| ID original/novo | Pendência | Situação precisa |
| --- | --- | --- |
| D-02 | Nome definitivo e marca | Mantida; esta documentação não faz verificação de marca |
| D-03 | Início da T-001 | A condição antiga de nenhum código ainda existir está desatualizada: há bootstrap no PR #2; homologação e integração continuam separadas |
| D-04 | Desfecho | Direção ampliada em N-06; definir requisitos de descobertas/alianças e estado final antes de implementar |
| D-05 | Chefes | Elenco realocado em N-05; nomes do comandante e antigo Penitente e contratos de combate ainda pendentes |
| D-06 | Licença | Não foi escolhida por esta atualização |
| D-07 | Política de spoilers públicos | Documentos editoriais aqui têm aviso e README sem revelações; política definitiva continua pendente |
| D-08 | Metas de desempenho | Somente após benchmark real |
| D-09 | Contratos de gameplay | Proposta no PR #4; conciliar referências narrativas v0.2 sem mudar interfaces técnicas ou aprovar números automaticamente |
| D-10 | Morte e retorno em gameplay | Não confundir reload ou respawn com imortalidade canônica |
| D-11 | Endgame depois do final | Narrativa admite estado anterior ao confronto; persistência/interface precisam de contrato técnico |
| D-12 | Continuidade v0.3 | Definir o rosto do Corvo, nomes selados e sentido de filho da sepultura; revisar coerência sem bloquear Health |

## Precedência e histórico

Instrução explícita mais recente do responsável prevalece. O Documento Mestre
v0.1 é preservado como histórico. A narrativa v0.3 substitui as propostas conflitantes e preserva o texto histórico sem
reescrever fórmulas; valores provisórios da arena não se tornam balanceamento
final por aparecerem numa branch.

| Data | Registro |
| --- | --- |
| 24/10/2026 | Proposta documental original no PR #1; HUD horizontal registrado como F-04 |
| 24/10/2026 | Bootstrap no PR #2 e arena experimental no PR #3, sem presumir homologação |
| 24/10/2026 | Responsável pediu prompts ao executor; documentação/história passam a ser frente separada |
| 24/10/2026 | Atualização da main documental e narrativa editorial v0.2, com resoluções N-01 a N-07 |
| 24/10/2026 | História expandida fornecida pelo responsável incorporada como v0.3; v0.2 substituída e impactos de contratos registrados |

