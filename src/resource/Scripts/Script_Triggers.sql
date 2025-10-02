use assistech;


#author: José Bartolomeu A. D. Neto
#Trigger1. Para atualizar o atributo  "idade" da tabela DEPENDENTE

#Descricao do Funcionamento:
#o bloco if corrige o erro que pode ocorrer pela simples subtração do ano_atual - ano_nasc.
#se o ano 'virou', mas o mês não chegou ainda ou se o ano 'virou' mas mas o mês chegou e o dia não é subtraído 1 da data de aniversario calculada
#pois a pessoa oficialmente ainda não fez aniversário.
#ex: eu nasci em 01-11-1989, se eu deixasse só o conteúdo dentro do elseif no trigger, ele simplismente faria 2018 - 1989 = 29 em qualquer mês
#de 2018... No entanto eu só faço 29 anos quando o mês atual for novembro e chegar o dia do meu aniversário...

drop trigger if exists update_age;

delimiter |
create trigger update_age
before insert on assistech.dependente
for each row
begin
	
    if  ( MONTH(curdate()) < MONTH(new.Data_nascimento) or (MONTH(curdate()) >= MONTH(new.Data_nascimento) ) and DAY(curdate()) < DAY(New.Data_nascimento)) then
		set new.Idade = ((YEAR(curdate())) - YEAR(new.Data_nascimento))-1;
	elseif ( MONTH(curdate()) >= MONTH(new.Data_nascimento) and DAY(curdate()) >= DAY(new.Data_nascimento) ) then
			set new.Idade = (YEAR(curdate())) - YEAR(new.Data_nascimento);
    end if;
end|


drop trigger if exists upd_num_func_ins;
#author: José Bartolomeu A. D. Neto
#Trigger2.1  Para atualizar   o atributo "Num.Funcionarios" de UNIDADE DE SUPORTE ao Inserir um Funcionário.
delimiter |
create trigger upd_num_func_ins
after insert on assistech.funcionario
for each row
begin
	SET @num_func:=(select Nro_funcionarios from assistech.unidade_de_suporte where Cod=new.CodigoUnidadeDeSuporte);
    UPDATE assistech.unidade_de_suporte SET Nro_funcionarios = @num_func + 1 WHERE  Cod=new.CodigoUnidadeDeSuporte;
end |

drop trigger if exists upd_num_func_del;
#author: José Bartolomeu A. D. Neto
#Trigger2.2  Para atualizar   o atributo "Num.Funcionarios" de UNIDADE DE SUPORTE ao Remover um Funcionário.
delimiter |
create trigger upd_num_func_del
after delete on assistech.funcionario
for each row
begin
	SET @num_func:=(select Nro_funcionarios from assistech.unidade_de_suporte where Cod=old.CodigoUnidadeDeSuporte);
    UPDATE assistech.unidade_de_suporte SET Nro_funcionarios = @num_func - 1 WHERE  Cod=old.CodigoUnidadeDeSuporte;
end |

drop trigger if exists set_dta_devida;
#author: Bartô
#Trigger3.  Para  gerar o valor do atributo "dt_devida" de ORDEM DE SERVICO
delimiter |
create trigger set_dta_devida
before insert on assistech.ordem_servico
for each row
begin
		
        #meses com 30 dias. testado ok.
		IF ( DAY(LAST_DAY(new.Dt_criacao)) = 30 ) AND ( (new.Prazo_em_dias + day(new.Dt_criacao)) > 30 ) then
			set @diferenca := abs(30 - ( new.Prazo_em_dias + day(new.Dt_criacao) ) );   
            set new.Dt_devida = ( CONCAT(YEAR(new.Dt_criacao), '-', MONTH(new.Dt_criacao)+1, '-', @diferenca) );
		ELSEIF ( DAY(LAST_DAY(new.Dt_criacao)) = 30 ) THEN
			set @diferenca := ( new.Prazo_em_dias + day(new.Dt_criacao) );   
            set new.Dt_devida = ( CONCAT(YEAR(new.Dt_criacao), '-',MONTH(new.Dt_criacao), '-',@diferenca) );
        END IF;  
        
        #mes de dezembro, passou de 31, incrementa o ano. testado ok.
        IF ( EXTRACT(MONTH from new.Dt_criacao) = 12 ) AND ( (new.Prazo_em_dias + day(new.Dt_criacao)) > 31 ) then
			set @diferenca := ( abs(31 - ( new.Prazo_em_dias + day(new.Dt_criacao) ) ) );   
			set new.Dt_devida=CONCAT(YEAR(new.Dt_criacao)+1, '-','01', '-',@diferenca); 
        ELSEIF ( EXTRACT(MONTH from new.Dt_criacao) = 12 ) THEN
			set @diferenca := ( new.Prazo_em_dias + day(new.Dt_criacao) );   
			set new.Dt_devida = ( CONCAT(YEAR(new.Dt_criacao), '-','12', '-',@diferenca) );
        END IF;
        
        #meses com 31 dias, exceto dezembro. testado ok.
        IF ( EXTRACT(MONTH from new.Dt_criacao) != 12 ) AND ( DAY(LAST_DAY(new.Dt_criacao))=31 ) AND ( (new.Prazo_em_dias + day(new.Dt_criacao) ) > 31 ) THEN
			set @diferenca := abs(31 - ( new.Prazo_em_dias + day(new.Dt_criacao) ) );   
            set new.Dt_devida = CONCAT(YEAR(new.Dt_criacao), '-',MONTH(new.Dt_criacao)+1, '-',@diferenca);
        ELSEIF ( EXTRACT(MONTH from new.Dt_criacao)!=12 ) AND (DAY(LAST_DAY(new.Dt_criacao))=31) THEN
			set @diferenca := ( new.Prazo_em_dias + day(new.Dt_criacao) );   
            set new.Dt_devida = ( CONCAT(YEAR(new.Dt_criacao), '-',MONTH(new.Dt_criacao), '-',@diferenca) ); 
		END IF;
        
        #ano não-bissexto, fevereiro com 28 dias. testado ok.
        IF (DAY(LAST_DAY(new.Dt_criacao))=28) AND ( (new.Prazo_em_dias + day(new.Dt_criacao)) > 28 ) THEN
			set @diferenca := abs(28 - ( new.Prazo_em_dias + day(new.Dt_criacao) ) );
            set new.Dt_devida = CONCAT(YEAR(new.Dt_criacao), '-','03', '-',@diferenca);
        ELSEIF DAY(LAST_DAY(new.Dt_criacao))=28 THEN 
			set @diferenca := ( new.Prazo_em_dias + day(new.Dt_criacao) );
            set new.Dt_devida = (CONCAT(YEAR(new.Dt_criacao), '-','02', '-',@diferenca));
        END IF;    
        
        #ano bissexto. - Fevereiro tem 29 dias. testado ok.
        IF ( DAY(LAST_DAY(new.Dt_criacao)) = 29 ) AND ( (new.Prazo_em_dias + day(new.Dt_criacao)) > 29 ) THEN
			set @diferenca := abs(29 - ( new.Prazo_em_dias + day(new.Dt_criacao) ) );
            set new.Dt_devida = ( CONCAT(YEAR(new.Dt_criacao), '-','03', '-',@diferenca) );
        ELSEIF ( DAY(LAST_DAY(new.Dt_criacao)) = 29 ) THEN
			set @diferenca := ( new.Prazo_em_dias + day(new.Dt_criacao) );
            set new.Dt_devida = ( CONCAT(YEAR(new.Dt_criacao), '-','02', '-',@diferenca) );
		END IF;    
       
end |

#select abs(7);
#SELECT DAY(LAST_DAY( curdate() )) as DIAS_MES;

#drop trigger upd_num_funcionarios; #show triggers in assistech;