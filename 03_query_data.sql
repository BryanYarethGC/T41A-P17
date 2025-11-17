SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';

CREATE INDEX idx_data_gin ON usuarios USING GIN (data);

SELECT * FROM usuarios
WHERE data @> '{"activo": true}';

--EJERCICIOS RECOMENDADOS

SELECT atributos->>'NOMBRE' as PRODUCTO from productos where atributos->>'CATEGORIA' = 'PAPELERIA';

CREATE INDEX idx_atributos_gin ON productos USING GIN (atributos);

--EJERCICIOS BASICOS
SELECT atributos->>'NOMBRE' as PRODUCTO from productos where atributosH->'COLOR' = 'ROJO';

UPDATE productos SET atributosH=atributosH || 'PESO=>165KG' WHERE id=4;
SELECT atributosH->'PESO' as PESO from productos where id=4;

UPDATE productos SET atributosH= delete(atributosH,'MARCA') where id=2;
SELECT atributosH from productos where id=2;

--EJERCICIOS INTERMEDIOS
SELECT atributos->>'NOMBRE' as PRODUCTO, atributosH from productos WHERE atributosH?'MARCA';

SELECT atributos->>'NOMBRE'as PRODUCTO, atributosH from productos WHERE atributosH->'MARCA' = 'SAMSUNG' and precio>500;

SELECT skeys(atributosH) AS clave, svals(atributosH) AS valor
FROM productos;

SELECT count(*) from productos WHERE atributosH?'COLOR';

--EJERCICIOS AVANZADOS

CREATE INDEX idx_atributosH_gin ON productos USING GIN (atributosH);

SELECT atributosH->'MARCA' as MARCA,count(*) from productos
GROUP BY atributosH->'MARCA';

SELECT
    id,
    hstore_to_json(atributosH) AS atributos_en_jsonb
FROM
    productos;
    
SELECT atributos->>'NOMBRE' as PRODUCTO, atributosH from productos WHERE atributosH?&ARRAY['COLOR','PESO'];


CREATE OR REPLACE FUNCTION resumen(
    info HSTORE,
    info2 JSONB
)
RETURNS TEXT AS $$
BEGIN
    RETURN 
      info2->>'NOMBRE' ||
      ', PESO: '||
      coalesce(info->'PESO',' ')||
      ', COLOR: '||
      coalesce(info->'COLOR',' ')||
      ', MARCA: '||
      coalesce(info->'MARCA',' ');
END;
$$ LANGUAGE plpgsql;

SELECT resumen(atributosH,atributos) from productos;
