SELECT
tercero.id AS outsourced_id,
tercero.nombre AS outsourced_name,
ABS(tercero_campo.tolerancia_dias1) AS outsourced_tolerance_down,
ABS(tercero_campo.tolerancia_dias2) AS outsourced_tolerance_up,
ped1.fecha_sol AS order_date_request,
ped1.numero AS order_number,
ped1.cantidad AS order_quantity,
ped1.tipo AS order_type,
ped1.um AS order_um,
ped1.valor_unitario AS order_unit_value,
ficha.id AS sheet_id,
ficha.version AS sheet_version,
ficha.cliente AS sheet_client,
ficha.numero AS sheet_number,
ficha.tipo_corte AS sheet_cut_type,
ficha.cantidad AS sheet_guillotine,
ficha.tipo_producto AS sheet_product_type,
pelicula.nombre AS sheet_film,
pelicula_codigo.nombre AS sheet_composite,
ficha_cuanti.calibre AS sheet_caliber,
ficha_cuanti.largo AS sheet_height,
ficha_cuanti.ancho AS sheet_width,
ficha_cuanti.metros AS sheet_meters_roll,
clase_impresion.imprime AS sheet_print,
ficha_diseno.largo_planeado AS sheet_height_planned,
ficha_diseno.cabida_ancho AS sheet_spaces
FROM ped1
INNER JOIN ficha ON ficha.id = ped1.ficha
INNER JOIN ficha_cuanti ON ficha.id = ficha_cuanti.ficha
LEFT OUTER JOIN ficha_diseno ON  ficha.id = ficha_diseno.ficha
INNER JOIN tercero ON ped1.cliente = tercero.id
INNER JOIN tercero_campo ON tercero.id = tercero_campo.tercero
INNER JOIN pelicula ON ficha.pelicula = pelicula.id 
INNER JOIN pelicula_codigo ON ficha.codigo_compuesto = pelicula_codigo.id
INNER JOIN clase_impresion ON clase_impresion.id = ficha.clase_impresion
WHERE ped1.numero > '28311'
ORDER BY ped1.numero ASC

    
    ficha. as sheet_route
    

 SELECT `ped1`.`fecha`, `ped1`.`numero`, `ped1`.`tipo`, `ficha`.`referencia`, `ped1`.`asesor`, `ped1`.`oc`, `condicionpago`.`nombre`, `ped1`.`fecha_sol`, `ped1`.`cantidad`, `forma`.`nombre`, `color`.`nombre`, `ficha`.`tipo_producto`, `ficha`.`tipo_selle`, `ficha`.`modo_impresion`, `ficha`.`micro`, `ficha_diseno`.`cabida_ancho`, `ficha_diseno`.`cabida_largo`, `ficha_diseno`.`largo_planeado`, `vendedor`.`nombre`, `ficha`.`id`, `tercero_campo`.`codigo`, `tercero_campo`.`zona`, `tercero_campo`.`recibe_parciales`, `tercero_campo`.`tolerancia_dias1`, `tercero_campo`.`tolerancia_dias2`, `tercero_campo`.`tolerancia_fecha1`, `tercero_campo`.`tolerancia_fecha2`, `pelicula`.`nombre`, `pelicula_codigo`.`nombre`, `ficha_cuanti`.`molde`, `ficha_cuanti`.`calibre`, `ficha_cuanti`.`largo`, `ficha_cuanti`.`ancho`, `grafilado2`.`nombre`, `ficha_cuanti`.`grafilado`, `ficha_cuanti`.`grafilado_longitud`, `ficha_cuanti`.`grafilado_distancia`, `ficha`.`lengueta`, `ficha_cuanti`.`traslape`, `ficha_cuanti`.`codigo_tipo`, `ficha_cuanti`.`codigo_numero`, `ficha_cuanti`.`traslape_ancho`, `ficha`.`cliente`, `ficha`.`numero`, `ficha`.`sector`, `unidad_medida`.`nombre`, `ficha_cuanti`.`core`, `ficha_cuanti`.`metros`, `ficha_diseno`.`ancho_planeado`, `ficha_cuanti`.`embobinado`, `ficha_cuanti`.`empalmes_rollo`, `ficha_cuanti`.`empalme_cinta`, `ficha_cuanti`.`empalme`, `ficha`.`nivel`, `ficha`.`clase_impresion`, `ped1`.`requiere_iva`, `tercero`.`nit`, `ficha_diseno`.`rodillo`, `ped1`.`valor_unitario`, `ficha_cuanti`.`montaje`, `ficha`.`guillotinado`, `ficha`.`cantidad`, `ficha`.`tipo_corte`, `ficha`.`adhesivo`, `ficha`.`micro1`, `ficha`.`micro2`, `ficha`.`micro3`, `ficha`.`micro4`, `ficha_cuanti`.`peso_rollo`, `ficha_cuanti`.`rombo`, `ficha`.`pestana`, `color_cintilla`.`nombre`, `clase_impresion`.`nombre`, `zona`.`nombre`, `tercero_campo`.`direccion`, `tercero_campo`.`direccion_factura`, `tercero_campo`.`telefono`, `ciudad`.`nombre`, `tercero_campo`.`establecimiento`, `ficha`.`cintilla`, `ped1`.`pedido_anterior`, `ped1`.`repeticion`, `ped1`.`observaciones`, `ficha`.`observaciones`
 FROM   {oj ((((((((((((`ficha` `ficha` INNER JOIN ((((`tercero_campo` `tercero_campo` INNER JOIN `tercero` `tercero` ON `tercero_campo`.`tercero`=`tercero`.`id`) 
 INNER JOIN `zona` `zona` ON `tercero_campo`.`zona`=`zona`.`id`) 
 INNER JOIN `ciudad` `ciudad` ON `tercero_campo`.`pais`=`ciudad`.`id`) 
 INNER JOIN `ped1` `ped1` ON `tercero`.`id`=`ped1`.`cliente`) ON `ficha`.`id`=`ped1`.`ficha`) 
 LEFT OUTER JOIN `ficha_diseno` `ficha_diseno` ON `ficha`.`id`=`ficha_diseno`.`ficha`) 
 INNER JOIN `unidad_medida` `unidad_medida` ON `ficha`.`um`=`unidad_medida`.`id`) 
 INNER JOIN `color` `color` ON `ficha`.`color_pelicula`=`color`.`id`) 
 INNER JOIN `forma` `forma` ON `ficha`.`forma`=`forma`.`id`) 
 INNER JOIN `ficha_cuanti` `ficha_cuanti` ON `ficha`.`id`=`ficha_cuanti`.`ficha`) 
 INNER JOIN `pelicula` `pelicula` ON `ficha`.`pelicula`=`pelicula`.`id`) 
 INNER JOIN `color` `color_cintilla` ON `ficha`.`color_cintilla`=`color_cintilla`.`id`) 
 INNER JOIN `pelicula_codigo` `pelicula_codigo` ON `ficha`.`codigo_compuesto`=`pelicula_codigo`.`id`) 
 LEFT OUTER JOIN `grafilado2` `grafilado2` ON `ficha`.`grafilado2`=`grafilado2`.`id`) 
 INNER JOIN `clase_impresion` `clase_impresion` ON `ficha`.`clase_impresion`=`clase_impresion`.`id`) 
 INNER JOIN `condicionpago` `condicionpago` ON `ped1`.`condicion_pago`=`condicionpago`.`id`) 
 INNER JOIN `tercero` `vendedor` ON `ped1`.`asesor`=`vendedor`.`id`}
 
    
    
SELECT 
numero AS order_number,
um AS order_um,
cantidad AS order_quantity,
valor_unitario AS order_unit_value,
fecha_sol AS order_date_request,
ficha AS sheet_id,
tipo AS order_type
FROM ped1 LIMIT 1