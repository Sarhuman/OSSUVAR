# Migração documental para a narrativa v0.3

Data: 24/10/2026. Origem: história expandida fornecida pelo responsável, **O Décimo Quarto Sino**. Esta instrução tem precedência sobre as propostas narrativas anteriores.

## Fonte vigente e limites

Usar [NARRATIVA.md](NARRATIVA.md) e [MISSOES_ATO_I.md](MISSOES_ATO_I.md) da main atual. O Documento Mestre v0.1 continua disponível como histórico, mas não como fonte vigente dos pontos substituídos abaixo.

Nenhum código, asset, teste, fórmula ou branch executora foi alterado por esta atualização documental. Ela não integra PRs e não modifica implicitamente o escopo do P02-A de Health.

| Consumidor | Informação antiga | Informação vigente / ação necessária |
| --- | --- | --- |
| Pitch/README | Último jurado vivo | Penitente em busca do mestre; Halric está vivo e existe outro antigo Penitente |
| Cosmologia | Ossos de deus e vontade divina | Pacto da guerra civil, vozes aprisionadas e túmulos dos primeiros reis |
| Ato I | Orwyn, Halric morto/selado | Comandante guardando a porta do mausoléu; somente vestígios de Halric |
| Ato II | Neral | Pranteadora e ritual das vozes; comportas e nomes selados |
| Ato III | Vardek e Halric já morto | Antigo Penitente; primeira aparição pessoal de Halric, vivo e corresponsável pela fundição |
| Ato IV | Irrik como chefe final obrigatório | Confronto com Halric; forma jogável ainda a contratar |
| Finais | Duas escolhas exclusivas | Destruir, tocar ou reforjar; revelar a verdade como resultado político articulável à decisão ritual |
| Aliados | Arcos com baixa consequência obrigatória | Apoio e estado no Ato IV dependem de alianças comunicadas e registradas |

## PR #4 — contratos ainda não integrados

O documento de P01 em `codex/P-01-contratos-gameplay`, commit `3210b266542a3b4552ecc608a8d450e0c7eb077b`, foi escrito sobre a v0.2. Não foi editado nesta atualização para preservar o trabalho do executor.

Em sua próxima tarefa documental, conciliar:

1. Fontes/status que dizem narrativa v0.2: apontar a v0.3 e a instrução mais recente.
2. Tabela de zonas: retirar “Orwyn 15” da cripta. Não transferir automaticamente HP, nível, fases, invocações ou recompensas para o comandante; criar subcontrato do novo encontro.
3. Missões: retirar selamento de Halric e substituir a missão antiga por mapeamento explícito do novo objetivo do mausoléu.
4. Regras de Orwyn: movê-las para proposta do Ato II e revisar a mecânica de ritual/identificação, sem fingir que a realocação aprova aqueles números.
5. Endgame e persistência: revisar flags do confronto final, denúncia, aliados e descoberta de possibilidades; não assumir o final binário antigo.

As interfaces de Health, migração por adapters, perfil legado e RNG do contrato técnico **não são invalidadas pela mudança da história**. Podem ser revisadas/implementadas no recorte autorizado, sem incorporar números novos de campanha.

## Backlog e prompts anteriores

- O prompt P25 e os trechos de conteúdo que nomeiem Orwyn como chefe do Ato I precisam da atualização narrativa antes da implementação de campanha. O T-007 original trata do esqueleto e não é alterado por esta nota.
- P22/P23 mantêm a sequência de zonas e a cripta, com os novos objetivos e porta do mausoléu.
- Não executar o antigo objetivo de selar Halric nem adicionar dois chefes principais ao Ato I para tentar cumprir ambas as versões.
- Quantidades, balanceamento e catálogos continuam propostas ou pendências, conforme decisão específica.
- Usar histórico Git para consulta da v0.2; não manter dois roteiros concorrentes marcados como vigentes.
