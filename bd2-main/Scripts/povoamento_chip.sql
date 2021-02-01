--Gera números aleatórios para povoar chip
DO $$
DECLARE
ddd text[] := '[0:25]={68, 82, 96, 92, 71, 85, 61, 27, 62, 98, 65, 67, 31, 83, 41, 81, 86, 21, 84, 51, 69, 95, 47, 11, 79, 63}';
random_i integer;
BEGIN
	FOR i_op IN 1..10 LOOP
		FOR j IN 1..100 LOOP
			random_i := floor(random() * 25::int);
			insert into chip values (gerar_numero(ddd[random_i],i_op::char), i_op, floor(random() * 11::int + 1));
		END LOOP;
	END LOOP;
END$$;