unit utilidades_usuarios;

{$mode objfpc}{$H+}

interface

uses
  utilidades_bd, Forms, utilidades_general, sqldb, Classes, SysUtils;

function  UTI_usr_Permiso_SN( param_Menu : shortint; param_Tipo_CRUD : ShortString; param_Ver_Error : boolean ) : Boolean;
function  UTI_usr_Permiso_SN_conPermisoTotal_SN( param_Id : Integer ) : Boolean;
function  UTI_usr_Permiso_SN_Permisos( param_Menu : shortint; param_Tipo_CRUD : ShortString; param_Ver_Error : boolean ) : Boolean;
function  UTI_usr_Permiso_SN_Permisos_2( param_SQLQuery : TSQLQuery; param_Menu : shortint; param_Tipo_CRUD : ShortString; param_Ver_Error : boolean ) : Boolean;

function  UTI_usr_Traer_Nombre_Usuario(param_id : Integer) : ShortString;
function  UTI_usr_Traer_Nombre_Usuario_2(param_id : Integer) : ShortString;

function  UTI_usr_Obligado_WHY_Delete_SN( param_Menu : ShortInt ) : Boolean;
function  UTI_usr_Obligado_WHY_Delete_SN_2( param_Menu : ShortInt ) : Boolean;

implementation

uses
  menu;

function UTI_usr_Permiso_SN_conPermisoTotal_SN( param_Id : Integer ) : Boolean;
var var_SQL            : TStrings;
    var_SQLTransaction : TSQLTransaction;
    var_SQLConnector   : TSQLConnector;
    var_SQLQuery       : TSQLQuery;
begin
  { ****************************************************************************
    Creamos la Transaccion y la conexión con el motor BD, y la abrimos
    **************************************************************************** }
    var_SQLTransaction := TSQLTransaction.Create(nil);
    var_SQLConnector   := TSQLConnector.Create(nil);

    if UTI_CN_Abrir( var_SQLTransaction,
                     var_SQLConnector ) = False then Application.Terminate;

  { ****************************************************************************
    Creamos la SQL Según el motor de BD
    **************************************************************************** }
    var_SQL := TStringList.Create;

    var_SQL.Add( 'SELECT *' );
    var_SQL.Add(   'FROM users' );
    var_SQL.Add(  'WHERE Id =  ' + Trim(IntToStr(param_Id)) );
    var_SQL.Add(    'AND Del_WHEN IS NULL ' );
    var_SQL.Add(  'ORDER BY Id' );

  { ****************************************************************************
    Abrimos la tabla
    **************************************************************************** }
    var_SQLQuery := TSQLQuery.Create(nil);

    if UTI_TB_Abrir( '', '', '',
                     var_SQLConnector,
                     var_SQLTransaction,
                     var_SQLQuery,
                     -1, // asi me trae todos los registros de golpe
                     var_SQL.Text ) = False then Application.Terminate;

  { ****************************************************************************
    TRABAJAMOS CON LOS REGISTROS DEVUELTOS
    ****************************************************************************
    Si el módulo no se creó, no se permite entrar en él ... Result := False
    **************************************************************************** }
    with var_SQLQuery do
    begin
        if RecordCount > 0 then
            begin
                if FieldByName('Del_WHEN').IsNull then
                    begin
                        if Trim(FieldByName('Permiso_Total_SN').AsString) = '' then
                            begin
                              { ************************************************
                                No se puso nada, así que no tiene permiso total
                                ************************************************ }
                                Result := False;
                            end
                        else
                            begin
                                Result := False;
                                if UpperCase(Trim(FieldByName('Permiso_Total_SN').AsString)) = 'S' then
                                begin
                                    Result := True;
                                end;
                            end;
                    end
                else
                    begin
                      { ********************************************************
                        Usuario dado de baja ... no tiene permisos totales
                        ******************************************************** }
                        Result := False;
                    end;
            end
        else Result := False; // NO EXISTE
    end;

  { ****************************************************************************
    Cerramos la tabla
    **************************************************************************** }
    if UTI_TB_Cerrar( var_SQLConnector,
                      var_SQLTransaction,
                      var_SQLQuery ) = false then Application.Terminate;

    var_SQLQuery.Free;

    var_SQL.Free;

  { ****************************************************************************
    Cerramos La transacción y la conexión con la BD
    **************************************************************************** }
    if UTI_CN_Cerrar( var_SQLTransaction,
                      var_SQLConnector ) = False then Application.Terminate;

    var_SQLTransaction.Free;
    var_SQLConnector.Free;
end;

function UTI_usr_Permiso_SN_Permisos_2( param_SQLQuery : TSQLQuery;
                                        param_Menu : shortint;
                                        param_Tipo_CRUD : ShortString;
                                        param_Ver_Error : boolean ) : Boolean;
var var_Mayusculas : ShortString;
    var_msg        : TStrings;
begin
    var_msg := TStringList.Create;
    Result  := False;

  { ****************************************************************************
    param_Tipo_CRUD puede contener ... 'A' .- Alta
                                       'M' .- Modificar
                                       'B' .- Borrar
                                       'I' .- Imprimir
                                       'O' .- Otro uso
                                       ''  .- Ninguna opción ... para ver si
                                              tiene algún tipo de permiso para
                                              el menu que preguntamos
    **************************************************************************** }
    if Trim(param_Tipo_CRUD) = '' then
        begin
          { ********************************************************************
            No se pidió ningún tipo de uso ('A', 'M', 'B', 'I' o 'O'), por lo
            que podría devolver un registro, varios o ninguno
            ******************************************************************** }
            if param_SQLQuery.RecordCount > 0 then
                 Result := True // devuelvo true porque tiene algún tipo de uso para este modulo
            else var_msg.Add( 'PARA ESTA OPCION NO TIENE PERMISOS' );
        end
    else
        begin
          { ********************************************************************
            Se pidió en concreto permiso para un tipo de uso para un menu, así
            que solo me tiene que devolver un registro
            ******************************************************************** }
            var_Mayusculas := AnsiUpperCase(param_Tipo_CRUD);
            if param_SQLQuery.RecordCount = 0 then
                begin
                  { ************************************************************
                    Para el tipo de permiso solicitado('A', 'M', 'B', 'I' o 'O')
                    no tiene permiso
                    ************************************************************ }
                    if (Trim(var_Mayusculas) = 'A') or
                       (Trim(var_Mayusculas) = 'M') or
                       (Trim(var_Mayusculas) = 'B') or
                       (Trim(var_Mayusculas) = 'I') or
                       (Trim(var_Mayusculas) = 'O') then
                        begin
                            if Trim(var_Mayusculas) = 'A' then var_msg.Add( 'PARA ESTA OPCION NO TIENE PERMISOS DE ' + QuotedStr('ALTAS') );
                            if Trim(var_Mayusculas) = 'M' then var_msg.Add( 'PARA ESTA OPCION NO TIENE PERMISOS DE ' + QuotedStr('MODIFICAR') );
                            if Trim(var_Mayusculas) = 'B' then var_msg.Add( 'PARA ESTA OPCION NO TIENE PERMISOS DE ' + QuotedStr('BORRAR') );
                            if Trim(var_Mayusculas) = 'I' then var_msg.Add( 'PARA ESTA OPCION NO TIENE PERMISOS DE ' + QuotedStr('IMPRIMIR') );
                            if Trim(var_Mayusculas) = 'O' then var_msg.Add( 'PARA ESTA OPCION NO TIENE PERMISOS DE ' + QuotedStr('OTRO USO') );
                        end
                    else var_msg.Add( 'LA OPCION DE PERMISOS ' + Trim(var_Mayusculas) + ' NO ESTA CONTEMPLADA' );
                end
            else
                begin
                  { ************************************************************
                    El tipo de opción solicitada('A', 'M', 'B', 'I' o 'O') fué
                    creado como permiso para el menú solicitado, así que devol-
                    vemos si tiene permiso, según valor del campo (Permiso_SN)
                    ************************************************************ }
                    if AnsiUpperCase(param_SQLQuery.FieldByName('Permiso_SN').Value) = 'S' then
                    begin
                        Result := True; { tiene permiso }
                    end;
                end;
        end;

    if (Trim(var_msg.Text) <> '') and
       (param_Ver_Error = True)   then UTI_GEN_Aviso(var_msg, 'PERMISO DENEGADO', True, False);

    var_msg.Free;
end;

function UTI_usr_Permiso_SN_Permisos( param_Menu : shortint;
                                      param_Tipo_CRUD : ShortString;
                                      param_Ver_Error : boolean ) : Boolean;
var var_SQL            : TStrings;
    var_SQLTransaction : TSQLTransaction;
    var_SQLConnector   : TSQLConnector;
    var_SQLQuery       : TSQLQuery;
begin
  { ****************************************************************************
    Creamos la Transaccion y la conexión con el motor BD, y la abrimos
    **************************************************************************** }
    var_SQLTransaction := TSQLTransaction.Create(nil);
    var_SQLConnector   := TSQLConnector.Create(nil);

    if UTI_CN_Abrir( var_SQLTransaction,
                     var_SQLConnector ) = False then Application.Terminate;

  { ****************************************************************************
    Creamos la SQL Según el motor de BD
    **************************************************************************** }
    var_SQL := TStringList.Create;

    var_SQL.Add( 'SELECT *' );
    var_SQL.Add(   'FROM users_menus_permissions' );
    var_SQL.Add(  'WHERE Id_Users = ' +  Trim(IntToStr(Form_Menu.public_User)) );
    var_SQL.Add(    'AND Id_Menus  = ' +  Trim(IntToStr(param_Menu)) );
    var_SQL.Add(    'AND Del_WHEN IS NULL ' );

    if Trim(param_Tipo_CRUD) <> '' then
         var_SQL.Add(  ' AND Tipo_CRUD  = ' + QuotedStr(Trim(param_Tipo_CRUD)) )
    else var_SQL.Add(  ' AND Permiso_SN  = ' + QuotedStr('S') + ' ' );

    var_SQL.Add(' ORDER BY Id_Users, Id_Menus, Tipo_CRUD ' );

  { ****************************************************************************
    Abrimos la tabla
    **************************************************************************** }
    var_SQLQuery := TSQLQuery.Create(nil);

    if UTI_TB_Abrir( '', '', '',
                     var_SQLConnector,
                     var_SQLTransaction,
                     var_SQLQuery,
                     -1, // asi me trae todos los registros de golpe
                     var_SQL.Text ) = False then Application.Terminate;

  { ****************************************************************************
    TRABAJAMOS CON LOS REGISTROS DEVUELTOS
    ****************************************************************************
    Si el módulo no se creó, no se permite entrar en él ... Result := False
    **************************************************************************** }
    Result := UTI_usr_Permiso_SN_Permisos_2( var_SQLQuery,
                                             param_Menu,
                                             param_Tipo_CRUD,
                                             param_Ver_Error );

  { ****************************************************************************
    Cerramos la tabla
    **************************************************************************** }
    if UTI_TB_Cerrar( var_SQLConnector,
                      var_SQLTransaction,
                      var_SQLQuery ) = false then Application.Terminate;

    var_SQLQuery.Free;

    var_SQL.Free;

  { ****************************************************************************
    Cerramos La transacción y la conexión con la BD
    **************************************************************************** }
    if UTI_CN_Cerrar( var_SQLTransaction,
                      var_SQLConnector ) = False then Application.Terminate;

    var_SQLTransaction.Free;
    var_SQLConnector.Free;
end;

function UTI_usr_Permiso_SN( param_Menu : shortint;
                             param_Tipo_CRUD : ShortString;
                             param_Ver_Error : boolean ) : Boolean;
var var_msg    : TStrings;
    var_Fecha  : tDateTime;
    var_Caduca : Boolean;
begin
    // jerofa hay que hacer la gestión de permisos
    Result := True;
    Exit;
    // jerofa hay que hacer la gestión de permisos

    if (Form_Menu.public_User = 0) { Usuario = 0 es el superusuario }    or
       (UTI_usr_Permiso_SN_conPermisoTotal_SN(Form_Menu.public_User) = True) then
        begin
          { ********************************************************************
            O es el SUPER USUARIO, o tiene PERMISOS TOTALES. Por lo que devuelvo
            que si que tiene permiso
            ******************************************************************** }
            Result := True;
        end
    else
        begin
          { ********************************************************************
            Compruebo si tiene permisos para la opción solicitada
            ******************************************************************** }
            Result := UTI_usr_Permiso_SN_Permisos( param_Menu, param_Tipo_CRUD, param_Ver_Error );
        end;

  { ****************************************************************************
    Pero puede ocurrir que la contraseña haya caducado, por lo que no debo de
    dar permisos
    **************************************************************************** }
    var_Caduca := True;
    if Form_Menu.public_pwd_No_Caduca = True then
        var_Caduca := False
    else
        begin
            var_Fecha := UTI_CN_Fecha_Hora;

            if (var_Fecha >= Form_Menu.public_pwd_Caduca_Inicio) and
               (var_Fecha <= Form_Menu.public_pwd_Caduca_Fin)    then
            begin
                var_Caduca := False;
            end;
        end;

    if var_Caduca = True then
    begin
        var_msg := TStringList.Create;
        var_msg.Add('CONTRASEÑA CADUCADA');
        UTI_GEN_Aviso(var_msg, 'PERMISO DENEGADO', True, False);
        var_msg.Free;
        Result := False;
    end;

  { ****************************************************************************
    Si tiene permisos, se cambia el momento de comprobación de tiempo de espera
    para pedir la password otra vez
    **************************************************************************** }
    if Result = True then Form_Menu.public_When_OLD_Permiso := Now;
end;

function UTI_usr_Traer_Nombre_Usuario_2(param_id : Integer) : ShortString;
var var_SQL            : TStrings;
    var_SQLTransaction : TSQLTransaction;
    var_SQLConnector   : TSQLConnector;
    var_SQLQuery       : TSQLQuery;
begin
  { ****************************************************************************
    Creamos la Transaccion y la conexión con el motor BD, y la abrimos
    **************************************************************************** }
    var_SQLTransaction := TSQLTransaction.Create(nil);
    var_SQLConnector   := TSQLConnector.Create(nil);

    if UTI_CN_Abrir( var_SQLTransaction,
                     var_SQLConnector ) = False then Application.Terminate;

  { ****************************************************************************
    Creamos la SQL Según el motor de BD
    **************************************************************************** }
    var_SQL := TStringList.Create;

    var_SQL.Add ( 'SELECT Descripcion_Nick' );
    var_SQL.Add(    'FROM users' );
    var_SQL.Add(   'WHERE Id = ' + Trim(IntToStr(param_id)) );
    var_SQL.Add(     'AND Del_WHEN IS NULL ' );
    var_SQL.Add (  'ORDER BY Id' );

  { ****************************************************************************
    Abrimos la tabla
    **************************************************************************** }
    var_SQLQuery := TSQLQuery.Create(nil);

    if UTI_TB_Abrir( '', '', '',
                     var_SQLConnector,
                     var_SQLTransaction,
                     var_SQLQuery,
                     -1, // asi me trae todos los registros de golpe
                     var_SQL.Text ) = False then Application.Terminate;

  { ****************************************************************************
    TRABAJAMOS CON LOS REGISTROS DEVUELTOS
    ****************************************************************************
    Si el módulo no se creó, no se permite entrar en él ... Result := False
    **************************************************************************** }
    Result := var_SQLQuery.FieldByName('Descripcion_Nick').AsString;

  { ****************************************************************************
    Cerramos la tabla
    **************************************************************************** }
    if UTI_TB_Cerrar( var_SQLConnector,
                      var_SQLTransaction,
                      var_SQLQuery ) = false then Application.Terminate;

    var_SQLQuery.Free;

    var_SQL.Free;

  { ****************************************************************************
    Cerramos La transacción y la conexión con la BD
    **************************************************************************** }
    if UTI_CN_Cerrar( var_SQLTransaction,
                      var_SQLConnector ) = False then Application.Terminate;

    var_SQLTransaction.Free;
    var_SQLConnector.Free;
end;

function UTI_usr_Traer_Nombre_Usuario(param_id : Integer) : ShortString;
begin
    if param_id = 0 then
         Result := 'USUARIO INSTALACION'
    else Result := UTI_usr_Traer_Nombre_Usuario_2(param_id);
end;

function UTI_usr_Obligado_WHY_Delete_SN( param_Menu : ShortInt ) : Boolean;
begin
    if Form_Menu.public_User = 0 then // 0 es el superusuario
         Result := False
    else Result := UTI_usr_Obligado_WHY_Delete_SN_2( param_Menu );
end;

function UTI_usr_Obligado_WHY_Delete_SN_2( param_Menu : ShortInt ) : Boolean;
var var_SQL            : TStrings;
    var_SQLTransaction : TSQLTransaction;
    var_SQLConnector   : TSQLConnector;
    var_SQLQuery       : TSQLQuery;
begin
  { ****************************************************************************
    Creamos la Transaccion y la conexión con el motor BD, y la abrimos
    **************************************************************************** }
    var_SQLTransaction := TSQLTransaction.Create(nil);
    var_SQLConnector   := TSQLConnector.Create(nil);

    if UTI_CN_Abrir( var_SQLTransaction,
                     var_SQLConnector ) = False then Application.Terminate;

  { ****************************************************************************
    Creamos la SQL Según el motor de BD
    **************************************************************************** }
    var_SQL := TStringList.Create;

    var_SQL.Add('SELECT Forcing_Why_Delete' );
    var_SQL.Add(  'FROM users_menus' );
    var_SQL.Add(' WHERE Id_Users = ' +  Trim(IntToStr(Form_Menu.public_User)) + ' ' );
    var_SQL.Add('   AND Id_Menus  = ' +  Trim(IntToStr(param_Menu)) + ' ' );
    var_SQL.Add(   'AND Del_WHEN IS NULL ' );
    var_SQL.Add(' ORDER BY Id_Users, Id_Menus ' );

  { ****************************************************************************
    Abrimos la tabla
    **************************************************************************** }
    var_SQLQuery := TSQLQuery.Create(nil);

    if UTI_TB_Abrir( '', '', '',
                     var_SQLConnector,
                     var_SQLTransaction,
                     var_SQLQuery,
                     -1, // asi me trae todos los registros de golpe
                     var_SQL.Text ) = False then Application.Terminate;

  { ****************************************************************************
    TRABAJAMOS CON LOS REGISTROS DEVUELTOS
    ****************************************************************************
    Si el módulo no se creó, no se permite entrar en él ... Result := False
    **************************************************************************** }
    Result := False;
    if Trim(UpperCase(var_SQLQuery.FieldByName('Forcing_Why_Delete').AsString)) = 'S' then
    begin
        Result := True;
    end;

  { ****************************************************************************
    Cerramos la tabla
    **************************************************************************** }
    if UTI_TB_Cerrar( var_SQLConnector,
                      var_SQLTransaction,
                      var_SQLQuery ) = false then Application.Terminate;

    var_SQLQuery.Free;

    var_SQL.Free;

  { ****************************************************************************
    Cerramos La transacción y la conexión con la BD
    **************************************************************************** }
    if UTI_CN_Cerrar( var_SQLTransaction,
                      var_SQLConnector ) = False then Application.Terminate;

    var_SQLTransaction.Free;
    var_SQLConnector.Free;
end;

end.

