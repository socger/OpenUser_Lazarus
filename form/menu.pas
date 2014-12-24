unit menu;

{$mode objfpc}{$H+}

interface

uses
    utilidades_bd, utilidades_usuarios, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Buttons, Menus,
    utilidades_general, Dialogs, ExtCtrls, utilidades_forms_Filtrar;

type

    { Tform_Menu }

    Tform_Menu = class(TForm)
        ImageList_Grid_Sort: TImageList;
        MainMenu1: TMainMenu;
        MenuItem1: TMenuItem;
        MenuItem_Usuarios: TMenuItem;
        MenuItem_Menus: TMenuItem;
        MenuItem_Salir: TMenuItem;
        MenuItem_Medios: TMenuItem;
        MenuItem_Peliculas: TMenuItem;
        Timer_Sin_Usar: TTimer;

        procedure Preguntar_pwd;
        procedure Salir;
        procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
        procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
        procedure FormCreate(Sender: TObject);
        procedure MenuItem1Click(Sender: TObject);
        procedure MenuItem_MenusClick(Sender: TObject);
        procedure MenuItem_UsuariosClick(Sender: TObject);
        procedure MenuItem_MediosClick(Sender: TObject);
        procedure MenuItem_PeliculasClick(Sender: TObject);
        procedure Timer_Sin_UsarTimer(Sender: TObject);
    private
      { private declarations }
        private_Salir_OK : Boolean;
    public
      { public declarations }

      { ************************************************************************
        Variables para la comprobación de la contraseña del usuario
        ************************************************************************ }
        public_User_Super             : ShortString;
        public_User                   : Int64;
        public_User_Descripcion_Nick  : ShortString;

        public_pwd                    : ShortString;
        public_Password_Expira_SN     : Boolean;
        public_Password_Expira_Inicio : ShortString;
        public_Password_Expira_Fin    : ShortString;

        public_User_Last_Empresa      : Integer;

        public_User_Id_Empleados      : ShortString;
        public_User_Nombre_Empleado   : ShortString;

      { ************************************************************************
        Variables que controlará cuando fué el último momento en el que se
        comprobaron los permisos y no se uso la aplicación.
        ************************************************************************
        Nos sirve para vigilar que el usuario no se olvide la pantalla abierta
        durante mucho tiempo y otro usuario pueda entrar en módulos que no tenga
        privilegios.
        ************************************************************************ }
        public_When_Last_Permission : ShortString;
    end;

var
    form_Menu: Tform_Menu;

implementation

{$R *.lfm}

{ Tform_Menu }

Uses peliculas_000, medios_000;

procedure Tform_Menu.FormCreate(Sender: TObject);
var var_Valor_Minuto : Extended;
    var_CN_Conexion  : Trecord_CN_Conexion;
begin
    ShortDateFormat {%H-} := 'dd/mm/yyyy';
    DateSeparator {%H-}   := '/';
    public_User_Super     := 'OrJe';

  { ****************************************************************************
    Obligado en cada formulario para no olvidarlo
    **************************************************************************** }
    with Self do
    begin
        Position    := poScreenCenter;
        BorderIcons := [biSystemMenu,biMinimize,biMaximize];
        BorderStyle := bsSingle;
    end;

    private_Salir_OK := false;
    { **************************************************************************** }


  { ****************************************************************************
    Pasamos a activar el contador de tiempo para preguntar por la contraseña.
    Y para que la pregunte nada mas empezar, le quitamos a ahora los minutos de
    pausa para que obligue a preguntar por ella
    **************************************************************************** }
    // public_User := -1; // Así todavía no se eligió ningun usuario

    var_CN_Conexion := UTI_CN_Traer_Configuracion;
    if var_CN_Conexion.con_Exito = False then
    begin
        Application.Terminate;
    end;

    var_Valor_Minuto            := StrToTime('00:02:00') - StrToTime('00:01:00');
    public_When_Last_Permission := DateTimeToStr( Now -
                                                 (var_Valor_Minuto * StrToFloat(var_CN_Conexion.min_no_Work )) );

    Timer_Sin_Usar.Interval     := 100;
    Timer_Sin_Usar.Enabled      := true;
end;

procedure Tform_Menu.MenuItem_UsuariosClick(Sender: TObject);
begin
    UTI_Abrir_Form(false, false, '', 30);
end;

procedure Tform_Menu.MenuItem_MediosClick(Sender: TObject);
begin
    UTI_Abrir_Form(false, false, '', 10);
end;

procedure Tform_Menu.MenuItem_PeliculasClick(Sender: TObject);
begin
    UTI_Abrir_Form(false, false, '', 20);
    close;
end;

procedure Tform_Menu.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
{
if MessageDlg('Desea Realmente Salir ...?', mtConfirmation,
   [mbOK, mbCancel],0) =mrCancel then
   begin
        CanClose := False;
   end
   else
   begin
        Application.Terminate;
   end;
}
end;

procedure Tform_Menu.MenuItem_MenusClick(Sender: TObject);
begin
    UTI_Abrir_Form(false, false, '', 40);
end;

procedure Tform_Menu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    if private_Salir_OK = false then
        CloseAction := caNone
    else
        begin
            CloseAction := caFree;
            Timer_Sin_Usar.Enabled := false;
        end;
end;

procedure Tform_Menu.MenuItem1Click(Sender: TObject);
begin
    Salir;
end;

procedure Tform_Menu.Salir;
begin
    try
       private_Salir_OK := True;
       Close;
    Except
      on E: Exception do
        raise;
    end;
end;

procedure Tform_Menu.Timer_Sin_UsarTimer(Sender: TObject);
var var_Tiempo_Transcurrido   : Extended;
    var_Se_Sale               : Boolean;
    var_Valor_Minuto          : Extended;
    var_CN_Conexion           : Trecord_CN_Conexion;
begin
    LA SEGUNDA VEZ QUE LE TOCA PREGUNTAR EL USUARIO
    SE SALE DE LA APLICACION

    if UTI_GEN_Form_Abierto_Ya('form_AskByPwd') = true then
    begin
        { Si form_AskByPwd está abierto ya, pues no vuelve a abrirlo }
        Exit;
    end;

    var_CN_Conexion := UTI_CN_Traer_Configuracion;
    if var_CN_Conexion.con_Exito = False then
    begin
        Application.Terminate;
    end;

    var_Valor_Minuto := StrToTime('00:02:00') - StrToTime('00:01:00');

    // Algún proceso ya empezó a controlar el tiempo
    if Trim(public_When_Last_Permission) <> '' then
    begin
        var_Tiempo_Transcurrido := Now - StrToDateTime(Trim(public_When_Last_Permission));

        // if var_Tiempo_Transcurrido >= (var_Valor_Minuto * 9) then // Tiempo de espera ... 9 minutos
        if var_Tiempo_Transcurrido >= (var_Valor_Minuto * StrToFloat(var_CN_Conexion.min_no_Work)) then // Tiempo de espera ... 9 minutos
        begin
            var_Se_Sale := True;
            if (public_User = 0) { Usuario = 0 es el superusuario }        or
               (UTI_usr_Permiso_SN_conPermisoTotal_SN(public_User) = True) then
            begin
                var_Se_Sale := False;
            end;

            if var_Se_Sale = True then
                begin
                    // Mucho tiempo sin usar el programa
                    Salir;
                end
            else Preguntar_pwd;
        end;
    end;
end;

procedure Tform_Menu.Preguntar_pwd;
var var_ctdad_veces           : Integer;
    var_User                  : Integer;
    var_User_Descripcion_Nick : ShortString;
    var_User_Last_Empresa     : Integer;
    var_Se_Sale               : Boolean;
    var_la_pwd                : ShortInt;
begin
    // Es el superusuario o es un usuario con todos los permisos
    // asi que pregunto por su contraseña
    Timer_Sin_Usar.Enabled    := False;
    var_ctdad_veces           := 0;
    var_User                  := public_User;
    var_User_Descripcion_Nick := public_User_Descripcion_Nick;
    var_User_Last_Empresa     := public_User_Last_Empresa;

    var_Se_Sale               := True;
    While var_ctdad_veces < 3 do
    begin
        var_la_pwd := UTI_usr_AskByPwd; // 0 = Pulsó salir de la aplicación, 1 = Contraseña correcta, 2 = Contraseña incorrecta

        if var_la_pwd = 0 then Break; // Quiso salir de la aplicación

        if var_la_pwd = 2 then
        begin
            // Un intento de introducir la contraseña erroneo
            var_ctdad_veces := var_ctdad_veces + 1;

            // vuelvo a dejar el usuario que era
            public_User                  := var_User;
            public_User_Descripcion_Nick := var_User_Descripcion_Nick ;
            public_User_Last_Empresa     := var_User_Last_Empresa;
        end;

        if var_la_pwd = 1 then // la contraseña introducida corresponde a la de un usuario
        begin
            if Trim(public_User_Descripcion_Nick) = '' then
                begin
                    // LA PRIMERA VEZ SE IDENTIFICO UN USUARIO, ASI QUE VAMOS A COMPROBAR QUE EL QUE
                    // INTRODUJO LA CONTRASEÑA ES EL MISMO
                    if public_User = var_User then
                        begin
                            // La contraseña introducida corresponde a la del usuario que inició la sesión
                            var_Se_Sale := False;
                            Break;
                        end
                    else
                        begin
                            // No es el usuario que inició la sesión
                            var_ctdad_veces := var_ctdad_veces + 1;

                            // vuelvo a dejar el usuario que era
                            public_User                  := var_User;
                            public_User_Descripcion_Nick := var_User_Descripcion_Nick ;
                            public_User_Last_Empresa     := var_User_Last_Empresa;
                        end;
                end
            else
                begin
                    // TODAVIA NO SE HABIA IDENTIFICADO NINGUN USUARIO ANTERIORMENTE
                    var_Se_Sale := False;
                    Break;
                end;
        end;
    end;

    if var_Se_Sale = True then Salir;

    Timer_Sin_Usar.Interval := 5000;
    Timer_Sin_Usar.Enabled  := true;

    public_When_Last_Permission := DateTimeToStr(Now);
end;

end.

JEROFA

Despues de insertar un permiso a un usuario para un modulo, no filtra bien los permisos creados para
ese modulo, pues me presenta más registros de los que tiene. Es como si no filtrara bien por el
usuario o por el modulo.

tambien ver el codigo de errores para copiar y enviar por correo pues lleva un detalle de como ver
el valor de cada campo

Creo que voy a tener que cambiar todos los FreeAndNil() por Destroy ... a la vuelta de llamar a una funcion en la que hice
varios freeandnil, el programa seguia sobre la linea de comandos y el que me daba problemas era un FreeAndNil(form) de un form
Lo resolvi quitando todos los freeandnil de la funcion y convirtiendolos en Destroy

Las llamadas a los diferentes módulos deberían de construir diferentes record asi no tendriamos
un record tan sumamente grande como diferentes tablas se hubieran creado



