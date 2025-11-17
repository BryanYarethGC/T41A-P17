DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 1 AND data->>'nombre' = 'Ana'
  ) THEN
    RAISE NOTICE 'OK: nombre correcto para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: nombre incorrecto para id 1';
  END IF;

  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 1 AND data->>'activo' = 'true'
  ) THEN
    RAISE NOTICE 'OK: usuario activo para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: usuario no está activo para id 1';
  END IF;

  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 2 AND data->>'edad' = '25'
  ) THEN
    RAISE NOTICE 'OK: edad correcta para id 2';
  ELSE
    RAISE EXCEPTION 'Fallo: edad incorrecta para id 2';
  END IF;
END;
$$;

--EJERCICIO

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM productos WHERE id = 1 AND atributos->>'COLOR' = 'ROJO'
  ) THEN
    RAISE NOTICE 'OK: color correcto para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: color incorrecto para id 1';
  END IF;

  IF EXISTS (
    SELECT 1 FROM productos WHERE id = 1 AND atributos->>'CATEGORIA' = 'PAPELERIA'
  ) THEN
    RAISE NOTICE 'OK: categoria correcta para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: categoria incorrecta para id 1';
  END IF;

  IF EXISTS (
    SELECT 1 FROM productos WHERE id = 2 AND atributos->>'TAMANO' = 'PEQUENO'
  ) THEN
    RAISE NOTICE 'OK: tamaño correcto para id 2';
  ELSE
    RAISE EXCEPTION 'Fallo: tamaño incorrecto para id 2';
  END IF;
END;
$$;
