-- Removendo dados
truncate table tmp_serv_siape_cad;
truncate table final_serv_siape_cad;

-- Tratando datas inválidas 
update tmp_serv_siape_cad 
set data_inicio_afastamento = nullif(data_inicio_afastamento, ''),
	data_termino_afastamento = nullif(data_termino_afastamento, ''),
	data_ingresso_cargofuncao = nullif(data_ingresso_cargofuncao, ''),
	data_nomeacao_cargofuncao = nullif(data_nomeacao_cargofuncao, ''),
	data_ingresso_orgao = nullif(data_ingresso_orgao, ''),
	data_diploma_ingresso_servicopublico = nullif(data_diploma_ingresso_servicopublico, '')
	where data_inicio_afastamento ilike '' or data_termino_afastamento ilike '' 
		or data_ingresso_cargofuncao ilike '' or data_nomeacao_cargofuncao ilike ''
		or data_ingresso_orgao ilike '' or data_diploma_ingresso_servicopublico ilike ''

-- Inserindo dados tratados na tabela final
insert into final_serv_siape_cad 
	(id_servidor_portal, nome, cpf, matricula, descricao_cargo, classe_cargo, referencia_cargo, padrao_cargo, 
	nivel_cargo, sigla_funcao, nivel_funcao, funcao, codigo_atividade, atividade, opcao_parcial, cod_uorg_lotacao, uorg_lotacao, cod_org_lotacao, 
	org_lotacao, cod_orgsup_lotacao, orgsup_lotacao, cod_uorg_exercicio, uorg_exercicio, cod_org_exercicio, org_exercicio, cod_orgsup_exercicio, 
	orgsup_exercicio, cod_tipo_vinculo, tipo_vinculo, situacao_vinculo, data_inicio_afastamento, data_termino_afastamento, regime_juridico, 
	jornada_de_trabalho, data_ingresso_cargofuncao, data_nomeacao_cargofuncao, data_ingresso_orgao, documento_ingresso_servicopublico, 
	data_diploma_ingresso_servicopublico, diploma_ingresso_cargofuncao, diploma_ingresso_orgao, diploma_ingresso_servicopublico, uf_exercicio)
		select 
		-- Distinct on está retornando apenas os ids diferentes		
		distinct on (id_servidor_portal) id_servidor_portal, nome, cpf, matricula, descricao_cargo, classe_cargo, referencia_cargo, padrao_cargo, 
			nivel_cargo, sigla_funcao, nivel_funcao, funcao, codigo_atividade, atividade, opcao_parcial, cod_uorg_lotacao, uorg_lotacao, cod_org_lotacao, 
			org_lotacao, cod_orgsup_lotacao, orgsup_lotacao, cod_uorg_exercicio, uorg_exercicio, cod_org_exercicio, org_exercicio, cod_orgsup_exercicio, 
			orgsup_exercicio, cod_tipo_vinculo, tipo_vinculo, situacao_vinculo, TO_DATE(data_inicio_afastamento, 'DD/MM/YYYY'), 
			TO_DATE(data_termino_afastamento, 'DD/MM/YYYY'), regime_juridico, jornada_de_trabalho, TO_DATE(data_ingresso_cargofuncao, 'DD/MM/YYYY'),
			TO_DATE(data_nomeacao_cargofuncao, 'DD/MM/YYYY'), TO_DATE(data_ingresso_orgao, 'DD/MM/YYYY'), documento_ingresso_servicopublico, 
			TO_DATE(data_diploma_ingresso_servicopublico, 'DD/MM/YYYY'), diploma_ingresso_cargofuncao, diploma_ingresso_orgao, diploma_ingresso_servicopublico, uf_exercicio
		from tmp_serv_siape_cad
		order by id_servidor_portal;
	truncate table tmp_serv_siape_cad

-- Transformando data nula em fictícia
update tmp_serv_siape_cad 
set data_ingresso_cargofuncao = coalesce(data_ingresso_cargofuncao, '01/01/2020')
where data_ingresso_cargofuncao is null

update tmp_serv_siape_cad 
set data_ingresso_orgao  = coalesce(data_ingresso_orgao, '01/01/2020')
where data_ingresso_orgao is null
