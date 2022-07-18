program Menu;

uses
  Vcl.Forms,
  Un_Principal in 'Un_Principal.pas' {Form1},
  Un_MenuLateral in '..\Un_MenuLateral.pas',
  Un_MenuLateralDef in '..\Un_MenuLateralDef.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
