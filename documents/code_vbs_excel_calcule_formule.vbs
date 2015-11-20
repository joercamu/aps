Public Function CRound(valor As Variant, Optional uds As Integer = 2) As Variant
    Dim cifra As Variant
    On Local Error Resume Next
    cifra = (10 ^ uds) * (Int(valor / (10 ^ uds)) + 1)
    If Err Then
        Err.Clear
        CRound = 0
    Else
        dif = cifra - valor
        If dif < 50 Then
           CRound = cifra
           Else
           CRound = valor
        End If
    End If
End Function

Private Sub CommandButton1_Click()
ActiveSheet.Protect UserInterfaceOnly:=True

Range("A5:Z5").Value = ""
'conexion
Dim con As New ADODB.Connection
con.Open "DSN=suprapak"
'variables
Dim cont As Integer
Dim numpedido As String
Dim ficha As String
Dim tintas As String
Dim tolerancia As Integer
Dim cintilla As Integer
Dim tipo_pedido As String
Dim largo_planeado As Double
Dim um As String
Dim cabidas As Integer
Dim metros_rollos As Integer

Dim codigo_query As String
Dim codigo_query2 As String
Dim codigo_query3 As String

Dim fila As Integer
fila = 5
'capturo el numero del pedido
numpedido = Range("A2").Value
cont = 1
If numpedido <> "" Then
    If con.State = 1 Then
        'CASO General
        'QUERY CONSULTA
        codigo_query = "SELECT ficha_cuanti.metros, ped1.um, ficha.tipo_corte, ficha.cantidad AS  fcantidad, ped1.fecha, ped1.valor_unitario, ficha.cliente as fcliente, ficha.numero as fnumero,"
        codigo_query = codigo_query & "ped1.numero AS numero_pedido, ped1.fecha_sol, ped1.tipo, pelicula_codigo.nombre as pelicula_nombre,"
        codigo_query = codigo_query & "tercero_campo.establecimiento, ficha_cuanti.ancho, ficha_cuanti.largo, ficha_cuanti.calibre, "
        codigo_query = codigo_query & "tercero_campo.tolerancia_dias2, ped1.cantidad "
        codigo_query = codigo_query & "FROM ped1 "
        codigo_query = codigo_query & "INNER JOIN ficha ON ped1.ficha=ficha.id "
        codigo_query = codigo_query & "INNER JOIN pelicula_codigo ON pelicula_codigo.id=ficha.codigo_compuesto "
        codigo_query = codigo_query & "INNER JOIN tercero_campo ON ped1.cliente=tercero_campo.tercero "
        codigo_query = codigo_query & "INNER JOIN ficha_cuanti ON ficha_cuanti.ficha=ficha.id WHERE ped1.numero= " + numpedido
        
        Dim query As New ADODB.Command
        query.ActiveConnection = con
        query.CommandText = codigo_query
        query.CommandType = adCmdText
        
        Dim rs As ADODB.Recordset
        Set rs = query.Execute
        'CASO Impreso
        'QUERY CONSULTA 2 PARA LAS TINTAS
        codigo_query2 = "SELECT ficha_diseno.largo_planeado, ficha_diseno.rodillo, ficha_diseno.cabida_ancho, ficha_color.color,ficha_color.cara , ficha_color.linea "
        codigo_query2 = codigo_query2 & "FROM ped1 "
        codigo_query2 = codigo_query2 & "INNER JOIN ficha ON ficha.id=ped1.ficha "
        codigo_query2 = codigo_query2 & "INNER JOIN ficha_diseno ON ficha_diseno.ficha=ficha.id "
        codigo_query2 = codigo_query2 & "INNER JOIN ficha_color ON ficha_color.ficha=ficha.id "
        codigo_query2 = codigo_query2 & "WHERE ped1.numero=" + numpedido
        
        Dim query2 As New ADODB.Command
        query2.ActiveConnection = con
        query2.CommandText = codigo_query2
        query2.CommandType = adCmdText
        
        Dim rs2 As ADODB.Recordset
        Set rs2 = query2.Execute
        'CASO CINTILLA
        'QUERY CONSULTA
        codigo_query3 = "SELECT ped1.numero, ficha.id, ficha.cintilla, ficha.color_cintilla, color.nombre "
        codigo_query3 = codigo_query3 & "FROM ped1 "
        codigo_query3 = codigo_query3 & "INNER JOIN ficha ON ped1.ficha=ficha.id "
        codigo_query3 = codigo_query3 & "INNER JOIN color ON color.id=ficha.color_cintilla "
        codigo_query3 = codigo_query3 & "WHERE ped1.numero =" + numpedido

        
        Dim query3 As New ADODB.Command
        query3.ActiveConnection = con
        query3.CommandText = codigo_query3
        query3.CommandType = adCmdText
        
        Dim rs3 As ADODB.Recordset
        Set rs3 = query3.Execute
        
        'VALIDACIONES Y MUESTRA DE DATOS
            If rs.EOF = False Then
                If rs2.EOF = False Then
                    Do While Not rs2.EOF
                        Hoja1.Cells(fila, 8) = rs2("rodillo")
                        Hoja1.Cells(fila, 10) = rs2("cabida_ancho")
                        cabidas = rs2("cabida_ancho")
                        largo_planeado = rs2("largo_planeado")
                        'validacion de tipo de solvente
                            If rs2("linea") = "Base agua" Then
                                tintas = tintas & rs2("cara") & "." & rs2("color") & " {agu}" & " / "
                            ElseIf rs2("linea") = "Base solvente" Then
                                tintas = tintas & rs2("cara") & "." & rs2("color") & " {sol}" & " / "
                            ElseIf rs2("linea") = "UV" Then
                                tintas = tintas & rs2("cara") & "." & rs2("color") & " {UV}" & " / "
                            Else
                                tintas = tintas & rs2("color") & " / "
                            End If
                        rs2.MoveNext
                    Loop
                    Hoja1.Cells(fila, 20) = "46"
                    tipo_pedido = "impreso"
                Else
                    Hoja1.Cells(fila, 20) = "43"
                    Hoja1.Cells(fila, 10) = "1"
                    cabidas = 1
                    tipo_pedido = "transparente"
                End If
                
                'muestra de cintilla
                Do While Not rs3.EOF
                If rs3("cintilla") = "1" Then
                Hoja1.Cells(fila, 15) = rs3("nombre")
                End If
                rs3.MoveNext
                Loop
                
                Do While Not rs.EOF
                    'concateno las tintas encontradas en el select, pero no se muestan aun
                    
                    If cont = 1 Then
                        um = rs("um")
                        'Hoja1.Cells(fila, 4) = rs("fecha")
                        metros_rollos = rs("metros")
                        Hoja1.Cells(fila, 5) = rs("valor_unitario")
                        Hoja1.Cells(fila, 6) = Date
                        ficha = rs("fcliente") & "-" & rs("fnumero")
                        Hoja1.Cells(fila, 7) = ficha
                        '8 rodillo
                        '9 la tinta se imprime despues del ciclo
                        '10 cabida_ancho
                        
                        Hoja1.Cells(fila, 11) = "K" & rs("numero_pedido")
                        Hoja1.Cells(fila, 12) = rs("fecha_sol")
                        Hoja1.Cells(fila, 13) = rs("tipo")
                        Hoja1.Cells(fila, 14) = rs("pelicula_nombre")
                        Hoja1.Cells(fila, 16) = rs("establecimiento")
                        Hoja1.Cells(fila, 17) = rs("ancho")
                        
                        'si es transparente y sellado carte/largo+10 DE LO CONTRARIO no sume nada
                        If (tipo_pedido = "transparente") And (rs("tipo_corte") = "SELLADO") Then
                            Hoja1.Cells(fila, 18) = rs("largo") + 10
                        'Si es impreso cortado y guillotinado
                        ElseIf (tipo_pedido = "impreso") And (rs("tipo_corte") = "CORTADO") And (rs("fcantidad") > 0) Then
                            Hoja1.Cells(fila, 18) = largo_planeado
                        'si es impreso y sellado
                        ElseIf (tipo_pedido = "impreso") And (rs("tipo_corte") = "SELLADO") Then
                            Hoja1.Cells(fila, 18) = largo_planeado
                        ElseIf um = "ROL" Then
                            Hoja1.Cells(fila, 18) = 0
                        Else
                        'si no cumple con las anteriores condiciones
                            Hoja1.Cells(fila, 18) = rs("largo")
                        End If
                        
                        Hoja1.Cells(fila, 19) = rs("calibre")
                        '20 ruta
                        '21 stock sobrante
                        Hoja1.Cells(fila, 22) = rs("cantidad")
                        Hoja1.Cells(fila, 24) = Abs(rs("tolerancia_dias2") / 100)
                        Hoja1.Cells(fila, 23) = rs("cantidad") * (1 + Abs(rs("tolerancia_dias2") / 100))
                        'fila = fila + 1
                        cont = cont + 1
                        
                        If um = "ROL" Then
                            If tipo_pedido = "impreso" Then
                                Hoja1.Cells(fila, 26) = CRound(Int(Round(((Range("W5").Value * metros_rollos) / (0.9)) / cabidas, 1)), 2)
                                
                            ElseIf tipo_pedido = "transparente" Then
                                Hoja1.Cells(fila, 26) = CRound(Int(Round(((Range("W5").Value * metros_rollos) / (0.97)) / cabidas, 1)), 2)
                            End If
                        End If
                    End If
                rs.MoveNext
                Loop
                'muestro las tintas
                Hoja1.Cells(fila, 9) = tintas
                'Range("E5:W5").Copy
            Else
                MsgBox "record_set esta vacio: no hay registros para el pedido: " + numpedido
            End If
        con.Close
    Else
        MsgBox "error conexion"
    End If
Else
        MsgBox "Pedido vacio"

End If

Range("Y5").FormulaLocal = "=W5-U5"
ActiveSheet.Protect UserInterfaceOnly:=False
If um = "ROL" Then
    Range("E5:Z5").Copy
Else
    Range("E5:X5").Copy
End If
End Sub

