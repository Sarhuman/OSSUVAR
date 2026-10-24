> **Contém spoilers do Ato I.** P01 — proposta para revisão do responsável e do Claude. Nenhuma regra nova deste documento está homologada ou implementada.

# Contratos de gameplay — OSSUVAR

Versão de proposta: 0.1, 24/10/2026. Escopo exclusivamente documental. Publicação ou merge deste texto não autoriza P02 nem aprova seus números.

## 1. Base, fontes, status e consumidores

Base documental conferida: main em 7ccf335c2b36d6801e308a9b817f5337083de87a. Foram lidos [README](../README.md), [DECISOES](DECISOES.md), [Documento Mestre](DOCUMENTO_MESTRE.md), [NARRATIVA](NARRATIVA.md), [MISSOES_ATO_I](MISSOES_ATO_I.md) e [ESTADO_PROJETO](ESTADO_PROJETO.md). Esses arquivos permanecem intactos.

Base técnica distinta: protótipo dff6ae1e2d1ef67c8404a3cf6f0a4b461caa8126, PR #3 sobre o bootstrap da T-001. P00 verificou 16 testes/68 asserts e lint nessa base; são resultados anteriores a este documento, não testes executados por P01. Main documental não contém esse código. Não refazer bootstrap, IsoMath, menu, HUD ou arena.

| Marca | Significado e fonte |
| --- | --- |
| C | Instrução confirmada nesta tarefa ou em DECISOES/F: orientação vigente, sem declarar implementação |
| P | Proposta para aprovação; inclui fórmulas herdadas do GDD ainda não homologadas como contrato final |
| L | Pendência explícita; impede apenas o consumidor dependente, não toda a documentação |
| S1 | Pedido P01 atual e pacote de prompts: delimitação do trabalho |
| S2 | DECISOES, README e ESTADO_PROJETO da base documental acima |
| S3 | Documento Mestre v0.1, seções 4 e 5: mecânicas e arquitetura históricas |
| S4 | NARRATIVA v0.2, seções 3 e 7–10; MISSOES_ATO_I: conteúdo editorial em revisão |
| S5 | Código/relatórios do protótipo dff6ae1 e auditoria P00: somente comportamento experimental |

C/S1/S2: Diablo II é a referência central de experiência; Project Diablo 2 orienta mapas de endgame. As propostas abaixo são de OSSUVAR, não transcrição de regras, mapas ou assets dessas referências. Nenhum vídeo fornece dimensões ou balanceamento. C/S1: Godot 4.7.2 Standard, Compatibility, GDScript tipado, somente 2D, projeção 2:1, tiles 64×32, oito direções. C/S2/F-04: HUD horizontal de Vida/Mana/Vigor/XP.

S4 preencheu a quarta área com a Estrada dos Ossários; a revisão editorial do Claude permanece pendente. Não há lacuna de nome a reconstruir. Nomes e sequência são P editorial; os números abaixo são P de gameplay independente. Não alterar S4 para acomodar números.

| Contrato | Status, origem e consumidores futuros |
| --- | --- |
| A — atributos/progressão | P/S3 §4.2 + proposta P01; P03–P05, P13, P15 |
| K — skills | P/S3 §4.6 + proposta P01; P06, P09–P13 |
| CMB — combate | P/S3 §4.3 + proposta P01; P03, P06–P08 |
| Z — campanha/zonas | P/S4 + proposta P01; P19–P25 |
| E — endgame | P/S1/S2/S4; somente P28–P30 após campanha |
| T — fronteiras técnicas | P/S3 §5 + evidência S5; aprovação delimitada necessária para P02 |
| I/M/S — itens, derrota, save | P de fronteiras e L de catálogo/política; P14–P18, P21, P24, P26 |

Todo número não marcado C é P, inclusive números repetidos do GDD. Fixtures de teste e valores da arena não são balanceamento oficial. Aprovação deve citar contrato/versão/linhas de decisão; aprovação parcial não libera consumidores de contratos restantes.

## 2. A — atributos, derivados e progressão (P)

Proposta P01, consumindo os quatro atributos e os recursos de S3. Objetivo: personagem inicial resistente o suficiente para observar avisos de ataque, com investimento distinto em melee, acerto e magia; validar por playtest, sem prometer dificuldade ou duração.

| Campo | Proposta inicial / regra | Justificativa |
| --- | --- | --- |
| Nível e teto | L=1; teto de personagem 50; Ato I mira nível 12–15 | Separa recorte do ato de progressão futura; não promete conteúdo até 50 |
| Força / Destreza / Vitalidade / Energia | 20 / 20 / 25 / 15 | Leve viés de sobrevivência, sem impedir magia |
| Vida máxima | 100 + 4×(Vitalidade−25) + 6×(L−1), mínimo 1 | Cada investimento em Vitalidade tem efeito visível |
| Mana máxima | 50 + 4×(Energia−15) + 2×(L−1), mínimo 0 | Permite várias skills iniciais sem equiparar reserva à Vida |
| Vigor máximo | 100 + 2×(Vitalidade−25) + (L−1), mínimo 0 | Acompanha sobrevivência, com crescimento menor que Vida |
| Acerto AR | max(0, 5×Destreza + 10×(L−1) + AR de equipamento) | Destreza e nível mantêm relevância na fórmula do GDD |
| Defesa DEF | max(0, 2×Destreza + defesa de equipamento) | Base de esquiva; armadura melhora DEF, sem redução física automática |
| Dano físico por Força | +1 ponto percentual por Força acima de 20, mínimo 0 | Incentiva requisito ofensivo sem multiplicar cada fonte |
| Destreza e bloqueio | Usa Destreza efetiva na fórmula CMB | Evita segunda fórmula divergente |
| Regeneração fora de hub | Vida 0/s; Mana 1% do máximo/s; Vigor 10/s após 2s sem correr | Poções importam; recuperação de mana previsível |
| Corrida | 1,4× velocidade de andar; gasto 15 Vigor/s; a zero volta a andar | Mobilidade custa recurso; sem consumir durante pausa |
| Pontos | 0 atributos livres e 1 skill no nível 1; +5 atributos/+1 skill em cada subida | Preserva ganho por nível de S3; ponto inicial permite escolher skill |
| Limites | Atributo investido 0–245; rank individual 0–10; sem respec neste contrato | 49 subidas ×5 pontos; respec é L separado |

P: os atributos das fórmulas são efetivos, calculados em snapshot; porcentagens são pontos percentuais, convertidos por divisão por 100. Máximos são inteiros após floor, e HP/Mana/Vigor atuais usam unidades inteiras com acumulador fracionário de regeneração por tick. Dano básico vem do item; sem arma, faixa proposta 3–5 física. S5/120 Vida/70 Mana não é convertido em aprovação de 100/50.

### A1. XP, recompensas e requisitos

P: XP para passar de nível L para L+1 = 100×L², para 1≤L<50. XP acumulado mínimo de nível L = 100×(L−1)×L×(2L−1)/6. Guardar XP total, derivar nível; processar todas as subidas pendentes em uma transação. No teto, limitar total ao limiar de 50 e não conceder novos pontos.

| Nível alcançado | XP acumulado mínimo | Próxima subida |
| --- | --- | --- |
| 1 | 0 | 100 |
| 2 | 100 | 400 |
| 5 | 3.000 | 2.500 |
| 10 | 28.500 | 10.000 |
| 15 | 101.500 | 22.500 |
| 50 | 4.042.500 | Sem subida |

P: monstro comum de nível m concede 3×m² XP; elite ×3; chefe ×20, floor uma vez. Sem penalidade de diferença de nível no primeiro recorte. Crédito exige identidade de morte única; invocados não concedem XP nem drops. Objetivo: curva crescente e auditável; a meta 12–15 exige simulação de rota/seed e revisão conjunta de XP/densidade, não é garantida por esta tabela.

P: requisitos de equipamento usam nível, Força e Destreza do estado sem o item candidato e sem bônus temporários. Para evitar ciclos de autoqualificação, avaliar os itens em ordem estável de slot, usando atributos base+investidos, sem bônus de nenhum equipamento na checagem; todos os bônus dos itens elegíveis entram depois no cálculo. Item sem requisito explícito não exige atributo. Item inelegível permanece no slot, inativo, com motivo visível.

### A2. Fontes, recálculo e recursos atuais

P: cada bônus tem source_id, stat_id, operação, valor e duração opcional. Base, pontos investidos, equipamento, passivas, efeitos temporários e penalidade de ciclo são camadas distintas. Por stat: somar valores planos; somar percentuais aditivos; aplicar uma única multiplicação (1+soma/100); depois caps específicos e floor. Não introduzir multiplicadores independentes sem campo explícito aprovado; remoção de fonte recalcula a partir da base, nunca desfaz por subtrações acumuladas.

P: bônus de atributo é resolvido antes dos derivados. Bônus direto de máximo entra depois da fórmula do atributo. Para dano, usar a ordem CMB, não aplicar a mesma porcentagem de A2 novamente. Exemplo: Vida calculada 100, +20 plana, +25% = floor(120×1,25)=150.

P: ao equipar, remover buff ou alocar ponto, preservar valor atual absoluto e clamp ao novo máximo; não curar por troca de item. Subida de nível também preserva valor absoluto neste contrato futuro. Dead permanece HP=0 sob qualquer recálculo. Hub pode restaurar via ação explícita. P02 preserva a cura de level-up da arena através do adapter legado: só P04 pode ativar a política nova aprovada.

## 3. K — contrato das doze skills (P)

Os nomes/árvores vêm de S3; efeitos detalhados e todos os números são propostas P01, sujeitos à revisão de S4 (sem ressurreição humana). IDs abaixo são propostos; reconciliar com IDs existentes antes de serializar. Rank r inteiro 1–10; 0 significa não aprendida. Gastar um ponto por rank. Requisito máximo permitido = min(10, 1+floor((L−desbloqueio)/2)); cada pré-requisito exige rank 1. Passivas consomem pontos como ativas.

P: skills físicas usam faixa da arma e acerto/bloqueio; feitiços dispensam AR, mas usam resistência e exigem trajetória/linha de visão. Duração/cooldown em ticks de 25 Hz. Ação define preparação W, um frame ativo e recuperação R: total base W+1+R. Velocidade altera total pela fórmula CMB, repartindo W/R proporcionalmente; frame ativo = max(1, floor((W/total_base)×total_efetivo)); R ocupa o restante. Passivas/toggle não fazem ataque oculto. Cooldowns e durações não são reduzidos pela velocidade de ação.

| ID / skill | Alvo e efeito proposto | Desbloqueio / pré-requisito |
| --- | --- | --- |
| ferro_golpe / Golpe Contundente | Um inimigo a 1,5 célula; impacto físico de arma ×[1,20+0,10×(r−1)] | L1 / nenhum |
| ferro_giro / Giro Ceifador | Área centrada no usuário, raio 2 células; um impacto por alvo, arma ×[0,90+0,07×(r−1)] | L6 / Golpe |
| ferro_investida / Investida do Penitente | Inimigo visível entre 2–6 células; avança por caminho validado e atinge ao chegar, arma ×[1,40+0,10×(r−1)] | L12 / Golpe |
| ferro_estilhacar / Estilhaçar | Cone frontal, alcance 2 células e 90°; um impacto por alvo, arma ×[1,60+0,12×(r−1)] | L18 / Giro |
| cal_escudo / Escudo de Cal | Próprio; absorção de dano final até 20+8×(r−1), sem exigir escudo equipado | L1 / nenhum |
| cal_aura / Aura de Resolução | Próprio; toggle com +[5+(r−1)] pontos de resistência elemental, respeitando teto | L6 / Escudo de Cal |
| cal_postura / Postura Inabalável | Passiva própria; +[10+3×(r−1)]% DEF e redução de hit_recovery conforme CMB | L12 / Escudo de Cal |
| cal_grito / Grito Funerário | Inimigos visíveis em raio 4; reduz dano de saída em [10+2×(r−1)]% | L18 / Aura |
| cinza_chama / Chama do Réquiem | Ponto visível até 8 células; projétil de fogo, primeiro alvo, faixa [8+3×(r−1),12+4×(r−1)] | L1 / nenhum |
| cinza_marca / Marca da Cinza | Um inimigo visível até 6 células; −[10+2×(r−1)] pontos de resistência a fogo | L6 / Chama |
| cinza_pira / Pira | Ponto visível até 6 células; área de fogo raio 2, ticks de dano fixo 4+2×(r−1) | L12 / Marca |
| cinza_sopro / Sopro de Cinzas | Passiva própria; +[5+2×(r−1)]% dano de fogo aditivo à camada da skill | L18 / Chama |

| Skill | Mana proposta | Cooldown | W/ativo/R base | Duração / frequência |
| --- | --- | --- | --- | --- |
| Golpe Contundente | 3+floor((r−1)/3) | 0 | 6/1/9 | Impacto único |
| Giro Ceifador | 10+floor((r−1)/2) | 50 ticks | 8/1/11 | Impacto único |
| Investida do Penitente | 8+floor((r−1)/2) | 75 ticks | 5/1/9 após travessia | Travessia até 25 ticks; sem teleporte |
| Estilhaçar | 12+floor((r−1)/2) | 100 ticks | 12/1/12 | Impacto único |
| Escudo de Cal | 8+floor((r−1)/2) | 150 ticks | 6/1/8 | 200+10×(r−1) ticks ou absorção esgotada |
| Aura de Resolução | Reserva 20% da Mana máxima; sem gasto de ativação | 25 ticks entre toggles | 0/0/0 | Até desligar, morrer ou tornar-se inválida |
| Postura Inabalável | 0 | 0 | 0/0/0 | Enquanto aprendida e vivo |
| Grito Funerário | 10+floor((r−1)/2) | 125 ticks | 8/1/11 | 100+5×(r−1) ticks |
| Chama do Réquiem | 4+floor((r−1)/3) | 0 | 5/1/9 | Projétil a 12 células/s, vida máxima 25 ticks |
| Marca da Cinza | 6+floor((r−1)/3) | 50 ticks | 5/1/9 | 125+10×(r−1) ticks |
| Pira | 12+floor((r−1)/2) | 100 ticks | 10/1/14 | 100 ticks; dano aos ticks 25,50,75,100 após criar |
| Sopro de Cinzas | 0 | 0 | 0/0/0 | Enquanto aprendida e vivo |

Justificativa P: entrada com custos 3–8 para permitir experimentação com 50 Mana; área, mobilidade e controle custam mais e têm cooldown; ranks posteriores não cabem todos no Ato I. Armas lentas e dano real precisam de simulação antes de validar DPS. O Giro da arena custa 18 e tem parâmetros diferentes: manter como fixture legada até migração específica, sem chamar esta proposta de ajuste já aprovado.

P: reserva da Aura reduz Mana disponível para gasto, não o máximo do stat; disponível=max(0,atual−reserva). Ativar exige atual≥reserva. Reduzir máximo recalcula reserva e desativa se impossível; desligar não restaura Mana gasta. Não há drenagem contínua adicional.

### K1. Sinergias e empilhamento

P: somente ranks investidos, não ranks de equipamento, alimentam sinergias; bônus calculado do snapshot anterior à ação, sem feedback recursivo entre skills.

| Destino | Sinergia proposta |
| --- | --- |
| Golpe / Giro / Investida / Estilhaçar | Golpe recebe +2% por rank de Postura; Giro +3% por rank de Golpe; Investida +2% por rank de Golpe; Estilhaçar +3% por rank de Giro, aditivos à porcentagem da arma |
| Escudo de Cal | +2 de absorção por rank de Aura, após absorção base |
| Aura de Resolução | +1 ponto de resistência por 2 ranks de Postura, floor, antes do teto |
| Postura Inabalável | Sem sinergia recebida; não aumenta seus próprios ranks |
| Grito Funerário | +2 ticks de duração por rank de Escudo de Cal |
| Chama / Pira | +4% dano de fogo por rank de Pira na Chama; +3% por rank de Chama na Pira, aditivos ao Sopro |
| Marca da Cinza | +2 ticks de duração por rank de Sopro |
| Sopro de Cinzas | Sem sinergia recebida |

P: um efeito de cada ID por alvo; reaplicar conserva a magnitude maior e renova a duração, sem somar magnitudes. Só uma Pira ativa por lançador: a nova substitui a antiga, sem dano imediato; entre lançadores distintos, aplica apenas o maior dano por tick, sem soma. Escudo de Cal substitui o pool anterior e nunca acumula pools. Aura é própria, não é aura de grupo neste recorte. Grito não se soma consigo; Marca não se soma consigo; outros debuffs futuros exigem grupo de exclusão definido.

P: custo e cooldown são comprometidos juntos no início, após validar estado, alvo e trajetória; falha anterior ao início não consome. Cancelamento após compromisso não devolve recurso. Alvo morto antes do ativo pode fazer o golpe falhar, sem reembolsar. Investida aborta no último ponto seguro ao bloquear caminho, sem atravessar parede nem causar impacto remoto. Não há stun adicional implícito nas skills Ferro além de CMB.

## 4. CMB — combate, defesa e compromisso (P)

Origem S3 §4.3; preservam-se as fórmulas históricas abaixo como P para contrato final. Complementos de ordem, unidades e limites são P01. Tick proposto mantido em 25 Hz (40 ms); pausa não avança simulação, cooldown, buff nem RNG.

1. Validar intenção, estado vivo, alcance lógico, trajetória e permissões. Enumerar alvos por entity_id estável; reservar um action_id e um hit_id por impacto/alvo. Rejeitar duplicatas antes de qualquer sorteio.
2. Para ataques físicos: p=clamp(2×AR/(AR+DEF)×La/(La+Lt),0,05,0,95). Níveis ≥1, AR/DEF≥0; AR+DEF=0 retorna 0,05. Sorteio uniforme u em [0,1); acerta se u<p. Feitiços não fazem esse sorteio; colisão e alcance continuam obrigatórios.
3. Se físico acertou, testar bloqueio quando alvo usa escudo e está fora de hit_recovery/dead: p=clamp(B×(Dex−15)/(L×2),0,0,75), com B em fração (30%=0,30). Um bloqueio anula o impacto inteiro e seus on-hit; DoT não é bloqueável. Sem animação de block nem travamento extra neste recorte.
4. Sortear um inteiro inclusivo min..max por canal. Para físico de arma: sorteio×[coef_skill+(Força_pct+equipamento_pct+sinergia_pct)/100]+fixo; ataque básico tem coef_skill=1 e a tabela K fornece o coeficiente das skills. Para fogo de feitiço: sorteio×[1+(equipamento_fogo_pct+Sopro_pct+sinergia_pct)/100]+fixo. Assim a fórmula histórica faixa×(1+percentual)+fixo fica explícita, sem contar o coeficiente da skill duas vezes; Força não aumenta fogo de feitiço.
5. Golpe Mortal: uma rolagem por impacto físico elegível, dobra apenas o canal físico; probabilidade proposta limitada a 100%. Não dobra fogo nem Golpe Esmagador.
6. Aplicar resistências por canal: d×(1−R/100). Elementais Fogo/Gelo/Raio/Peste com teto 75% de S3 e piso proposto −100%; ciclos II/III subtraem 40/100 pontos no jogador, uma vez. Redução física percentual é stat separado, proposta 0–50%; DEF não reduz de novo o dano acertado. Esta separação explicita a ambiguidade da frase histórica sobre defesa/redução e requer aprovação.
7. Golpe Esmagador: proposta de 10% da Vida atual do alvo comum, antes deste impacto; nunca chefes, DoT ou feitiços. Uma rolagem por impacto elegível, chance 0–100%; parcela física sofre redução física, não é dobrada por Mortal. Não ignora absorção.
8. Somar canais/parcela Esmagadora, floor apenas ao fim, mínimo 0; aplicar absorção de Escudo de Cal e então Health. Não impor dano mínimo 1 contra imunidade futura. Emissão de dano, recuperação e morte/recompensas ocorre uma vez, após atualização do HP.
9. HP zerado tem precedência sobre recuperação e ação ativa no mesmo tick. Ordenar impactos por tick, action_id, source_entity_id e target_entity_id. Um emissor morto antes de seu frame ativo não gera novo impacto; projétil já emitido pode persistir, sem duplicar recompensa.

P: resistência física e elemental são canais distintos; novas conversões de dano e imunidades são L, não inferidas. Exemplo independente: físico min=max=10, +50%, +2 fixos produz 17; Mortal produz 34; redução física 25% produz floor(25,5)=25, sem Escudo/Esmagador. Fogo 20 contra R=−25 produz 25. Bloqueio B=0,30/Dex=35/L=10 produz 30%.

P: velocidade eficaz=floor(120×b/(120+b)); frames=max(4,ceil(base×100/(100+eficaz))). Para esta versão, b≥0; bônus negativo é entrada rejeitada, lentidão usa duração de estado explicitamente aprovada. Base de ataque desarmado 16 ticks, arma declara a sua; skills usam tabela K. Cooldowns não usam essa fórmula.

### CMB1. Estados, recuperação e cancelamento

P: estados idle, move, attack, cast, hit_recovery, dead. Golpe que retira pelo menos 10% da Vida máxima em um impacto dispara hit_recovery de 8 ticks (antes da fórmula de velocidade de recuperação); Postura reduz a base em floor(r/4), mínimo 4. Dano absorvido/bloqueado ou DoT não dispara recuperação. Reaplicação durante recuperação mantém o maior prazo restante e não soma. Chefes não recebem hit_recovery; seus telegraphs definem janelas próprias. Justificativa: ler impactos relevantes sem stun permanente por dano mínimo; medir em playtest.

| Estado | Movimento/comando de skill | Cancelamento proposto |
| --- | --- | --- |
| idle / move | Pode iniciar ação válida; Shift impede aproximação automática | Nova intenção substitui movimento |
| attack / cast antes do ativo | Um comando futuro em buffer substituível | Só morte ou hit_recovery; sem refund |
| attack / cast após o ativo | Buffer não antecipa fim | Só morte ou hit_recovery; dano emitido não se repete |
| hit_recovery | Não age; guarda no máximo última intenção válida | Morte tem precedência |
| dead | Bloqueia combate, skill, poção e alocação | Somente fluxo de retorno aprovado M |

P: clique/hold repete intenção, nunca cria ação adicional antes do término; Shift+alvo fora do alcance não anda. Trocar skill/item não zera relógio. Inventário e pausa param a simulação; abrir painel não cancela ação; ao fechar, retoma o mesmo tick. Corrida não é estado de ataque nem imunidade. Política de invulnerabilidade na Investida: nenhuma.

## 5. Z — campanha, níveis e geração (P editorial + P numérica)

Fonte de sequência/landmarks: S4; dimensões, densidade e gates são P01, sem homologar narrativa. Uma célula lógica corresponde a tile isométrico 64×32, não a metro. Dimensões são bounding boxes de grade, não imagens em pixels nem área totalmente caminhável. Densidade usa células caminháveis fora das áreas seguras; N=floor(densidade×células_elegíveis/100), limitado ao orçamento total da zona. Chefes/quest não entram nesse N.

| ID proposto / zona | Grade; níveis de monstro | Densidade /100 células; teto / grupo | Entrada → saída e landmark garantido |
| --- | --- | --- | --- |
| act1_vigil / Vigília de Cal | 40×40; segura | 0; 0 / 0 | Início/retorno → Campos; quatro serviços e Marco acessíveis |
| act1_fields / Campos Calcinados | 64×64; 1–3 | 2; 50 / 3–4 | Vigília → Bosque; posto funerário de Halric com bilhete |
| act1_grove / Bosque dos Enforcados | 72×64; 4–6 | 2,5; 70 / 3–5 | Campos → Estrada; registro do destacamento em ponto alcançável |
| act1_road / Estrada dos Ossários | 80×48; 7–9 | 2; 65 / 3–5 | Bosque → Mosteiro; carroça principal/guia e posto de passagem |
| act1_monastery / Mosteiro Sem Voz | 64×64; 10–12 | 2,5; 70 / 3–5 | Estrada → Cripta; arquivo e registro ritual |
| act1_crypt / Cripta dos Pranteadores | 64×64, um piso; 13–15, Orwyn 15 | 2; 60 / 3–4 | Mosteiro → retorno ao Mosteiro; Halric, antecâmara e condutor |

P: exterior usa templates/conectores; cripta e interior do mosteiro usam salas-corredores/BSP, sem obrigar exterior a parecer masmorra. Valores de 40–80 células mantêm primeiro lote de seeds e navegação limitados; tetos de 50–70 comuns por zona permitem estimar percurso/XP antes de elevar densidade. Não equivalem a benchmark de FPS. Definir nível por subtipo/encontro dentro da faixa, não sortear a cada carregamento.

P: distância de spawn hostil mínima de 8 células caminháveis da entrada/Marco; antecâmara segura de 6×6, arena de Orwyn com área caminhável mínima 20×20. Caminho principal com largura mínima 2 células; conexões e pistas alcançáveis por flood-fill; reservar entradas/landmarks antes de população. Orçamento: 16 tentativas de geração, depois template fallback aprovado e conexo; registrar generator_version e tentativa escolhida.

P: cada área tem exatamente uma conexão principal de entrada e uma de saída, bidirecionais; a cripta retorna pelo acesso do mosteiro, sem carregar Ato II. Marco em Vigília, Campos, Estrada e Mosteiro; desbloqueio apenas ao interagir. Fresta leva da zona atual à Vigília, uma por personagem, mantendo destino de retorno até trocar/encerrar a run; sem custo no primeiro recorte. Um boss combat ativo bloqueia abrir Fresta, mas não fecha a saída segura da antecâmara. Revisar facilidade de fuga antes de P21/P25.

P: bilhete/registro/guia/arquivo são flags, não drops de chance nem itens que ocupam inventário. Propor gates de saída pela evidência de cada missão, não nível de personagem. Descoberta antecipada fica registrada e reconcilia a missão; só conceder recompensa uma vez por quest_id. Partes opcionais não bloqueiam a cadeia.

| Quest de S4 | XP proposto único; ouro/itens | Gate e justificativa |
| --- | --- | --- |
| act1_01_last_oath | 80; nenhum | Bilhete; recompensa pequena de entrada |
| act1_02_names_without_graves | 200; nenhum | Registro; reforça exploração |
| act1_03_bone_convoy | 400; nenhum | Guia; transição para área intermediária |
| act1_04_silent_archive | 650; nenhum | Registro ritual abre cripta |
| act1_05_the_mourner | 1.200; loot de Orwyn separado | Derrota, condutor e Halric selado; sem duplicar XP de morte |
| act1_06_return_to_vigil | 400; nenhum | Informar hub; marca Ato I, sem acesso a ato inexistente |

P: quests seguem unavailable/available/active/objective_met/completed de S4. L: falas, apresentação e aprovação editorial não são decididas aqui. Orwyn exige subcontrato: propor fases em 100–70%, 70–35%, 35–0% HP, aviso mínimo 15 ticks, máximo 4 invocados sem XP/drop, nenhuma transição invulnerável infinita. L: valores de HP/dano, ataques, arena final e recompensas de chefe precisam de revisão específica antes de P25; não bloqueiam P02.

## 6. I — contratos de itens e economia ainda necessários (P/L)

P/S3: Normal, Mágico 1–2 afixos, Raro 3–6, Único, Conjunto; Selos/receitas com ordem; inventário em grade e durabilidade. Consumidores P14–P18/P24. P01 não cria catálogo oficial nem receitas.

| Fronteira | Proposta inicial e justificativa | Pendência de aprovação |
| --- | --- | --- |
| ItemBase / instância | ID de catálogo imutável; instance_id único; base_id, nível, rolls, sockets ordenados, durabilidade e localização separados | L: catálogo, intervalos, exclusões e migração do item-string da arena |
| Grade / slots | 10×4 células; arma 1M 1×3, 2M 2×4, escudo 2×3; sem rotação | P para testar restrição espacial; L: tabela completa e compatibilidade de slots |
| Requisitos iniciais | Base de arma L1/For20, escudo L1/For20, foco L1/Ene15; requisitos Ene são extensão proposta ao GDD | L: aprovar extensão ou manter só For/Dex; não implementar por inferência |
| Loot piloto | Comum: 25% de um equipamento; pesos Normal/Mágico/Raro 80/18/2; Único/Conjunto 0 até catálogo | P só para simulação; L: Fortuna, tabelas por zona e budget de chefe |
| Moeda / serviços | Uma moeda inteira local; compra/venda/reparo atômicos e nunca saldo negativo | L: nome, preços, estoque, regras de venda e itens misteriosos |
| Selos / conjuntos | Receitas por IDs e ordem; bônus por source_id; peça distinta por base_id | L: catálogo, compatibilidades, número de sockets, receitas e limiares |

P: cada item possui exatamente uma localização entre mundo, grade, equipamento e baú; transferência valida tudo antes do commit. Repetir request_id retorna o resultado anterior. Recalcular pelo conjunto de fontes elegíveis de A2; nunca modificar Resource-base compartilhado. Item quebrado fica inativo, sem destruir a instância. P: poção inicial cura 40% do máximo, 4 posições de cinto, cooldown global 25 ticks; L: preços/tiers e se existe poção de Mana. Diferente do estoque único da arena, migração só em tarefa de itens.

## 7. M/S — derrota, retorno e persistência (P/L)

Fonte S2/D-10/D-11 e S4: retorno em gameplay não é imortalidade canônica. P: modo normal, sem permadeath, retorno explícito ao último Marco desbloqueado (Vigília como fallback), Vida/Mana/Vigor completos; sem perda de XP, equipamento ou ouro no primeiro recorte. Justificativa: validar campanha e save antes de adicionar recuperação de cadáver; custos de derrota e hardcore são L posterior.

P: ao retornar, manter mortes, drops, seeds, descoberta e flags da run; tentativa de chefe não concluída reinicia HP/fase/invocados para evitar softlock, sem repetir quest já concluída. Sem reset automático de toda a zona. Nova run é ação explícita no hub e muda run_id/seed, recompõe encontros repetíveis, preserva progressão/flags permanentes. Quest única não reaparece; apresentar vestígios de chefes somente após aprovação editorial da apresentação.

P: um perfil local com personagem identificado, save_version=1, generator_version e rules_version. Autosave após transação de quest/itens/Marco e saída segura; saída durante ataque restaura no último Marco com resultado transacional anterior, nunca no meio do impacto. Não duplicar itens/recompensas ao restaurar; o commit do estado e do registro de operações é único. L: retenção de backups, múltiplos personagens, baú compartilhado e política de atualização de regras.

P: JSON inclui base/investidos, XP total, pontos gastos/livres, ranks investidos, instâncias de itens/localizações, quest flags e ledger, Marcos, run_id/seed/streams, zonas/exploração/drops, versões. Não confiar em derivados salvos; recalcular. Não salvar Resources executáveis, NodePaths nem caminhos livres de scripts. Máximo inicial proposto 8 MiB, profundidade 16, 2.000 itens e 10.000 entidades/objetos de zona por perfil; rejeitar limite antes de alocar/ler excessivamente. Esses limites precisam de teste de arquivo representativo antes de P26.

P: validar tipos estritos, finitos, intervalos e IDs allowlist; versões futuras recusadas sem sobrescrever; migrações explícitas; escrita temporária, troca atômica e backup. Salvar estados RNG com inteiro de 64 bits como string decimal validada para não depender da precisão numérica de JSON. Falha conserva último save válido e oferece recuperação. L: migração de saves já distribuídos, se surgirem; hoje S5 não possui save.

## 8. E — endgame separado da campanha (P)

S1/S2: referência PD2 para mapas de endgame, sem copiar mapas, itens, nomes ou números. Ato I não vira um sistema de tiers. Propostas abaixo não autorizam implementar P28–P30 nem abrir acesso no protótipo.

| Tema | Proposta | Justificativa / pendência |
| --- | --- | --- |
| Acesso | Item consumível de mapa, personagem L40 e campanha completa; depuração separada sem recompensas persistentes | Conteúdo posterior; L: campanha IV inexistente e contrato de drops |
| Estado narrativo | Perfil de rejogo sinalizado anterior à decisão final, mantendo final registrado em separado | Compatível com S4; não é viagem no tempo nem desfaz mortes |
| Tiers iniciais | T1 L40, T2 L45, T3 L50; apenas definições, não três mapas prometidos | Escala pequena para validar o sistema; L: catálogo de zonas-base |
| Modificadores | 1–3; pool piloto: +20% HP inimigo, +10% dano inimigo, +15% densidade | Magnitudes independentes, sem recompensa automática inferida |
| Compatibilidade | Sem duplicar stat/grupo; sem modifier de mecânica inexistente; teto de população do gerador prevalece | Não permitir combinação impossível nem ignorar orçamento |
| Conclusão | Chefe/objetivo da definição derrotado/concluído uma vez; limpar 100% não é obrigatório | Evita inimigo inacessível bloquear saída; L: objetivo por mapa |
| Consumo | Só após destino validado; falha anterior preserva item; portal/reentrada vinculados ao instance_id | Transação única e recuperável |
| Recompensa | Loot do objetivo e crédito único por map_instance_id | L: pesos, Fortuna, bônus por risco e janela de retomada; não gerar economia por esses números |

P: definição possui tier, zona-base, condição e grupos de modifiers; instância guarda seed, versões, rolls, consumo e conclusão. L: aprovação de reset/reentrada/derrota e integração de save antes de implementar. Endgame não bloqueia P02 e não altera sementes, dificuldade ou flags de zonas de campanha.

## 9. T — fronteiras suficientes para P02 (P, aprovação separável)

Origem S3 §5 e achados S5. Objetivo: preservar o mesmo jogo durante migração, sem usar as propostas A/K/CMB/Z como regras ativas. São propostas de interface para revisão, não scripts criados. Nenhuma aprovação de números da campanha é necessária para testar o adapter legado; a aprovação de T1–T4 abaixo e a base técnica continuam necessárias.

### T1. Entidades e propriedade do estado

P: EntityState tipado e não-Node (RefCounted), com entity_id estável, faction_id, posição lógica Vector2, HealthComponent e StatsComponent; EnemyState acrescenta cooldown/path/windup tipados equivalentes à arena. IDs por sequência determinística de spawn, nunca endereço de objeto ou ordem incidental de Dictionary. DropState tipado pode permanecer fora do primeiro subrecorte Health, com adapter explícito.

P: HealthComponent e StatsComponent são modelos tipados RefCounted testáveis headless; wrappers Node só quando uma cena futura precisar. Health é único dono de current/max/dead e transition_id; current/max são float finitos para compatibilidade com a arena, enquanto o perfil futuro da campanha quantiza na fronteira definida em A. Recebe dano/cura finitos não negativos, aplica clamp e retorna resultado tipado (aplicado, absorvido externo, HP anterior/final, morreu_agora). DamageEvent identifica source/action/hit; resultado já processado não reaplica. Apenas transição vivo→zero emite died uma vez; curar/recalcular não revive. Resultado final emite changed no máximo uma vez por operação.

P: StatsComponent mantém base/investidos/fontes e snapshot derivado imutável ao consumidor, com versão de revisão; único serviço de recálculo. Resource contém definições, nunca HP atual ou estado compartilhado entre entidades. Sinais locais alimentam adapter/serviços; não duplicar HP no HUD ou introduzir EventBus como segundo dono. P02 não precisa introduzir quests/equipamento final.

### T2. Adapters e compatibilidade do protótipo

P: ArenaRun continua coordenando ticks, IDs e comandos. Extração gradual: primeiro Health dos inimigos + adapter de leitura para ArenaView e testes; depois jogador, Stats e streams, antes de declarar P02 completo. Mantém um caminho de escrita: comandos chamam modelo; view/HUD leem snapshot tipado, sem mutar Dictionary espelhado. Se teste antigo escrevia enemy.hp, adaptar fixture ao setter de teste/modelo; não conservar dois HP canônicos.

P: preservar IsoMath existente, TileMapLayer, menu, HUD horizontal, semente 1314, mapa, drops, custos/dano/cooldowns e comportamento de level-up de S5 como perfil arena_legacy_v1. Migrar números espalhados para Resource apenas sem mudar valores e com dependência comprovada. Novo perfil campaign_proposal_v1 permanece somente neste documento até tarefas aprovadas. O adapter não pode chamar A/K/CMB novos inadvertidamente.

P: snapshot explícito converte Vector2/HP/cooldown sem usar UI como persistência. Após cada subpasso executar regressão de menu→arena→combate→drop→equipar→pausa→reinício. Nenhum segundo CombatMath, IsoMath, inventário ou RNG. HUD continua em ui/arena_hud.gd até tarefa própria, sem mover para ui/hud só para coincidir com o destino futuro.

### T3. RNG determinístico e isolamento de streams

P: completar o autoload Rng existente como dono de streams world, combat e loot por (run_id, zone_id, geração/version, stream_name). Não criar um segundo autoload nem depender de hash() do runtime. Contrato v1 de seed: inteiros run_seed em [0,2^63−1], zone_id ASCII estável de catálogo, versões inteiras positivas; serialização UTF-8 em netstrings concatenadas (comprimento decimal em bytes, dois-pontos, conteúdo, vírgula), sem espaços, inteiros decimais sem zeros extras (zero é 0); SHA-256; primeiros 8 bytes big-endian, mascarados com 0x7fffffffffffffff. Codificar a tupla em ordem run_seed, zone_id, generator_version, rng_version, stream_name; run_id identifica a sessão, não entra na derivação, permitindo repetir seed/configuração em outra sessão.

P: streams usam RandomNumberGenerator da versão Godot fixada e são criados uma vez por zona/run, com seed e state persistíveis; não prometer sequência compatível entre upgrades de engine sem versão/migração. Criação/reentrada não ressemeia stream já avançado. Mundo não consome combat; loot não altera acertos; render, partículas, áudio e UI não consomem nenhum stream de gameplay. Ordem de consumo e enumeração dos alvos são contratos versionados.

P: perfil arena_legacy_v1 injeta explicitamente seed 1314 no stream combat para preservar a sequência atual. World e loot já ficam isolados, mas a arena continua fixa e o drop continua determinístico sem rolagem. Essa exceção fica nomeada e não redefine a derivação de seed da campanha. Vetores fixos independentes da derivação e teste de intercalar 100 sorteios de loot sem mudar combate são obrigatórios na implementação.

### T4. Aceite futuro e decisões que liberam P02

| Decisão técnica proposta | Aceite verificável na tarefa consumidora |
| --- | --- |
| Aprovar T1: Health/Stats e autoridade única | Dano/cura/clamp, morte uma vez, entradas inválidas, fontes sem acumulação e snapshot consistente |
| Aprovar T2: migração por adapter legado | Mesma sequência de comandos preserva HP, kills, XP, drops, mana e cooldown da arena; 16 testes anteriores preservados/adaptados sem enfraquecer asserts |
| Aprovar T3: derivação/streams e exceção legada | Vetores fixos; repetir seed/versões; reentrada sem reset; loot não altera combate; nada de RNG em draw |
| Escolher base de código e conciliação documental | Base dff6ae1 ou sucessora explicitamente autorizada; documentação main atual consultada sem merge cego dos READMEs |

L: essas quatro decisões precisam do responsável/Claude antes de iniciar P02. Não esperar aprovação de tiers, quests, catálogo ou números das doze skills para decidir interfaces de Health/RNG; também não tratar aprovação técnica como aprovação desses números. A main atual é a base deste PR documental, não autorização para integrar #2/#3.

## 10. Revisão, subdivisões e validação documental

P01 entrega este contrato único para revisão. Subdivisões de aprovação propostas: P01-A (A/CMB), P01-B (K), P01-C (Z/I/M/S e conteúdo de Orwyn), P01-D (T1–T4, mínimo liberador de P02) e P01-E (E, posterior). São recortes de revisão, não tarefas automaticamente iniciadas nem novos documentos exigidos. Cada consumidor aguarda apenas seus contratos aprovados.

Pendências prioritárias: T1–T4 para P02; defesa versus redução física, política de máximos e bloqueio para P03/P04; cancelamento/timings para P06; revisão das skills para P09; geração/contagem editorial e dimensões para P19; derrota/save/itens para P15/P21/P26. Licença e política de spoilers permanecem em DECISOES, sem alteração por P01.

Validação desta entrega: conferir links relativos contra a árvore documental de base, presença das 12 skills e seus campos, cálculos de XP, faixas/caps, status/fontes/consumidores e diff restrito ao novo documento. Não exigir GUT ou lint de gameplay em uma mudança apenas Markdown. Playtest de balanceamento, aprovação editorial do Claude, renderização no Editor, benchmark e implementação são pendentes e não são declarados concluídos.
