-- Contado campos para alteração 
SELECT count(*) FROM tmp_ceis where data_do_transito_em_julgado ilike ''

-- Tratando datas vazias para nulo
update tmp_ceis
	set data_final_sancao = replace(data_final_sancao , '', NULL)
		where data_final_sancao ilike ''

update tmp_ceis
	set data_publicacao = replace(data_publicacao , '', NULL)
		where data_publicacao ilike ''

update tmp_ceis
	set data_do_transito_em_julgado = replace(data_do_transito_em_julgado, '', NULL)
		where data_do_transito_em_julgado ilike ''

-- Inserindo dados tratados na tabela final
insert into final_ceis 
(tipo_de_pessoa, cpf_ou_cnpj_do_sancionado, nome_informado_pelo_orgao_sancionador, razao_social_cadastro_receita, nome_fantasia_cadastro_receita, 
numero_do_processo, tipo_sancao, data_inicio_sancao, data_final_sancao, orgao_sancionador, uf_orgao_sancionador, origem_informacoes, 
data_origem_informacoes, data_publicacao, publicacao, detalhamento, abragencia_definida_em_decisao_judicial, fundamentacao_legal, 
descricao_da_fundamentacao_legal, data_do_transito_em_julgado, complemento_do_orgao, observacoes)
	select
		tipo_de_pessoa, cpf_ou_cnpj_do_sancionado, nome_informado_pelo_orgao_sancionador, razao_social_cadastro_receita, nome_fantasia_cadastro_receita, 
		numero_do_processo, tipo_sancao, TO_DATE(data_inicio_sancao, 'DD/MM/YYYY'), TO_DATE(data_final_sancao, 'DD/MM/YYYY'), orgao_sancionador, uf_orgao_sancionador, origem_informacoes, 
		TO_DATE(data_origem_informacoes, 'DD/MM/YYYY'), TO_DATE(data_publicacao, 'DD/MM/YYYY'), publicacao, detalhamento, abragencia_definida_em_decisao_judicial, fundamentacao_legal, 
		descricao_da_fundamentacao_legal, TO_DATE(data_do_transito_em_julgado, 'DD/MM/YYYY'), complemento_do_orgao, observacoes
		from tmp_ceis;
truncate tmp_ceis;
