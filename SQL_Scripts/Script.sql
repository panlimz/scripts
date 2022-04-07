 -- Seleção básica
SELECT * FROM tmp_cpgf where data like ''
SELECT * FROM tmp_cpgf where valor is not null

-- Tratando dados da tabela temporária
update tmp_cpgf 
set valor = replace(valor, ',', '.')
where valor is not null

update tmp_cpgf 
data = TO_DATE(data, 'DD/MM/YYYY')
where data not like ''

SELECT * FROM tmp_cpgf

-- Copiando dados pra tabela final 
insert into final_cpgf 
	(codigo_orgao_superior, nome_orgao_superior, codigo_orgao, nome_orgao, codigo_unidade_gestora, 
	nome_unidade_gestora, ano, mes, cpf_portador, nome_portador, documento_favorecido, 
	nome_favorecido, transacao, "data", valor)
SELECT 
	codigo_orgao_superior, nome_orgao_superior, codigo_orgao, nome_orgao, codigo_unidade_gestora, 
	nome_unidade_gestora, ano, mes, cpf_portador, nome_portador, documento_favorecido, 
	nome_favorecido, transacao, TO_DATE(data, 'DD/MM/YYYY'), cast(valor as decimal(20,2))
FROM tmp_cpgf

-- transformando dados de string em decimal
select cast(valor as decimal(20,2)) from tmp_cpgf

-- Deletando dados de uma coluna
truncate table tmp_cpgf;
truncate table tmp_pep;
truncate table final_cpgf;

-- Contar linhas da tabela
select * from tmp_serv_siape_rem
	
select count(data_fim_exercicio) from tmp_pep where data_fim_exercicio not like '%/%/%'

-- Alterando virgula para ponto, essa string para decimal e dados vazios para null
select ano, mes, cpf, "gratif_natal_(R$)", 
	nullif((cast(replace("gratif_natal_(R$)", ',', '.') as decimal(20,2))), 0)
from tmp_serv_siape_rem 
