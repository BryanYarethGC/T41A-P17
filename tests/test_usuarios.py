import psycopg2
import pytest

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(query):
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()

def test_nombre_ana():
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    print(f'resultado del query: {result}')
    assert result[0][0] == "Ana"

def test_usuario_activo():
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"

def test_edad_juan():
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"

def test_categoria_jsonb():
    result=run_query("SELECT atributos->>'NOMBRE' as PRODUCTO from productos where atributos->>'CATEGORIA' = 'PAPELERIA';")
    productos={row[0] for row in result}
    assert "LIBRETA" in productos
    assert "LAPIZ" in productos
    assert "LIBRO" in productos

def test_color_basico():
    result=run_query("SELECT atributos->>'NOMBRE' as PRODUCTO from productos where atributosH->'COLOR' = 'ROJO';")
    productos={row[0] for row in result}
    assert "LIBRETA" in productos
    assert "RELOJ" in productos

def test_update_basico():
    result=run_query("SELECT atributosH->'PESO' as PESO from productos where id=4;")
    assert result[0][0]=='165KG'

def test_marca_inter():
    result=run_query("SELECT atributos->>'NOMBRE' as PRODUCTO, atributosH from productos WHERE atributosH?'MARCA';")
    productos={row[0] for row in result}
    assert "LIBRETA" in productos
    assert "RELOJ" in productos
    assert "CELULAR" in productos

def test_marcayprecio_inter():
    result=run_query("SELECT atributos->>'NOMBRE'as PRODUCTO, atributosH from productos WHERE atributosH->'MARCA' = 'SAMSUNG' and precio>500;")
    productos={row[0] for row in result}
    assert "RELOJ" in productos
    assert "CELULAR" in productos

def test_keysyvals_inter():
    result=run_query("SELECT skeys(atributosH) AS clave, svals(atributosH) AS valor FROM productos;")
    keys={row[0] for row in result}
    vals={row[1] for row in result}
    assert "MARCA" in keys
    assert "PESO" in keys
    assert "COLOR" in keys
    assert "ROJO" in vals
    assert "SAMSUNG" in vals

def test_contarcolor_inter():
    result=run_query("SELECT count(*) from productos WHERE atributosH?'COLOR';")
    assert result[0][0]==4

def test_groupby_avanz():
    result=run_query("SELECT atributosH->'MARCA' as MARCA,count(*) from productos GROUP BY atributosH->'MARCA';")
    assert result[1][0]=="SAMSUNG"
    assert result[1][1]==2

def test_multclaves_avanz():
    result=run_query("SELECT atributos->>'NOMBRE' as PRODUCTO, atributosH from productos WHERE atributosH?&ARRAY['COLOR','PESO'];")
    productos={row[0] for row in result}
    assert "RELOJ" in productos
    assert "CELULAR" in productos
    assert "LIBRETA" in productos
    assert "LIBRO" in productos

def test_resumen_avanz():
    result=run_query("SELECT resumen(atributosH,atributos) from productos where id=1;")
    assert result[0][0]=="LIBRETA, PESO: 60G, COLOR: ROJO, MARCA: SCRIBE"
