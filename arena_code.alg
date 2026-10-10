algoritmo "ArenaCode Championship"
// Disciplina  : Algoritmo e Lógica de Programação
// Professor   : André Olímpio
// Descrição   : ArenaCode Championship – Sistema de Gerenciamento de Campeonato de E-Sports
// Autor(a)    : Arthur Egydio Cruz
// Data atual  : 10/10/2026
const
   PONTOS_VITORIA = 3
   PONTOS_EMPATE = 1
   PONTOS_DERROTA = 0
   MAX_EQUIPES = 10
   MAX_PLACAR = 100
   MAX_CONTAGEM = 10

// REGISTRO: todos os dados de UMA equipe
tipo TEquipe = registro
   codigo: inteiro
   nome: caractere
   capitao: caractere
   vitorias: inteiro
   empates: inteiro
   derrotas: inteiro
   pontosMarcados: inteiro
   pontosSofridos: inteiro
   saldo: inteiro
   pontuacao: inteiro
fimregistro

// GLOBAIS: dados usados pelo sistema inteiro.
// confrontos[a, b] = nº de partidas entre a equipe de código a
// e a de código b. O índice é o CÓDIGO (não a posição no vetor),
// assim a matriz continua certa depois que o vetor é ordenado.
// Obs.: o tamanho 10 deve ser igual a MAX_EQUIPES.
var
   equipes: vetor[1..10] de TEquipe
   confrontos: vetor[1..10, 1..10] de inteiro
   qtdEquipes: inteiro
   opcao: inteiro

// Lê um inteiro e só aceita valores entre minimo e maximo
funcao lerInteiro(mensagem: caractere; minimo, maximo: inteiro): inteiro
var
   valor: inteiro
inicio
   repita
      escreva(mensagem, " (", minimo, " a ", maximo, "): ")
      leia(valor)
      se (valor < minimo) ou (valor > maximo) entao
         escreval(">> Valor inválido!")
      fimse
   ate (valor >= minimo) e (valor <= maximo)
   retorne valor
fimfuncao

// Lê um texto e não aceita vazio
funcao lerTexto(mensagem: caractere): caractere
var
   texto: caractere
inicio
   escreva(mensagem, ": ")
   leia(texto)
   enquanto texto = "" faca
      escreva(">> Não pode ficar vazio. ", mensagem, ": ")
      leia(texto)
   fimenquanto
   retorne texto
fimfuncao

// Retorna a posição da equipe no vetor, ou 0 se não existir
funcao buscarEquipe(codigo: inteiro): inteiro
var
   i, posicao: inteiro
inicio
   posicao <- 0
   i <- 1
   enquanto (i <= qtdEquipes) e (posicao = 0) faca
      se equipes[i].codigo = codigo entao
         posicao <- i
      fimse
      i <- i + 1
   fimenquanto
   retorne posicao
fimfuncao

funcao calcularPontuacao(vitorias, empates, derrotas: inteiro): inteiro
inicio
   retorne vitorias * PONTOS_VITORIA + empates * PONTOS_EMPATE + derrotas * PONTOS_DERROTA
fimfuncao

funcao calcularSaldo(marcados, sofridos: inteiro): inteiro
inicio
   retorne marcados - sofridos
fimfuncao

procedimento inicializarSistema
var
   i, j: inteiro
inicio
   qtdEquipes <- 0
   para i de 1 ate MAX_EQUIPES faca
      para j de 1 ate MAX_EQUIPES faca
         confrontos[i, j] <- 0
      fimpara
   fimpara
fimprocedimento

procedimento exibirMenu
inicio
   escreval("")
   escreval("===== ARENA CODE CHAMPIONSHIP =====")
   escreval("1 - Cadastrar equipe")
   escreval("2 - Listar equipes")
   escreval("3 - Registrar resultado de partida")
   escreval("4 - Consultar equipe")
   escreval("5 - Exibir classificação geral")
   escreval("6 - Exibir estatísticas")
   escreval("7 - Consultar confrontos")
   escreval("8 - Contagem regressiva (recursiva)")
   escreval("9 - Encerrar")
   escreva("Opção: ")
fimprocedimento

procedimento cadastrarEquipe
var
   codigo: inteiro
inicio
   se qtdEquipes >= MAX_EQUIPES entao
      escreval(">> Capacidade máxima atingida.")
   senao
      codigo <- lerInteiro("Código", 1, MAX_EQUIPES)
      se buscarEquipe(codigo) <> 0 entao
         escreval(">> Erro: código ", codigo, " já cadastrado.")
      senao
         qtdEquipes <- qtdEquipes + 1
         equipes[qtdEquipes].codigo <- codigo
         equipes[qtdEquipes].nome <- lerTexto("Nome da equipe")
         equipes[qtdEquipes].capitao <- lerTexto("Capitão")
         equipes[qtdEquipes].vitorias <- 0
         equipes[qtdEquipes].empates <- 0
         equipes[qtdEquipes].derrotas <- 0
         equipes[qtdEquipes].pontosMarcados <- 0
         equipes[qtdEquipes].pontosSofridos <- 0
         equipes[qtdEquipes].saldo <- 0
         equipes[qtdEquipes].pontuacao <- 0
         escreval(">> Cadastrada na posição ", qtdEquipes, " do vetor.")
      fimse
   fimse
fimprocedimento

procedimento listarEquipes
var
   i: inteiro
inicio
   escreval("Pos Cód  Equipe (capitão)")
   para i de 1 ate qtdEquipes faca
      escreval(i:3, equipes[i].codigo:4, "  ", equipes[i].nome, " (", equipes[i].capitao, ")")
   fimpara
fimprocedimento

procedimento exibirEquipe(posEq: inteiro)
inicio
   escreval(equipes[posEq].nome, " | código ", equipes[posEq].codigo, " | capitão ", equipes[posEq].capitao)
   escreval("V ", equipes[posEq].vitorias, " | E ", equipes[posEq].empates, " | D ", equipes[posEq].derrotas)
   escreval("Marcados ", equipes[posEq].pontosMarcados, " | Sofridos ", equipes[posEq].pontosSofridos, " | Saldo ", equipes[posEq].saldo)
   escreval("Pontuação: ", equipes[posEq].pontuacao)
fimprocedimento

procedimento consultarEquipe
var
   posEq: inteiro
inicio
   posEq <- buscarEquipe(lerInteiro("Código", 1, MAX_EQUIPES))
   se posEq = 0 entao
      escreval(">> Equipe não localizada.")
   senao
      exibirEquipe(posEq)
   fimse
fimprocedimento

// Atualiza UMA equipe com o resultado, do ponto de vista dela
procedimento atualizarEquipe(posEq, marcados, sofridos: inteiro)
inicio
   se marcados > sofridos entao
      equipes[posEq].vitorias <- equipes[posEq].vitorias + 1
   senao
      se marcados = sofridos entao
         equipes[posEq].empates <- equipes[posEq].empates + 1
      senao
         equipes[posEq].derrotas <- equipes[posEq].derrotas + 1
      fimse
   fimse
   equipes[posEq].pontosMarcados <- equipes[posEq].pontosMarcados + marcados
   equipes[posEq].pontosSofridos <- equipes[posEq].pontosSofridos + sofridos
   equipes[posEq].saldo <- calcularSaldo(equipes[posEq].pontosMarcados, equipes[posEq].pontosSofridos)
   equipes[posEq].pontuacao <- calcularPontuacao(equipes[posEq].vitorias, equipes[posEq].empates, equipes[posEq].derrotas)
fimprocedimento

procedimento registrarPartida
var
   codA, codB, posA, posB, placarA, placarB: inteiro
inicio
   codA <- lerInteiro("Código da 1ª equipe", 1, MAX_EQUIPES)
   codB <- lerInteiro("Código da 2ª equipe", 1, MAX_EQUIPES)
   posA <- buscarEquipe(codA)
   posB <- buscarEquipe(codB)
   se (posA = 0) ou (posB = 0) entao
      escreval(">> Erro: equipe não encontrada.")
   senao
      se codA = codB entao
         escreval(">> Erro: uma equipe não pode jogar contra ela mesma.")
      senao
         placarA <- lerInteiro("Pontos de " + equipes[posA].nome, 0, MAX_PLACAR)
         placarB <- lerInteiro("Pontos de " + equipes[posB].nome, 0, MAX_PLACAR)
         atualizarEquipe(posA, placarA, placarB)
         atualizarEquipe(posB, placarB, placarA)
         confrontos[codA, codB] <- confrontos[codA, codB] + 1
         confrontos[codB, codA] <- confrontos[codB, codA] + 1
         escreval(">> Partida registrada.")
      fimse
   fimse
fimprocedimento

// Verdadeiro se a equipe da posição a deve ficar ACIMA da posição b.
// Critérios: pontuação, vitórias, saldo, pontos marcados.
funcao vemAntes(a, b: inteiro): logico
var
   resposta: logico
inicio
   se equipes[a].pontuacao <> equipes[b].pontuacao entao
      resposta <- equipes[a].pontuacao > equipes[b].pontuacao
   senao
      se equipes[a].vitorias <> equipes[b].vitorias entao
         resposta <- equipes[a].vitorias > equipes[b].vitorias
      senao
         se equipes[a].saldo <> equipes[b].saldo entao
            resposta <- equipes[a].saldo > equipes[b].saldo
         senao
            resposta <- equipes[a].pontosMarcados > equipes[b].pontosMarcados
         fimse
      fimse
   fimse
   retorne resposta
fimfuncao

// BUBBLE SORT: compara vizinhos e troca quando o de baixo deve subir
procedimento ordenarClassificacao
var
   i, j: inteiro
   aux: TEquipe
inicio
   para i de 1 ate qtdEquipes - 1 faca
      para j de 1 ate qtdEquipes - i faca
         se vemAntes(j + 1, j) entao
            aux <- equipes[j]
            equipes[j] <- equipes[j + 1]
            equipes[j + 1] <- aux
         fimse
      fimpara
   fimpara
fimprocedimento

procedimento exibirClassificacao
var
   i: inteiro
inicio
   ordenarClassificacao
   escreval("Pos   P   V   E   D  PM  PS  SG  Equipe")
   para i de 1 ate qtdEquipes faca
      escreval(i:3, equipes[i].pontuacao:4, equipes[i].vitorias:4, equipes[i].empates:4, equipes[i].derrotas:4, equipes[i].pontosMarcados:4, equipes[i].pontosSofridos:4, equipes[i].saldo:4, "  ", equipes[i].nome)
   fimpara
fimprocedimento

// Cada partida aparece 2 vezes na matriz: soma só acima da diagonal
funcao contarPartidas: inteiro
var
   i, j, total: inteiro
inicio
   total <- 0
   para i de 1 ate MAX_EQUIPES - 1 faca
      para j de i + 1 ate MAX_EQUIPES faca
         total <- total + confrontos[i, j]
      fimpara
   fimpara
   retorne total
fimfuncao

// Parâmetros por REFERÊNCIA (var): o resultado volta para quem chamou
procedimento somarResultados(var vitorias: inteiro; var pontos: inteiro)
var
   i: inteiro
inicio
   vitorias <- 0
   pontos <- 0
   para i de 1 ate qtdEquipes faca
      vitorias <- vitorias + equipes[i].vitorias
      pontos <- pontos + equipes[i].pontosMarcados
   fimpara
fimprocedimento

procedimento exibirEstatisticas
var
   i, partidas, somaVitorias, somaPontos: inteiro
   pVit, pPts, pSaldo, pMarc: inteiro
   media: real
inicio
   partidas <- contarPartidas
   se partidas = 0 entao
      escreval(">> Nenhuma partida registrada.")
   senao
      somarResultados(somaVitorias, somaPontos)
      pVit <- 1
      pPts <- 1
      pSaldo <- 1
      pMarc <- 1
      para i de 2 ate qtdEquipes faca
         se equipes[i].vitorias > equipes[pVit].vitorias entao
            pVit <- i
         fimse
         se equipes[i].pontuacao > equipes[pPts].pontuacao entao
            pPts <- i
         fimse
         se equipes[i].saldo > equipes[pSaldo].saldo entao
            pSaldo <- i
         fimse
         se equipes[i].pontosMarcados > equipes[pMarc].pontosMarcados entao
            pMarc <- i
         fimse
      fimpara
      escreval("Equipes: ", qtdEquipes, " | Partidas: ", partidas)
      // Toda partida tem 1 vencedor ou é empate
      escreval("Com vencedor: ", somaVitorias, " | Empatadas: ", partidas - somaVitorias)
      media <- somaPontos / partidas
      escreval("Média de pontos por partida: ", media:6:2)
      escreval("Mais vitórias: ", equipes[pVit].nome)
      escreval("Maior pontuação: ", equipes[pPts].nome)
      escreval("Maior saldo: ", equipes[pSaldo].nome)
      escreval("Mais pontos marcados: ", equipes[pMarc].nome)
   fimse
fimprocedimento

// Mostra a matriz: linhas e colunas são os CÓDIGOS das equipes
procedimento exibirConfrontos
var
   i, j: inteiro
inicio
   escreva("Cód")
   para j de 1 ate qtdEquipes faca
      escreva(equipes[j].codigo:4)
   fimpara
   escreval("")
   para i de 1 ate qtdEquipes faca
      escreva(equipes[i].codigo:3)
      para j de 1 ate qtdEquipes faca
         escreva(confrontos[equipes[i].codigo, equipes[j].codigo]:4)
      fimpara
      escreval("")
   fimpara
fimprocedimento

// RECURSÃO. Caso-base: n = 0. Chamada recursiva: n - 1.
procedimento contagemRegressiva(n: inteiro)
inicio
   se n = 0 entao
      escreval("CAMPEONATO INICIADO!")
   senao
      escreva(n, "... ")
      contagemRegressiva(n - 1)
   fimse
fimprocedimento

// PRINCIPAL: só controla o menu
inicio
   inicializarSistema
   opcao <- 0
   enquanto opcao <> 9 faca
      exibirMenu
      leia(opcao)
      escolha opcao
         caso 1
            cadastrarEquipe
         caso 2
            listarEquipes
         caso 3
            registrarPartida
         caso 4
            consultarEquipe
         caso 5
            exibirClassificacao
         caso 6
            exibirEstatisticas
         caso 7
            exibirConfrontos
         caso 8
            escreval("Iniciando campeonato em...")
            contagemRegressiva(lerInteiro("Contar a partir de", 1, MAX_CONTAGEM))
         caso 9
            escreval("Sistema encerrado.")
         outrocaso
            escreval(">> Opção inválida!")
      fimescolha
   fimenquanto
fimalgoritmo
