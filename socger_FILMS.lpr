program socger_FILMS;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, peliculas_000, dm_pelis, utilidades_bd, utilidades_usuarios,
  utilidades_general, avisos, peliculas_001, menu, estado_registro, dm_medios, filtrar_registros,
  utilidades_rgtro, utilidades_forms_Filtrar, medios_000, informe, medios_001, users_000, dm_users,
  users_001, arrancar, users_002, users_003, users_004, dm_menus, menus_000, menus_001, 
  dm_historico_registros, AskByPwd;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm_Arrancar, Form_Arrancar);
  Application.Run;
end.

