CREATE OR REPLACE FUNCTION gerar_numero(ddd varchar(2), prefixo varchar(2)) --recebe o DDD e o prefixo da operadora escolhida pelo ciente
RETURNS varchar(11) AS $$
	DECLARE
		operadora varchar(2);
		digito text[] := '[0:9]={0,1,2,3,4,5,6,7,8,9}';
-- 		ddd_valido text[] := '[0:26]={68, 82, 96, 92, 71, 85, 61, 27, 
-- 		62, 98, 65, 67, 31, 91, 83, 41, 81, 86, 21, 84, 51, 69, 95, 47, 11, 79, 63}';
		ddd_length integer := 1;
		prefixo_length integer := 2;
		complemento_length integer := 4;
		numero_gerado varchar[] := '{}';
		random_int int;
		flag_loop boolean := true;
	BEGIN
		WHILE flag_loop LOOP
				
-- 			random_int := random() * 27::int;
			numero_gerado := array_append(numero_gerado, ddd); --Insere o DDD
			
			numero_gerado := array_append(numero_gerado, '9'); --Insere o 9 obrigatório
			CASE --Prefixos das operadoras
      			WHEN prefixo = '1'  THEN operadora := '85';
      			WHEN prefixo = '2'  THEN operadora := '15';
				WHEN prefixo = '3'  THEN operadora := '25';
				WHEN prefixo = '4'  THEN operadora := '35';
				WHEN prefixo = '5'  THEN operadora := '45';
				WHEN prefixo = '6'  THEN operadora := '55';
				WHEN prefixo = '7'  THEN operadora := '65';
				WHEN prefixo = '8'  THEN operadora := '95';
				WHEN prefixo = '9'  THEN operadora := '75';
				WHEN prefixo = '10' THEN operadora := '05';
				
    			
			END CASE;
			numero_gerado := array_append(numero_gerado, operadora); --Operadora de acordo com o prefixo
			
			FOR prefixo_i in 1..prefixo_length LOOP
				random_int := random() * 1::int + 1; --retorna o 1 ou 2
				numero_gerado := array_append(numero_gerado, digito[random_int]::varchar);
			END LOOP;
			
			FOR complemento_i in 1..complemento_length LOOP
				random_int := random() * 9::int; --Completa o número com valores aleatórios
				numero_gerado := array_append(numero_gerado, digito[random_int]::varchar);
			END LOOP;
			
			flag_loop := fone_repetido(array_to_string(numero_gerado, ''));
		END LOOP;
		
			RETURN array_to_string(numero_gerado, '');
	END;
$$ LANGUAGE plpgsql;


--Função criada para quebrar o while
create or replace function fone_repetido(novo_numero varchar(11))
returns boolean as $$
begin
	if (select idnumero from chip where idnumero = novo_numero) is not null then
		return true;
	end if;
	
	return false;
end;
$$
language plpgsql;


