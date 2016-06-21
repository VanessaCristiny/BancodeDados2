/*_________________categories_____________________*/
CREATE OR REPLACE TYPE CATEGORIA AS OBJECT(
	nome VARCHAR(30)
);

CREATE OR REPLACE TYPE SUBCATEGORIA AS OBJECT(
	nome VARCHAR(30),
	e_de REF CATEGORIA	
);

/*___________________product______________________*/

CREATE OR REPLACE TYPE T_ENDERECO AS OBJECT 
( 
    rua VARCHAR(30),
    numero INTEGER,
    complemento varchar(20),
    bairro varchar(20),
    cidade VARCHAR(30),
    estado CHAR(2),
    cep CHAR(8)
)FINAL;

CREATE OR REPLACE TYPE T_PRODUTO AS OBJECT(
	id_produto NUMBER,
	nome VARCHAR(30),
	descricao VARCHAR(100),
	pertence REF SUBCATEGORIA
)NOT FINAL;

CREATE OR REPLACE TYPE T_BEM UNDER T_PRODUTO(

);

CREATE OR REPLACE TYPE T_SERVICO UNDER T_PRODUTO(
	local T_ENDERECO,
	tempo_duracao NUMBER
);

CREATE OR REPLACE TYPE LISTA_PRODS AS TABLE OF T_PRODUTO;

/*___________________user_________________________*/

CREATE OR REPLACE TYPE T_NOME AS OBJECT 
( 
    primeiro_nome VARCHAR(30),
    nome_meio VARCHAR(30),
    ultimo_nome VARCHAR(30)
)FINAL;

CREATE OR REPLACE TYPE T_TELEFONE AS OBJECT 
( 
    ddd CHAR(2),
    tel VARCHAR(10),
    descr VARCHAR(15)
)FINAL;

CREATE TYPE LISTA_TELS as VARRAY(5) OF T_TELEFONE;

CREATE OR REPLACE TYPE T_USUARIO AS OBJECT(
	nome T_NOME,
	login VARCHAR(50),
	senha VARCHAR(20),
	cpf CHAR(11),
	sexo CHAR(1),
	email VARCHAR(50),
	endereco T_ENDERECO,
	telefones LISTA_TELS
)NOT FINAL;

CREATE OR REPLACE TYPE T_ADM UNDER T_USUARIO(
);

/*___________________Transation___________________*/

CREATE OR REPLACE TYPE T_DURACAO AS OBJECT(
	dataInicio DATE,
	dataFim DATE
)FINAL;

CREATE OR REPLACE TYPE T_TEMPO AS OBJECT(
	qtd INTEGER,
	descricao VARCHAR(10)
)FINAL;

CREATE OR REPLACE TYPE T_ANUNCIO AS OBJECT(
	id_anuncio NUMBER,
	data_limite DATE,
	finalizado NUMBER,
	data_postagem DATE,
	descricao VARCHAR(100),
	tempo_posse T_TEMPO,
	usuario REF T_USUARIO,
	produto  REF T_PRODUTO
)FINAL;

CREATE OR REPLACE TYPE LISTA_ANUNCIOS AS TABLE OF T_ANUNCIO;

CREATE OR REPLACE TYPE T_TRANSACAO AS OBJECT(
	id_transacao NUMBER,
	descricao VARCHAR(20)
)NOT FINAL;

CREATE OR REPLACE TYPE T_VENDA UNDER T_TRANSACAO(
	preco NUMBER
);

CREATE OR REPLACE TYPE T_TROCA UNDER T_TRANSACAO(
	produtos LISTA_PRODS
);

CREATE OR REPLACE TYPE T_EMPRESTIMO UNDER T_TRANSACAO(
	tempo_duracao T_DURACAO
);

CREATE OR REPLACE TYPE T_DOACAO UNDER T_TRANSACAO(
); 

CREATE OR REPLACE TYPE T_LANCE AS OBJECT(
	usuario REF T_USUARIO,
	lance NUMBER
);

CREATE OR REPLACE TYPE LISTA_LANCES AS VARRAY(5) OF T_LANCE;

CREATE OR REPLACE TYPE T_LEILAO UNDER T_TRANSACAO(
	lance_minimo NUMBER,
	tempo_duracao T_DURACAO,
	lances LISTA_LANCES
);

/*_________________OTHERS___________________*/

CREATE OR REPLACE TYPE T_ANUNCIO_TRANS AS OBJECT(
	anuncio REF T_ANUNCIO,
	transacao T_TRANSACAO,
	realizou T_USUARIO NULL
)FINAL;

CREATE OR REPLACE TYPE T_ANUNCIO_USUARIO AS OBJECT(
	usuario REF T_USUARIO,
	anuncios LISTA_ANUNCIOS	
);

CREATE TABLE CATEGORIAS OF CATEGORIA(nome PRIMARY KEY);
CREATE TABLE SUBCATEGORIAS OF SUBCATEGORIA(nome PRIMARY KEY);
CREATE TABLE PRODUTOS OF T_PRODUTO(id_produto PRIMARY KEY);
CREATE TABLE BENS OF T_BEM;
CREATE TABLE SERVICOS OF T_SERVICO;
CREATE TABLE USUARIOS OF T_USUARIO(email PRIMARY KEY);
CREATE TABLE ADM OF T_ADM;
CREATE TABLE ANUNCIOS OF T_ANUNCIO(id_anuncio PRIMARY KEY);
CREATE TABLE TRANSACOES OF T_TRANSACAO(id_transacao PRIMARY KEY);
CREATE TABLE VENDAS OF T_VENDA;
CREATE TABLE TROCAS OF T_TROCA NESTED TABLE produtos STORE AS PRODS;
CREATE TABLE EMPRESTIMOS OF T_EMPRESTIMO;
CREATE TABLE DOACOES OF T_DOACAO;
CREATE TABLE LEILOES OF T_LEILAO;
CREATE TABLE ANUNCIOS_TRANS OF T_ANUNCIO_TRANS;
CREATE TABLE ANUNCIOS_USUARIOS OF T_ANUNCIO_USUARIO NESTED TABLE anuncios STORE AS ANUNC;


INSERT INTO USUARIOS VALUES(T_NOME('Vanessa', 'C.R.','Vasconcelos'), 'vanessacristiny', 'lala', '52036915874', 'F', 'vavacristiny@hotmail.com', T_ENDERECO('Frei Orlando', 708, 'apto 603', 'Betania', 'Vicosa', 'MG', '36570000'), LISTA_TELS(T_TELEFONE('31','32331587', 'NULL')));

INSERT INTO CATEGORIAS VALUES('Brinquedos');

INSERT INTO SUBCATEGORIAS VALUES('Bonecas', (SELECT REF(c) FROM CATEGORIAS c WHERE c.nome = 'Brinquedos'));