-- Sequencia
create sequence proc_cliente_sequence start with 1;
drop sequence proc_cliente_sequence;

truncate monitor.proc_cliente

-- Insert cliente CPGF
insert into monitor.proc_cliente (
	aposentado, ativo, cep, cnae, codigo, codigo_localizador, documento, dt_atualizacao, dt_entrada, empresa, id_proc_cliente, 
	id_sistema, nome, outros, patrimonio, profissao, renda, score, tipo_cadastro, validado)
select false, true, '', '', (CONCAT('CPGF_', p.codigo_portador)), '', (p.cpf_portador), 
	MIN(c.data), MIN(c.data), (u.nome_unidade_gestora), (nextval('proc_cliente_sequence')), 1, 
	(p.nome_portador), '{}', 0, '', 0, 0, 1, true
from models.portador p
join models.cartao c on p.codigo_portador = c.codigo_portador 
join models.unidade_gestora u  on p.codigo_unidade_gestora = u.codigo_unidade_gestora
group by p.codigo_portador, u.codigo_unidade_gestora;  

-- Insert cliente Siape
insert into monitor.proc_cliente (
	aposentado, ativo, cep, cnae, codigo, codigo_localizador, documento, dt_atualizacao, dt_entrada, empresa, id_proc_cliente, 
	id_sistema, nome, outros, patrimonio, profissao, renda, score, tipo_cadastro, validado)
select false, true, '', '', (CONCAT('SERV_', s.id_servidor_portal)), '', (s.cpf), (s.data_ingresso_cargofuncao), (s.data_ingresso_orgao), 
	(s.org_lotacao), (nextval('proc_cliente_sequence')), 2, (s.nome), '{}', 0, (s.descricao_cargo), (avg(r."total_rem_(R$+U$)")), 0, 1, true
from public.final_serv_siape_cad s
left join public.final_serv_siape_rem r 
on s.id_servidor_portal = r.id_servidor_portal
group by s.id_servidor_portal, s.cpf, s.data_ingresso_cargofuncao, s.data_ingresso_orgao, s.org_lotacao, s.nome, s.descricao_cargo 

-- Contando servidores sem renda 
select count(*) from 
(select * from monitor.proc_cliente where codigo like 'S%' and renda = 0) as rem