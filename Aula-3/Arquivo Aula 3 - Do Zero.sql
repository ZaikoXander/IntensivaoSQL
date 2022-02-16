# --- AULA 3: ANÁLISES DE DADOS COM SQL --- #

USE hashtagmovie;

-- Agrupamentos
-- Filtragem avançada
-- Joins
-- Subqueries
-- Criação de Views

-- Lembrando das tabelas do banco de dados...

SELECT * FROM alugueis;
SELECT * FROM atores;
SELECT * FROM atuacoes;
SELECT * FROM clientes;
SELECT * FROM filmes;

# =======        PARTE 1:        =======#
# =======  CRIANDO AGRUPAMENTOS  =======#

USE hashtagmovie;

-- CASE 1. Você deverá começar fazendo uma análise para descobrir o preço médio de aluguel dos filmes.

SELECT AVG(preco_aluguel) AS 'Preço médio' FROM filmes;

-- Agora que você sabe o preço médio para se alugar filmes na hashtagmovie, você deverá ir além na sua análise e descobrir qual é o preço médio para cada gênero de filme.

/*
genero                   | preco_medio
______________________________________
Comédia                  | X
Drama                    | Y
Ficção e Fantasia        | Z
Mistério e Suspense      | A
Arte                     | B
Animação                 | C
Ação e Aventura          | D
*/

-- Você seria capaz de mostrar os gêneros de forma ordenada, de acordo com a média?

SELECT
    genero,
    AVG(preco_aluguel) AS 'Preço Médio'
FROM filmes GROUP BY genero ORDER BY AVG(preco_aluguel) ASC;

-- Altere a consulta anterior para mostrar na nossa análise também a quantidade de filmes para cada gênero, conforme exemplo abaixo.

/*
genero                   | preco_medio      | qtd_filmes
_______________________________________________________
Comédia                  | X                | .
Drama                    | Y                | ..
Ficção e Fantasia        | Z                | ...
Mistério e Suspense      | A                | ....
Arte                     | B                | .....
Animação                 | C                | ......
Ação e Aventura          | D                | .......
*/

SELECT
    genero,
    AVG(preco_aluguel) AS 'Preço Médio',
    COUNT(*) AS 'Qtd de Filmes'
FROM filmes GROUP BY genero;


-- CASE 2. Para cada filme, descubra a classificação média, o número de avaliações e a quantidade de vezes que cada filme foi alugado. Ordene essa consulta a partir da avaliacao_media, em ordem decrescente.

/*
id_filme  | avaliacao_media   | num_avaliacoes  | num_alugueis
_______________________________________________________
1         | X                 | .               | .
2         | Y                 | ..              | ..
3         | Z                 | ...             | ...
4         | A                 | ....            | ....
5         | B                 | .....           | .....
...
*/

SELECT
    id_filme AS 'ID do Filme',
    AVG(nota) AS 'Avaliação Média',
    COUNT(nota) AS 'Num Avaliações',
    COUNT(*) AS 'Num Alugueis'
FROM alugueis GROUP BY id_filme ORDER BY AVG(nota) DESC;

# =======              PARTE 2:               =======#
# =======  FILTROS AVANÇADOS EM AGRUPAMENTOS  =======#

USE hashtagmovie;

-- CASE 3. Você deve alterar a consulta DO CASE 1 e considerar os 2 cenários abaixo:

-- Cenário 1: Fazer a mesma análise, mas considerando apenas os filmes com ANO_LANCAMENTO igual a 2011.

SELECT
    genero,
    AVG(preco_aluguel) AS 'Preço Médio',
    COUNT(*) AS 'Qtd de Filmes'
FROM filmes WHERE ano_lancamento = 2011 GROUP BY genero;

-- Cenário 2: Fazer a mesma análise, mas considerando apenas os filmes dos gêneros com mais de 10 filmes.

SELECT
    genero,
    AVG(preco_aluguel) AS 'Preço Médio',
    COUNT(*) AS 'Qtd de Filmes' 
FROM filmes GROUP BY genero HAVING COUNT(*) > 10;

# =======              PARTE 3:              =======#
# =======  RELACIONANDO TABELAS COM O JOIN   =======#

USE hashtagmovie;

-- CASE 4. Selecione a tabela de Atuações. Observe que nela, existem apenas os ids dos filmes e ids dos atores. Você seria capaz de completar essa tabela com as informações de títulos dos filmes e nomes dos atores?

SELECT
    atuacoes.id_filme AS 'ID Filme',
    filmes.titulo AS 'Filme',
    atuacoes.id_ator AS 'ID Ator',
    atores.nome_ator AS 'Ator'
FROM atuacoes
LEFT JOIN filmes ON atuacoes.id_filme = filmes.id_filme
LEFT JOIN atores ON atuacoes.id_ator = atores.id_ator;

-- CASE 5. Média de avaliações dos clientes

SELECT
    alugueis.id_cliente AS 'ID Cliente',
    clientes.nome_cliente AS 'Nome Cliente',
    AVG(alugueis.nota) AS 'Avaliação Média'
FROM alugueis
LEFT JOIN clientes ON alugueis.id_cliente = clientes.id_cliente
GROUP BY alugueis.id_cliente
ORDER BY `Avaliação Média` DESC;

# =======                         PARTE 4:                           =======#
# =======  SUBQUERIES: UTILIZANDO UM SELECT DENTRO DE OUTRO SELECT   =======#

USE hashtagmovie;

-- CASE 6. Você precisará fazer uma análise de desempenho dos filmes. Para isso, uma análise comum é identificar quais filmes têm uma nota acima da média. Você seria capaz de fazer isso?

SELECT
    AVG(nota) AS 'Nota Média de todos os Filmes'
FROM alugueis; -- 7,94

SELECT
    alugueis.id_filme AS 'ID Filme',
    filmes.titulo AS 'Nome Filme',
    AVG(alugueis.nota) AS 'Nota Média'
FROM alugueis
LEFT JOIN filmes ON alugueis.id_filme = filmes.id_filme
GROUP BY alugueis.id_filme;

SELECT
    alugueis.id_filme AS 'ID Filme',
    filmes.titulo AS 'Nome Filme',
    AVG(alugueis.nota) AS 'Nota Média'
FROM alugueis
LEFT JOIN filmes ON alugueis.id_filme = filmes.id_filme
GROUP BY alugueis.id_filme
HAVING `Nota Média` > (SELECT AVG(nota) FROM alugueis);

# =======   PARTE 5:     =======#
# =======  CREATE VIEW   =======#

USE hashtagmovie;

-- CREATE/DROP VIEW: Guardando o resultado de uma consulta no nosso banco de dados

-- CASE 7. Crie uma view para guardar o resultado do SELECT abaixo.

CREATE VIEW resultados AS
    SELECT
        titulo,
        COUNT(*) AS num_alugueis,
        AVG(nota) AS media_nota,
        SUM(preco_aluguel) AS receita_total
    FROM alugueis
    LEFT JOIN filmes
    ON alugueis.id_filme = filmes.id_filme
    GROUP BY titulo
    ORDER BY num_alugueis DESC;

SELECT * FROM resultados;

DROP View resultados;