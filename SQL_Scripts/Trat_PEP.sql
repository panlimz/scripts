-- Tratamento PEP (Transformação de datas inválidas para Nulo)
update tmp_pep
	set data_fim_exercicio = replace(data_fim_exercicio , 'Não informada', NULL)
		where data_fim_exercicio ilike 'Não informada'

update tmp_pep
	set data_inicio_exercicio = replace(data_inicio_exercicio , 'Não informada', NULL)
		where data_inicio_exercicio ilike 'Não informada'

update tmp_pep
	set data_fim_carencia = replace(data_fim_carencia , 'Não informada', NULL)
		where data_fim_carencia ilike 'Não informada'

-- Inserindo dados tratados na tabela final
insert into final_pep 
(cpf, nome_pep, sigla_funcao, descricao_funcao, nivel_funcao, nome_orgao, data_inicio_exercicio, data_fim_exercicio, data_fim_carencia)
	select
	cpf, nome_pep, sigla_funcao, descricao_funcao, nivel_funcao, nome_orgao, TO_DATE(data_inicio_exercicio, 'DD/MM/YYYY'), 
	TO_DATE(data_fim_exercicio, 'DD/MM/YYYY'), TO_DATE(data_fim_carencia, 'DD/MM/YYYY')
		from tmp_pep;
truncate tmp_pep;