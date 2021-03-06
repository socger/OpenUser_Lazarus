unit utilidades_bd;

{$mode objfpc}{$H+}

interface

uses
  Controls, Forms, FileUtil, Classes, SysUtils, DB, sqldb, IniFiles, Dialogs, utilidades_general,
  ButtonPanel;

{
var Variable : String;
}

type

  TOrder_By = record
      Titulo       : String;
      Memo_OrderBy : String;
  end;

  Trecord_CN_Conexion = record
      con_Exito         : boolean;
      ConnectorType     : string;
      DatabaseName      : string;
      HostName          : string;
      Password          : string;
      UserName          : string;
      min_no_Work       : string;
  end;

  Trecord_Cambiar_Filtros_Devuelve = record
      Cambio_Filtro : Boolean;
      Ok            : boolean;
      bajas         : ShortInt;
  end;

function  UTI_CN_Abrir(param_SQLTransaction: TSQLTransaction; param_SQLConnector: TSQLConnector): boolean;
function  UTI_CN_Cerrar(param_SQLTransaction: TSQLTransaction; param_SQLConnector: TSQLConnector): boolean;
function  UTI_CN_Fecha_Hora : TDateTime;
function  UTI_CN_Traer_Configuracion: Trecord_CN_Conexion;

function  UTI_TB_Quitar_AndOr_Principio(param_SQL: string): string;
procedure UTI_TB_Ver_Bajas_SN(param_nombre_tabla : String; param_SQL: TStrings; param_ver_Bajas: shortint);
function  UTI_TB_Cambiar_Filtros( param_Order_By : array of TOrder_By; param_Ver_Bajas : ShortInt; param_nombre_tabla : String; param_SQLQuery : TSQLQuery; param_SQL_WHERE, param_SQL_ORDER_BY : TStrings ) : Trecord_Cambiar_Filtros_Devuelve;
function  UTI_TB_Filtrar( param_Order_By : array of TOrder_By; param_DeleteSQL, param_UpdateSQL, param_InsertSQL : String; param_ctdad_Rgtros : Integer; param_SQLTransaction : TSQLTransaction; param_SQLConnector : TSQLConnector; param_SQLQuery : TSQLQuery; param_nombre_tabla : String; param_Ver_Bajas : ShortInt; param_SQL_SELECT_FROM_JOIN : String; param_SQL_WHERE, param_SQL_ORDER_BY : TStrings; param_Cambiamos_Filtro : Boolean ) : ShortInt;
function  UTI_TB_Abrir( param_DeleteSQL, param_UpdateSQL, param_InsertSQL : String; param_SQLConnector: TSQLConnector; param_SQLTransaction: TSQLTransaction; param_SQLQuery: TSQLQuery; param_PacketRecords: integer; param_SQL: string ) : boolean;
function  UTI_TB_Cerrar(param_SQLConnector: TSQLConnector; param_SQLTransaction: TSQLTransaction; param_SQLQuery: TSQLQuery): boolean;
procedure UTI_TB_Quitar_Filtro(param_Frase: string; param_SQL: TStrings);

implementation

uses filtrar_registros, estado_registro, menu;

function UTI_CN_Fecha_Hora : TDateTime;
var var_SQL            : TStrings;
    var_SQLTransaction : TSQLTransaction;
    var_SQLConnector   : TSQLConnector;
    var_CN_Conexion    : Trecord_CN_Conexion;
    var_SQLQuery       : TSQLQuery;
begin
  { ****************************************************************************
    Creamos la Transaccion y la conexión con el motor BD, y la abrimos
    **************************************************************************** }
    var_SQLTransaction := TSQLTransaction.Create(nil);
    var_SQLConnector := TSQLConnector.Create(nil);

    if UTI_CN_Abrir(var_SQLTransaction, var_SQLConnector) = False then UTI_GEN_Salir;

  { ****************************************************************************
    Creamos la SQL Según el motor de BD
    **************************************************************************** }
    var_SQL := TStringList.Create;

    var_CN_Conexion := UTI_CN_Traer_Configuracion;
    if var_CN_Conexion.con_Exito = False then UTI_GEN_Salir;

    if UpperCase(Copy(var_CN_Conexion.ConnectorType, 1, 5)) = UpperCase('MySQL') then
    begin
        var_SQL.Add('SELECT NOW() AS Momento');
    end;

    if Trim(var_CN_Conexion.ConnectorType) = 'MSSQLServer' then
    begin
        var_SQL.Add('SELECT GETDATE() AS Momento');
    end;

    if Trim(var_CN_Conexion.ConnectorType) = 'Firebird' then
    begin
        var_SQL.Add('select current_timestamp as Momento from rdb$database;');
    end;

    if Trim(var_CN_Conexion.ConnectorType) = 'Oracle' then
    begin
        var_SQL.Add('SELECT tt_sysdate AS Momento FROM dual;');
    end;

    if Trim(var_CN_Conexion.ConnectorType) = 'PostgreSQL' then
    begin
        var_SQL.Add('SELECT CURRENT_TIMESTAMP AS Momento;');
    end;

    if Trim(var_CN_Conexion.ConnectorType) = 'SQLite3' then
    begin
        // SELECT datetime('now') AS Momento;
        var_SQL.Add('SELECT datetime(' + QuotedStr('now') + ') AS Momento;');
    end;

    if Trim(var_CN_Conexion.ConnectorType) = 'Sybase' then
    begin
        var_SQL.Add('SELECT getdate() AS Momento');
    end;

  { ****************************************************************************
    Pasamos a traer la fecha y a devolverla
    **************************************************************************** }
    var_SQLQuery      := TSQLQuery.Create(nil);
    var_SQLQuery.Name := 'SQLQuery_UTI_CN_Fecha_Hora';

    if UTI_TB_Abrir( '', '', '',
                     var_SQLConnector,
                     var_SQLTransaction,
                     var_SQLQuery,
                     -1, // asi me trae todos los registros de golpe
                    var_SQL.Text ) = False then UTI_GEN_Salir;

    Result := var_SQLQuery.FieldByName('Momento').Value;

    if UTI_TB_Cerrar( var_SQLConnector,
                      var_SQLTransaction,
                      var_SQLQuery ) = false then UTI_GEN_Salir;

    var_SQLQuery.Free;

    var_SQL.Free;

    var_SQLTransaction.Free;
    var_SQLConnector.Free;
end;

function UTI_TB_Quitar_AndOr_Principio( param_SQL: string ) : string;
begin
    if UpperCase(Copy(Trim(param_SQL), 0, 3)) = UpperCase('AND') then
    begin
        param_SQL := Copy(Trim(param_SQL), 4, (length(param_SQL) - 4));
    end;

    if UpperCase(Copy(Trim(param_SQL), 0, 2)) = UpperCase('OR') then
    begin
        param_SQL := Copy(Trim(param_SQL), 3, (length(param_SQL) - 3));
    end;

    Result := Trim(param_SQL);
end;

procedure UTI_TB_Quitar_Filtro(param_Frase: string; param_SQL: TStrings);
var var_Pos             : integer;
    var_Frase_Principio : string;
    var_Frase_Final     : string;
    var_Total           : integer;
    var_Buscar          : string;
begin
    var_Buscar := param_SQL.Text;
    var_Pos := Pos(UpperCase(param_Frase), UpperCase(var_Buscar));
    if var_Pos > 0 then
    begin
        var_Frase_Principio := Trim(Copy(var_Buscar, 0, (var_Pos - 1)));

        var_Total           := var_Pos + Length(param_Frase);
        var_Frase_Final     := Trim(  Copy( var_Buscar,
                                            var_Total,
                                            length(var_Buscar) - (var_Total - 1) )  );

        var_Buscar          := var_Frase_Principio + var_Frase_Final;

        param_SQL.Clear;
        param_SQL.Add(var_Buscar);
    end;
end;

procedure UTI_TB_Ver_Bajas_SN( param_nombre_tabla : String;
                               param_SQL : TStrings;
                               param_ver_Bajas : shortint );
begin
    if Trim(param_nombre_tabla) <> '' then
         UTI_TB_Quitar_Filtro('AND ' + Trim(param_nombre_tabla) + '.Del_WHEN IS NULL', param_SQL)
    else UTI_TB_Quitar_Filtro('AND Del_WHEN IS NULL', param_SQL);

    if Trim(param_nombre_tabla) <> '' then
         UTI_TB_Quitar_Filtro('OR ' + Trim(param_nombre_tabla) + '.Del_WHEN IS NULL', param_SQL)
    else UTI_TB_Quitar_Filtro('OR Del_WHEN IS NULL', param_SQL);

    if Trim(param_nombre_tabla) <> '' then
         UTI_TB_Quitar_Filtro( Trim(param_nombre_tabla) + '.Del_WHEN IS NULL', param_SQL)
    else UTI_TB_Quitar_Filtro('Del_WHEN IS NULL', param_SQL);

    if param_ver_Bajas = 1 then
    begin
        // Se pidió NO VER las bajas, asi que si no existe lo añadimos
        if Trim(param_SQL.Text) <> '' then
            begin
                if (UpperCase(Copy(Trim(param_SQL.Text), 0, 3)) <> UpperCase('AND')) and
                   (UpperCase(Copy(Trim(param_SQL.Text), 0, 2)) <> UpperCase('OR'))  then
                    begin
                        if Trim(param_nombre_tabla) <> '' then
                             param_SQL.Text := Trim(param_nombre_tabla) + '.Del_WHEN IS NULL' + ' AND ' + Trim(param_SQL.Text)
                        else param_SQL.Text := 'Del_WHEN IS NULL' + ' AND ' + Trim(param_SQL.Text)
                    end
                else
                    begin
                        if Trim(param_nombre_tabla) <> '' then
                             param_SQL.Text := Trim(param_nombre_tabla) + '.Del_WHEN IS NULL' + ' ' + Trim(param_SQL.Text)
                        else param_SQL.Text := 'Del_WHEN IS NULL' + ' ' + Trim(param_SQL.Text);
                    end;
            end
        else
            begin
                if Trim(param_nombre_tabla) <> '' then
                     param_SQL.Text := Trim(param_nombre_tabla) + '.Del_WHEN IS NULL'
                else param_SQL.Text := 'Del_WHEN IS NULL';
            end;
    end;
end;

function UTI_TB_Cambiar_Filtros( param_Order_By : array of TOrder_By;
                                 param_Ver_Bajas : ShortInt;
                                 param_nombre_tabla : String;
                                 param_SQLQuery : TSQLQuery;
                                 param_SQL_WHERE,
                                 param_SQL_ORDER_BY : TStrings ) : Trecord_Cambiar_Filtros_Devuelve;
var var_Form_Filtrar_Registros : TForm_Filtrar_Registros;
//  var_Contador               : ShortInt;
begin
    var_Form_Filtrar_Registros := TForm_Filtrar_Registros.Create(nil);

    var_Form_Filtrar_Registros.RadioGroup_Bajas.ItemIndex := param_Ver_Bajas;
    var_Form_Filtrar_Registros.public_nombre_tabla := param_nombre_tabla;

  { ****************************************************************************
    Movemos los campos a form_Filtrar_Registros
    **************************************************************************** }
    var_Form_Filtrar_Registros.public_Campos.Assign(param_SQLQuery.FieldDefs);
    var_Form_Filtrar_Registros.Rellenar_Campos;

  { ****************************************************************************
    Añadimos los anteriores filtros
    **************************************************************************** }
    var_Form_Filtrar_Registros.AnadirStrings_Filtros(param_SQL_WHERE);
    var_Form_Filtrar_Registros.AnadirStrings_OrderBy(param_SQL_ORDER_BY);

{
    SetLength( var_Form_Filtrar_Registros.public_Order_By,
               (length(param_Order_By) + 1) );

    var_Form_Filtrar_Registros.public_Order_By[0].Titulo       := 'Por campo elegido (ASC / DESC)';
    var_Form_Filtrar_Registros.public_Order_By[0].Memo_OrderBy := param_Order_By[var_Contador].Memo_OrderBy;

    for var_Contador := 0 to (Length(param_Order_By) - 1) do
    begin
        var_Form_Filtrar_Registros.public_Order_By[var_Contador + 1].Titulo       := param_Order_By[var_Contador].Titulo;
        var_Form_Filtrar_Registros.public_Order_By[var_Contador + 1].Memo_OrderBy := param_Order_By[var_Contador].Memo_OrderBy;
    end;
}
    var_Form_Filtrar_Registros.Rellenar_Filtros( param_Order_By );

  { ****************************************************************************
    Añadimos el anterior filtro y vemos si no pulso cancelar para devolver que
    filtramos o no
    **************************************************************************** }
    Result.bajas         := var_Form_Filtrar_Registros.RadioGroup_Bajas.ItemIndex;

    Result.Cambio_Filtro := true;

    Result.Ok            := false;

    var_Form_Filtrar_Registros.ShowModal;
    if var_Form_Filtrar_Registros.public_Pulso_Aceptar = true then
    begin
        param_SQL_WHERE.Assign(var_Form_Filtrar_Registros.Memo_Filtros.Lines);
        if var_Form_Filtrar_Registros.ComboBox_Filtros.ItemIndex = 0 then
             param_SQL_ORDER_BY.Assign(var_Form_Filtrar_Registros.Memo_OrderBy.Lines)
        else param_SQL_ORDER_BY.Text := param_Order_By[var_Form_Filtrar_Registros.ComboBox_Filtros.ItemIndex - 1].Memo_OrderBy;

        Result.Ok    := true;
        Result.bajas := var_Form_Filtrar_Registros.RadioGroup_Bajas.ItemIndex;
    end;

  { ****************************************************************************
    Destruimos el formulario para Filtrar_Registros
    **************************************************************************** }
    var_Form_Filtrar_Registros.Free;
end;

function UTI_TB_Filtrar( param_Order_By : array of TOrder_By;
                         param_DeleteSQL,
                         param_UpdateSQL,
                         param_InsertSQL : String;
                         param_ctdad_Rgtros : Integer;
                         param_SQLTransaction : TSQLTransaction;
                         param_SQLConnector : TSQLConnector;
                         param_SQLQuery : TSQLQuery;
                         param_nombre_tabla : String;
                         param_Ver_Bajas : ShortInt;
                         param_SQL_SELECT_FROM_JOIN : String;
                         // param_SQL_ORDER_BY : String;
                         param_SQL_WHERE,
                         param_SQL_ORDER_BY : TStrings;
                         param_Cambiamos_Filtro : Boolean ) : ShortInt;
var var_SQL      : String;
    var_Devuelto : Trecord_Cambiar_Filtros_Devuelve;
begin
    UTI_TB_Ver_Bajas_SN(param_nombre_tabla, param_SQL_WHERE, param_Ver_Bajas);

    var_Devuelto.Cambio_Filtro := false;
    var_Devuelto.Ok            := false;
    var_Devuelto.bajas         := param_Ver_Bajas;

    if param_Cambiamos_Filtro = true then
    begin
        // ***************************************************************************************** //
        // ** Llamamos al formuloario que crea/modifica los filtros                               ** //
        // ** Por supuesto, pasamos también los forms ya creados                                  ** //
        // ***************************************************************************************** //
        var_Devuelto := UTI_TB_Cambiar_Filtros( param_Order_By,
                                                param_Ver_Bajas,
                                                param_nombre_tabla,
                                                param_SQLQuery,
                                                param_SQL_WHERE,
                                                param_SQL_ORDER_BY );
    end;

    // ********************************************************************************************* //
    // ** Devolvemos si se ha cambiado el ver bajas SI o NO                                       ** //
    // ********************************************************************************************* //
    Result := var_Devuelto.bajas;

    if (var_Devuelto.Cambio_Filtro = true) and
       (var_Devuelto.Ok = false)           then Exit;

    var_SQL := param_SQL_SELECT_FROM_JOIN;

    if Trim(param_SQL_WHERE.Text) <> '' then
    begin
        param_SQL_WHERE.Text := UTI_TB_Quitar_AndOr_Principio(param_SQL_WHERE.Text);
        var_SQL := Trim(var_SQL) + ' ' +
                   'WHERE' + ' ' + Trim(param_SQL_WHERE.Text);
    end;

    var_SQL := Trim(var_SQL) + ' ORDER BY ' +
               param_SQL_ORDER_BY.Text;

//    if UTI_CN_Abrir( param_SQLTransaction,
//                     param_SQLConnector ) = False then UTI_GEN_Salir;

    if UTI_TB_Abrir( param_DeleteSQL,
                     param_UpdateSQL,
                     param_InsertSQL,
                     param_SQLConnector,
                     param_SQLTransaction,
                     param_SQLQuery,
                     param_ctdad_Rgtros,
                     var_SQL ) = False then UTI_GEN_Salir;
end;

function UTI_TB_Cerrar( param_SQLConnector: TSQLConnector;
                        param_SQLTransaction: TSQLTransaction;
                        param_SQLQuery : TSQLQuery ) : boolean;
var var_msg : TStrings;
begin
    try
        Result := True;
        param_SQLQuery.Active := False;

        Result := UTI_CN_Cerrar( param_SQLTransaction, param_SQLConnector );
    except
        on error : Exception do
        begin
            var_msg := TStringList.Create;
            var_msg.Clear;
            var_msg.Add('Error al CERRAR la TABLA ' + param_SQLQuery.Name);
            var_msg.Add('Este es el mensaje de error: ');
            var_msg.Add( ' ');
            var_msg.Add(error.Message);

            UTI_GEN_Aviso(var_msg, 'ERROR', True, False);

            var_msg.Add( 'ooo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 000');
            var_msg.Add( ' ');

            UTI_GEN_Log(var_msg.Text);

            var_msg.Free;

            Result := False;
        end;
    end;
end;

function UTI_CN_Cerrar( param_SQLTransaction: TSQLTransaction;
                        param_SQLConnector: TSQLConnector ) : boolean;
var var_msg : TStrings;
begin
  { ****************************************************************************
    Cerramos La transacción y la conexión con la BD
    **************************************************************************** }
    try
        Result := True;
        if param_SQLConnector.Connected = true then
        begin
             param_SQLConnector.Connected := False;
        end;

        if param_SQLTransaction.Active = true then
        begin
             param_SQLTransaction.Active  := False;
        end;
    except
        on error : Exception do
        begin
            var_msg := TStringList.Create;
            var_msg.Clear;
            var_msg.Add('Error al CERRAR la CONEXION con el MOTOR de la BD');
            var_msg.Add('Este es el mensaje de error: ');
            var_msg.Add( ' ');
            var_msg.Add(error.Message);

            UTI_GEN_Aviso(var_msg, 'ERROR', True, False);

            var_msg.Add( 'ooo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 000');
            var_msg.Add( ' ');

            UTI_GEN_Log(var_msg.Text);

            var_msg.Free;

            Result := False;
        end;
    end;
end;

function UTI_CN_Abrir( param_SQLTransaction: TSQLTransaction;
                       param_SQLConnector: TSQLConnector ): boolean;
var var_CN_Conexion : Trecord_CN_Conexion;
begin
    try
        Result := True;

        if UTI_CN_Cerrar(param_SQLTransaction, param_SQLConnector) = False then UTI_GEN_Salir;

        with param_SQLTransaction do
        begin
            Action := caCommit;
            Database := param_SQLConnector;
            Params.Clear;
            Tag := 0;
        end;

        var_CN_Conexion := UTI_CN_Traer_Configuracion;

        if var_CN_Conexion.con_Exito = True then
            begin
                with param_SQLConnector do
                begin
                    CharSet        := 'utf8';
                    ConnectorType  := var_CN_Conexion.ConnectorType;
                    DatabaseName   := var_CN_Conexion.DatabaseName;
                    HostName       := var_CN_Conexion.HostName;
                    KeepConnection := False;

                    LoginPrompt    := False;
                    Params.Clear;
                    Password       := var_CN_Conexion.Password;
                    Role           := '';
                    Tag            := 0;
                    Transaction    := param_SQLTransaction;
                    UserName       := var_CN_Conexion.UserName;

                    {
                        LogEvents      := LogAllEvents; // Para registrar los sucesos tenemos que decirle que hacer  = [detCustom, detPrepare, detExecute, detFetch, detCommit, detRollBack]
                                                        // ... and to which procedure the connection should send the events:
                        OnLog          := @Self.GetLogEvent;
                    }
                end;
            end
        else Result := False;
    except
        Result := False;
    end;
end;

function UTI_CN_Traer_Configuracion : Trecord_CN_Conexion;
var var_fichero_ini : TIniFile;
    var_msg         : TStrings;
begin
    if (FileExists(GetCurrentDirUTF8 + '\ini\socger.ini')) then
    begin
        try
            var_fichero_ini          := TIniFile.Create(GetCurrentDirUTF8 + '\ini\socger.ini');
            Result.con_Exito         := True;
            Result.ConnectorType     := var_fichero_ini.ReadString('HowConnectBD', 'ConnectorType', '');
            Result.DatabaseName      := var_fichero_ini.ReadString('HowConnectBD', 'DatabaseName', '');
            Result.HostName          := var_fichero_ini.ReadString('HowConnectBD', 'HostName', '');
            Result.Password          := var_fichero_ini.ReadString('HowConnectBD', 'Password', '');
            Result.UserName          := var_fichero_ini.ReadString('HowConnectBD', 'UserName', '');

            Result.min_no_Work       := var_fichero_ini.ReadString('Config', 'min_no_Work', '');

            var_fichero_ini.Free;
        except
            on error : Exception do
            begin
                var_msg := TStringList.Create;
                var_msg.Clear;
                var_msg.Add('Error al ABRIR el fichero de CONFIGURACION');
                var_msg.Add('Este es el mensaje de error: ');
                var_msg.Add( ' ');
                var_msg.Add(error.Message);

                UTI_GEN_Aviso(var_msg, 'ERROR', True, False);

                var_msg.Add( 'ooo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 000');
                var_msg.Add( ' ');

                UTI_GEN_Log(var_msg.Text);

                var_msg.Free;

                Result.con_Exito := False;
            end;
        end;
    end;
end;

function UTI_TB_Abrir( param_DeleteSQL,
                       param_UpdateSQL,
                       param_InsertSQL : String;
                       param_SQLConnector: TSQLConnector;
                       param_SQLTransaction: TSQLTransaction;
                       param_SQLQuery: TSQLQuery;
                       param_PacketRecords: integer;
                       param_SQL: string ) : boolean;
var var_msg : TStrings;
begin
    if UTI_TB_Cerrar( param_SQLConnector,
                      param_SQLTransaction,
                      param_SQLQuery) = false then UTI_GEN_Salir;
    try
        Result := True;

        param_SQLConnector.Connected := True;
        param_SQLTransaction.Active := True;

        with param_SQLQuery do
        begin
            Active          := False;
            AutoCalcFields  := True;
            Database        := param_SQLConnector;
            PacketRecords   := param_PacketRecords;

            MaxIndexesCount := 100; // Ensure the TSQLQuery.MaxIndexesCount is large enough to hold the new indexes you will be creating. For this example I had it set to 100.
            IndexFieldNames := ''; // Esto nos permite ordenar el DbGrid, o mas bien el TDataSet, ejemplo IndexFieldNames := 'LastName;FirstName';

            Filtered        := true; // Lo pongo a true porque puede ser que en el onfilter del sqlquery ponga algo

            ParseSQL        := true; // Esto es obligado porque ntros vamos a controlar las sql con parametros

            DeleteSQL.Text  := Trim(param_DeleteSQL);
            UpdateSQL.Text  := Trim(param_UpdateSQL);
            InsertSQL.Text  := Trim(param_InsertSQL);

            SQL.Clear;
            SQL.Add(param_SQL);

            UpdateMode := upWhereKeyOnly;
            UsePrimaryKeyAsKey := True;

            Active := True;

            {
                ShowMessage(IntToStr(RecordCount));
                Es curioso sólo me devuelve 20 por que es justo lo que le he
                puesto a PacketRecords

                Copiado de ... http://wiki.freepascal.org/SqlDBHowto/es

                ¿Por qué TSQLQuery.RecordCount siempre devuelve 0?
                Para contar los registros de un dataset, usaremos RecordCount.
                Sin embargo, observa que RecordCount muestra el número de
                registros que se ha cargado desde el servidor. SQLdb no lee
                todos los registros al abrir un TSQLQuery de forma predeter-
                minada, sólo los 10 primeros. Sólo cuando se accede al
                undécimo registro entonces el siguiente conjunto de 10
                registros se carga. Usando .Last todos los registros se
                cargarán.
                Si desea conocer el número real de registros en el servidor
                hay que llamar primero '.Last' y luego llamar a .RecordCount.
                Hay una alternativa disponible. El número de registros
                devueltos por el servidor está determinado por el valor de
                la propiedad PacketRecords. El valor por defecto es 10, si
                se pone a -1 entonces todos los registros serán cargados a
                la vez.
            }
        end;
    except
        on error : Exception do
        begin
            var_msg := TStringList.Create;
            var_msg.Clear;
            var_msg.Add('Error al ABRIR la TABLA ' + param_SQLQuery.Name);
            var_msg.Add('Este es el mensaje de error: ');
            var_msg.Add( ' ');
            var_msg.Add(error.Message);

            UTI_GEN_Aviso(var_msg, 'ERROR', True, False);

            var_msg.Add( 'ooo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 000');
            var_msg.Add( ' ');

            UTI_GEN_Log(var_msg.Text);

            var_msg.Free;

            Result := False;
        end;
    end;
end;

end.


