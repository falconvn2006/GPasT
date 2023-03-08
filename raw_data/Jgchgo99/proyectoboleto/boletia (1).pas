program programafac;
uses crt;
var
 opcion:char;
 respuesta:Integer;
 cedula:string;
 NOMBRE:String;
 boletos: Integer;
 tipos: integer;
 preciot: real;
 viaje: integer;
 ticket: integer;
 linea: integer;
 subestacion: Char;
 i: integer;
 llegada, salida: integer;
 salidat, llegadat : string;
 pasaje: string;
 comprar : integer;
 monto: real;
 cambio: real;
 menu, usar: integer;
 viajes, cedula2: string;
 bolet: integer;


begin

  clrscr();
  textColor(04));
  writeln('//////////////////////////////////////////////');
  delay(2));
  Writeln()'     BIENVENIDOS AL METRO DE CARACAS   ');
  writeln();
  writeln('   -----------------------------------  ');

  textColor(14));
  Writeln ('        RIF-40000000000     '));
  writeln ();
  writeln('/////////////////////////////////////'));
  writeln ('INDIQUE QUE DESEA HACER');
  writeln ('1 COMPRAR BOLETO');
  Writeln ('2  SALIR ');
  readln (respuesta);

  if respuesta= 1 then

   begin
    writeln(' -----------------------------------  ');
    writeln ('  INGRESE SU NUMERO DE CEDULA');
    readln(cedula);
    writeln ('  INGRESE SU NOMBBRE');
    readln(NOMBRE);
    writeln ('-----------------------------------');
    writeln ('¨CUANTOS BOLETOS DESEAS COMPRAR?');
    readln(boletos);
    clrscr();
    writeln(' ---------------------------------  ');
    writeln(' CEDULA:  ', cedula);
    writeln(' NOMBRE:  ', nombre);
    writeln ('---------------------------------  ');
    textColor(15);

    writeln ('---------------------------------------------------------------------------------------------------');
    writeln ('|                                    BOLETERIA DISPONIBLE                                         |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|       BOLETOS                      |           COLOR        |           COBERTURA               |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    a. SIMPLE                       |         AMARILLO       |      1 VIAJE EN EL METRO          |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    b. INTEGRADO                    |         AMARILLO       |      1 VIAJE EN METRO             |');
    writeln ('|                                    |                        |      1 VIEJE EN METROBUS          |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    c. IDA Y VUELTA                 |         AMARILLO       |      2 VIAJES EN METRO            |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    d. IDA Y VUELTA INTREGRADO      |         AMARILLO       |      2 VIAJES EN METRO            |');
    writeln ('|                                    |                        |      2 VIAJES EN METROBUS         |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    e. MULTIABONO                   |         NARANJA        |      10 VIAJES EN METROBUS        |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    f. MULTIABONO INTEGRADO         |         NARANJA        |      10 VIAJES EN METRO           |');
    writeln ('|                                    |                        |      10 VIAJES EN METROBUS        |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    g. ESTUDIANTIL SIMPLE           |         AZUL           |      10 VIAJES EN METRO           |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    h. ESTUDIANTIL INTEGRADO        |         AZUL           |      10 VIAJES EN METRO           |');
    writeln ('|                                    |                        |      20 VIAJES EN METROBUS        |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    i. METROTARJETA                 |         ROJO           |      20 VIAJES                    |');
    writeln ('|                                    |                        |      30 VIAJES                    |');
    writeln ('|                                    |                        |      40 VIAJES                    |');
    writeln ('|-------------------------------------------------------------------------------------------------|');
    writeln ('|    j. METROTARJETA INTEGRADA       |         ROJO           |      20 VIAJES (METRO Y METROBUS) |');
    writeln ('|                                    |                        |      30 VIAJES (METRO Y METROBUS) |');
    writeln ('|                                    |                        |      40 VIAJES (METRO Y METROBUS) |');
    writeln ('---------------------------------------------------------------------------------------------------');
    writeln ();

    writeln ('Indique la opcion de boleto que Desea');
    readln(opcion);

    case opcion of

    'a':
        begin
	writeln (' -------------------------------------------------------------------');
        writeln ('|  a. BOLETO SIMPLE    |      AMARILLO     |      1 VIAJE EN METRO  |');
        writeln ('|  PRECIO DEL BOLETO: 2,00 BS                                       |');
        preciot:= ( 2.00 * boletos);
        write   ('| PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        Ticket:= (01);
        writeln ('--------------------------------------------------------------------');
        writeln ('PROCESANDO....');
        pasaje:= ('a. BOLETO SIMPLE  | AMARILLO  |    1 VIAJE EN METRO');
        viajes := ('VIAJES EN METRO');
	end;

      'b':
  	begin
	writeln ('----------------------------------------------------------------------------');
    	writeln ('|  b. INTEGRADO    |   AMARILLO   | 1 VIAJE EN METRO | 1 VIAJE EN METROBUS  |');
        writeln ('|  PRECIO DEL BOLETO: 4,00 BS                                              |');
        writeln ('----------------------------------------------------------------------------');
        writeln ('INDIQUE SI DESEA VIAJAR EN: ');
        writeln ('1. METRO');
        writeln ('2.METROBUS');
        readln (viaje);
        writeln ('-----------------------------------------------------------');

        if viaje = 1 then

         begin
          writeln ('HA SELECCIONADO VIAJE EN METRO');
          viajes := ('VIAJE EN METRO');
          writeln ('|  B. INTEGRADO   |   AMARILLO  |  1 VIAJE EN METRO  |');
          pasaje := 'b. INTEGRADO   |   AMARILLO  |  1 VIAJE EN METRO  |';
         end
        else if viaje = 2 then
         begin
           writeln ('HA SELECCIONADO VIAJE EN METROBUS');
           viajes := ('VIAJE EN METROBUS');
           writeln ('|  b. INTEGRADO   |  AMARILLO   |  1 VIAJE EN METROBUS  |');
           pasaje := ('|  b. INTEGRADO   |  AMARILLO   |  1 VIAJE EN METROBUS  |');
         end
        else
         begin
         writeln ('Opcion incorrecta, cerrando...');
         end;
        writeln ('-----------------------------------------------------------');
        writeln ('FACTURACIàN');
        writeln ('PRECIO DEL BOLETO: 4,00 BS');

        preciot:= ( 4.00 * boletos);
        write ('PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        ticket:= (01);
    	writeln ('-----------------------------------------------------------------------------------------------------');
        delay (2500);
	end;

      'c':
	begin
	writeln ('-------------------------------------------------------------------------');
    	writeln(' c. IDA Y VUELTA  |   AMARILLO   |   2 VIAJES EN METRO');
    	writeln ('-------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 3,00 BS                                            |');
        preciot:= ( 3.00 * boletos);
        write   ('| PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        Ticket:= (01);
        writeln ('-------------------------------------------------------------------------');
        writeln ('PROCESANDO....');
        pasaje:= ('c. IDA Y VUELTA  |  AMARILLO  |  2 VIAJES EN METRO  |');
        viajes := ('VIAJES EN METRO');
        delay (2500);
        end;

     'd':
	begin
	writeln ('--------------------------------------------------------------------------------------------');
    	writeln('|  d.IDA Y VUELTA INTEGRADO   |    AMARILLO  | 2 VIAJES EN METRO  | 2 VIAJES EN METROBUS    |');
    	writeln ('--------------------------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 6,00 BS                                              |');
        writeln ('INDIQUE SI DESEA VIAJAR EN: ');
        writeln ('1. METRO');
        writeln ('2.METROBUS');
        readln (viaje);
        writeln ('-----------------------------------------------------------');

        if viaje = 1 then

         begin
          writeln ('HA SELECCIONADO VIAJE EN METRO');
          viajes := ('VIAJE EN METRO');
          writeln ('|  d.IDA Y VUELTA INTEGRADO   |    AMARILLO  |  2 VIAJES EN METRO   |');
          pasaje := ' d. IDA Y VUELTA INTEGRADO   |    AMARILLO  |  2 VIAJE EN METRO  |';
         end
        else if viaje = 2 then
         begin
           writeln ('HA SELECCIONADO VIAJE EN METROBUS');
           viajes := ('VIAJE EN METROBUS');
           writeln ('| d.IDA Y VUELTA INTEGRADO   |    AMARILLO  | 2 VIAJES EN METROBUS  |');
           pasaje := ('|  d.IDA Y VUELTA INTEGRADO   |    AMARILLO  | 2 VIAJES EN METROBUS  |');
         end
        else
         begin
         writeln ('Opcion incorrecta, cerrando...');
         end;
        writeln ('-----------------------------------------------------------');
        writeln ('FACTURACIàN');
        writeln ('PRECIO DEL BOLETO: 6,00 BS');

        preciot:= ( 6.00 * boletos);
        write ('PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        writeln ('PROCESANDO...');
        ticket:= (01);
    	writeln ('-----------------------------------------------------------------------------');
        delay (2500);
	end;

     'e':
	begin
	writeln ('------------------------------------------------------------------------------------------------');
    	writeln('| e. MULTIABONO  |   NARANJA   |   10 VIAJES EN METRO   |');
    	writeln ('------------------------------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 8,00 BS                             |');
        preciot:= ( 8.00 * boletos);
        write   ('| PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        Ticket:= (01);
        writeln ('------------------------------------------------------------------------------------------------');
        writeln ('PROCESANDO....');
        pasaje:= ('|  e. MULTIABONO  |  NARANJA  |   10 VIAJES EN METRO');
        viajes := ('VIAJES EN METRO');
        delay (2500);
	end;

      'f':
	begin
	writeln ('-------------------------------------------------------------------------------------------------');
    	writeln('|  f.MULTIABONO INTEGRADO   |    NARANJA  |    10 VIAJES EN METROBUS    | 10 VIAJES EN METRO      |');
    	writeln ('-------------------------------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 11,00 BS                                                                   |');
        writeln ('INDIQUE SI DESEA VIAJAR EN: ');
        writeln ('1. METRO');
        writeln ('2.METROBUS');
        readln (viaje);
        writeln ('-------------------------------------------------------------------------------------------------');

        if viaje = 1 then

         begin
          writeln ('HA SELECCIONADO VIAJE EN METRO');
          viajes := ('VIAJE EN METRO');
          writeln ('|  f.MULTIABONO INTEGRADO   |    NARANJA  |  10 VIAJES EN METRO     |');
          pasaje := ('|  f.MULTIABONO INTEGRADO   |    NARANJA  |  10 VIAJES EN METRO  |');
         end
        else if viaje = 2 then
         begin
           writeln ('HA SELECCIONADO VIAJE EN METROBUS');
           viajes := ('VIAJE EN METROBUS');
           writeln ('|  f.MULTIABONO INTEGRADO   |    NARANJA   |   10 VIAJES EN METROBUS   |');
           pasaje := ('| f.MULTIABONO INTEGRADO   |    NARANJA   |   10 VIAJES EN METROBUS   |');
         end
        else
         begin
         writeln ('Opcion incorrecta, cerrando...');
         end;
        writeln ('-----------------------------------------------------------');
        writeln ('FACTURACIàN');
        writeln ('PRECIO DEL BOLETO: 11,00 BS');

        preciot:= ( 11.00 * boletos);
        write ('PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        writeln ('PROCESANDO...');
        ticket:= (01);
    	writeln ('-----------------------------------------------------------------------------');
        delay (2500);
	end;

     'g':
	begin
	writeln ('-------------------------------------------------------------');
    	writeln('|  g. ESTUDIANTIL SIMPLE  |  AZUL   |   10 VIAJES EN METRO    |');
    	writeln ('-------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 9,00 BS                             |');
        preciot:= ( 9.00 * boletos);
        write   ('| PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        Ticket:= (01);
        writeln ('----------------------------------------------------------');
        writeln ('PROCESANDO....');
        pasaje:= ('|  g. ESTUDIANTIL SIMPLE  |  AZUL   |   10 VIAJES EN METRO  |');
        viajes := ('VIAJES EN METRO');
        delay (2500);
        end;

      'h':
	begin
	writeln ('----------------------------------------------------------------------------------------------------');
    	writeln('| h. ESTUDIANTIL INTEGRADO   |     AZUL    |    10 VIAJES EN METRO    |      20 VIAJES EN METROBUS   |');
    	writeln ('-----------------------------------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 13,00 BS                                                                   |');
        writeln ('INDIQUE SI DESEA VIAJAR EN: ');
        writeln ('1. METRO');
        writeln ('2.METROBUS');
        readln (viaje);
        writeln ('---------------------------------------------------------------------------');

        if viaje = 1 then

         begin
          writeln ('HA SELECCIONADO VIAJE EN METRO');
          viajes := ('VIAJE EN METRO');
          writeln ('|  h. ESTUDIANTIL INTEGRADO   |     AZUL    |    10 VIAJES EN METRO      |');
          pasaje := ('  h. ESTUDIANTIL INTEGRADO   |     AZUL    |    10 VIAJES EN METRO  ');
         end
        else if viaje = 2 then
         begin
           writeln ('HA SELECCIONADO VIAJE EN METROBUS');
           viajes := ('VIAJE EN METROBUS');
           writeln ('|  h. ESTUDIANTIL INTEGRADO   |     AZUL    |   20 VIAJES EN METROBUS   |');
           pasaje := ('| h. ESTUDIANTIL INTEGRADO   |     AZUL    |   20 VIAJES EN METROBUS   |');
         end
        else
         begin
         writeln ('Opcion incorrecta, cerrando...');
         end;
        writeln ('----------------------------------------------------------------------------');
        writeln ('FACTURACIàN');
        writeln ('PRECIO DEL BOLETO: 13,00 BS');

        preciot:= ( 13.00 * boletos);
        write ('PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        writeln ('PROCESANDO...');
        ticket:= (01);
    	writeln ('-----------------------------------------------------------------------------');
        delay (2500);
	end;

      'i':
	begin
	writeln ('----------------------------------------------------------------------------------------------------');
    	writeln('| i.METROTARJETA  |   ROJO  |   20 VIAJES  |   3O VIAJES   |   40 VIAJES');
    	writeln ('-----------------------------------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 20,00 BS                                                                   |');
        writeln ('INDIQUE SI DESEA: ');
        writeln ('1. 20 VIAJES');
        writeln ('2. 30 VIAJES');
        writeln ('3. 40 VIAJES');
        readln (viaje);
        writeln ('---------------------------------------------------------------------------');

        if viaje = 1 then

         begin
          writeln ('HA SELECCIONADO 20 VIAJES');
          viajes := ('20 VIAJES');
          writeln ('|  i.METROTARJETA  |   ROJO  |   20 VIAJES    |');
          pasaje := ('  i.METROTARJETA  |   ROJO  |   20 VIAJES   ');
         end
        else if viaje = 2 then
         begin
           writeln ('HA SELECCIONADO 30 VIAJES');
           viajes := ('30 VIAJES');
           writeln ('|  i.METROTARJETA  |   ROJO  |   30 VIAJES    |');
           pasaje := ('| i.METROTARJETA  |   ROJO  |   30 VIAJES    |');
         end
         else if viaje = 3 then
          begin
           writeln ('HA SELECCIONADO 40 VIAJES');
           viajes := ('40 VIAJES');
           writeln ('|  i.METROTARJETA  |   ROJO  |   40 VIAJES    |');
           pasaje := ('| i.METROTARJETA  |   ROJO  |   40 VIAJES    |');
           end

        else
         begin
         writeln ('Opcion incorrecta, cerrando...');
         end;
        writeln ('----------------------------------------------------------------------------');
        writeln ('FACTURACIàN');
        writeln ('PRECIO DEL BOLETO: 20,00 BS');

        preciot:= ( 20.00 * boletos);
        write ('PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        writeln ('PROCESANDO...');
        ticket:= (01);
    	writeln ('-----------------------------------------------------------------------------');
        delay (2500);
	end;

      'j':
	begin
	writeln ('--------------------------------------------------------------------------------------------------------------------------------');
    	writeln('| j. METROTARJETA INTEGRADA | ROJO | 20 VIAJES (METRO Y METROBUS)  |  30 VIAJES (METRO Y METROBUS)  | 40 VAJES (METRO Y METROBUS)');
    	writeln ('--------------------------------------------------------------------------------------------------------------------------------');
        writeln ('|  PRECIO DEL BOLETO: 30,00 BS                                                                   |');
        writeln ('INDIQUE SI DESEA: ');
        writeln ('1. 20 VIAJES');
        writeln ('2. 30 VIAJES');
        writeln ('3. 40 VIAJES');
        readln (viaje);
        writeln ('---------------------------------------------------------------------------');

        if viaje = 1 then

         begin
          writeln ('HA SELECCIONADO 20 VIAJES (METRO Y METROBUS)');
          viajes := ('20 VIAJES');
          writeln ('|  j.METROTARJETA INTEGRADA  |   ROJO  |   20 VIAJES (METRO Y METROBUS)   |');
          pasaje := ('  j.METROTARJETA INTEGRADA  |   ROJO  |   20 VIAJES (METRO Y METROBUS) ');
         end
        else if viaje = 2 then
         begin
           writeln ('HA SELECCIONADO 30 VIAJES');
           viajes := ('30 VIAJES');
           writeln ('|  j.METROTARJETA  |   ROJO  |   30 VIAJES  (METRO Y METROBUS) |');
           pasaje := ('| j.METROTARJETA  |   ROJO  |   30 VIAJES  (METRO Y METROBUS) |');
         end
         else if viaje = 3 then
          begin
           writeln ('HA SELECCIONADO 40 VIAJES');
           viajes := ('40 VIAJES');
           writeln ('|  j.METROTARJETA INTEGRADA  |   ROJO  |   40 VIAJES (METRO Y METROBUS)   |');
           pasaje := ('| j.METROTARJETA INTEGRADA  |   ROJO  |   40 VIAJES (METRO Y METROBUS)  |');
           end

        else
         begin
         writeln ('Opcion incorrecta, cerrando...');
         end;
        writeln ('----------------------------------------------------------------------------');
        writeln ('FACTURACIàN');
        writeln ('PRECIO DEL BOLETO: 30,00 BS');

        preciot:= ( 30.00 * boletos);
        write ('PRECIO TOTAL A PAGAR: ', preciot:5:2);
        writeln (' BS');
        writeln ('PROCESANDO...');
        ticket:= (01);
    	writeln ('-----------------------------------------------------------------------------');
        delay (2500);


	end

      else
	begin
	writeln('CERRANDO DATO INCORRECTO');
        end
      end;

      delay(2500);
      clrscr();
      writeln('CEDULA:  ', cedula);
      writeln('NOMBRE:  ', nombre);
      writeln('BOLETOS:  ', boletos);
      writeln ('TIPO DE BOLETO: ',pasaje);

      if ticket = 01 then

       begin
        writeln ('----------------------------------------------------------------------------------------------------');
        writeln ('LINEAS DISPONIBLE');
        writeln ('----------------------------------------------------------------------------------------------------');

        textColor(14);

        writeln ('LINEA 1 ');
        writeln (' ----------------------------------------------------------------------------');
        writeln ('| PROPATRIA       - CAPITOLIO          - PLAZA VENEZUELA   - MIRANDA         |');
        writeln ('| PEREZ BONALDE   - LA HOYADA          - SABANA GRANDE     - LOS DOS CAMINOS |');
        writeln ('| PLAZA SUCRE     - PARQUE CARABOBO    - CHACAITO          - LOS CORTIJOS    |');
        writeln ('| GATO NEGRO      - BELLAS ARTES       - CHACAO            - LA CALIFORNIA   |');
        writeln ('| AGUA SALUL      - COLEGIO DE ING     - ALTAMIRA          - PETARE          |');
        writeln ('| CA¥O AMRILLO                                             - PALO VERDE      |');
        writeln (' ----------------------------------------------------------------------------');

        writeln ();
        writeln ('LINEA 2 ');
        writeln (' -----------------------------------------------------------------');
        writeln ('| EL SILECIO      - LA PAZ          - MAMERA                      |');
        writeln ('| CAPUCHINO       - LA YAGUARA      - CARICUAO                    |');
        writeln ('| MATERNIDAD      - CAREPITA        - ZOOLOGICO                   |');
        writeln ('| ANTIGUAS        - ANTIMANO        - RUIZ PINEDA / LAS ADJUNTAS  |');
        writeln (' -----------------------------------------------------------------');

        writeln ();
        writeln ('LINEA 3 ');
        writeln (' -----------------------------------------------------------------');
        writeln ('| PLAZA VENEZUELA         - LA BANDERA      - COCHE               |');
        writeln ('| CIUDAD UNIVERSITARIA    - MERCADO         - EL VALLE            |');
        writeln ('| LOS SIMBOLOS            - LOS JARDINES    - LA RINCONADA        |');
        writeln (' -----------------------------------------------------------------');

        writeln();
        writeln ('LINEA 4 ');
        writeln (' ---------------------------------------------------------------------');
        writeln ('| ZONA RENTAL     - MATERNIDAD         - ANTIMANO                     |');
        writeln ('| PARQUE CENTAL   - ARTIGAS            - MAMERA                       |');
        writeln ('| NUEVO CIRCO     - LA PAZ             -RUIZ PINEDA / LAS ADJUNTAS    |');
        writeln ('| TEATROS         - LA YARAGUA                                        |');
        writeln ('| CAPUCHINOS      - CARAPITA                                          |');
        writeln (' ---------------------------------------------------------------------');

        writeln();
        writeln ('LINEA 5 ');
        writeln (' ----------------------------------------------------------------------------');
        writeln ('| BELLO MONTE            - BELLO CAMPO        - BOLEITA                      |');
        writeln ('| LAS MERCEDES           - HUGO CHAVEZ        - EL MARQUEZ                   |');
        writeln ('| PARQUE SIMON BOLIVAR   - MONTECRISTO        - WARAIRAREPANO                |');
        writeln (' ----------------------------------------------------------------------------');

        writeln();
        writeln ('LINEA 6 ');
        writeln (' ------------------------------------------');
        writeln ('| ZOOLOGICO       - LA RINCONADA           |');
        writeln (' ------------------------------------------');

        writeln();
        writeln ('LINEA 7 ');
        writeln (' ----------------------------------------------------------------');
        writeln ('| LAS FLORES        - EL CRISTO            - ROOSEVELT           |');
        writeln ('| PANTEON           - ROCA TARPEYA         - LA BANDERA          |');
        writeln ('| SOCORRO           - PRESIDENTE MEDINA    - LOS ILUSTRE         |');
        writeln ('| LA HOYADA         - INCES                                      |');
        writeln (' ----------------------------------------------------------------');

        writeln();
        writeln ('CABLETREN 8 ');
        writeln (' -----------------------------------------------------------------------');
        writeln ('| PETRARE 2            - 5 DE JULIO        - WARAIRAREPANO              |');
        writeln ('| 19 DE ABRIL          - 24 DE JULIO                                    |');
        writeln (' -----------------------------------------------------------------------');


        textColor(15);
        writeln ();
        writeln ('INDIQUE LA LINEA DE VIAJE');
        readln (linea);
        writeln ('---------------------------');
        writeln ('PROCESANDO....');
        delay(2500);
        clrscr();

        case linea of

           1:
            begin

              writeln('Usted selecciono LINEA 1');
              writeln (' ---------------------------------------------------------------------------------');
              writeln ('| a. - PROPATRIA       - CAPITOLIO          - PLAZA VENEZUELA   - MIRANDA         |');
              writeln ('| b. - PEREZ BONALDE   - LA HOYADA          - SABANA GRANDE     - LOS DOS CAMINOS |');
              writeln ('| c. - PLAZA SUCRE     - PARQUE CARABOBO    - CHACAITO          - LOS CORTIJOS    |');
              writeln ('| d. - GATO NEGRO      - BELLAS ARTES       - CHACAO            - LA CALIFORNIA   |');
              writeln ('| e. - AGUA SALUL      - COLEGIO DE ING     - ALTAMIRA          - PETARE          |');
              writeln ('| f. - CA¥O AMRILLO                                             - PALO VERDE      |');
              writeln (' ---------------------------------------------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := 02;


                   writeln (' LINEA 1 - SUBESTACION A');
                   writeln (' ------------------------------------------------------------------------');
                   writeln ('|  1 - PROPATRIA    2 - CAPITOLIO    3 - PLAZA VENEZUELA  4  - MIRANDA   |');
                   writeln (' ------------------------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PROPATRIA');
                        salidat := 'PROPATRIA';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: CAPITOLIO');
                           salidat := 'CAPITLIO';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: PLAZA VENEZUELA');
                              salidat := ('PLAZA VENEZUELA');
                             end

                           else if salida = 4 then

                             begin
                              writeln ('SALIDA: MIRANDA');
                              salidat := ('MIRANDA');
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PROPATRIA');
                       llegadat:= ('PROPATRIA');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: CAPITOLIO ');
                         llegadat := ('CAPITOLIO');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: PLAZA VENEZUELA');
                            llegadat := ('PLAZA VENEZUELA');
                            end

                              else if llegada = 4 then

                              begin
                              writeln ('LLEGADA: MIRANDA');
                              llegadat := ('MIRANDA');
                              end
                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin
                   writeln ('LINEA 1 - SUBESTACONES B');

                   ticket := 02;
                   writeln ('-------------------------------------------------------------------------------');
                   writeln (' 1 - PEREZ BONALDE    2 - LA HOYADA    3 - SABANA GRANDE  4 - LOS DOS CAMINOS  |');
                   writeln ('-------------------------------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PEREZ BONALDE');
                        salidat := ('PEREZ BONLADE');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA HOYADA');
                           salidat := ('LA HOYADA');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: SABANA GRANDE');
                              salidat := ('SABANA GRANDE');
                             end

                           else if salida = 4 then

                             begin
                              writeln ('SALIDA: LOS DOS CAMINOS');
                              salidat := ('LOS DOS CAMINOS');
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PEREZ BONALDE');
                       llegadat:= ('PEREZ BONALDE');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA HOYADA ');
                         llegadat := ('LA HOYADA');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: SABANA GRANDE');
                            llegadat := ('SABANA GRANDE');
                            end

                              else if llegada = 4 then

                              begin
                              writeln ('LLEGADA: LOS DOS CAMINOS');
                              llegadat := ('LOS DOS CAMINOS');
                              end
                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                     end;

                   'c':
                      begin
                          writeln ('LINEA 1 - SUBESTACONES C');
                          ticket := (02);
                          writeln ('---------------------------------------------------------------------------');
                          writeln (' 1 - PLAZA SUCRE    2 - PARQUE CARABOBO    3 - CHACAITO  4 - LOS CORTIJOS  |');
                          writeln ('---------------------------------------------------------------------------');
                          writeln ('INGRESE ESTACION DE SALIDA');
                          readln(salida);

                          if salida = 1 then

                            begin
                            writeln ('SALIDA: PLAZA SUCRE');
                            salidat := ('PLAZA SUCRE');
                            end

                            else if salida = 2 then

                              begin
                              writeln ('SALIDA: PARQUE CARABOBO');
                              salidat := ('PARQUE CARABOBO');
                              end

                              else if salida = 3 then

                                begin
                                writeln ('SALIDA: CHACAITO');
                                salidat := ('CHACAITO');
                                end

                                  else if salida = 4 then

                                   begin
                                   writeln ('SALIDA: LOS CORTIJOS');
                                   salidat := ('LOS CORTIJOS');
                                   end

                          else

                            begin
                            writeln('DATO INCORRECTO...');
                            end;

                          writeln('INGRESE LA SUBESTACION DE LLEGADA');
                          readln (llegada);

                          if llegada = 1 then

                             begin
                             writeln ('LLEGADA: PLAZA SUCRE');
                             llegadat:= ('PLAZA SUCRE');
                             end

                             else if llegada = 2 then

                                begin
                                writeln ('LLEGADA: PARQUE CARABOBO ');
                                llegadat := ('PARQUE CARABOBO');
                                end

                                else if llegada = 3 then

                                  begin
                                  writeln ('LLEGADA: CHACAITO');
                                  llegadat := ('CHACAITO');
                                  end

                                  else if llegada = 4 then

                                    begin
                                    writeln ('LLEGADA: LOS CORTIJOS');
                                    llegadat := ('LOS CORTIJOS');
                                    end
                           else

                            begin
                            writeln ('ERROR CERRANDO');
                           end
                        end;

                    'd':
                      begin

                          writeln ('LINEA 1 - SUBESTACONES D');
                          ticket := (02);
                          writeln ('--------------------------------------------------------------------');
                          writeln (' 1 - GATO NEGRO   2 - BELLAS ARTES   3 - CHACAO  4 - LA CALIFORNIA  |');
                          writeln ('--------------------------------------------------------------------');
                          writeln ('INGRESE ESTACION DE SALIDA');
                          readln(salida);

                          if salida = 1 then

                            begin
                            writeln ('SALIDA: GATO NEGRO');
                            salidat := ('GATO NEGRO');
                            end

                            else if salida = 2 then

                              begin
                              writeln ('SALIDA: BELLAS ARTES');
                              salidat := ('BELLAS ARTES');
                              end

                              else if salida = 3 then

                                begin
                                writeln ('SALIDA: CHACAO');
                                salidat := ('CHACAO');
                                end

                                  else if salida = 4 then

                                   begin
                                   writeln ('SALIDA: LA CALIFORNIA');
                                   salidat := ('LA CALIDORNIA');
                                   end

                          else

                            begin
                            writeln('DATO INCORRECTO...');
                            end;

                          writeln('INGRESE LA SUBESTACION DE LLEGADA');
                          readln (llegada);

                          if llegada = 1 then

                             begin
                             writeln ('LLEGADA: GATO NEGRO');
                             llegadat:= ('GATO NEGRO');
                             end

                             else if llegada = 2 then

                                begin
                                writeln ('LLEGADA: BELLAS ARTES ');
                                llegadat := ('BELLAS ARTES');
                                end

                                else if llegada = 3 then

                                  begin
                                  writeln ('LLEGADA: CHACAO');
                                  llegadat := ('CHACAO');
                                  end

                                  else if llegada = 4 then

                                    begin
                                    writeln ('LLEGADA: LA CALIFORNIA');
                                    llegadat := ('LA CALIFORNIA');
                                    end
                           else

                            begin
                            writeln ('ERROR CERRANDO');
                           end
                        end;

                    'e':
                       begin

                          writeln ('LINEA 1 - SUBESTACONES E');
                          ticket := (02);
                          writeln ('-------------------------------------------------------------------');
                          writeln (' 1 - AGUA SALUD    2 - COLEGIO DE ING    3 - ALTAMIRA  4 - PETARE  |');
                          writeln ('-------------------------------------------------------------------');
                          writeln ('INGRESE ESTACION DE SALIDA');
                          readln(salida);

                          if salida = 1 then

                            begin
                            writeln ('SALIDA: AGUA SALUD');
                            salidat := ('AGUA SALUD');
                            end

                            else if salida = 2 then

                              begin
                              writeln ('SALIDA: COLEGIO DE ING');
                              salidat := ('COLEGIO DE ING');
                              end

                              else if salida = 3 then

                                begin
                                writeln ('SALIDA: ALTAMIRA');
                                salidat := ('ALTAMIRA');
                                end

                                  else if salida = 4 then

                                   begin
                                   writeln ('SALIDA: PETARE');
                                   salidat := ('PETARE');
                                   end

                          else

                            begin
                            writeln('DATO INCORRECTO...');
                            end;

                          writeln('INGRESE LA SUBESTACION DE LLEGADA');
                          readln (llegada);

                          if llegada = 1 then

                             begin
                             writeln ('LLEGADA: AGUA SALUD');
                             llegadat:= ('AGUA SALUD');
                             end

                             else if llegada = 2 then

                                begin
                                writeln ('LLEGADA: COLEGIO DE ING ');
                                llegadat := ('COLEGIO DE ING');
                                end

                                else if llegada = 3 then

                                  begin
                                  writeln ('LLGADA: ALTAMIRA ');
                                  llegadat := ('ALTAMIRA');
                                  end

                                  else if llegada = 4 then

                                    begin
                                    writeln ('LLEGADA: PETARE');
                                    llegadat := ('PETARE');
                                    end
                           else

                            begin
                            writeln ('ERROR CERRANDO');
                           end
                        end;


                    'f':
                       begin

                          writeln ('LINEA 1 - SUBESTACONES F');
                          ticket := (02);
                          writeln ('-------------------------------------');
                          writeln (' 1 - CA¥O AMARILLO   2 - PALO VERDE  |');
                          writeln ('-------------------------------------');
                          writeln ('INGRESE ESTACION DE SALIDA');
                          readln(salida);

                          if salida = 1 then

                            begin
                            writeln ('SALIDA: CA¥O AMARILLO');
                            salidat := ('CA¥O AMARILLO');
                            end

                            else if salida = 2 then

                              begin
                              writeln ('SALIDA: PALO VERDE');
                              salidat := ('PALO VERDE');
                              end

                          else

                            begin
                            writeln('DATO INCORRECTO...');
                            end;

                          writeln('INGRESE LA SUBESTACION DE LLEGADA');
                          readln (llegada);

                          if llegada = 1 then

                             begin
                             writeln ('LLEGADA: CA¥O AMARILLO');
                             llegadat:= ('CA¥O AMARILLO');
                             end

                             else if llegada = 2 then

                                begin
                                writeln ('LLEGADA: PALO VERDE ');
                                llegadat := ('PALO VERDE');
                                end

                           else

                            begin
                            writeln ('ERROR CERRANDO');
                           end


                     end

                end

             end;

           2:
            begin

              writeln ('Usted selecciono LINEA 2');
              writeln (' ----------------------------------------------------------------------');
              writeln ('| a. - EL SILECIO      - LA PAZ          - MAMERA                      |');
              writeln ('| b. - CAPUCHINO       - LA YAGUARA      - CARICUAO                    |');
              writeln ('| c. - MATERNIDAD      - CAREPITA        - ZOOLOGICO                   |');
              writeln ('| d. - ANTIGUAS        - ANTIMANO        - RUIZ PINEDA / LAS ADJUNTAS  |');
              writeln (' ----------------------------------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := (02);

                   writeln (' LINEA 2 - SUBESTACION A');
                   writeln ('---------------------------------------------');
                   writeln (' 1 - EL SILENCIO   2 - LA PAZ   3 - MAMERA   |');
                   writeln ('---------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: EL SILENCIO');
                        salidat := ('EL SILENCIO');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA PAZ');
                           salidat := ('LA PAZ');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: MAMERA');
                              salidat := ('MAMERA)';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: EL SILENCIO');
                       llegadat:= ('EL SILENCIO');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA PAZ');
                         llegadat := ('LA PAZ');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: MAMERA');
                            llegadat := ('MAMERA');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin


                   ticket := (02);

                   writeln (' LINEA 2 - SUBESTACION B');
                   writeln ('--------------------------------------------------');
                   writeln (' 1 - CAPUCHINOS   2 - LA YAGUARA   3 - CARICUAO   |');
                   writeln ('--------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: CAPUCHINOS');
                        salidat := ('CAPUCHINOS');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA YAGUARA');
                           salidat := ('LA YAGUARA');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: CARICUAO');
                              salidat := ('CARICUAO');
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: CAPUCHINOS');
                       llegadat:= ('CAPUCHINOS');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA YAGUARA');
                         llegadat := ('LA YAGURA');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: CARICUAO');
                            llegadat := ('CARICUAO');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'c':
                  begin

                   ticket := (02);

                   writeln (' LINEA 2 - SUBESTACION C');
                   writeln ('-------------------------------------------------');
                   writeln (' 1 - MATERNIDAD   2 - CARAPITA   3 - ZOOLOGICO   |');
                   writeln ('-------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: MATERNIDAD');
                        salidat := ('MATERNIDAD');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: CARAPITA');
                           salidat := ('CARAPITA');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: ZOOLOGICO');
                              salidat := ('ZOOLOGICO');
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: MATERNIDAD');
                       llegadat:= ('MATERNIDAD');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: CARAPITA');
                         llegadat := ('CARAPITA');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: ZOOLOGICO');
                            llegadat := ('ZOOLOGICO');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'd':
                  begin

                   ticket := (02);

                   writeln (' LINEA 2 - SUBESTACION D');
                   writeln ('---------------------------------------------------------------');
                   writeln (' 1 - ARTIGUAS   2 - ANTIMANO   3 - RUIZ PINEDA / LAS ADJUNTAS  |');
                   writeln ('---------------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: ARTIGUAS');
                        salidat := ('ARTIGUAS');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: ANTIMANO');
                           salidat := ('ANTIMANO');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: RUIZ PINEDA / LAS ADJUNTAS');
                              salidat := ('RUIZ PINEDA / LAS ADJUNTAS');
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: ARTIGUAS');
                       llegadat:= ('ARTIGUAS');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: ANTIMANO');
                         llegadat := ('ANTIMANO');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: RUIZ PINEDA / LAS ADJUNTAS');
                            llegadat := ('RUIZ PINEDA / LAS ADJUNTAS');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end

               end

            end;



           3:
            begin
              writeln ('Usted selecciono LINEA 3');

              writeln ('LINEA 3 ');
              writeln (' --------------------------------------------------------------------');
              writeln ('| a. PLAZA VENEZUELA         - LA BANDERA      - COCHE               |');
              writeln ('| b. CIUDAD UNIVERSITARIA    - MERCADO         - EL VALLE            |');
              writeln ('| c. LOS SIMBOLOS            - LOS JARDINES    - LA RINCONADA        |');
              writeln (' --------------------------------------------------------------------');


              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := (02);

                   writeln (' LINEA 3 - SUBESTACION A');
                   writeln ('---------------------------------------------------');
                   writeln (' 1 - PLAZA VENEZUELA   2 - LA BANDERA  3 - COCHE   |');
                   writeln ('---------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PLAZA VENEZUELA');
                        salidat := ('PLAZA VENEZUELA');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA BANDERA');
                           salidat := ('LA BANDERA');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: COCHE');
                              salidat := ('COCHE');
                             end


                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PLAZA VENEZUELA');
                       llegadat:= ('PLAZA VENEZUELA');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA BANDERA ');
                         llegadat := ('LA BANDERA');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: COCHE');
                            llegadat := ('COCHE');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin

                     ticket := (02);

                   writeln (' LINEA 3 - SUBESTACION B');
                   writeln ('---------------------------------------------------------');
                   writeln (' 1 - CIUDAD UNIVERSITARIA   2 - EL VALLE   3 - MERCADO   |');
                   writeln ('---------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: CIUDAD UNIVERSITARIA');
                        salidat := ('CIUDAD UNIVERSITARIA');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: EL VALLE');
                           salidat := ('EL VALLE');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: MERCADO');
                              salidat := ('MERCADO');
                             end


                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: CIUDAD UNIVERSITARIA');
                       llegadat:= ('CIUDAD UNIVERSITARIA');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: EL VALLE ');
                         llegadat := ('EL VALLE');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: MERCADO');
                            llegadat := ('MERCADO');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end


                  end;


               'c':
                  begin


                    ticket := (02);

                   writeln (' LINEA 3 - SUBESTACION C ');
                   writeln ('---------------------------------------------------');
                   writeln (' 1 - PLAZA VENEZUELA   2 - LA BANDERA  3 - COCHE   |');
                   writeln ('---------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PLAZA VENEZUELA');
                        salidat := ('PLAZA VENEZUELA');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA BANDERA');
                           salidat := ('LA BANDERA');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: COCHE');
                              salidat := ('COCHE');
                             end


                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PLAZA VENEZUELA');
                       llegadat:= ('PLAZA VENEZUELA');
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA BANDERA ');
                         llegadat := ('LA BANDERA');
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: COCHE');
                            llegadat := ('COCHE');
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end

               end

            end;

           4:
            begin
              writeln ('Usted selecciono LINEA 4');

              writeln (' --------------------------------------------------------------------------');
              writeln ('| a. - ZONA RENTAL     - MATERNIDAD         - ANTIMANO                     |');
              writeln ('| b. - PARQUE CENTAL   - ARTIGAS            - MAMERA                       |');
              writeln ('| c. - NUEVO CIRCO     - LA PAZ             -RUIZ PINEDA / LAS ADJUNTAS    |');
              writeln ('| d. - TEATROS         - LA YARAGUA                                        |');
              writeln ('| e. - CAPUCHINOS      - CARAPITA                                          |');
              writeln (' --------------------------------------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := (02);

                   writeln (' LINEA 4 - SUBESTACION A');
                   writeln ('----------------------------------------------------');
                   writeln (' 1 - ZONA RENTAL    2 - MATERNIDAD    3 - ANTIMANO  |');
                   writeln ('----------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: ZONA RENTAL');
                        salidat := ('ZONA RENTAL');
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: MATERNIDAD');
                           salidat := ('MATERNIDAD');
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: ANTIMANO');
                              salidat := ('ANTIMANO');
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: ZONA RENTAL');
                       llegadat:= 'ZONA RENTAL';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: MATERNIDAD ');
                         llegadat := 'METERNIDAD';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: ANTIMANO ');
                            llegadat := 'ANTMANO';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin

                   ticket := 02;

                   writeln (' LINEA 4 - SUBESTACION B');
                   writeln ('--------------------------------------------------');
                   writeln (' 1 - PARQUE CENTRAL    2 - ARTIGAS    3 - MAMERA  |');
                   writeln ('--------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PARQUE CENTRAL');
                        salidat := 'PARQUE CENTRAL';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: ARTIGAS');
                           salidat := 'ARTIGAS';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: MAMERA');
                              salidat := 'MAMERA';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PARQUE CENTRAL');
                       llegadat:= 'PARQUE CENTRAL';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: ARTIGAS ');
                         llegadat := 'ARTIGAS';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: MAMERA ');
                            llegadat := 'MAMERA';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'c':
                  begin


                   ticket := 02;

                   writeln (' LINEA 4 - SUBESTACION C');
                   writeln ('------------------------------------------------------------------');
                   writeln (' 1 - NUEVO CIRCO    2 - LA PAZ    3 - RUIZ PINEDA / LAS ADJUNTAS  |');
                   writeln ('------------------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: NUEVO CIRCO');
                        salidat := 'NUEVO CIRCO';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA PAZ');
                           salidat := 'LA PAZ';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: RUIZ PINEDA / LAS ADJUNTAS');
                              salidat := 'RUIZ PINEDA / LAS ADJUNTAS';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: NUEVO CIRCO');
                       llegadat:= 'NUEVO CIRCO';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA PAZ ');
                         llegadat := 'LA PAZ';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: RUIZ PINEDA / LAS ADJUNTAS ');
                            llegadat := 'RUIZ PINEDA / LAS ADJUNTAS';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                  end;


               'd':
                  begin

                      ticket := 02;

                   writeln (' LINEA 4 - SUBESTACIONES D');
                   writeln ('-----------------------------');
                   writeln (' 1 - TEATROS   2 - YARAGUA   |');
                   writeln ('-----------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: TEATROS');
                        salidat := 'TEATROS';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: YARAGUA');
                           salidat := 'YARAGUA';
                           end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: TEATROS');
                       llegadat:= 'TEATROS';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: YARAGUA ');
                         llegadat := 'YARAGUA';
                         end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'e':
                  begin

                    ticket := 02;

                   writeln (' LINEA 4 - SUBESTACIONES E');
                   writeln ('---------------------------------');
                   writeln (' 1 - CAPUCHINOS   2 - CARAPITA   |');
                   writeln ('---------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: CAPUCHINOS');
                        salidat := 'CAPUCHINOS';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: CARAPITA');
                           salidat := 'CARAPITA';
                           end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: CAPUCHINO');
                       llegadat:= 'CAPUCHINO';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: CARAPITA ');
                         llegadat := 'CARAPITA';
                         end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end


                  end

               end

            end;

           5:
            begin

              writeln ('Usted selecciono LINEA 5');

              writeln (' -------------------------------------------------------------------------------');
              writeln ('| a. BELLO MONTE            - BELLO CAMPO        - BOLEITA                      |');
              writeln ('| b. LAS MERCEDES           - HUGO CHAVEZ        - EL MARQUEZ                   |');
              writeln ('| C. PARQUE SIMON BOLIVAR   - MONTECRISTO        - WARAIRAREPANO                |');
              writeln (' -------------------------------------------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := 02;

                   writeln (' LINEA 5 - SUBESTACION A');
                   writeln ('-----------------------------------------------------');
                   writeln (' 1 - BELLO MONTE    2 - BELLO CAMPO    3 - BOLEITA   |');
                   writeln ('-----------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: BELLO MONTE');
                        salidat := 'BELLO MONTE';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: BELLO CAMPO');
                           salidat := 'BELLO CAMPO';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: BOLEITA');
                              salidat := 'BOLEITA';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: BELLO MONTE');
                       llegadat:= 'BELLO MONTE';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: BELLO CAMPO ');
                         llegadat := 'BELLO CAMPO';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: BOLEITA');
                            llegadat := 'BOLEITA';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin

                       ticket := 02;

                   writeln (' LINEA 5 - SUBESTACION B');
                   writeln ('-------------------------------------------------------');
                   writeln (' 1 - LAS MERCEDES   2 - HUGO CHAVEZ   3 - EL MARQUEZ   |');
                   writeln ('-------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: LAS MERCEDES');
                        salidat := 'LAS MERCEDES';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: HUGO CHAVEZ');
                           salidat := 'HUGO CHAVEZ';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: EL MARQUEZ');
                              salidat := 'EL MARQUEZ';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: LAS MAERCEDES');
                       llegadat:= 'LAS MERCEDES';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: HUGO CHAVEZ ');
                         llegadat := 'HUGO CHAVEZ';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: EL MARQUEZ');
                            llegadat := 'EL MARQUEZ';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'c':
                  begin

                       ticket := 02;

                   writeln (' LINEA 5 - SUBESTACION C');
                   writeln ('--------------------------------------------------------------------');
                   writeln (' 1 - PARQUE SIMON BOLIVAR    2 - MONTECRISTO    3 - WARAIRAREPANO   |');
                   writeln ('--------------------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PARQUE SIMON BOLIVAR');
                        salidat := 'PARQUE SIMON BOLIVAR';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: MONTECRISTO');
                           salidat := 'MONTECRISTO';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: WARAIRAREPANO');
                              salidat := 'WARAIRAREPANO';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PARQUE SIMON BOLIVAR');
                       llegadat:= 'PARQUE SIMON BOLIVAR';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: MONTECRISTO ');
                         llegadat := 'MONTECRISTO';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: WARAIRAREPANO');
                            llegadat := 'WARAIRAREPANO';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                   end


               end

            end;

           6:
            begin
              writeln ('Usted selecciono LINEA 6');

              writeln (' ------------------------------------------');
              writeln ('| a. ZOOLOGICO       - LA RINCONADA        |');
              writeln (' ------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := 02;

                   writeln (' LINEA 6 - SUBESTACION A');
                   writeln ('-------------------------------------');
                   writeln (' 1 - ZOOLOGICO    2 - LA RINCONADA   |');
                   writeln ('-------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: ZOOLOGICO');
                        salidat := 'ZOOLOGICO';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: LA RINCONADA');
                           salidat := 'LA RINCONADA';
                           end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: ZOOLOGICO');
                       llegadat:= 'ZOOLOGICO';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: LA RINCONADA ');
                         llegadat := 'LA RINCONADA';
                         end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end

               end

            end;

           7:
            begin
              writeln ('Usted selecciono LINEA 7');

              writeln (' -------------------------------------------------------------------');
              writeln ('| a. LAS FLORES        - EL CRISTO            - ROOSEVELT           |');
              writeln ('| b. PANTEON           - ROCA TARPEYA         - LA BANDERA          |');
              writeln ('| c. SOCORRO           - PRESIDENTE MEDINA    - LOS ILUSTRE         |');
              writeln ('| d. LA HOYADA         - INCES                                      |');
              writeln (' -------------------------------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := 02;

                   writeln (' LINEA 7 - SUBESTACION A');
                   writeln ('----------------------------------------------------');
                   writeln (' 1 - LAS FLORES    2 - EL CRISTO    3 - ROOSEVELT   |');
                   writeln ('----------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: LAS FLORES');
                        salidat := 'LAS FLORES';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: EL CRISTO');
                           salidat := 'EL CRISTO';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: ROOSEVELT');
                              salidat := 'ROOSEVELT';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: LAS FLORES');
                       llegadat:= 'LAS FLORES';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: EL CRISTO ');
                         llegadat := 'EL CRISTO';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: ROOSEVELT');
                            llegadat := 'ROOSEVELT';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin

                   ticket := 02;

                   writeln (' LINEA 7 - SUBESTACION B');
                   writeln ('-----------------------------------------------------');
                   writeln (' 1 - PANTEON    2 - ROCA TARPEYA    3 - LA BANDERA   |');
                   writeln ('-----------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PANTEON');
                        salidat := 'PANTEON';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: ROCA TARPEYA');
                           salidat := 'ROCA TARPEYA';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: LA BANDERA');
                              salidat := 'LA BANDERA';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PANTEON');
                       llegadat:= 'PANTEON';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: ROCA TARPEYA ');
                         llegadat := 'ROCA TARPEYA';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: LA BANDERA');
                            llegadat := 'LA BANDERA';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'c':
                  begin

                    ticket := 02;

                   writeln (' LINEA 7 - SUBESTACION C');
                   writeln ('---------------------------------------------------------');
                   writeln (' 1 - SOCORRO   2 - PRESIDENTE MEDINA   3 - LOS ILUSTRE   |');
                   writeln ('---------------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: SOCORRO');
                        salidat := 'SOCOROO';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: PRESIDENTE MEDINA');
                           salidat := 'PRESIDENTE MEDINA';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: LOS ILUSTRES');
                              salidat := 'LOS ILUSTRES';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: SOCORRO');
                       llegadat:= 'SOCORRO';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: PRESIDENTE MEDINA ');
                         llegadat := 'PRESIDENTE MEDINA';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: LOS ILUSTRES');
                            llegadat := 'LOS ILUSTRES';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end;


               'd':
                  begin

                   ticket := 02;

                   writeln (' LINEA 7 - SUBESTACION D');
                   writeln ('----------------------------');
                   writeln (' 1 - LA HOYADA   2- INCES   |');
                   writeln ('----------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: LA HOYADA');
                        salidat := 'LA HOYADA';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: INCES');
                           salidat := 'INCES';
                           end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: LA HOYADA');
                       llegadat:= 'LA HOYADA';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: INCES ');
                         llegadat := 'INCES';
                         end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end

               end

            end;

           8:
            begin

             writeln ('Usted selecciono CABLETREN 8');

              writeln (' -----------------------------------------------------------------------');
              writeln ('| a. PETRARE 2          - 5 DE JULIO        - WARAIRAREPANO              |');
              writeln ('| b.  19 DE ABRIL       - 24 DE JULIO                                    |');
              writeln (' -----------------------------------------------------------------------');

              writeln ('Seleccione la LINEA DE SUBESTACIONES');
              readln  (subestacion);

              case subestacion of


               'a':
                  begin

                   ticket := 02;

                   writeln (' CABLETREN 8 - SUBESTACION A');
                   writeln ('-----------------------------------------------------');
                   writeln (' 1 - PETARE    2- 5 DE JULIO     3 - WARAIRAREPANO   |');
                   writeln ('-----------------------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: PETARE');
                        salidat := 'PETARE';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: 5 DE JULIO');
                           salidat := '5 DE JULIO';
                           end

                           else if salida = 3 then

                             begin
                              writeln ('SALIDA: WARAIRAREPANO');
                              salidat := 'WARAIRAREPANO';
                             end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: PETARE');
                       llegadat:= 'PETARE';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: 5 DE JULIO ');
                         llegadat := '5 DE JULIO';
                         end

                            else if llegada = 3 then

                            begin
                            writeln ('LLEGADA: WARAIRAREPANO');
                            llegadat := 'WARAIRAREPANO';
                            end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end
                   end;


               'b':
                  begin

                   ticket := 02;

                   writeln (' CABLETREN 8 - SUBESTACION B');
                   writeln ('----------------------------------------');
                   writeln (' 1 - 19 DE ABRIL      2 - 24 DE JULIO   |');
                   writeln ('----------------------------------------');
                   writeln ('INGRESE ESTACION DE SALIDA');
                   readln(salida);

                     if salida = 1 then

                        begin
                        writeln ('SALIDA: 19 DE ABRIL');
                        salidat := '19 DE ABRIL';
                        end

                        else if salida = 2 then

                           begin
                           writeln ('SALIDA: 24 DE JULIO');
                           salidat := '24 DE JULIO';
                           end

                      else
                          begin
                          writeln('DATO INCORRECTO...');
                          end;

                     writeln('INGRESE LA SUBESTACION DE LLEGADA');
                     readln (llegada);

                     if llegada = 1 then

                       begin
                       writeln ('LLEGADA: 19 DE ABRIL');
                       llegadat:= '19 DE ABRIL';
                       end

                       else if llegada = 2 then

                         begin
                         writeln ('LLEGADA: 24 DE JULIO ');
                         llegadat := '24 DE JULIO';
                         end

                       else
                           begin
                           writeln ('ERROR CERRANDO');
                       end

                  end

               end

             end

        end;

        writeln ('PROCESANDO...');
        delay(2500);
        if ticket = 02 then

          begin

          clrscr();

          writeln (' ------------------------------------------------------------------------------------------------');
          writeln ('|               FACTURA                                                                          |');
          writeln ('|                                                                                                |');
          writeln ('|                                                                                                |');
          writeln ('|        CEDULA: ', cedula);
          writeln ('|        NOMBRE:', nombre);
          writeln ('|                                                                                                |');
          writeln ('|    TIPO DE BOLETO:                                                                             |');
          writeln ('|  ',pasaje);
          writeln ('|      SUBESTACIONES SELECCIONADAS                                                               |');
          writeln ('|                                                                                                |');
          writeln ('|  ', viajes);
          writeln ('|  SALIDA: ', salidat);
          writeln ('|  LLEGADA: ', llegadat);
          writeln ('|                                                                                                |');
          writeln (' ------------------------------------------------------------------------------------------------');
          writeln ('CARGANDO...');
          delay (2500);
          writeln ('---------------------------------');
          writeln ('¨ESTA SEGURO DE SU COMPRA?');
          writeln ('1.SI ');
          writeln ('2.NO ');
          readln (comprar);
          writeln ('---------------------------------');

            if comprar = 1 then

               begin
                writeln ('---------------------------------');
                writeln ('PARA FINALIZAR COMPRA SU COMPRA  ');
                writeln ('---------------------------------');

                writeln ('PAGUE EL MONTO INDICADO');
                writeln ('PRECIO TOTAL : ', preciot:5:2, ' BS');

                writeln ('---------------------------------');
                write ('INGRESAR MONTO: ');
                readln  (monto);

                  if monto = preciot then

                     begin
                      writeln ('----------------------------------------');
                      writeln ('|       COMPRA REALIZADA CON EXITO      |');
                      writeln ('|        GRACIAS POR PREFERIRNOS        |');
                      writeln ('----------------------------------------');
                      ticket := 03;

                     end

                     else if monto < preciot then

                       begin
                       writeln ('----------------------------------------');
                       writeln ('POR FAVOR');
                       cambio := preciot - monto;
                       writeln ('FALTAN : ', cambio:5:2, 'BS');
                       Writeln ('INGRESE EL DINERO RESTANTE');
                       end

                     else if monto > preciot then

                       begin
                       writeln ('----------------------------------------');
                       writeln ('USTED A INGRESADO UN MONTO MAYOR');
                       writeln ('ESPERE SU CAMBIO');
                       cambio := monto - preciot;
                       writeln ('SU CAMBIO ES DE: ', cambio:5:2, 'BS');
                       writeln ('----------------------------------------');
                       writeln ('----------------------------------------');
                       writeln ('|       COMPRA REALIZADA CON EXITO      |');
                       writeln ('|        GRACIAS POR PREFERIRNOS        |');
                       writeln ('----------------------------------------');

                     end;

                writeln ('CARGANDO MENU..');

                delay(5000);
               end

            else if comprar = 2 then

               begin
                 clrscr();
                 writeln (' -----------------------');
                 writeln ('|                       |');
                 writeln ('|     VUELVA PRONTO.    |');
                 writeln ('|    SISTEMA CERRADO... |');
                 writeln ('|                       |');
                 writeln (' -----------------------');
                 delay (5500);
               end

            else
               begin
                writeln('DATO INCORRECTO. CERRANDO SISTEMA.');
                delay(2500);

            end;



            if  ticket = 03 then

              begin
               clrscr();
               writeln (' ---------------------------');
               writeln ('|  INDIQUE QUE DESEA HACER  |');
               writeln ('|   1. SALIR DEL SISTEMA    |');
               writeln ('|   2. UTILIZAR BOLETO      |');
               writeln (' ---------------------------');
               readln (menu);

                  case menu of

                     1:
                     begin
                       writeln (' ------------------------');
                       writeln ('|                        |');
                       writeln ('|  GRACIAS POR ELEGIRNOS |');
                       writeln ('|     VUELVA PRONTO      |');
                       writeln ('|                        |');
                       writeln (' ------------------------');
                       delay (2500);
                     end;

                     2:
                     begin
                      writeln ('POR FAVOR INGRESE SU CEDULA');
                      readln (cedula2);

                          if cedula2 = cedula then

                           begin

                              writeln (' ----------------------------');
                              writeln ('|          BIENVENIDO        |');
                              writeln ('|                            |');
                              writeln ('| NOMBRE: ', nombre);
                              writeln ('| CEDULA: ', cedula);
                              writeln ('|                            |');
                              writeln ('| USTED POSEE: ',boletos);
                              writeln ('|                            |');
                              writeln (' ----------------------------');
                              writeln ();
                              writeln ('¨DESEA USAR UN BOLETO?');
                              writeln ('1. SI');
                              writeln ('2. NO');
                              writeln ();
                              readln (usar);

                                 if usar = 1 then

                                    begin

                                    clrscr();
                                    bolet := boletos - 1;

                                    writeln (' ----------------------------');
                                    writeln ('|          BIENVENIDO        |');
                                    writeln ('|                            |');
                                    writeln ('| NOMBRE: ', nombre);
                                    writeln ('| CEDULA: ', cedula);
                                    writeln ('|                            |');
                                    writeln ('| BOLETO UTILIZADO           |');
                                    writeln ('|                            |');
                                    writeln ('| BOLETOS RESTANTES: ',bolet);
                                    writeln ('|                            |');
                                    writeln ('| ­VUELVA PRONTO!');
                                    writeln (' ----------------------------');

                                    delay (5000);
                                    end

                                    else if usar = 2 then

                                      begin
                                        writeln ('CERRANDO..');
                                        delay (2500);
                                      end


                       end

                  end;

                 3:
                  begin
                   writeln ('VER INFORME');
                  end
                end
              end

          end


       end

     end
  else
  begin
   writeln ('VUELVA PRONTO AL METROBUS');
   delay (2500);
  end;
end.
