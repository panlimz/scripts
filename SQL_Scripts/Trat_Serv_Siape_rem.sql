-- Removendo dados
truncate table tmp_serv_siape_rem;
truncate table final_serv_siape_rem;

-- Deletando linhas de observação do final da tabela
Delete FROM tmp_serv_siape_rem where ano ilike '%(*)%';

-- Esboço de tratamento dos dados substituindo vírgula por ponto, transformando em decimal 
-- e transformando valores zerados em nulo
select ano, mes, cpf, "gratif_natal_(R$)", 
	nullif((cast(replace("gratif_natal_(R$)", ',', '.') as decimal(20,2))), 0) as test2
from tmp_serv_siape_rem 

-- Esboço de soma das colunas
select "rem_pos_deduc_obrig_(R$)" + "total_verbas_indeniz_(R$)(*)",
		"rem_pos_deduc_obrig_(U$)" + "total_verbas_indeniz_(U$)(*)"
	from final_serv_siape_rem

-- Inserindo dados tratados na tabela final 
insert into final_serv_siape_rem
	(ano, mes, id_servidor_portal, cpf, nome, "rem_bas_bruta_(R$)", "rem_bas_bruta_(U$)", "abate-teto_(R$)", "abate-teto_(U$)", 
	"gratif_natal_(R$)", "gratif_natal_(U$)", "abate-teto_gratif_natal_(R$)", "abate-teto_gratif_natal_(U$)", "férias_(R$)", 
	"férias_(U$)", "outras_rem_event_(R$)", "outras_rem_event_(U$)", "IRRF_(R$)", "IRRF_(U$)", "PSS_RPGS_(R$)", "PSS_RPGS_(U$)", 
	"demais_ded_(R$)", "demais_ded_(U$)", "pensao_militar_(R$)", "pensao_militar_(U$)", "fundo_saude_(R$)", "fundo_saude_(U$)", 
	"tx_ocup_imovel_funcional_(R$)", "tx_ocup_imovel_funcional_(U$)", "rem_pos_deduc_obrig_(R$)", "rem_pos_deduc_obrig_(U$)", 
	"verbas_indeniz_sist_pes_civil_(R$)(*)", "verbas_indeniz_sist_pes_civil_(U$)(*)", "verbas_indeniz_sist_pes_militar_(R$)(*)", 
	"verbas_indeniz_sist_pes_militar_(U$)(*)", "verbas_indeniz_prog_deslig_volunt_mp-792-2017_(R$)", 
	"verbas_indeniz_prog_deslig_volunt_mp-792-2017_(U$)", "total_verbas_indeniz_(R$)(*)", "total_verbas_indeniz_(U$)(*)")
	select 
		cast(ano as int), cast(mes as int), id_servidor_portal, cpf, nome, cast(replace("rem_bas_bruta_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("rem_bas_bruta_(U$)", ',', '.') as decimal(20,2)), cast(replace("abate-teto_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("abate-teto_(U$)", ',', '.') as decimal(20,2)), cast(replace("gratif_natal_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("gratif_natal_(U$)", ',', '.') as decimal(20,2)), cast(replace("abate-teto_gratif_natal_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("abate-teto_gratif_natal_(U$)", ',', '.') as decimal(20,2)), cast(replace("férias_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("férias_(U$)", ',', '.') as decimal(20,2)), cast(replace("outras_rem_event_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("outras_rem_event_(U$)", ',', '.') as decimal(20,2)), cast(replace("IRRF_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("IRRF_(U$)", ',', '.') as decimal(20,2)), cast(replace("PSS_RPGS_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("PSS_RPGS_(U$)", ',', '.') as decimal(20,2)), cast(replace("demais_ded_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("demais_ded_(U$)", ',', '.') as decimal(20,2)), cast(replace("pensao_militar_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("pensao_militar_(U$)", ',', '.') as decimal(20,2)), cast(replace("fundo_saude_(R$)", ',', '.') as decimal(20,2)),
		cast(replace("fundo_saude_(U$)", ',', '.') as decimal(20,2)), cast(replace("tx_ocup_imovel_funcional_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("tx_ocup_imovel_funcional_(U$)", ',', '.') as decimal(20,2)), cast(replace("rem_pos_deduc_obrig_(R$)", ',', '.') as decimal(20,2)),
		cast(replace("rem_pos_deduc_obrig_(U$)", ',', '.') as decimal(20,2)),
		cast(replace("verbas_indeniz_sist_pes_civil_(R$)(*)", ',', '.') as decimal(20,2)), 
		cast(replace("verbas_indeniz_sist_pes_civil_(U$)(*)", ',', '.') as decimal(20,2)), 
		cast(replace("verbas_indeniz_sist_pes_militar_(R$)(*)", ',', '.') as decimal(20,2)), 
		cast(replace("verbas_indeniz_sist_pes_militar_(U$)(*)", ',', '.') as decimal(20,2)), 
		cast(replace("verbas_indeniz_prog_deslig_volunt_mp-792-2017_(R$)", ',', '.') as decimal(20,2)), 
		cast(replace("verbas_indeniz_prog_deslig_volunt_mp-792-2017_(U$)", ',', '.') as decimal(20,2)),
		cast(replace("total_verbas_indeniz_(R$)(*)", ',', '.') as decimal(20,2)), 
		cast(replace("total_verbas_indeniz_(U$)(*)", ',', '.') as decimal(20,2))
		from tmp_serv_siape_rem;
	truncate table tmp_serv_siape_rem;

-- Inserindo novas colunas
alter table final_serv_siape_rem 
add "total_rem_(R$)" numeric (20,2), 
add "total_rem_(U$)" numeric (20,2)

-- Atualizando novas colunas com valores
update "final_serv_siape_rem"
	set "total_rem_(R$)" = "rem_pos_deduc_obrig_(R$)" + "total_verbas_indeniz_(R$)(*)", 
		"total_rem_(U$)" = "rem_pos_deduc_obrig_(U$)" + "total_verbas_indeniz_(U$)(*)"
	where ("rem_pos_deduc_obrig_(R$)" is not null) or ("total_verbas_indeniz_(R$)(*)" is not null)
	
-- Atualizando nova coluna total da soma das rendas
update "final_serv_siape_rem"
	set "total_rem_(R$+U$)" = "total_rem_(R$)" + ("total_rem_(U$)" *5) 
	where ("total_rem_(R$)" is not null) or ("total_rem_(U$)" is not null)

-- Deletando entradas com renda negativa ou zerada
delete from final_serv_siape_rem 
where "total_rem_(R$+U$)" <= 0
	
-- Visualizando apenas pessoas que possuem ambas as rendas
select * from final_serv_siape_rem 
where ("total_rem_(R$)" is not null)and ("total_rem_(U$)" is not null)
order by "total_rem_(R$)" desc

