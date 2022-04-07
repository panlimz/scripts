--"Atualmente estamos utilizando um modelo "normalizado" direcionado para relatório e exportação


-----------------Criação das tabelas-----------------------
--Cartão: (562589 linhas)
--codigo_compra PK, codigo_portador FK, documento_favorecido, nome_favorecido, transacao, valor, data
drop table if exists models.cartao;
create table models.cartao (
	codigo_compra integer primary key, 
	codigo_portador integer, 
	documento_favorecido varchar(20), 
	nome_favorecido varchar(200), 
	transacao varchar(100), 
	valor numeric(10,2), 
	"data" date,
	constraint fk_cartao_portador foreign key(codigo_portador) REFERENCES models.portador(codigo_portador)
);

create sequence cartao_sequence start with 1;
drop sequence cartao_sequence;


--Portador: (10745)
--codigo_portador PK, nome_portador, cpf_portador, codigo_orgao FK, codigo_unidade_gestora FK
drop table if exists models.portador cascade;
create table models.portador (
	codigo_portador integer primary key, 
	nome_portador varchar(200), 
	cpf_portador varchar(20),
	codigo_orgao integer, 
	codigo_unidade_gestora integer,
	constraint fk_orgao_portador 
	foreign key(codigo_orgao) REFERENCES models.orgao(codigo_orgao),
	foreign key(codigo_unidade_gestora) REFERENCES models.unidade_gestora(codigo_unidade_gestora)
)

create sequence portador_sequence start with 1;
drop sequence portador_sequence;


--Orgao: (188 linhas)
--codigo_orgao PK, nome_orgao, codigo_orgao_superior FK
drop table if exists models.orgao;
create table models.orgao (
	codigo_orgao integer, 
	nome_orgao varchar(200), 
	codigo_orgao_superior integer,
	primary key (codigo_orgao),
	constraint fk_orgao_sup foreign key(codigo_orgao_superior) REFERENCES models.orgao_superior(codigo_orgao_superior)
)

--Orgao_Superior: (22 linhas)
--codigo_orgao_superior PK, nome_orgao_superior
drop table if exists models.orgao_superior;
create table models.orgao_superior (
	codigo_orgao_superior integer primary key, 
	nome_orgao_superior varchar(200)
)

--UNIDADE_GESTORA: (1414 linhas)
--codigo_unidade_gestora PK, nome_unidade_gestora
drop table if exists models.unidade_gestora;
create table models.unidade_gestora (
	codigo_unidade_gestora integer primary key, 
	nome_unidade_gestora varchar(200)
)

-----------------Inserindo dados-----------------------
--cartao
truncate table models.cartao 
insert into models.cartao (
	codigo_compra, codigo_portador, documento_favorecido, nome_favorecido, transacao, valor, "data")
select 
	nextval('cartao_sequence'), p.codigo_portador, cf.documento_favorecido, cf.nome_favorecido, cf.transacao, cf.valor, cf."data" 
from final_cpgf cf 
join models.portador p on cf.nome_portador = p.nome_portador
where cf.documento_favorecido != '-11'
	
--portador 
insert into models.portador (
	codigo_portador, nome_portador, cpf_portador, codigo_orgao, codigo_unidade_gestora) 
select 
	nextval('portador_sequence'), nome_portador, cpf_portador, codigo_orgao, codigo_unidade_gestora 
from (select distinct on (nome_portador, cpf_portador)
	nome_portador, cpf_portador, codigo_orgao, codigo_unidade_gestora
	from public.final_cpgf
	where nome_portador not ilike 'Sigiloso'
	) as portadores
	
--orgao
insert into models.orgao 
select distinct on(codigo_orgao)
    codigo_orgao, nome_orgao, codigo_orgao_superior 
from public.final_cpgf
order by codigo_orgao, "data" desc

--orgao_superior 
insert into models.orgao_superior 
select distinct on (codigo_orgao_superior)
	codigo_orgao_superior, nome_orgao_superior 
from public.final_cpgf 

--unidade_gestora 
insert into models.unidade_gestora 
select distinct on (codigo_unidade_gestora)
	codigo_unidade_gestora, nome_unidade_gestora 
from 
	public.final_cpgf 