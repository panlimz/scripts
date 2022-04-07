create sequence proc_op_realizada_sequence
drop sequence proc_op_realizada_sequence

-- Insert operação realizada cpgf
insert into monitor.proc_operacao_realizada (cep, codigo, complemento, documento_contraparte, dt_operacao, especie, hr_operacao, 
	id_operacao_disponivel, id_proc_cliente, id_proc_contrato, id_proc_operacao_realizada, id_produto, nome_contraparte, outros, 
	patrimonio, renda, tipo_operacao, valor, valor_esperado)
select
	null, CONCAT(od.prefixo, '_', nextval('proc_op_realizada_sequence')), null, mc.documento_favorecido, mc."data", od.especie, null, 
	od.id_operacao_disponivel, pc.id_proc_cliente, pco.id_proc_contrato, currval('proc_op_realizada_sequence'), pco.id_produto, 
	mc.nome_favorecido, '{}', pc.patrimonio, pc.renda, od.tipo_operacao, mc.valor, null
from models.cartao mc 
join monitor.proc_cliente pc on concat('CPGF_', mc.codigo_portador) = pc.codigo
join monitor.proc_contrato pco on pc.id_proc_cliente = pco.id_proc_cliente  
join monitor.operacao_disponivel od on mc.transacao = od.nome  
where mc.valor > 0 and mc.documento_favorecido not like '-11';


-- Insert operação realizada servidores
insert into monitor.proc_operacao_realizada (cep, codigo, complemento, documento_contraparte, dt_operacao, especie, hr_operacao, 
	id_operacao_disponivel, id_proc_cliente, id_proc_contrato, id_proc_operacao_realizada, id_produto, nome_contraparte, outros, 
	patrimonio, renda, tipo_operacao, valor, valor_esperado)
select
	null, CONCAT(od.prefixo, '_', nextval('proc_op_realizada_sequence')), null, fsr.cpf, 
	cast(concat(fsr.ano, '-', fsr.mes, '-', '01')as date), od.especie, null, od.id_operacao_disponivel, pc.id_proc_cliente, 
	pco.id_proc_contrato, currval('proc_op_realizada_sequence'), pco.id_produto, 
	fsr.nome, '{}', pc.patrimonio, pc.renda, od.tipo_operacao, fsr."total_rem_(R$+U$)", null
from public.final_serv_siape_rem fsr
join monitor.proc_cliente pc on fsr.nome = pc.nome 
join monitor.proc_contrato pco on pco.id_proc_cliente = pc.id_proc_cliente  
join monitor.operacao_disponivel od on od.id_produto = pco.id_produto 
where fsr."total_rem_(R$+U$)" > 0

select * from monitor.proc_operacao_realizada por where id_produto = 2 order by id_proc_cliente, dt_operacao 