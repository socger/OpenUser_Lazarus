unit users_000;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
    utilidades_usuarios, utilidades_rgtro, utilidades_bd, utilidades_general, ExtCtrls, DBGrids,
    variants, DbCtrls, Grids;

type

    { Tform_users_000 }

    Tform_users_000 = class(TForm)
        BitBtn_Filtrar: TBitBtn;
        BitBtn_Imprimir: TBitBtn;
        BitBtn_Seleccionar: TBitBtn;
        BitBtn_Ver_Situacion_Registro: TBitBtn;
        DataSource_Users: TDataSource;
        DataSource_Users_Menus_Permisos: TDataSource;
        DataSource_Users_Passwords: TDataSource;
        DataSource_Users_Menus: TDataSource;
        DBGrid_Principal: TDBGrid;
        DBNavigator1: TDBNavigator;
        Image_Confirmado: TImage;
        Memo_Filtros: TMemo;
        Memo_OrderBy: TMemo;
        RadioGroup_Bajas: TRadioGroup;
        BitBtn_SALIR: TBitBtn;
        SQLQuery_Users: TSQLQuery;
        SQLQuery_UsersChange_Id_User: TLargeintField;
        SQLQuery_UsersChange_WHEN: TDateTimeField;
        SQLQuery_UsersDel_Id_User: TLargeintField;
        SQLQuery_UsersDel_WHEN: TDateTimeField;
        SQLQuery_UsersDel_WHY: TStringField;
        SQLQuery_UsersDescripcion_Nick: TStringField;
        SQLQuery_Usersid: TLargeintField;
        SQLQuery_UsersId_Empleados: TLargeintField;
        SQLQuery_UsersInsert_Id_User: TLargeintField;
        SQLQuery_UsersInsert_WHEN: TDateTimeField;
        SQLQuery_UsersPermiso_Total_SN: TStringField;
        SQLQuery_Users_Menus_Permisos: TSQLQuery;
        SQLQuery_Users_MenusChange_Id_User: TLargeintField;
        SQLQuery_Users_MenusChange_WHEN: TDateTimeField;
        SQLQuery_Users_MenusDel_Id_User: TLargeintField;
        SQLQuery_Users_MenusDel_WHEN: TDateTimeField;
        SQLQuery_Users_MenusDel_WHY: TStringField;
        SQLQuery_Users_MenusForcing_Why_Delete: TStringField;
        SQLQuery_Users_Menusid: TLargeintField;
        SQLQuery_Users_MenusId_Menus: TLargeintField;
        SQLQuery_Users_MenusId_Users: TLargeintField;
        SQLQuery_Users_MenusInsert_Id_User: TLargeintField;
        SQLQuery_Users_MenusInsert_WHEN: TDateTimeField;
        SQLQuery_Users_MenusOT_Descripcion_Menu: TStringField;
        SQLQuery_Users_MenusOT_Descripcion_Nick: TStringField;
        SQLQuery_Users_Menus_PermisosDescripcion: TStringField;
        SQLQuery_Users_Menus_Permisosid: TLargeintField;
        SQLQuery_Users_Menus_PermisosPermisoSN: TStringField;
        SQLQuery_Users_Menus_PermisosTipo_CRUD_Descripcion1: TStringField;
        SQLQuery_Users_Passwords: TSQLQuery;
        SQLQuery_Users_Menus: TSQLQuery;
        SQLQuery_Users_PasswordsChange_Id_User: TLargeintField;
        SQLQuery_Users_PasswordsChange_WHEN: TDateTimeField;
        SQLQuery_Users_PasswordsDel_Id_User: TLargeintField;
        SQLQuery_Users_PasswordsDel_WHEN: TDateTimeField;
        SQLQuery_Users_PasswordsDel_WHY: TStringField;
        SQLQuery_Users_Passwordsid: TLargeintField;
        SQLQuery_Users_PasswordsId_Users: TLargeintField;
        SQLQuery_Users_PasswordsInsert_Id_User: TLargeintField;
        SQLQuery_Users_PasswordsInsert_WHEN: TDateTimeField;
        SQLQuery_Users_PasswordsObligado_NICK_SN: TStringField;
        SQLQuery_Users_PasswordsOT_Descripcion_Nick: TStringField;
        SQLQuery_Users_PasswordsPassword: TStringField;
        SQLQuery_Users_PasswordsPassword_Expira_Fin: TDateTimeField;
        SQLQuery_Users_PasswordsPassword_Expira_Inicio: TDateTimeField;
        SQLQuery_Users_PasswordsPassword_Expira_SN: TStringField;
        SQLQuery_Users_Menus_PermisosChange_Id_User: TLargeintField;
        SQLQuery_Users_Menus_PermisosChange_WHEN: TDateTimeField;
        SQLQuery_Users_Menus_PermisosDel_Id_User: TLargeintField;
        SQLQuery_Users_Menus_PermisosDel_WHEN: TDateTimeField;
        SQLQuery_Users_Menus_PermisosDel_WHY: TStringField;
        SQLQuery_Users_Menus_PermisosId_Menus: TLargeintField;
        SQLQuery_Users_Menus_PermisosId_Users: TLargeintField;
        SQLQuery_Users_Menus_PermisosInsert_Id_User: TLargeintField;
        SQLQuery_Users_Menus_PermisosInsert_WHEN: TDateTimeField;
        SQLQuery_Users_Menus_PermisosOT_Descripcion_Menu: TStringField;
        SQLQuery_Users_Menus_PermisosOT_Descripcion_Nick: TStringField;
        SQLQuery_Users_Menus_PermisosTipo_CRUD: TStringField;

        function  Filtrar_users_passwords( param_Last_Column : TColumn; param_ver_bajas : ShortInt; param_Cambiamos_Filtro : Boolean; param_Lineas_Filtro, param_Lineas_OrderBy : TStrings ) : ShortInt;
        function  Filtrar_users_menus( param_Last_Column : TColumn; param_ver_bajas : ShortInt; param_Cambiamos_Filtro : Boolean; param_Lineas_Filtro, param_Lineas_OrderBy : TStrings ) : ShortInt;
        function  Filtrar_users_menus_permisos( param_Last_Column : TColumn; param_ver_bajas : ShortInt; param_Cambiamos_Filtro : Boolean; param_Lineas_Filtro, param_Lineas_OrderBy : TStrings ) : ShortInt;
        function  Filtrar_Principal( param_Cambiamos_Filtro : Boolean ) : ShortInt;
        procedure Refrescar_Registros;
        procedure Refrescar_Registros_Passwords;
        procedure Refrescar_Registros_Menus;
        procedure Refrescar_Registros_Menus_Permisos;
        procedure SQLQuery_Users_Menus_PermisosAfterPost(DataSet: TDataSet);
        procedure Presentar_Datos;
        procedure DBGrid_PrincipalTitleClick(Column: TColumn);
        procedure Filtrar_tablas_ligadas;
        procedure Filtrar_tablas_ligadas_Menus;
        procedure Cerramos_Tablas;
        procedure Cerramos_Tablas_Ligadas;
        procedure FormDestroy(Sender: TObject);
        procedure no_Tocar;
        procedure Dibujar_Grid( param_Sender: TObject; param_SQLQuery : TSQLQuery; param_Rect: TRect; param_DataCol: Integer; param_Column: TColumn; param_State: TGridDrawState );
        procedure Seleccionado_Rgtro;
        procedure Editar_Registro;
        procedure Insertar_Registro;

        procedure BitBtn_ImprimirClick(Sender: TObject);
        procedure BitBtn_SALIRClick(Sender: TObject);
        procedure BitBtn_SeleccionarClick(Sender: TObject);
        procedure BitBtn_Ver_Situacion_RegistroClick(Sender: TObject);
        procedure DBGrid_PrincipalCellClick(Column: TColumn);
        procedure DBGrid_PrincipalDblClick(Sender: TObject);
        procedure DBGrid_PrincipalDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
        procedure DBGrid_PrincipalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure DBGrid_PrincipalKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
        procedure DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType);
        procedure BitBtn_FiltrarClick(Sender: TObject);
        procedure FormActivate(Sender: TObject);
        procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
        procedure FormCreate(Sender: TObject);
        procedure RadioGroup_BajasClick(Sender: TObject);
        procedure SQLQuery_UsersAfterPost(DataSet: TDataSet);
        procedure SQLQuery_UsersAfterScroll(DataSet: TDataSet);
        procedure SQLQuery_UsersBeforePost(DataSet: TDataSet);
        procedure SQLQuery_Users_MenusAfterPost(DataSet: TDataSet);
        procedure SQLQuery_Users_MenusAfterScroll(DataSet: TDataSet);
        procedure SQLQuery_Users_MenusBeforePost(DataSet: TDataSet);
        procedure SQLQuery_Users_Menus_PermisosBeforePost(DataSet: TDataSet);
        procedure SQLQuery_Users_Menus_PermisosCalcFields(DataSet: TDataSet);
        procedure SQLQuery_Users_PasswordsAfterPost(DataSet: TDataSet);
        procedure SQLQuery_Users_PasswordsBeforePost(DataSet: TDataSet);
    private
        { private declarations }
        private_Salir_OK           : Boolean;
        private_Last_Column        : TColumn;
        private_Order_By           : array of TOrder_By;
        private_Order_By_Menus     : array of TOrder_By;
        private_Order_By_passwords : array of TOrder_By;
        private_Order_By_permisos  : array of TOrder_By;
    public
        { public declarations }
        public_Solo_Ver                   : Boolean;
        public_Elegimos                   : Boolean;
        public_Menu_Worked                : Integer;
        public_Rgtro_Seleccionado         : Boolean;
        public_Last_Column_Password       : TColumn;
        public_Last_Column_Menus          : TColumn;
        public_Last_Column_Menus_Permisos : TColumn;
    end;

var
    form_users_000: Tform_users_000;

implementation

{$R *.lfm}

uses dm_users, menu, informe, users_001;

{ Tform_users_000 }

procedure Tform_users_000.FormCreate(Sender: TObject);
begin
  { ****************************************************************************
    Obligado en cada formulario para no olvidarlo
    **************************************************************************** }
    with Self do
    begin
        Position    := poScreenCenter;
        BorderIcons := [];
        BorderStyle := bsSingle;
    end;

    private_Salir_OK := false;

  { ****************************************************************************
    Solo para formularios que traten con datos
    **************************************************************************** }
    DBGrid_Principal.TitleImageList := Form_Menu.ImageList_Grid_Sort;
    public_Solo_Ver                 := false;
    public_Elegimos                 := false;

    public_Rgtro_Seleccionado       := false;

    if UTI_GEN_Form_Abierto_Ya('DataModule_Users') = False then
    begin
        DataModule_Users := TDataModule_Users.Create(Application);
    end;

  { ****************************************************************************
    Preparamos los diferentes tipos de orden preconfigurados
    **************************************************************************** }
    // USERS
    SetLength(private_Order_By, 2);

    private_Order_By[0].Titulo       := 'Por la descripción'; // El índice 0 siempre será por el que empezará la aplicación y los filtros
    private_Order_By[0].Memo_OrderBy := 'u.Descripcion_Nick ASC';

    private_Order_By[1].Titulo       := 'Por la id';
    private_Order_By[1].Memo_OrderBy := 'u.id ASC';

    Memo_OrderBy.Lines.Text          := private_Order_By[0].Memo_OrderBy;

    // USERS_MENUS
    SetLength(private_Order_By_Menus, 2);

    private_Order_By_Menus[0].Titulo       := 'Por Menú'; // El índice 0 siempre será por el que empezará la aplicación y los filtros
    private_Order_By_Menus[0].Memo_OrderBy := 'um.Id_Users ASC, um.Id_Menus ASC';

    private_Order_By_Menus[1].Titulo       := 'Por la id';
    private_Order_By_Menus[1].Memo_OrderBy := 'um.id ASC';

    // USERS_PASSWORDS
    SetLength(private_Order_By_passwords, 2);

    private_Order_By_passwords[0].Titulo       := 'Por Password'; // El índice 0 siempre será por el que empezará la aplicación y los filtros
    private_Order_By_passwords[0].Memo_OrderBy := 'up.Id_Users ASC, up.Password ASC';

    private_Order_By_passwords[1].Titulo       := 'Por la id';
    private_Order_By_passwords[1].Memo_OrderBy := 'up.id ASC';

    // USERS_PERMISSIONS
    SetLength(private_Order_By_permisos, 2);

    private_Order_By_permisos[0].Titulo       := 'Por Password'; // El índice 0 siempre será por el que empezará la aplicación y los filtros
    private_Order_By_permisos[0].Memo_OrderBy := 'upe.Id_Users ASC, upe.Id_Menus ASC, upe.Tipo_CRUD ASC';

    private_Order_By_permisos[1].Titulo       := 'Por la id';
    private_Order_By_permisos[1].Memo_OrderBy := 'upe.id ASC';

  { ****************************************************************************
    Filtramos los datos
    **************************************************************************** }
    RadioGroup_Bajas.ItemIndex := Filtrar_Principal( false );

    Presentar_Datos;
end;

procedure Tform_users_000.FormActivate(Sender: TObject);
begin
    If public_Elegimos = true then
    begin
         BitBtn_Seleccionar.Visible := True;
         BitBtn_Imprimir.Visible  := False;
    end;

    if public_Solo_Ver = true then no_Tocar;
end;

procedure Tform_users_000.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    if private_Salir_OK = False then
        begin
          { ********************************************************************
            Intento BitBtn_SALIR de la aplicación de un modo no permitido
            ******************************************************************** }
            CloseAction := caNone;
        end
    else
        begin
          { ********************************************************************
            Fue correcto el modo como quiere BitBtn_SALIR de la aplicación
            ******************************************************************** }
        end;
end;

procedure Tform_users_000.Cerramos_Tablas;
begin
    Cerramos_Tablas_Ligadas;

    if UTI_TB_Cerrar( DataModule_Users.SQLConnector_Users,
                      DataModule_Users.SQLTransaction_Users,
                      SQLQuery_Users ) = false then
    begin
        Application.Terminate;
    end;

    FreeAndNil(DataModule_Users);
end;

procedure Tform_users_000.Cerramos_Tablas_Ligadas;
begin
    if UTI_TB_Cerrar( DataModule_Users.SQLConnector_Users_Passwords,
                      DataModule_Users.SQLTransaction_Users_Passwords,
                      SQLQuery_Users_Passwords ) = false then
    begin
        Application.Terminate;
    end;

    //jerofa faltan tablas por cerrar
end;

procedure Tform_users_000.FormDestroy(Sender: TObject);
begin
    Cerramos_Tablas;
end;

procedure Tform_users_000.BitBtn_FiltrarClick(Sender: TObject);
begin
    RadioGroup_Bajas.ItemIndex := Filtrar_Principal( true );
end;

procedure Tform_users_000.RadioGroup_BajasClick(Sender: TObject);
begin
    Refrescar_Registros;
end;

procedure Tform_users_000.BitBtn_SALIRClick(Sender: TObject);
begin
    private_Salir_OK := true;  { La pongo a true para controlar el modo de BitBtn_SALIR del programa}

    Close;
end;

procedure Tform_users_000.BitBtn_SeleccionarClick(Sender: TObject);
begin
    Seleccionado_Rgtro;
end;

procedure Tform_users_000.DBGrid_PrincipalDblClick(Sender: TObject);
begin
    If public_Elegimos then
         Seleccionado_Rgtro
    else Editar_Registro;
end;

procedure Tform_users_000.DBGrid_PrincipalDrawColumnCell(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
    Dibujar_Grid( Sender, SQLQuery_Users, Rect, DataCol, Column, State );
end;

procedure Tform_users_000.DBGrid_PrincipalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key = 13 then
    begin
        If public_Elegimos then
             Seleccionado_Rgtro
        else Editar_Registro;
    end;
end;

procedure Tform_users_000.SQLQuery_UsersAfterPost(DataSet: TDataSet);
begin
    UTI_RGTRO_Grabar( DataModule_Users.SQLTransaction_Users, SQLQuery_Users );
    Refrescar_Registros;
end;

procedure Tform_users_000.SQLQuery_UsersBeforePost(DataSet: TDataSet);
begin
    UTI_RGTRO_param_assign_value( SQLQuery_Users );
end;

procedure Tform_users_000.SQLQuery_Users_MenusAfterPost(DataSet: TDataSet);
begin
    UTI_RGTRO_Grabar( DataModule_Users.SQLTransaction_Users_Menus, SQLQuery_Users_Menus );
    Refrescar_Registros_Menus;
end;

procedure Tform_users_000.SQLQuery_Users_MenusBeforePost(DataSet: TDataSet);
begin
    UTI_RGTRO_param_assign_value( SQLQuery_Users_Menus );
end;

procedure Tform_users_000.SQLQuery_Users_Menus_PermisosBeforePost(DataSet: TDataSet);
begin
    UTI_RGTRO_param_assign_value( SQLQuery_Users_Menus_Permisos );
end;

procedure Tform_users_000.SQLQuery_Users_PasswordsAfterPost(DataSet: TDataSet);
begin
    UTI_RGTRO_Grabar( DataModule_Users.SQLTransaction_Users_Passwords, SQLQuery_Users_Passwords );
    Refrescar_Registros_Passwords;
end;

procedure Tform_users_000.SQLQuery_Users_PasswordsBeforePost(DataSet: TDataSet);
begin
    UTI_RGTRO_param_assign_value( SQLQuery_Users_Passwords );
end;

procedure Tform_users_000.BitBtn_Ver_Situacion_RegistroClick(Sender: TObject);
begin
    if UTI_usr_Permiso_SN(public_Menu_Worked, '', True) = True then
    begin
        if SQLQuery_Users.RecordCount > 0 then UTI_RGTRO_Ver_Estado_Registro( SQLQuery_Users, DataSource_Users, DBGrid_Principal );
    end;
end;

procedure Tform_users_000.BitBtn_ImprimirClick(Sender: TObject);
var var_msg          : TStrings;
    var_form_Informe : Tform_Informe;
begin
    if UTI_usr_Permiso_SN(public_Menu_Worked, 'I', True) = True then
    begin
        if public_Solo_Ver = True then
        begin
            var_msg := TStringList.Create;
            var_msg.Add('Sólo se puede visualizar.');
            UTI_GEN_Aviso(var_msg, 'SOLO PARA OBSERVAR', True, False);
            FreeAndNil(var_msg);
            Exit;
        end;

        var_form_Informe := Tform_Informe.Create(nil);
        var_form_Informe.frDBDataSet1.DataSource := DataSource_Users;
        var_form_Informe.public_Menu_Worked      := public_Menu_Worked;
        var_form_Informe.public_informe          := 'informes/users.lrf';
        var_form_Informe.ShowModal;
        FreeAndNil(var_form_Informe);
    end;
end;

procedure Tform_users_000.no_Tocar;
begin
     BitBtn_Imprimir.Enabled := False;
end;

procedure Tform_users_000.Dibujar_Grid( param_Sender: TObject;
                                        param_SQLQuery : TSQLQuery;
                                        param_Rect: TRect;
                                        param_DataCol: Integer;
                                        param_Column: TColumn;
                                        param_State: TGridDrawState );
var var_Color_Normal : TColor;
begin
    with param_Sender as TDBGrid do
    begin
        if param_SQLQuery.RecordCount = 0 then Exit;

        var_Color_Normal := Canvas.Brush.Color;

      { ************************************************************************
        Primero comprobamos si es un registro dado de baja o no
        ************************************************************************ }
        if not param_SQLQuery.FieldByName('Del_WHEN').IsNull then
            begin
              { ****************************************************************
                Registro DADO de BAJA
                **************************************************************** }
                Canvas.Font.Color := clSilver;
            end
        else
            begin
              { ****************************************************************
                Registro DADO de ALTA, NO BAJA
                ****************************************************************
                Así que las pinto, pero sólo si no son las columnas que van a
                ser dibujadas
                **************************************************************** }
                if param_State <> [gdSelected] then
                begin
                    if (param_Column.FieldName <> 'COLUMNA_CON_IMAGEN') then
                    begin
                        Canvas.font.Color := clBlack;
                    end;
                end;
            end;

      { ************************************************************************
        Ahora paso a dibujar una celda normal con los colores elegidos o una
        dibujada
        ************************************************************************ }
        if (param_Column.FieldName <> 'COLUMNA_CON_IMAGEN') then
            begin
              { ****************************************************************
                No es una de las columnas a dibujar por lo que la pinto con los
                colores elegidos
                **************************************************************** }
                DefaultDrawColumnCell(param_Rect, param_DataCol, param_Column, param_State)
            end
        else
            begin
              { ****************************************************************
                Es una de las columnas a dibujar
                **************************************************************** }
                // COLUMNA CONFIRMADA
                if param_Column.FieldName = 'COLUMNA_CON_IMAGEN'  then
                begin
                    {
                    if Trim(param_SQLQuery.FieldByName('id_medio').asString) = '1' then
                    begin
                        Canvas.StretchDraw(param_Rect, Image_Confirmado.Picture.Graphic);
                    end;
                    }
                end;
            end;

        Canvas.Font.Color := var_Color_Normal;
    end;
end;

procedure Tform_users_000.Seleccionado_Rgtro;
begin
    private_Salir_OK          := true;  { La pongo a true para controlar el modo de BitBtn_SALIR del programa}
    public_Rgtro_Seleccionado := true;
    Close;
end;

procedure Tform_users_000.DBGrid_PrincipalCellClick(Column: TColumn);
begin
    //Filtrar_tablas_ligadas;
end;

procedure Tform_users_000.DBGrid_PrincipalKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if (key = 40) or
       (key = 38) then
    begin
         //Filtrar_tablas_ligadas;
    end;
end;

procedure Tform_users_000.DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType);
begin
    //Filtrar_tablas_ligadas;

    case Button of
        nbInsert : begin
            Insertar_Registro;
            Abort;
        end;

        nbEdit : begin
            Editar_Registro;
            Abort;
        end;

        nbDelete : begin
            if UTI_usr_Permiso_SN(public_Menu_Worked, 'B', True) = True then
            begin
                UTI_RGTRO_Borrar( SQLQuery_Users,
                                  public_Solo_Ver,
                                  public_Menu_Worked );
            end;
            Abort;
        end;

        nbRefresh : begin
            Refrescar_Registros;
            Abort;
        end;
    end;
end;

procedure Tform_users_000.SQLQuery_UsersAfterScroll(DataSet: TDataSet);
begin
    Filtrar_tablas_ligadas;
end;

procedure Tform_users_000.Insertar_Registro;
var var_msg : TStrings;
begin
    with SQLQuery_Users do
    begin
        var_msg := TStringList.Create;

        if UTI_usr_Permiso_SN(public_Menu_Worked, 'A', True) = True then
        begin
            if public_Solo_Ver = True then
                begin
                    var_msg.Add('Sólo se puede visualizar.');
                    UTI_GEN_Aviso(var_msg, 'SOLO PARA OBSERVAR', True, False);
                end
            else
                begin
                    Insert;

                    //Filtrar_tablas_ligadas;

                    FieldByName('Permiso_Total_SN').AsString := 'N';

                    Application.CreateForm(TForm_users_001, Form_users_001);

                    Form_users_001.RadioGroup_Bajas.ItemIndex := RadioGroup_Bajas.ItemIndex;

                    Form_users_001.ShowModal;
                    if Form_users_001.public_Pulso_Aceptar = true then
                        begin
                            FieldByName('Insert_WHEN').Value    := UTI_CN_Fecha_Hora;
                            FieldByName('Insert_Id_User').Value := Form_Menu.public_User;
                            Post;
                            // RadioGroup_Bajas.ItemIndex := Form_users_001.RadioGroup_Bajas.ItemIndex;
                        end
                    else Cancel;

                    FreeAndNil(Form_users_001);
                end;
        end;

        var_msg.Free;
    end;
end;

procedure Tform_users_000.DBGrid_PrincipalTitleClick(Column: TColumn);
begin
    private_Last_Column := UTI_GEN_Ordenar_dbGrid(private_Last_Column, Column, SQLQuery_Users);
end;

procedure Tform_users_000.Editar_Registro;
var var_msg : TStrings;
begin
    with SQLQuery_Users do
    begin
        var_msg := TStringList.Create;

        if RecordCount > 0 then
            begin
                if UTI_usr_Permiso_SN(public_Menu_Worked, 'M', True) = True then
                begin
                    // ***************************************************************************** //
                    // ** Esto se hace porque cuando creamos el registro, como hace un commit a la** //
                    // ** transaccion, no devuelve el valor dado a los campos autoincrementales   ** //
                    // ***************************************************************************** //
                    //if Trim(FieldByName('id').AsString) = '' then Refrescar_Registros;

                    Edit;

                    Application.CreateForm(TForm_users_001, Form_users_001);

                    Form_users_001.RadioGroup_Bajas.ItemIndex := RadioGroup_Bajas.ItemIndex;
                    Form_users_001.public_Menu_Worked         := public_Menu_Worked;

                    if public_Solo_Ver = true then
                    begin
                        Form_users_001.public_Solo_Ver := true;
                    end;

                    Form_users_001.ShowModal;
                    if Form_users_001.public_Pulso_Aceptar = true then
                        begin
                            if ( Trim(Form_users_001.public_Record_Rgtro.USERS_Descripcion_Nick) <> Trim(FieldByName('Descripcion_Nick').AsString) ) or
                               ( Trim(Form_users_001.public_Record_Rgtro.USERS_Id_Empleados)     <> Trim(FieldByName('Id_Empleados').AsString) )     or
                               ( Trim(Form_users_001.public_Record_Rgtro.USERS_Permiso_Total_SN) <> Trim(FieldByName('Permiso_Total_SN').AsString) ) then
                               begin
                                    FieldByName('Change_WHEN').Value    := UTI_CN_Fecha_Hora;
                                    FieldByName('Change_Id_User').Value := Form_Menu.public_User;
                                    Post;
                                    //RadioGroup_Bajas.ItemIndex := Form_users_001.RadioGroup_Bajas.ItemIndex;
                               end
                            else Cancel;
                        end
                    else Cancel;

                    FreeAndNil(Form_users_001);
                end;
            end
        else
            begin
                var_msg.Add('No hay registros.');
                UTI_GEN_Aviso(var_msg, '¿QUE VAS A VER?', True, False);
            end;
    end;

    var_msg.Free;
end;

procedure TForm_users_000.Presentar_Datos;
begin
     /// guardar por lo que pueda pasar
end;

procedure Tform_users_000.SQLQuery_Users_MenusAfterScroll(DataSet: TDataSet);
begin
     Filtrar_tablas_ligadas_Menus;
end;

procedure Tform_users_000.Filtrar_tablas_ligadas;
var var_Lineas_Filtro  : TStrings;
    var_Lineas_OrderBy : TStrings;
begin
    if SQLQuery_Users.RecordCount = 0 then Exit;

    var_Lineas_Filtro  := TStringList.Create;
    var_Lineas_OrderBy := TStringList.Create;

    UTI_RGTRO_Pasar_Valor_Campo( true, var_Lineas_Filtro, SQLQuery_Users.FieldByName('id').AsString, 'Id_Users', false );
    var_Lineas_OrderBy.Clear;
    Filtrar_users_passwords( private_Last_Column, RadioGroup_Bajas.ItemIndex, false, var_Lineas_Filtro, var_Lineas_OrderBy );

    UTI_RGTRO_Pasar_Valor_Campo( true, var_Lineas_Filtro, SQLQuery_Users.FieldByName('id').AsString, 'um.Id_Users', false );
    var_Lineas_OrderBy.Clear;
    Filtrar_users_menus( private_Last_Column, RadioGroup_Bajas.ItemIndex, false, var_Lineas_Filtro, var_Lineas_OrderBy );

    FreeAndNil(var_Lineas_Filtro);
    FreeAndNil(var_Lineas_OrderBy);
end;

procedure Tform_users_000.Filtrar_tablas_ligadas_Menus;
var var_Lineas_Filtro  : TStrings;
    var_Lineas_OrderBy : TStrings;
begin
    if SQLQuery_Users.RecordCount = 0 then Exit;

    var_Lineas_Filtro  := TStringList.Create;
    var_Lineas_OrderBy := TStringList.Create;

    UTI_RGTRO_Pasar_Valor_Campo( true, var_Lineas_Filtro, SQLQuery_Users_Menus.FieldByName('Id_Users').AsString, 'upe.Id_Users', false );
    UTI_RGTRO_Pasar_Valor_Campo( false, var_Lineas_Filtro, SQLQuery_Users_Menus.FieldByName('Id_Menus').AsString, 'upe.Id_Menus', false );
    var_Lineas_OrderBy.Clear;

    if UTI_GEN_Form_Abierto_Ya('Form_users_001') = true then
         begin
             Filtrar_users_menus_permisos( public_Last_Column_Menus_Permisos,
                                           Form_users_001.RadioGroup_Bajas.ItemIndex,
                                           false,
                                           var_Lineas_Filtro,
                                           var_Lineas_OrderBy );
         end
    else
         begin
             Filtrar_users_menus_permisos( private_Last_Column,
                                           RadioGroup_Bajas.ItemIndex,
                                           false,
                                           var_Lineas_Filtro,
                                           var_Lineas_OrderBy );
         end;

    FreeAndNil(var_Lineas_Filtro);
    FreeAndNil(var_Lineas_OrderBy);
end;

function Tform_users_000.Filtrar_Principal( param_Cambiamos_Filtro : Boolean ) : ShortInt;
var var_DeleteSQL     : String;
    var_UpdateSQL     : String;
    var_InsertSQL     : String;
    var_ctdad_Rgtros  : Integer;
    var_nombre_tabla  : ShortString;
    VAR_SQL_SELECT    : String;
    // VAR_SQL_ORDER_BY  : String;
begin
    var_DeleteSQL    := '';

    var_UpdateSQL    := 'UPDATE users' +
                          ' SET Descripcion_Nick = :Descripcion_Nick,' +
                              ' Id_Empleados = :Id_Empleados,' +
                              ' Permiso_Total_SN = :Permiso_Total_SN,' +

                              ' Insert_WHEN = :Insert_WHEN,' +
                              ' Insert_Id_User = :Insert_Id_User,' +
                              ' Del_WHEN = :Del_WHEN,' +
                              ' Del_Id_User = :Del_Id_User,' +
                              ' Del_WHY = :Del_WHY,' +
                              ' Change_WHEN = :Change_WHEN,' +
                              ' Change_Id_User = :Change_Id_User' +
                        ' WHERE id = :id';

    var_InsertSQL    := 'INSERT INTO users' +
                        ' ( Descripcion_Nick,' +
                          ' Id_Empleados,' +
                          ' Permiso_Total_SN,' +

                          ' Insert_WHEN, Insert_Id_User,' +
                          ' Del_WHEN, Del_Id_User, Del_WHY,' +
                          ' Change_WHEN, Change_Id_User )' +
                       ' VALUES' +
                        ' ( :Descripcion_Nick,' +
                          ' :Id_Empleados,' +
                          ' :Permiso_Total_SN,' +

                          ' :Insert_WHEN, :Insert_Id_User,' +
                          ' :Del_WHEN, :Del_Id_User, :Del_WHY,' +
                          ' :Change_WHEN, :Change_Id_User )';

    var_ctdad_Rgtros := 19;
    var_nombre_tabla := 'u';

    VAR_SQL_SELECT   := 'SELECT u.*' + ' ' +
                          'FROM users AS u';

    // var_SQL_ORDER_BY :=  'ORDER BY u.Descripcion_Nick';

    Result := UTI_TB_Filtrar( private_Order_By,

                              var_DeleteSQL,
                              var_UpdateSQL,
                              var_InsertSQL,

                              var_ctdad_Rgtros,
                              DataModule_Users.SQLTransaction_Users,
                              DataModule_Users.SQLConnector_Users,
                              SQLQuery_Users,

                              var_nombre_tabla,
                              RadioGroup_Bajas.ItemIndex,

                              VAR_SQL_SELECT,
                              // var_SQL_ORDER_BY,

                              Memo_Filtros.Lines,
                              Memo_OrderBy.Lines,

                              param_Cambiamos_Filtro );

    UTI_GEN_Borrar_Imagen_Orden_Grid(private_Last_Column);

    //Filtrar_tablas_ligadas;
end;

procedure Tform_users_000.SQLQuery_Users_Menus_PermisosAfterPost(DataSet: TDataSet);
begin
    UTI_RGTRO_Grabar( DataModule_Users.SQLTransaction_Users_Menus_Permisos, SQLQuery_Users_Menus_Permisos );
    Refrescar_Registros_Menus_Permisos;
end;

function Tform_users_000.Filtrar_users_menus( param_Last_Column : TColumn;
                                              param_ver_bajas : ShortInt;
                                              param_Cambiamos_Filtro : Boolean;
                                              param_Lineas_Filtro,
                                              param_Lineas_OrderBy : TStrings ) : ShortInt;
var var_DeleteSQL    : String;
    var_UpdateSQL    : String;
    var_InsertSQL    : String;
    var_ctdad_Rgtros : Integer;
    var_nombre_tabla : ShortString;
    VAR_SQL_SELECT   : String;
    // VAR_SQL_ORDER_BY : String;
begin
    var_DeleteSQL    := '';

    var_UpdateSQL    := 'UPDATE users_menus' +
                          ' SET Id_Users = :Id_Users,' +
                              ' Id_Menus = :Id_Menus,' +
                              ' Forcing_Why_Delete = :Forcing_Why_Delete,' +

                              ' Insert_WHEN = :Insert_WHEN,' +
                              ' Insert_Id_User = :Insert_Id_User,' +
                              ' Del_WHEN = :Del_WHEN,' +
                              ' Del_Id_User = :Del_Id_User,' +
                              ' Del_WHY = :Del_WHY,' +
                              ' Change_WHEN = :Change_WHEN,' +
                              ' Change_Id_User = :Change_Id_User' +
                        ' WHERE id = :id';

    var_InsertSQL    := 'INSERT INTO users_menus' +
                          ' ( Id_Users,' +
                            ' Id_Menus,' +
                            ' Forcing_Why_Delete,' +

                            ' Insert_WHEN, Insert_Id_User,' +
                            ' Del_WHEN, Del_Id_User, Del_WHY,' +
                            ' Change_WHEN, Change_Id_User )' +

                       ' VALUES' +
                          ' ( :Id_Users,' +
                            ' :Id_Menus,' +
                            ' :Forcing_Why_Delete,' +

                            ' :Insert_WHEN, :Insert_Id_User,' +
                            ' :Del_WHEN, :Del_Id_User, :Del_WHY,' +
                            ' :Change_WHEN, :Change_Id_User )';

    var_ctdad_Rgtros := 5;

    var_nombre_tabla := 'um';

    // ********************************************************************************************* //
    // ** No olvidemos que los campos que empiezan por OT_ son campos que pertenecen a otras      ** //
    // ** tablas(JOIN de la SELECT) y que por lo tanto no voy a permitir hacer nada con ellos en  ** //
    // ** form_filtrar_registros y de momento tampoco en form_ordenado_por                        ** //
    // ********************************************************************************************* //
    VAR_SQL_SELECT   := 'SELECT um.*,' +
                              ' u.Descripcion_Nick AS OT_Descripcion_Nick,' +
                              ' m.Descripcion AS OT_Descripcion_Menu' +

                        ' FROM users_menus AS um' +

                        ' LEFT JOIN users AS u' +
                          ' ON um.Id_Users = u.id' +

                        ' LEFT JOIN menus AS m' +
                          ' ON um.Id_Menus = m.id';

    // VAR_SQL_ORDER_BY := 'ORDER BY um.Id_Users ASC, um.Id_Menus ASC';
    if Trim(param_Lineas_OrderBy.Text) = '' then
    begin
         param_Lineas_OrderBy.Text := private_Order_By_Menus[0].Memo_OrderBy;
    end;

    Result := UTI_TB_Filtrar( private_Order_By_Menus,

                              var_DeleteSQL,
                              var_UpdateSQL,
                              var_InsertSQL,

                              var_ctdad_Rgtros,
                              DataModule_Users.SQLTransaction_Users_Menus,
                              DataModule_Users.SQLConnector_Users_Menus,
                              SQLQuery_Users_Menus,

                              var_nombre_tabla,
                              param_ver_bajas,

                              VAR_SQL_SELECT,
                              //var_SQL_ORDER_BY,

                              param_Lineas_Filtro,
                              param_Lineas_OrderBy,

                              param_Cambiamos_Filtro );

    UTI_GEN_Borrar_Imagen_Orden_Grid(param_Last_Column);
end;

function Tform_users_000.Filtrar_users_passwords( param_Last_Column : TColumn;
                                                  param_ver_bajas : ShortInt;
                                                  param_Cambiamos_Filtro : Boolean;
                                                  param_Lineas_Filtro,
                                                  param_Lineas_OrderBy : TStrings ) : ShortInt;
var var_DeleteSQL    : String;
    var_UpdateSQL    : String;
    var_InsertSQL    : String;
    var_ctdad_Rgtros : Integer;
    var_nombre_tabla : ShortString;
    VAR_SQL_SELECT   : String;
    // VAR_SQL_ORDER_BY : String;
begin
    var_DeleteSQL    := '';

    var_UpdateSQL    := 'UPDATE users_passwords' +
                          ' SET Id_Users = :Id_Users,' +
                              ' Password = :Password,' +
                              ' Password_Expira_SN = :Password_Expira_SN,' +
                              ' Password_Expira_Inicio = :Password_Expira_Inicio,' +
                              ' Password_Expira_Fin = :Password_Expira_Fin,' +
                              ' Obligado_NICK_SN = :Obligado_NICK_SN,' +

                              ' Insert_WHEN = :Insert_WHEN,' +
                              ' Insert_Id_User = :Insert_Id_User,' +
                              ' Del_WHEN = :Del_WHEN,' +
                              ' Del_Id_User = :Del_Id_User,' +
                              ' Del_WHY = :Del_WHY,' +
                              ' Change_WHEN = :Change_WHEN,' +
                              ' Change_Id_User = :Change_Id_User' +
                        ' WHERE id = :id';

    var_InsertSQL    := 'INSERT INTO users_passwords' +
                          ' ( Id_Users,' +
                            ' Password,' +
                            ' Password_Expira_SN,' +
                            ' Password_Expira_Inicio,' +
                            ' Password_Expira_Fin,' +
                            ' Obligado_NICK_SN,' +

                            ' Insert_WHEN, Insert_Id_User,' +
                            ' Del_WHEN, Del_Id_User, Del_WHY,' +
                            ' Change_WHEN, Change_Id_User )' +

                       ' VALUES' +
                          ' ( :Id_Users,' +
                            ' :Password,' +
                            ' :Password_Expira_SN,' +
                            ' :Password_Expira_Inicio,' +
                            ' :Password_Expira_Fin,' +
                            ' :Obligado_NICK_SN,' +

                            ' :Insert_WHEN, :Insert_Id_User,' +
                            ' :Del_WHEN, :Del_Id_User, :Del_WHY,' +
                            ' :Change_WHEN, :Change_Id_User )';

    var_ctdad_Rgtros := 4;

    var_nombre_tabla := 'up';

    // ********************************************************************************************* //
    // ** No olvidemos que los campos que empiezan por OT_ son campos que pertenecen a otras      ** //
    // ** tablas(JOIN de la SELECT) y que por lo tanto no voy a permitir hacer nada con ellos en  ** //
    // ** form_filtrar_registros y de momento tampoco en form_ordenado_por                        ** //
    // ********************************************************************************************* //
    VAR_SQL_SELECT   := 'SELECT up.*,' +
                              ' u.Descripcion_Nick AS OT_Descripcion_Nick' +

                        ' FROM users_passwords AS up' +

                        ' LEFT JOIN users AS u' +
                          ' ON up.Id_Users = u.id';

    // VAR_SQL_ORDER_BY := 'ORDER BY up.Id_Users ASC, up.Password ASC';
    if Trim(param_Lineas_OrderBy.Text) = '' then
    begin
         param_Lineas_OrderBy.Text := private_Order_By_passwords[0].Memo_OrderBy;
    end;

    Result := UTI_TB_Filtrar( private_Order_By_passwords,

                              var_DeleteSQL,
                              var_UpdateSQL,
                              var_InsertSQL,

                              var_ctdad_Rgtros,
                              DataModule_Users.SQLTransaction_Users_Passwords,
                              DataModule_Users.SQLConnector_Users_Passwords,
                              SQLQuery_Users_Passwords,

                              var_nombre_tabla,
                              param_ver_bajas,

                              VAR_SQL_SELECT,
                              // var_SQL_ORDER_BY,

                              param_Lineas_Filtro,
                              param_Lineas_OrderBy,

                              param_Cambiamos_Filtro );

    UTI_GEN_Borrar_Imagen_Orden_Grid(param_Last_Column);
end;

function Tform_users_000.Filtrar_users_menus_permisos( param_Last_Column : TColumn;
                                                       param_ver_bajas : ShortInt;
                                                       param_Cambiamos_Filtro : Boolean;
                                                       param_Lineas_Filtro,
                                                       param_Lineas_OrderBy : TStrings ) : ShortInt;
var var_DeleteSQL    : String;
    var_UpdateSQL    : String;
    var_InsertSQL    : String;
    var_ctdad_Rgtros : Integer;
    var_nombre_tabla : ShortString;
    VAR_SQL_SELECT   : String;
    // VAR_SQL_ORDER_BY : String;
begin
    var_DeleteSQL    := '';

    var_UpdateSQL    := 'UPDATE users_menus_permissions' +

                          ' SET Id_Users = :Id_Users,' +
                              ' Id_Menus = :Id_Menus,' +
                              ' Tipo_CRUD = :Tipo_CRUD,' +
                              ' Descripcion = :Descripcion,' +
                              ' PermisoSN = :PermisoSN,' +

                              ' Insert_WHEN = :Insert_WHEN,' +
                              ' Insert_Id_User = :Insert_Id_User,' +
                              ' Del_WHEN = :Del_WHEN,' +
                              ' Del_Id_User = :Del_Id_User,' +
                              ' Del_WHY = :Del_WHY,' +
                              ' Change_WHEN = :Change_WHEN,' +
                              ' Change_Id_User = :Change_Id_User' +
                        ' WHERE id = :id';

    var_InsertSQL    := 'INSERT INTO users_menus_permissions' +
                          ' ( Id_Users,' +
                            ' Id_Menus,' +
                            ' Tipo_CRUD,' +
                            ' Descripcion,' +
                            ' PermisoSN,' +

                            ' Insert_WHEN, Insert_Id_User,' +
                            ' Del_WHEN, Del_Id_User, Del_WHY,' +
                            ' Change_WHEN, Change_Id_User )' +

                       ' VALUES' +
                          ' ( :Id_Users,' +
                            ' :Id_Menus,' +
                            ' :Tipo_CRUD,' +
                            ' :Descripcion,' +
                            ' :PermisoSN,' +

                            ' :Insert_WHEN, :Insert_Id_User,' +
                            ' :Del_WHEN, :Del_Id_User, :Del_WHY,' +
                            ' :Change_WHEN, :Change_Id_User )';

    var_ctdad_Rgtros := 6;

    var_nombre_tabla := 'upe';

    // ********************************************************************************************* //
    // ** No olvidemos que los campos que empiezan por OT_ son campos que pertenecen a otras      ** //
    // ** tablas(JOIN de la SELECT) y que por lo tanto no voy a permitir hacer nada con ellos en  ** //
    // ** form_filtrar_registros y de momento tampoco en form_ordenado_por                        ** //
    // ********************************************************************************************* //
    VAR_SQL_SELECT   := 'SELECT upe.*,' +
                              ' u.Descripcion_Nick AS OT_Descripcion_Nick,' +
                              ' m.Descripcion AS OT_Descripcion_Menu' +

                        ' FROM users_menus_permissions AS upe' +

                        ' LEFT JOIN users AS u' +
                          ' ON upe.Id_Users = u.id' +

                        ' LEFT JOIN menus AS m' +
                          ' ON upe.Id_Menus = m.id';

    // VAR_SQL_ORDER_BY := 'ORDER BY um.Id_Users ASC, um.Id_Menus ASC';
    if Trim(param_Lineas_OrderBy.Text) = '' then
    begin
         param_Lineas_OrderBy.Text := private_Order_By_permisos[0].Memo_OrderBy; ;
    end;

    Result := UTI_TB_Filtrar( private_Order_By_permisos,

                              var_DeleteSQL,
                              var_UpdateSQL,
                              var_InsertSQL,

                              var_ctdad_Rgtros,
                              DataModule_Users.SQLTransaction_Users_Menus_Permisos,
                              DataModule_Users.SQLConnector_Users_Menus_Permisos,
                              SQLQuery_Users_Menus_Permisos,

                              var_nombre_tabla,
                              param_ver_bajas,

                              VAR_SQL_SELECT,
                              //var_SQL_ORDER_BY,

                              param_Lineas_Filtro,
                              param_Lineas_OrderBy,

                              param_Cambiamos_Filtro );

    UTI_GEN_Borrar_Imagen_Orden_Grid(param_Last_Column);
end;

procedure Tform_users_000.SQLQuery_Users_Menus_PermisosCalcFields(DataSet: TDataSet);
begin
    with SQLQuery_Users_Menus_Permisos do
    begin
        FieldByName('OT_CALC_Tipo_CRUD_Descripcion').AsString := '';

        if FieldByName('Tipo_CRUD').Value = 'A' then FieldByName('OT_CALC_Tipo_CRUD_Descripcion').AsString := 'INSERTAR / CREAR';
        if FieldByName('Tipo_CRUD').Value = 'M' then FieldByName('OT_CALC_Tipo_CRUD_Descripcion').AsString := 'MODIFICAR / EDITAR';
        if FieldByName('Tipo_CRUD').Value = 'B' then FieldByName('OT_CALC_Tipo_CRUD_Descripcion').AsString := 'BORRAR / DAR DE BAJA';
        if FieldByName('Tipo_CRUD').Value = 'I' then FieldByName('OT_CALC_Tipo_CRUD_Descripcion').AsString := 'IMPRIMIR';
        if FieldByName('Tipo_CRUD').Value = 'O' then FieldByName('OT_CALC_Tipo_CRUD_Descripcion').AsString := FieldByName('Descripcion').AsString;
    end;
end;

procedure Tform_users_000.Refrescar_Registros;
var var_Descripcion_Nick : String;
    {var_Id_Empleados     : Integer;}
    var_Permiso_Total_SN : ShortString;
begin
    // ********************************************************************************************* //
    // ** OJITO ... NO USAR CAMPOS AUTOINCREMENTABLES                                             ** //
    // ********************************************************************************************* //
    var_Descripcion_Nick := '';

    if SQLQuery_Users.RecordCount > 0 then
    begin
        var_Descripcion_Nick := SQLQuery_Users.FieldByName('Descripcion_Nick').Value;
      { if not SQLQuery_Users.FieldByName('Id_Empleados').IsNull then
               var_Id_Empleados     := SQLQuery_Users.FieldByName('Id_Empleados').Value;  }
        var_Permiso_Total_SN := SQLQuery_Users.FieldByName('Permiso_Total_SN').Value;
    end;

    RadioGroup_Bajas.ItemIndex := Filtrar_Principal( false );

    if Trim(var_Descripcion_Nick) <> '' then
    begin
         SQLQuery_Users.Locate( 'Descripcion_Nick;Permiso_Total_SN',
                                VarArrayOf( [ var_Descripcion_Nick, var_Permiso_Total_SN ] ),
                                [] );
    end;
    //if var_Descripcion_Nick <> '' then SQLQuery_Users.Locate('Descripcion_Nick', var_Descripcion_Nick, []);
end;

procedure TForm_users_000.Refrescar_Registros_Passwords;
var var_Lineas_Filtro      : TStrings;
    var_Lineas_OrderBy     : TStrings;
    var_Password           : String;
    var_Obligado_NICK_SN   : ShortString;
    var_Password_Expira_SN : ShortString;
    var_ver_Bajas          : ShortInt;
begin
    // ********************************************************************************************* //
    // ** OJITO ... NO USAR CAMPOS AUTOINCREMENTABLES                                             ** //
    // ********************************************************************************************* //
    var_Password           := '';
    var_Obligado_NICK_SN   := '';
    var_Password_Expira_SN := '';

    if SQLQuery_Users_Passwords.RecordCount > 0 then
    begin
        var_Password           := SQLQuery_Users_Passwords.FieldByName('Password').Value;
        var_Obligado_NICK_SN   := SQLQuery_Users_Passwords.FieldByName('Obligado_NICK_SN').Value;
        var_Password_Expira_SN := SQLQuery_Users_Passwords.FieldByName('Password_Expira_SN').Value;
    end;

    var_Lineas_Filtro  := TStringList.Create;
    var_Lineas_OrderBy := TStringList.Create;

    var_Lineas_Filtro.Clear;
    var_Lineas_OrderBy.Clear;

    if Trim(SQLQuery_Users.FieldByName('id').AsString) <> '' then
         var_Lineas_Filtro.Add('Id_Users = ' + Trim(SQLQuery_Users.FieldByName('id').AsString))
    else var_Lineas_Filtro.Add('Id_Users = Null');

    var_ver_Bajas := RadioGroup_Bajas.ItemIndex;
    if UTI_GEN_Form_Abierto_Ya('Form_users_001') = true then
    begin
        var_ver_Bajas := Form_users_001.RadioGroup_Bajas.ItemIndex;
    end;

    Filtrar_users_passwords( public_Last_Column_Password,
                             var_ver_Bajas,
                             false,
                             var_Lineas_Filtro,
                             var_Lineas_OrderBy );

    FreeAndNil(var_Lineas_Filtro);
    FreeAndNil(var_Lineas_OrderBy);

    if Trim(var_Password) <> '' then
    begin
         SQLQuery_Users_Passwords.Locate( 'Password;Obligado_NICK_SN;Password_Expira_SN',
                                          VarArrayOf( [ var_Password, var_Obligado_NICK_SN, var_Password_Expira_SN ] ),
                                          [] );
    end;
end;

procedure TForm_users_000.Refrescar_Registros_Menus_Permisos;
var var_Lineas_Filtro  : TStrings;
    var_Lineas_OrderBy : TStrings;
    var_Buscar         : Boolean;
    var_Id_Users       : Int64;
    var_Id_Menus       : Int64;
    var_Tipo_CRUD      : ShortString;
    var_ver_Bajas      : ShortInt;
begin
    // ********************************************************************************************* //
    // ** OJITO ... NO USAR CAMPOS AUTOINCREMENTABLES                                             ** //
    // ********************************************************************************************* //
    var_Buscar := false;

    if SQLQuery_Users_Menus_Permisos.RecordCount > 0 then
    begin
        var_Buscar     := true;
        var_Id_Users   := SQLQuery_Users_Menus_Permisos.FieldByName('Id_Users').Value;
        var_Id_Menus   := SQLQuery_Users_Menus_Permisos.FieldByName('Id_Menus').Value;
        var_Tipo_CRUD  := SQLQuery_Users_Menus_Permisos.FieldByName('Tipo_CRUD').Value;
    end;

    var_Lineas_Filtro  := TStringList.Create;
    var_Lineas_OrderBy := TStringList.Create;

    var_Lineas_Filtro.Clear;
    var_Lineas_OrderBy.Clear;

    if Trim(SQLQuery_Users.FieldByName('id').AsString) <> '' then
         var_Lineas_Filtro.Add('Id_Users = ' + Trim(SQLQuery_Users.FieldByName('id').AsString))
    else var_Lineas_Filtro.Add('Id_Users = Null');

    var_ver_Bajas := RadioGroup_Bajas.ItemIndex;
    if UTI_GEN_Form_Abierto_Ya('Form_users_001') = true then
    begin
        var_ver_Bajas := Form_users_001.RadioGroup_Bajas.ItemIndex;
    end;

    Filtrar_users_menus_permisos( public_Last_Column_Menus_Permisos,
                                  var_ver_Bajas,
                                  false,
                                  var_Lineas_Filtro,
                                  var_Lineas_OrderBy );

    FreeAndNil(var_Lineas_Filtro);
    FreeAndNil(var_Lineas_OrderBy);

    if var_Buscar = true then
    begin
         SQLQuery_Users_Menus_Permisos.Locate( 'Id_Users;Id_Menus;Tipo_CRUD',
                                               VarArrayOf( [ var_Id_Users, var_Id_Menus, var_Tipo_CRUD ] ),
                                               [] );
    end;
end;

procedure TForm_users_000.Refrescar_Registros_Menus;
var var_Lineas_Filtro  : TStrings;
    var_Lineas_OrderBy : TStrings;
    var_Buscar         : Boolean;
    var_Id_Users       : Int64;
    var_Id_Menus       : Int64;
    var_ver_Bajas      : ShortInt;
begin
    // ********************************************************************************************* //
    // ** OJITO ... NO USAR CAMPOS AUTOINCREMENTABLES                                             ** //
    // ********************************************************************************************* //
    var_Buscar := false;
    if SQLQuery_Users_Menus.RecordCount > 0 then
    begin
        var_Buscar   := true;
        var_Id_Users := SQLQuery_Users_Menus.FieldByName('Id_Users').Value;
        var_Id_Menus := SQLQuery_Users_Menus.FieldByName('Id_Menus').Value;
    end;

    var_Lineas_Filtro  := TStringList.Create;
    var_Lineas_OrderBy := TStringList.Create;

    var_ver_Bajas := RadioGroup_Bajas.ItemIndex;
    if UTI_GEN_Form_Abierto_Ya('Form_users_001') = true then
    begin
         var_ver_Bajas := Form_users_001.RadioGroup_Bajas.ItemIndex;
         Form_users_001.Preparar_Memo(false);
    end;

    var_Lineas_Filtro.AddStrings(Form_users_001.Memo_Filtros.Lines);
    var_Lineas_OrderBy.AddStrings(Form_users_001.Memo_OrderBy.Lines);

    Filtrar_users_Menus( public_Last_Column_Menus,
                         var_ver_Bajas,
                         false,
                         var_Lineas_Filtro,
                         var_Lineas_OrderBy );

    FreeAndNil(var_Lineas_Filtro);
    FreeAndNil(var_Lineas_OrderBy);

    if var_Buscar = true then
    begin
         SQLQuery_Users_Menus.Locate( 'Id_Users;Id_Menus',
                                      VarArrayOf( [ var_Id_Users, var_Id_Menus ] ),
                                      [] );
    end;
end;

end.


