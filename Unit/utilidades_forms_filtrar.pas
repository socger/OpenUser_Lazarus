unit utilidades_forms_Filtrar;

{$mode objfpc}{$H+}

interface

uses
    Dialogs, sqldb, db, Forms, Classes, SysUtils, utilidades_usuarios, utilidades_general;

type

    TRecord_Rgtro_Comun = record
        { COMUN A TODAS LAS TABLAS }
        Id             : ShortString;

        Insert_WHEN    : ShortString;
        Insert_Id_User : ShortString;

        Del_WHEN       : ShortString;
        Del_Id_User    : ShortString;
        Del_WHY        : ShortString;

        Change_WHEN    : ShortString;
        Change_Id_User : ShortString;

        { MENUS }
        MENUS_Descripcion : ShortString;
        MENUS_Id_Menus    : ShortString;

        { USERS }
        USERS_Descripcion_Nick : ShortString;
        USERS_Id_Empleados     : ShortString;
        USERS_Permiso_Total_SN : ShortString;

        { USERS_PASSWORDS }
        USERS_PASSWORDS_Id_Users               : ShortString;
        USERS_PASSWORDS_Password               : ShortString;
        USERS_PASSWORDS_Password_Expira_SN     : ShortString;
        USERS_PASSWORDS_Password_Expira_Inicio : ShortString;
        USERS_PASSWORDS_Password_Expira_Fin    : ShortString;
        USERS_PASSWORDS_Obligado_NICK_SN       : ShortString;

        { USERS_MENUS }
        USERS_MENUS_Id_Users           : ShortString;
        USERS_MENUS_Id_Menus           : ShortString;
        USERS_MENUS_Forcing_Why_Delete : ShortString;

        { USERS_MENUS_PERMISSIONS }
        USERS_MENUS_PERMISSIONS_Id_Users    : ShortString;
        USERS_MENUS_PERMISSIONS_Id_Menus    : ShortString;
        USERS_MENUS_PERMISSIONS_Tipo_CRUD   : ShortString;
        USERS_MENUS_PERMISSIONS_Descripcion : ShortString;
        USERS_MENUS_PERMISSIONS_PermisoSN   : ShortString;

        { PELICULAS }
        PELICULAS_titulo   : ShortString;
        PELICULAS_id_medio : ShortString;
        PELICULAS_Numero   : ShortString;

        { MEDIOS }
        MEDIOS_descripcion : ShortString;
    end;

    function UTI_Abrir_Form( param_Elegimos, param_Solo_Ver : Boolean; param_Campo : ShortString; param_Menu_Worked : Integer ) : TRecord_Rgtro_Comun;
    function UTI_Vaciar_Record : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Comunes(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Medios(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Pelis(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Usuarios(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Usuarios_Passwords(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Usuarios_Menus(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Usuarios_Menus_Permisos(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
    function UTI_Asignar_Fields_Menus(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;

implementation

uses users_000, menus_000, medios_000, peliculas_000;

function UTI_Vaciar_Record : TRecord_Rgtro_Comun;
begin
     Result.Id             := '';

     Result.Insert_WHEN    := '';
     Result.Insert_Id_User := '';

     Result.Del_WHEN       := '';
     Result.Del_Id_User    := '';
     Result.Del_WHY        := '';

     Result.Change_WHEN    := '';
     Result.Change_Id_User := '';

     // MENUS
     Result.MENUS_Descripcion := '';
     Result.MENUS_Id_Menus    := '';

     // USERS
     Result.USERS_Descripcion_Nick := '';
     Result.USERS_Id_Empleados     := '';
     Result.USERS_Permiso_Total_SN := '';

     // USERS_MENUS_PERMISSIONS
     Result.USERS_MENUS_PERMISSIONS_Id_Users    := '';
     Result.USERS_MENUS_PERMISSIONS_Id_Menus    := '';
     Result.USERS_MENUS_PERMISSIONS_Tipo_CRUD   := '';
     Result.USERS_MENUS_PERMISSIONS_Descripcion := '';
     Result.USERS_MENUS_PERMISSIONS_PermisoSN   := '';

     // USERS_PASSWORDS
     Result.USERS_PASSWORDS_Id_Users               := '';
     Result.USERS_PASSWORDS_Password               := '';
     Result.USERS_PASSWORDS_Password_Expira_SN     := '';
     Result.USERS_PASSWORDS_Password_Expira_Inicio := '';
     Result.USERS_PASSWORDS_Password_Expira_Fin    := '';
     Result.USERS_PASSWORDS_Obligado_NICK_SN       := '';

     // USERS_MENUS
     Result.USERS_MENUS_Id_Users           := '';
     Result.USERS_MENUS_Id_Menus           := '';
     Result.USERS_MENUS_Forcing_Why_Delete := '';

     // PELICULAS
     Result.PELICULAS_titulo   := '';
     Result.PELICULAS_id_medio := '';
     Result.PELICULAS_Numero   := '';

     // MEDIOS
     Result.MEDIOS_descripcion := '';
end;

function UTI_Asignar_Fields_Comunes(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Vaciar_Record;

    with param_SQLQuery do
    begin
        if not FieldByName('id').IsNull             then Result.Id                 := FieldByName('id').AsString;

        if not FieldByName('Insert_WHEN').IsNull    then Result.Insert_WHEN        := FieldByName('Insert_WHEN').AsString;
        if not FieldByName('Insert_Id_User').IsNull then Result.Insert_Id_User     := FieldByName('Insert_Id_User').AsString;
        if not FieldByName('Del_WHEN').IsNull       then Result.Del_WHEN           := FieldByName('Del_WHEN').AsString;
        if not FieldByName('Del_Id_User').IsNull    then Result.Del_Id_User        := FieldByName('Del_Id_User').AsString;
        if not FieldByName('Del_WHY').IsNull        then Result.Del_WHY            := FieldByName('Del_WHY').AsString;
        if not FieldByName('Change_WHEN').IsNull    then Result.Change_WHEN        := FieldByName('Change_WHEN').AsString;
        if not FieldByName('Change_Id_User').IsNull then Result.Change_Id_User     := FieldByName('Change_Id_User').AsString;
    end;
end;

function UTI_Asignar_Fields_Pelis(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('titulo').IsNull   then Result.PELICULAS_titulo   := FieldByName('titulo').AsString;
        if not FieldByName('id_medio').IsNull then Result.PELICULAS_id_medio := FieldByName('id_medio').AsString;
        if not FieldByName('Numero').IsNull   then Result.PELICULAS_Numero   := FieldByName('Numero').AsString;
    end;
end;

function UTI_Asignar_Fields_Medios(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('descripcion').IsNull then Result.MEDIOS_descripcion := FieldByName('descripcion').AsString;
    end;
end;

function UTI_Asignar_Fields_Usuarios(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('Descripcion_Nick').IsNull then Result.USERS_Descripcion_Nick := FieldByName('Descripcion_Nick').AsString;
        if not FieldByName('Id_Empleados').IsNull     then Result.USERS_Id_Empleados     := FieldByName('Id_Empleados').AsString;
        if not FieldByName('Permiso_Total_SN').IsNull then Result.USERS_Permiso_Total_SN := FieldByName('Permiso_Total_SN').AsString;
    end;
end;

function UTI_Asignar_Fields_Menus(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('Descripcion').IsNull then Result.MENUS_Descripcion := FieldByName('Descripcion').AsString;
        if not FieldByName('Id_Menus').IsNull    then Result.MENUS_Id_Menus    := FieldByName('Id_Menus').AsString;
    end;
end;

function UTI_Abrir_Form( param_Elegimos,
                         param_Solo_Ver : Boolean;
                         param_Campo : ShortString;
                         param_Menu_Worked : Integer ) : TRecord_Rgtro_Comun;
var var_msg : TStrings;
begin
     var_msg := TStringList.Create;
     var_msg.Clear;

   { ***********************************************************************************************
     EMPEZAMOS A VER A QUE MODULO LLAMAREMOS
     *********************************************************************************************** }
     { MEDIOS }
     If ( Pos( UpperCase('id_medio'), UpperCase(Trim(param_Campo)) ) <> 0 ) or
        ( param_Menu_Worked = 10 )                                          then
     begin
          if UTI_usr_Permiso_SN(param_Menu_Worked, '', True) = true then
          begin
              if UTI_GEN_Form_Abierto_Ya('Form_medios_000') = false then
                  begin
                      Application.CreateForm(TForm_medios_000, Form_medios_000);
                      Form_medios_000.public_Solo_Ver    := param_Solo_Ver;
                      Form_medios_000.public_Elegimos    := param_Elegimos;
                      Form_medios_000.public_Menu_Worked := param_Menu_Worked;
                      Form_medios_000.ShowModal;

                      if form_medios_000.public_Rgtro_Seleccionado = true then
                      begin
                          Result := UTI_Asignar_Fields_Medios(Form_medios_000.SQLQuery_Medios);
                      end;

                      Form_medios_000.Free;
                  end
              else var_msg.Add('Módulo ya abierto, no puedo abrirlo dos veces.');
          end;
     end;

     { PELICULAS }
     If ( Pos( UpperCase('id_pelicula'), UpperCase(Trim(param_Campo)) ) <> 0 ) or
        ( param_Menu_Worked = 20 )                                             then
     begin
          if UTI_usr_Permiso_SN(param_Menu_Worked, '', True) = true then
          begin
              if UTI_GEN_Form_Abierto_Ya('Form_peliculas_000') = false then
                  begin
                      Application.CreateForm(TForm_peliculas_000, Form_peliculas_000);
                      //var_Form_peliculas_000 := TForm_peliculas_000.Create(nil);
                      Form_peliculas_000.public_Solo_Ver    := param_Solo_Ver;
                      Form_peliculas_000.public_Elegimos    := param_Elegimos;
                      Form_peliculas_000.public_Menu_Worked := param_Menu_Worked;
                      Form_peliculas_000.ShowModal;

                      if Form_peliculas_000.public_Rgtro_Seleccionado = true then
                      begin
                          Result := UTI_Asignar_Fields_Pelis(Form_peliculas_000.SQLQuery_Pelis);
                      end;

                      Form_peliculas_000.Free;
                  end
              else var_msg.Add('Módulo ya abierto, no puedo abrirlo dos veces.');
          end;
     end;

     { USUARIOS }
     If ( Pos( UpperCase('Id_Users'), UpperCase(Trim(param_Campo)) ) <> 0 ) or
        ( param_Menu_Worked = 30 )                                          then
     begin
          if UTI_usr_Permiso_SN(param_Menu_Worked, '', True) = true then
          begin
              if UTI_GEN_Form_Abierto_Ya('Form_users_000') = false then
                  begin
                      Application.CreateForm(TForm_users_000, Form_users_000);
                      Form_users_000.public_Solo_Ver    := param_Solo_Ver;
                      Form_users_000.public_Elegimos    := param_Elegimos;
                      Form_users_000.public_Menu_Worked := param_Menu_Worked;
                      Form_users_000.ShowModal;

                      if Form_users_000.public_Rgtro_Seleccionado = true then
                      begin
                          Result := UTI_Asignar_Fields_Usuarios(Form_users_000.SQLQuery_Users);
                      end;

                      Form_users_000.Free;
                  end
              else var_msg.Add('Módulo ya abierto, no puedo abrirlo dos veces.');
          end;
     end;

     { MENUS }
     If ( Pos( UpperCase('Id_Menus'), UpperCase(Trim(param_Campo)) ) <> 0 ) or
        ( param_Menu_Worked = 40 )                                          then
     begin
          if UTI_usr_Permiso_SN(param_Menu_Worked, '', True) = true then
          begin
             if UTI_GEN_Form_Abierto_Ya('Form_menus_000') = false then
                  begin
                      Application.CreateForm(TForm_menus_000, Form_menus_000);
                      Form_menus_000.public_Solo_Ver    := param_Solo_Ver;
                      Form_menus_000.public_Elegimos    := param_Elegimos;
                      Form_menus_000.public_Menu_Worked := param_Menu_Worked;
                      Form_menus_000.ShowModal;

                     if Form_menus_000.public_Rgtro_Seleccionado = true then
                     begin
                          Result := UTI_Asignar_Fields_Menus(Form_menus_000.SQLQuery_Menus);
                          {
                          Result := UTI_Asignar_Fields_Comunes(Form_menus_000.SQLQuery_Menus);
                          with Form_menus_000.SQLQuery_Menus do
                          begin
                              if not FieldByName('Descripcion').IsNull    then Result.MENUS_Descripcion := FieldByName('Descripcion').AsString;
                              if not FieldByName('Id_Menus').IsNull       then Result.MENUS_Id_Menus    := FieldByName('Id_Menus').AsString;
                          end;
                          }
                     end;

                      Form_menus_000.Free;
                  end
              else var_msg.Add('Módulo ya abierto, no puedo abrirlo dos veces.');
          end;
     end;

   { ***********************************************************************************************
     EL MODULO QUE QUERIAMOS LLAMAR YA ESTABA ABIERTO, NO PERMITIMOS ABRIRLO DOS VECES
     *********************************************************************************************** }
     if Trim(var_msg.Text) <> '' then
     begin
          UTI_GEN_Aviso(var_msg, 'YA ABIERTO', True, False);
     end;

     var_msg.Free;
end;

function UTI_Asignar_Fields_Usuarios_Passwords(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('Id_Users').IsNull               then Result.USERS_PASSWORDS_Id_Users               := FieldByName('Id_Users').AsString;
        if not FieldByName('Password').IsNull               then Result.USERS_PASSWORDS_Password               := FieldByName('Password').AsString;
        if not FieldByName('Password_Expira_SN').IsNull     then Result.USERS_PASSWORDS_Password_Expira_SN     := FieldByName('Password_Expira_SN').AsString;
        if not FieldByName('Password_Expira_Inicio').IsNull then Result.USERS_PASSWORDS_Password_Expira_Inicio := FieldByName('Password_Expira_Inicio').AsString;
        if not FieldByName('Password_Expira_Fin').IsNull    then Result.USERS_PASSWORDS_Password_Expira_Fin    := FieldByName('Password_Expira_Fin').AsString;
        if not FieldByName('Obligado_NICK_SN').IsNull       then Result.USERS_PASSWORDS_Obligado_NICK_SN       := FieldByName('Obligado_NICK_SN').AsString;
    end;
end;

function UTI_Asignar_Fields_Usuarios_Menus(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('Id_Users').IsNull               then Result.USERS_MENUS_Id_Users               := FieldByName('Id_Users').AsString;
        if not FieldByName('Id_Menus').IsNull               then Result.USERS_MENUS_Id_Menus               := FieldByName('Id_Menus').AsString;
        if not FieldByName('Forcing_Why_Delete').IsNull     then Result.USERS_MENUS_Forcing_Why_Delete     := FieldByName('Forcing_Why_Delete').AsString;
    end;
end;

function UTI_Asignar_Fields_Usuarios_Menus_Permisos(param_SQLQuery : TSQLQuery) : TRecord_Rgtro_Comun;
begin
    Result := UTI_Asignar_Fields_Comunes(param_SQLQuery);
    with param_SQLQuery do
    begin
        if not FieldByName('Id_Users').IsNull    then Result.USERS_MENUS_PERMISSIONS_Id_Users    := FieldByName('Id_Users').AsString;
        if not FieldByName('Id_Menus').IsNull    then Result.USERS_MENUS_PERMISSIONS_Id_Menus    := FieldByName('Id_Menus').AsString;
        if not FieldByName('Tipo_CRUD').IsNull   then Result.USERS_MENUS_PERMISSIONS_Tipo_CRUD   := FieldByName('Tipo_CRUD').AsString;
        if not FieldByName('Descripcion').IsNull then Result.USERS_MENUS_PERMISSIONS_Descripcion := FieldByName('Descripcion').AsString;
        if not FieldByName('PermisoSN').IsNull   then Result.USERS_MENUS_PERMISSIONS_PermisoSN   := FieldByName('PermisoSN').AsString;
    end;
end;

end.


